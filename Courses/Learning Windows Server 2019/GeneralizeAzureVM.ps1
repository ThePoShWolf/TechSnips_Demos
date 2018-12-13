#Connect-AzureRmAccount
Stop-AzureRmVM -ResourceGroupName myResourceGroup -Name myVM -Force
Set-AzureRmVM -ResourceGroupName myResourceGroup -Name myVM -Generalized

$vm = Get-AzureRmVM -Name myVM -ResourceGroupName myResourceGroup
$image = New-AzureRmImageConfig -Location EastUS -SourceVirtualMachineId $vm.ID 
New-AzureRmImage -Image $image -ImageName myImage -ResourceGroupName myResourceGroup

