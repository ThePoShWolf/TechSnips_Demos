$rGroup = 'Anthony_Containers'
$cName = 'containerazcli'

# Show the resource group
az group show `
    --name $rGroup

# Create the container
az container create `
    --resource-group $rGroup `
    --name $cName `
    --image microsoft/aci-helloworld `
    --dns-name-label $cName `
    --ports 80

# Show the container
az container show `
    --resource-group $rGroup `
    --name $cName `
    --query "{FQDN:ipAddress.fqdn,ProvisioningState:provisioningState}" `
    --out table