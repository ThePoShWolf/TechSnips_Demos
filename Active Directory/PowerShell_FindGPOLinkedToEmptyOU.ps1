#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Sort OUs by whether or not they have child items
$emptyOUs = $nonEmptyOUs = @()
ForEach($OU in Get-ADOrganizationalUnit -Filter *){
    $objects = $null
    $objects = Get-ADObject -filter * -SearchBase $OU | Where-Object ObjectClass -ne "organizationalunit"
    If($objects){
        $nonEmptyOUs += $OU
    }Else{
        $emptyOUS += $OU
    }
}
#endregion

#region Find GPOs linked to those OUs

$GPOsLinkedToEmptyOUs = @()
ForEach($OU in $emptyOUs | Where-Object LinkedGroupPolicyObjects){
    ForEach($GPO in $OU.LinkedGroupPolicyObjects){
        $GPOsLinkedToEmptyOUs += [PSCustomObject]@{
            GPO = Get-GPO -Guid $GPO.Substring(4,36)
            OU = $OU
        }
    }
}
#endregion

#region Check if those GPOs are linked anywhere else

ForEach($OU in $nonEmptyOUs){
    ForEach($GPO in $GPOsLinkedToEmptyOUs){
        If($OU.LinkedGroupPolicyObjects){
            If($OU.LinkedGroupPolicyObjects.Substring(4,36) -contains $GPO.GPO.Id){
                Write-Host "$($GPO.GPO.DisplayName) also linked to $($OU.Name)"
            }
        }
    }
}

#endregion 
$LinkedGPOs = Get-ADOrganizationalUnit $OU | Select-Object -ExpandProperty LinkedGroupPolicyObjects
$LinkedGPOGUIDs = $LinkedGPOs | ForEach-Object{$_.Substring(4,36)}
$LinkedGPOGUIDs | ForEach-Object {Get-GPO -Guid $_ | Select-Object DisplayName}