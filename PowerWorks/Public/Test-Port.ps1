#requires -Version 2
<#
        .Synopsis
        This cmdlet will test a given TCP port till the port is open
        .DESCRIPTION
        This cmdlet will continously test a given TCP port untill the cmdlet is halted or a connection to the given port is established.  This is useful for testing connectivity while configuring firewall rules.
        .EXAMPLE
        Example of how to use this cmdlet
        .EXAMPLE
        Another example of how to use this cmdlet
#>
function Test-Port
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        # This is the remote machine you want to test connectivity to on the given port.
        [Parameter(Mandatory = $true,
                ValueFromPipelineByPropertyName = $true,
                Position = 0)]
        $Computer,

        # This is the port you wish to test connectivity to.
        [Parameter(Mandatory = $true,
                Position = 1)]
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
