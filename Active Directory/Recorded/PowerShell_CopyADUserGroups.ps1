Function Copy-ADUserGroups {
    Param(
        [string]$CopyFrom,
        [string]$CopyTo
    )
    ForEach($group in (Get-ADUser $CopyFrom -Properies MemberOf).MemberOf){
        Add-ADGroupMember $group -Member $CopyTo
    }
}