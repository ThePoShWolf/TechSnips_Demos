#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region 

$group = 'Domain Admins'

#Retrieve group memberships
Get-ADGroupMember $group



#endregion