param(
    $Task = 'Default'
)

# dependencies
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
if(-not (Get-Module -ListAvailable PSDepend))
{
    & (Resolve-Path "$PSScriptRoot\helpers\Install-PSDepend.ps1")
}
Install-Module Psake, PSDeploy, BuildHelpers, platyPS, PSScriptAnalyzer -force
Install-Module Pester -Force -SkipPublisherCheck
Import-Module Psake, BuildHelpers, platyPS, PSScriptAnalyzer
Import-Module PSDepend
$null = Invoke-PSDepend -Path "$PSScriptRoot\build.requirements.psd1" -Install -Import -Force

Set-BuildEnvironment

Invoke-psake $PSScriptRoot\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )