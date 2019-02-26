#region Prepare to deploy
# Create Security group
Invoke-Command -ComputerName 'netdc01' -ScriptBlock {
    New-ADGroup -GroupCategory Security -GroupScope Global -Name 'NCClients'
    Add-ADGroupMember 'NCClients' -Members 'netdc01$'

    New-ADGroup -GroupCategory Security -GroupScope Global -Name 'NCAdmins'
    Add-ADGroupMember 'NCAdmins' -Members Administrator
}

# Install the role
Install-WindowsFeature -Name NetworkController -IncludeManagementTools

#endregion

#region Install the network controller
# Create the node object for each Network Controller
$nodeParams = @{
    Name = 'Node1'
    Server = 'Net01'
    FaultDomain = 'Fd:/Lab1/Rack1/Host1'
    RestInterface = 'ethernet'
}
$node = New-NetworkControllerNodeObject @nodeParams

# Find the certificate to use
# Must have 'Server Authentication' in extensions
$certificate = Get-ChildItem Cert:\LocalMachine\My

# Create the cluster
$netControllerCluster = @{
    Node = $Node
    ClusterAuthentication = 'Kerberos'
    ManagementSecurityGroup = 'NCAdmins'
}
Install-NetworkControllerCluster @netControllerCluster

# Install the controller
$netController = @{
    Node = $node
    ClientAuthentication = 'Kerberos'
    ClientSecurityGroup = 'NCClients'
    ServerCertificate = $certificate
}
Install-NetworkController @netController
#endregion