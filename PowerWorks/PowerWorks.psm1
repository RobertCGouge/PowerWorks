﻿#Module vars
    $ModulePath = $PSScriptRoot


#Get public and private function definition files.
    $Public  = Get-ChildItem $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue
    $Private = Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue
    [string[]]$PrivateModules = Get-ChildItem $PSScriptRoot\Private -ErrorAction SilentlyContinue |
        Where-Object {$_.PSIsContainer} |
        Select -ExpandProperty FullName

# Dot source the files
    Foreach($import in $Public)
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error "Failed to import function $($import.fullname): $_"
        }
    }
        Foreach($import in $Private)
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error "Failed to import function $($import.fullname): $_"
        }
    }

# Load up dependency modules
    foreach($Module in $PrivateModules)
    {
        Try
        {
            Import-Module $Module -ErrorAction Stop
        }
        Catch
        {
            Write-Error "Failed to import module $Module`: $_"
        }
    }