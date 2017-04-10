class VirtualMachine {
    [String]$Name
    [string]$owner
    [string]$ownerEmail
    [Guid]$ID
    [datetime]$dateCreated
    [string]$status
    [int]$ram
    [int]$cores


    VirtualMachine ($Name){

    $vm = Get-SCVirtualMachine -Name $Name
    $this.ID = $vm.ID
    $this.name = $Name
    $this.owner = $vm.Owner
    $this.dateCreated = $vm.CreationTime
#   $this.ownerEmail = (Get-ADUser -Identity $this.owner.Split('\')[-1] -Properties *).EmailAddress

    
    
    $this.status = $vm.StatusString
    $this.ram = $vm.Memory
    $this.cores = $vm.CPUCount
    
    }
    

}