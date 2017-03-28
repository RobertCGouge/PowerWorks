﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Get-Item $here).Parent


$module = (Get-ChildItem -Path $root.FullName -Recurse -Filter '*.psm1').FullName

import-module $module


$ip = Resolve-DnsName -Name www.google.com | Where-Object -FilterScript {$_.Type -like 'AAAA'}

Describe "Test-Port -Port parameter" {
    It "Should throw an error on an invalid TCP port number" {
        {Test-port -Computer www.google.com -Port 65536} | should throw
    }
    It "Should throw an error when a string is passed" {
        {Test-port -Computer www.google.com -Port string | should throw}    
    }

    It "Should not throw on a valid TCP port number" {
        {Test-port -Computer www.google.com -Port 80} | should not throw
    }
}

Describe "Test-Port -Computer parameter"{
    It "Should accecpt a string" {
        {Test-port -Computer www.google.com -Port 80 | should not throw}
    }
    It "Should throw when passed a name that is unabled to be resolved"{
        {Test-Port -Computer notfound -Port 80 | should throw "$_ could not be resolved, please try another computer name."}
    }
        It "Should throw when passed an ip address" {
        {Test-port -Computer 8.8.8.8 -Port 53 | should throw "$_ is an IP address, please try again with -IPv4"}
    }
}

Describe "Test-Port -IPv4"{
    It "Should throw when an invalid IPv4 is passed" {
        {test-port -IP 555.555.555.555 -port 80 | should throw "$_ is not a valid IPv4 Address"}
    }
    It "Should not throw when a valid IPv4 is passed" {
        {test-port -IP 8.8.8.8 -port 53 | should not throw}
    }
    it "Should not throw when a valid IPv6 is passed" {
        {test-port -IP $ip.IPAddress -port 443 | should not throw}
    }
}
