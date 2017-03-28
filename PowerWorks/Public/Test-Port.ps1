<#
        .Synopsis
        This cmdlet will test a given TCP port till the port is open

        .DESCRIPTION
        This cmdlet will continously test a given TCP port untill the cmdlet is halted or a connection to the given port is established.  This is useful for testing connectivity while configuring firewall rules.  This function also allows for the verbose switch to be used.

        .PARAMETER Computer
        This is the name of the computer you want to test connectivity to

        .PARAMETER IPv4
        This is the IP address of the computer you want to test connectivity to

        .PARAMETER Port
        This is the port on the remote Computer you want to test connectivity to

        .EXAMPLE
        PS C:\> Test-Port -Computer somePC -Port 80

        .EXAMPLE
        PS C:\> Test-Port -IPv4 someIP -Port 80

        .EXAMPLE
        PS C:\> Test-Port -Computer somePC -Port 80 -Verbose

        .EXAMPLE
        PS C:\> Test-Port -IPv4 someIP -Port 80 -Verbose
        
        .OUTPUTS
        This script has no outputs.

        .LINK
        http://powerworks.readthedocs.io/en/latest/functions/Test-Port.md

        .LINK
        https://github.com/RobertCGouge/PowerWorks/blob/master/PowerWorks/Public/Test-Port.ps1            
#>
function Test-Port
{
    [CmdletBinding(HelpURI = 'http://powerworks.readthedocs.io/en/latest/functions/Test-Port')]
    [Alias()]
    Param
    (
        [Parameter(Mandatory = $true,
                Position = 0,
                ParameterSetName = 'ComputerName',
        HelpMessage = 'This is the name of the computer you want to test connectivity to')]
        $Computer,
        [Parameter(Mandatory = $true,
                Position = 0,
                ParameterSetName = 'IPAddress',
        HelpMessage = 'This is the IP address of the computer you want to test connectivity to')]
        [ValidateScript({
                    if([bool]($_ -as [ipaddress]))
                    {
                        $true
                    }
                    else
                    {
                        throw "$_ is not a valid IPv4 Address"
                    }
        })]
        $IPv4,
        [Parameter(Mandatory = $true,
                Position = 1,
                ParameterSetName = 'ComputerName',
        HelpMessage = 'This is the port on the remote Computer you want to test connectivity to')]
        [Parameter(ParameterSetName = 'IPAddress')]
        [ValidateRange(1,65535)]
        [int]
        $Port
    )

    Begin
    {
        if($Computer -ne $null)
        {
            Write-Verbose -Message "Attempting to connect to port: $Port at computer: $Computer"
        }
        if($IPv4 -ne $null)
        {
            Write-Verbose -Message "Attempting to connect to port: $Port at IP Address: $IPv4"
        }
    }
    Process
    {
        if($Computer -ne $null)
        {
            do
            {
                Start-Sleep -Seconds 5
            } until (Test-NetConnection -ComputerName $Computer -Port $Port)
        }
        if($IPv4 -ne $null)
        {
            do
            {
                Start-Sleep -Seconds 5
            } until (Test-NetConnection -ComputerName $IPv4 -Port $Port)
        }
        
    }
    End
    {
    }
}
