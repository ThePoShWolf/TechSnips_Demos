#region prep
$cred = Get-Credential
$net01 = New-PSSession Net01 -Credential $cred
$dc01 = New-PSSession DC01 -Credential $cred
#endregion

#region Prepare to deploy
# Create Security group
Invoke-Command -Session $dc01 -ScriptBlock {
    New-ADGroup -GroupCategory Security -GroupScope Global -Name 'Network Controller Clients'
    Add-ADGroupMember 'Network Controller Clients' -Members 'DC01$','DC02$'
}

Enter-PSSession -Session $net01

# Install the role
Install-WindowsFeature -Name NetworkController -IncludeManagementTools

#endregion

$node = New-NetworkControllerNodeObject -Name 'Net01' -Server 'Net01' -FaultDomain 'Fd:/Lab1/Rack1/Host1' -RestInterface 'ethernet'
Install-NetworkControllerCluster -Node $NodeObject -ClusterAuthentication None
Install-NetworkController -Node $node -ClientAuthentication Kerberos -ClientSecurityGroup 'Network Controller Clients'