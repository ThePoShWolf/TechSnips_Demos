$newVMName = 'Test VM'
$stagingVHDPath = 'C:\users\Public\Documents\Hyper-V\Virtual hard disks\New\'
$defaultVHDPath = 'C:\users\Public\Documents\Hyper-V\Virtual hard disks'

# Import the template
$newVM = Import-VM -Path 'E:\VMTemplate\Template\Virtual Machines\C30F0BFA-2D6A-48E4-BF93-8D8057332C15.vmcx' -Copy -VhdDestinationPath $stagingVHDPath -GenerateNewId

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