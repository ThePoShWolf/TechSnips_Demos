# Create a new Virtual Switch
New-VMSwitch -Name 'External02' -NetAdapterName 'Microsoft Hyper-V Network Adapter' -AllowManagementOS

# Create a new Virtual Machine
New-VM -Name 'New VM From PS' -MemoryStartupBytes 4GB -Generation 2 -BootDevice CD -SwitchName 'External02'

# Add a processor
Set-VM -Name 'New VM From PS' -ProcessorCount 2

# Attach the .iso to the DVD drive
Set-VMDvdDrive -VMName 'New VM From PS' -Path E:\en_windows_server_2019_x64_dvd_4cb967d8.iso

# Start the vm
Start-VM -Name 'New VM From PS'