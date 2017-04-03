<#
.Synopsis
   This function will return how old a virtual machine is and how long it has been off.
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-SCVirtualMachineAge
{
    [CmdletBinding()]
    [Alias()]
    #[OutputType([VirtualMachine])]
    Param
    (
        # This is System Center Virtual Machine Manager you want to query for Virtual Machines
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   ParameterSet='SCVMM')]
        $VMMServer
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