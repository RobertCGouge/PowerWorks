$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Get-Item $here).Parent


$module = (Get-ChildItem -Path $root.FullName -Recurse -Filter '*.psm1').FullName

import-module $module




Describe "Test-Port -Port parameter" {
    It "Should throw an error on an invalid TCP port number" {
        {Test-port -Computer . -Port 65536} | should throw
    }
    It "Should throw an error when a string is passed" {
        {Test-port -Computer . -Port string}    
    }

    It "Should not throw on a valid TCP port number" {
        {Test-port -Computer . -Port 25} | should not throw
    }
}

Describe "Test-Port -Computer parameter"{
}
