$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. ..\PowerWorks\Public\$sut

Describe "Test-Port" {
    It "Should throw an error on an invalid TCP port number" {
        {Test-port -Computer . -Port 65536} | should throw
    }
}