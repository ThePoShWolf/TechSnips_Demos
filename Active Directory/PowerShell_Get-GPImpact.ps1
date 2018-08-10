#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Go over prerequisites
$Name = 'Test'

#Retrieve the GPO and properties
$GPO = Get-GPO -Name $Name

#Retrieve the for the GPO
Get-GPPermission -All -Name $Name | Where-Object {$_.Permission -eq "GpoApply"}
$scope = Get-GPPermission -All -Name $Name | Where-Object {$_.Permission -eq "GpoApply"}

#Find all OUs that have the GPO linked
$OUs = Get-ADOrganizationalUnit -Filter * -Properties gplink | Where-Object {$_.gplink -like "*$($gpo.id)*"}

#Find all objects in scope in each OU
If($Scope.Trustee.Name -contains "Authenticated Users"){
    ForEach($OU in $OUs){
        Get-ADObject -SearchBase $ou.distinguishedname -Filter * | Where-Object {@("user","computer") -contains $_.objectclass} | Select-Object Name,ObjectClass
    }
}ElseIf($Scope.Trustee){
    $groupMembers = @()
    #Get group members within scope
    ForEach($Group in ($scope | Where-Object {$_.Trustee.SidType -eq "Group"})){
        $groupMembers += Get-ADGroupMember $group.Trustee.Name 
    }
    $groupMembers = $groupMembers | Select-Object -Unique
    #Find members the GPO applies to
    Foreach($OU in $OUs){
        Get-ADObject -SearchBase $ou.DistinguishedName -Filter * | Where-Object {@("user","computer") -contains $_.objectclass} | Where-Object {$groupMembers.Name -contains $_.name} | Select-Object Name,ObjectClass
    }
    #Find all users and computers explicitly within scope
    ForEach($object in ($scope | Where-Object {@("user","computer") -contains $_.TrusteeType})){
        Switch($object.TrusteeType){
            "User" {$object = Get-ADUser $object.Trustee}
            "Computer" {$object = Get-ADComputer $object.Trustee}
        }
        If($OUs -contains ($object.distinguishedname -creplace "^[^,]*,","")){
            Get-ADObject $object.distinguishedname
        }
    }
}

#endregion

#region Final Script
Function Get-GPImpact
{
    [cmdletbinding()]
    Param(
        [Parameter(ParameterSetName="Name",Mandatory="True")]
        [string]$Name
        ,
        [Parameter(ParameterSetName="ID",Mandatory="True")]
        [string]$ID
    )
    Begin{}
    Process{
        Switch ($psCmdlet.ParameterSetName){
            "Name" {
                Write-Verbose "using name"
                Try{
                    $gpo = Get-GPO -Name $Name
                }Catch{
                    Write-Error $error[0]
                    Return
                }
                $scope = Get-GPPermission -All -Name $Name | ?{$_.Permission -eq "GpoApply"}
                Write-Verbose "Scope: $($scope.trustee.name)"
            }
            "ID" {
                Write-Verbose "using id"
                Try{
                    $gpo = Get-GPO -Id $ID
                }Catch{
                    Write-Error $error[0]
                    Return
                }
                $scope = Get-GPPermission -All -Id $ID | ?{$_.Permission -eq "GpoApply"}
                Write-Verbose "Scope: $($scope.trustee.name)"
            }
        }
        $ous = Get-ADOrganizationalUnit -Filter * -Properties gplink | Where-Object {$_.gplink -like "*$($gpo.id)*"}
        If((Get-ADDomain).LinkedGroupPolicyObjects -like "*$($gpo.id)*"){
            $ous += (Get-ADDomain).DistinguishedName
        }
        If($ous){
            If($scope.Trustee.Name -contains "Authenticated Users"){
                Write-Verbose "Authenticated Users"
                ForEach($ou in $ous){
                    Write-Verbose $ou.distinguishedname
                    Get-ADObject -SearchBase $ou.distinguishedname -Filter * | Where-Object {@("user","computer") -contains $_.objectclass} | Select Name,ObjectClass
                }
            }ElseIf($scope.Trustee){
                If($Scope.Trustee.Name -contains "Authenticated Users"){
                    ForEach($OU in $OUs){
                        Get-ADObject -SearchBase $ou.distinguishedname -Filter * | Where-Object {@("user","computer") -contains $_.objectclass} | Select-Object Name,ObjectClass
                    }
                }ElseIf($Scope.Trustee){
                    $groupMembers = @()
                    #Get group members within scope
                    ForEach($Group in ($scope | Where-Object {$_.Trustee.SidType -eq "Group"})){
                        $groupMembers += Get-ADGroupMember $group.Trustee.Name 
                    }
                    $groupMembers = $groupMembers | Select-Object -Unique
                    #Find members the GPO applies to
                    Foreach($OU in $OUs){
                        Get-ADObject -SearchBase $ou.DistinguishedName -Filter * | Where-Object {@("user","computer") -contains $_.objectclass} | Where-Object {$groupMembers.Name -contains $_.name} | Select-Object Name,ObjectClass
                    }
                    #Find all users and computers explicitly within scope
                    ForEach($object in ($scope | Where-Object {@("user","computer") -contains $_.TrusteeType})){
                        Switch($object.TrusteeType){
                            "User" {$object = Get-ADUser $object.Trustee}
                            "Computer" {$object = Get-ADComputer $object.Trustee}
                        }
                        If($OUs -contains ($object.distinguishedname -creplace "^[^,]*,","")){
                            Get-ADObject $object.distinguishedname
                        }
                    }
                }
            }Else{
                Write-Error "GPO has no scope."
            }
        }Else{
            Write-Host "GPO has no links"
        }
    }
    End{}
}
#endregion