﻿# PSake makes variables declared here available in other scriptblocks
# Init some things
Properties {
    # Find the build folder based on build system
        $ProjectRoot = $ENV:BHProjectPath
        if(-not $ProjectRoot)
        {
            $ProjectRoot = Resolve-Path "$PSScriptRoot\.."
        }

    $Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
    if($ENV:BHCommitMessage -match "!verbose")
    {
        $Verbose = @{Verbose = $True}
    }
    $ReleaseNotes = "$ProjectRoot\RELEASE.md"
    $ChangeLog = "$ProjectRoot\docs\ChangeLog.md"
}

Task Default -Depends Test

Task Init {
    $lines
    Set-Location $ProjectRoot
    "Build System Details:"
    Get-Item ENV:BH*
    "`n"
}

Task Test -Depends Init  {
    $lines
    "`n`tSTATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestResults = Invoke-Pester -Path $ProjectRoot\Tests -PassThru -OutputFormat NUnitXml -OutputFile "$ProjectRoot\$TestFile"

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    If($ENV:BHBuildSystem -eq 'AppVeyor')
    {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)",
            "$ProjectRoot\$TestFile" )
    }

    Remove-Item "$ProjectRoot\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if($TestResults.FailedCount -gt 0)
    {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    "`n"
}

Task Build -Depends Test {
    $lines
    
    # Load the module, read the exported functions, update the psd1 FunctionsToExport
    Set-ModuleFunctions

    # Bump the module version
    Try
    {
        $Version = Get-NextPSGalleryVersion -Name $env:BHProjectName -ErrorAction Stop
        Update-Metadata -Path $env:BHPSModuleManifest -PropertyName ModuleVersion -Value $Version -ErrorAction stop
    }
    Catch
    {
        "Failed to update version for '$env:BHProjectName': $_.`nContinuing with existing version"
    }
}

Task BuildDocs -depends Test {
    $lines
    
    "Loading Module from $ENV:BHPSModuleManifest"
    Remove-Module $ENV:BHProjectName -Force -ea SilentlyContinue
    # platyPS + AppVeyor requires the module to be loaded in Global scope
    Import-Module $ENV:BHPSModuleManifest -force -Global
    
    #Build YAMLText starting with the header
    $YMLtext = (Get-Content "$ProjectRoot\header-mkdocs.yml") -join "`n"
    $YMLtext = "$YMLtext`n"
    $parameters = @{
        Path = $ReleaseNotes
        ErrorAction = 'SilentlyContinue'
    }
    $ReleaseText = (Get-Content @parameters) -join "`n"
    if ($ReleaseText) {
        $ReleaseText | Set-Content "$ProjectRoot\docs\RELEASE.md"
        $YMLText = "$YMLtext  - Realse Notes: RELEASE.md`n"
    }
    if ((Test-Path -Path $ChangeLog)) {
        $YMLText = "$YMLtext  - Change Log: ChangeLog.md`n"
    }
    $YMLText = "$YMLtext  - Functions:`n"
    # Drain the swamp
    $parameters = @{
        Recurse = $true
        Force = $true
        Path = "$ProjectRoot\docs\functions"
        ErrorAction = 'SilentlyContinue'
    }
    $null = Remove-Item @parameters
    $Params = @{
        Path = "$ProjectRoot\docs\functions"
        type = 'directory'
        ErrorAction = 'SilentlyContinue'
    }
    $null = New-Item @Params
    $Params = @{
        Module = $ENV:BHProjectName
        Force = $true
        OutputFolder = "$ProjectRoot\docs\functions"
        NoMetadata = $true
    }
    New-MarkdownHelp @Params | foreach-object {
        $Function = $_.Name -replace '\.md', ''
        $Part = "    - {0}: functions/{1}" -f $Function, $_.Name
        $YMLText = "{0}{1}`n" -f $YMLText, $Part
        $Part
    }
    $YMLtext | Set-Content -Path "$ProjectRoot\mkdocs.yml"
}

Task Deploy -Depends BuildDocs {
    $lines
    
    # Gate deployment
    if (
        $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        $ENV:BHCommitMessage -match 'deploy'
    ) {
        $Params = @{
            Path = $ProjectRoot
            Force = $true
        }
        
        Invoke-PSDeploy @Verbose @Params
    }
    else {
        "Skipping deployment: To deploy, ensure that...`n" +
        "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
        "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
        "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)"
    }
}

Task PostDeploy -depends Deploy {
    $lines
    if ($ENV:APPVEYOR_REPO_PROVIDER -notlike 'github') {
        "Repo provider '$ENV:APPVEYOR_REPO_PROVIDER'. Skipping PostDeploy"
        return
    }
    If ($ENV:BHBuildSystem -eq 'AppVeyor') {
        "git config --global credential.helper store"
        cmd /c "git config --global credential.helper store 2>&1"
        
        Add-Content "$env:USERPROFILE\.git-credentials" "https://$($env:access_token):x-oauth-basic@github.com`n"
        
        "git config --global user.email"
        cmd /c "git config --global user.email ""$($ENV:BHProjectName)-$($ENV:BHBranchName)-$($ENV:BHBuildSystem)@markekraus.com"" 2>&1"
        
        "git config --global user.name"
        cmd /c "git config --global user.name ""AppVeyor"" 2>&1"
        
        "git config --global core.autocrlf true"
        cmd /c "git config --global core.autocrlf true 2>&1"
    }
    
    "git checkout $ENV:BHBranchName"
    cmd /c "git checkout $ENV:BHBranchName 2>&1"
    
    "git add -A"
    cmd /c "git add -A 2>&1"
    
    "git commit -m"
    cmd /c "git commit -m ""AppVeyor post-build commit[ci skip]"" 2>&1"
    
    "git status"
    cmd /c "git status 2>&1"
    
    "git push origin $ENV:BHBranchName"
    cmd /c "git push origin $ENV:BHBranchName 2>&1"
    # if this is a !deploy on master, create GitHub release
    if (
        $ENV:BHBuildSystem -ne 'Unknown' -and
        $ENV:BHBranchName -eq "master" -and
        $ENV:BHCommitMessage -match 'deploy'
    ) {
        "Publishing Release 'v$BuildVersion' to Github"
        $parameters = @{
            Path = $ReleaseNotes
            ErrorAction = 'SilentlyContinue'
        }
        $ReleaseText = (Get-Content @parameters) -join "`r`n"
        if (-not $ReleaseText) {
            $ReleaseText = "Release version $BuildVersion ($BuildDate)"
        }
        $Body = @{
            "tag_name" = "v$BuildVersion"
            "target_commitish"= "master"
            "name" = "v$BuildVersion"
            "body"= $ReleaseText
            "draft" = $false
            "prerelease"= $false
        } | ConvertTo-Json
        $releaseParams = @{
            Uri = "https://api.github.com/repos/{0}/releases" -f $ENV:APPVEYOR_REPO_NAME
            Method = 'POST'
            Headers = @{
                Authorization = 'Basic ' + [Convert]::ToBase64String(
                    [Text.Encoding]::ASCII.GetBytes($env:access_token + ":x-oauth-basic"));
            }
            ContentType = 'application/json'
            Body = $Body
        }
        $Response = Invoke-RestMethod @releaseParams
        $Response | Format-List *
    }
}