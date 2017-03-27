<#
        .Synopsis
            This cmdlet will test a given TCP port till the port is open

        .DESCRIPTION
            This cmdlet will continously test a given TCP port untill the cmdlet is halted or a connection to the given port is established.  This is useful for testing connectivity while configuring firewall rules.

        .PARAMETER Computer
            This is the name or IP address of the computer you want to test connectivity to

        .PARAMETER Port
            This is the port on the remote Computer you want to test connectivity to

        .EXAMPLE
            PS C:\> Test-Port -Computer somePC -Port 80

        .EXAMPLE
            PS C:\> Test-Port -Computer someIP -Port 80
        
        .OUTPUTS
            This script has no outputs.

        .LINK
            http://powerworks.readthedocs.io/en/latest/functions/Test-Port.md

        .LINK
            https://github.com/RobertCGouge/PowerWorks/blob/master/PowerWorks/Public/Test-Port.ps1            
#>
function Test-Port
{
    [CmdletBinding(HelpURI="http://powerworks.readthedocs.io/en/latest/functions/Test-Port")]
    [Alias()]
    Param
    (
        [Parameter(Mandatory = $true,
                ValueFromPipelineByPropertyName = $true,
                Position = 0,
                HelpMessage = "This is the name or IP address of the computer you want to test connectivity to")]
        $Computer,
        [Parameter(Mandatory = $true,
                Position = 1,
                HelpMessage = "This is the port on the remote Computer you want to test connectivity to")]
        [ValidateRange(1,65535)]
        [int]
        $Port
    )

    Begin
    {
    }
    Process
    {
    }
    End
    {
    }
}
