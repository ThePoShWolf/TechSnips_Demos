Function New-VMFromTemplate {
    Param(
        [string]$NewVMName,
        [string]$TemplatePath = 'E:\VMTemplate\Template',
        [string]$StagingVHDPath = 'C:\users\Public\Documents\Hyper-V\Virtual hard disks\New\',
        [string]$DefaultVHDPath = 'C:\users\Public\Documents\Hyper-V\Virtual hard disks'
    )
    $TemplateFile = Get-Item (Join-Path $TemplatePath -ChildPath 'Virtual Machines\*.vmcx')
    If(Test-Path $TemplateFile.FullName){

        # Import the template
        $newVM = Import-VM -Path $TemplateFile.FullName -Copy -VhdDestinationPath $stagingVHDPath -GenerateNewId

        # Get the VHD Info
        $vmHD = Get-VMHardDiskDrive -VM $newVM -ControllerLocation 0 -ControllerNumber 0

        # Rename and move the VHD
        $newVHDPath = "$defaultVHDPath\$newVMName.vhdx"
        Move-Item $vmHD.Path -Destination $newVHDPath

        # Remove and attach the VHD
        Remove-VMHardDiskDrive -VMHardDiskDrive $vmHD
        Add-VMHardDiskDrive -VM $newVM -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0 -Path $newVHDPath

        # Rename VM
        Rename-VM -VM $newVM -NewName $newVMName
    }
}