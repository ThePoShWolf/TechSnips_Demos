Function Copy-ADUserGroups {
    Param(
        [string]$CopyFrom,
        [string]$CopyTo
    )
    ForEach($group in (Get-ADUser $CopyFrom -Properies MemberOf).MemberOf){
        Add-ADGroupMember $group -Member $CopyTo
    }
    <# One-liner
        (Get-ADUser $CopyFrom -Properties MemberOf).MemberOf | Foreach-Object { Add-ADGroupMember $_ -Member $CopyTo}
    #>
}