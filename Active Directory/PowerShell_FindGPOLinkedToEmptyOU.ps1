#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Sort OUs by whether or not they have child items

$emptyOUs = $nonEmptyOUs = @()
ForEach($OU in Get-ADOrganizationalUnit -Filter {LinkedGroupPolicyObjects -like "*"}){
    $objects = $null
    $objects = Get-ADObject -filter * -SearchBase $OU | Where-Object ObjectClass -ne "organizationalunit"
    If($objects){
        Write-Host "OU: '$($OU.Name)' is not empty"
        $nonEmptyOUs += $OU
    }Else{
        Write-Host "OU: '$($OU.Name)' is empty"
        $emptyOUS += $OU
    }
}
#endregion

#region Find GPOs linked to those OUs

$GPOsLinkedToEmptyOUs = @()
ForEach($OU in $emptyOUs | Where-Object LinkedGroupPolicyObjects){
    ForEach($GPOGuid in $OU.LinkedGroupPolicyObjects){
        $GPO = Get-GPO -Guid $GPOGuid.Substring(4,36)
        Write-Host "GPO: '$($GPO.DisplayName)' is linked to empty OU: $($OU.Name)"
        If($GPOsLinkedToEmptyOUs.GPO.Id -contains $GPO.Id){
            $GPOsLinkedToEmptyOUs | Where-Object {$_.GPO.Id -eq $GPO.Id} | ForEach-Object {$_.EmptyOU = [string[]]$_.EmptyOU + "$($OU.DistinguishedName)"}
        }Else{
            $GPOsLinkedToEmptyOUs += [PSCustomObject]@{
                GPO = $GPO
                EmptyOU = $OU.DistinguishedName
                NonEmptyOU = ''
            }
        }
    }
}
#endregion

#region Check if those GPOs are linked anywhere else

ForEach($OU in $nonEmptyOUs){
    ForEach($GPO in $GPOsLinkedToEmptyOUs){
        If($OU.LinkedGroupPolicyObjects){
            If($OU.LinkedGroupPolicyObjects.Substring(4,36) -contains $GPO.GPO.Id){
                Write-Verbose "GPO: '$($GPO.GPO.DisplayName)' also linked to non-empty OU: $($OU.Name)"
                If($GPO.NonEmptyOUs){
                    $GPO.NonEmptyOU = [string[]]$GPO.NonEmptyOU + $OU.DistinguishedName
                }Else{
                    $GPO.NonEmptyOU = $OU.DistinguishedName
                }
            }
        }
    }
}

#endregion

#region Bring it all together into a function with useful output

Function Get-GPOsLinkedToEmptyOUs{
    [cmdletbinding()]
    Param()
    $emptyOUs = $nonEmptyOUs = @()
    ForEach($OU in Get-ADOrganizationalUnit -Filter {LinkedGroupPolicyObjects -like "*"){
        $objects = $null
        $objects = Get-ADObject -filter * -SearchBase $OU | Where-Object ObjectClass -ne "organizationalunit"
        If($objects){
            Write-Verbose "OU: '$($OU.Name)' is not empty"
            $nonEmptyOUs += $OU
        }Else{
            Write-Verbose "OU: '$($OU.Name)' is empty"
            $emptyOUS += $OU
        }
    }
    $GPOsLinkedToEmptyOUs = @()
    ForEach($OU in $emptyOUs | Where-Object LinkedGroupPolicyObjects){
        ForEach($GPOGuid in $OU.LinkedGroupPolicyObjects){
            $GPO = Get-GPO -Guid $GPOGuid.Substring(4,36)
            Write-Verbose "GPO: '$($GPO.DisplayName)' is linked to empty OU: $($OU.Name)"
            If($GPOsLinkedToEmptyOUs.GPO.Id -contains $GPO.Id){
                $GPOsLinkedToEmptyOUs | Where-Object {$_.GPO.Id -eq $GPO.Id} | ForEach-Object{$_.EmptyOU = [string[]]$_.EmptyOU + "$($OU.DistinguishedName)"}
            }Else{
                $GPOsLinkedToEmptyOUs += [PSCustomObject]@{
                    GPO = $GPO
                    EmptyOU = $OU.DistinguishedName
                    NonEmptyOU = ''
                }
            }
        }
    }
    ForEach($OU in $nonEmptyOUs){
        ForEach($GPO in $GPOsLinkedToEmptyOUs){
            If($OU.LinkedGroupPolicyObjects){
                If($OU.LinkedGroupPolicyObjects.Substring(4,36) -contains $GPO.GPO.Id){
                    Write-Verbose "GPO: '$($GPO.GPO.DisplayName)' also linked to non-empty OU: $($OU.Name)"
                    If($GPO.NonEmptyOUs){
                        $GPO.NonEmptyOU = [string[]]$GPO.NonEmptyOU + $OU.DistinguishedName
                    }Else{
                        $GPO.NonEmptyOU = $OU.DistinguishedName
                    }
                }
            }
        }
    }
    $GPOsLinkedToEmptyOUs
}

#endregion