#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
Remove-Item $dir
New-Item $dir -ItemType Directory
New-Item "$dir\dog.txt" -ItemType File
New-Item "$dir\cat.txt" -ItemType File
#endregion

#region variables
$dir = 'C:\Temp'
#endregion

#region Retrieving current ACLs
#Get the ACL
Get-Acl $dir

#Examine the Access property
(Get-Acl $dir).Access

#Other format
Get-Acl $dir | Select-Object -ExpandProperty Access

#Format the output
(Get-Acl $dir).Access | Format-Table

#Additional useful stuff
#filtering for a user or group
(Get-Acl $dir).Access | Where-Object {$_.IdentityReference -like '*admin*'} | Format-Table

#Finding uninherited permissions
(Get-Acl $dir).Access | Where-Object {-not ($_.IsInherited)} | Format-Table

#endregion

#region Setting Acls
#Microsoft example. Boring.
$ACL = Get-Acl "$dir\Dog.txt"
Set-Acl -Path "$dir\Cat.txt" -AclObject $ACL

#region Add an ACE to an existing ACL on a folder
#Create the ACE
$identity = 'techsnipsdemo\Fido'
$rights = 'FullControl' #other options: [enum]::GetValues('System.Security.AccessControl.FileSystemRights')
$inheritance = 'ContainerInherit, ObjectInherit' #other options: [enum]::GetValues('System.Security.AccessControl.InheritanceFlags')
$propagation = 'None' #other options: [enum]::GetValues('System.Security.AccessControl.PropagationFlags')
$type = 'Allow' #other options: [enum]::GetValues('System.Security.AccessControl.AccessControlType')
$ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)

#Add ACE to ACL
$ACL = Get-Acl $dir
$ACL.AddAccessRule($ACE)

#Set-Acl
Set-Acl $dir -AclObject $ACL
#endregion

#region Remove an ACE on an existing ACL on a folder
#Get existing ACL
$ACL = Get-Acl $dir

#Filter for the ACE to remove
$ACE = $ACL.Access | ?{$_.IdentityReference -eq 'techsnipsdemo\Fido'}

#Remove the ACE
$ACL.RemoveAccessRule($ACE)

#Set the ACL
Set-Acl $dir -AclObject $ACL
#endregion

#endregion

#region Scripting ACLs
#variables
$share = 'C:\Share'
$folders = Get-ChildItem $share -Directory

$domain = 'techsnipsdemo'
$rights = 'Modify'
$inheritance = 'ContainerInherit, ObjectInherit'
$propagation = 'None'
$type = 'Allow'

#script
ForEach($folder in $folders){
    Write-Host "Working on $($folder.name)"
    If(Get-ADGroup $folder.Name){
        Write-Host ' -Creating ACE'
        $identity = "$domain\$($folder.name)"
        $ACE = New-Object System.Security.AccessControl.FileSystemAccessRule($identity,$rights,$inheritance,$propagation,$type)
        $ACL = Get-Acl $folder.FullName
        Write-Host ' -Adding ACE to ACL'
        $ACL.AddAccessRule($ACE)
        Write-Host ' -Applying new ACL to folder'
        Set-Acl $folder.FullName -AclObject $ACL
    }
}
#endregion
