#region Finding files in AWS

$BucketName = 'snip-videos'

# Get all files
Get-S3Object -BucketName $BucketName

# Get a single file
$Params = @{
    BucketName = $BucketName
    Key = 'how to assign specific services to users in office 365 using powershell/final.mp4'
}
Get-S3Object @Params

# Find by key prefix
$Params = @{
    BucketName = $BucketName
    KeyPrefix = 'how to'
}
Get-S3Object @Params

# Find by marker
$Params = @{
    BucketName = $BucketName
    Marker = 'how'
}
Get-S3Object @Params

# Limit file count
$Params = @{
    BucketName = $BucketName
    KeyPrefix = 'how to'
    MaxKey = 15
}
Get-S3Object @Params

#endregion

#region Downloading files in AWS

# A single file
$Params = @{
    BucketName = $BucketName
    Key = 'how to assign specific services to users in office 365 using powershell/final.mp4'
    File = 'D:\TechSnips\tmp\final.mp4'
}
Read-S3Object @Params

Get-Item $Params.File
Remove-Item $Params.File -Confirm:$false

# Based on key prefix
$Params = @{
    BucketName = $BucketName
    KeyPrefix = 'how'
    Folder = 'D:\TechSnips\tmp\'
}
Read-S3Object @Params

$Params.KeyPrefix = 'how to assign specific services to users in office 365 using powershell'
Read-S3Object @Params

Get-ChildItem $Params.Folder
Get-ChildItem $Params.Folder | Remove-Item -Confirm:$false

# A group of objects based on last modified date
$Params = @{
    BucketName = $BucketName  
    KeyPrefix = 'how to assign specific services to users in office 365 using powershell'
    ModifiedSinceDate = (Get-Date).AddHours(-12)
    Folder = 'D:\TechSnips\tmp'
}
Read-S3Object @Params

Get-ChildItem $Params.Folder

$Params.KeyPrefix = 'how to import a powershell module to azure automation directly from the powershell gallery'
Read-S3Object @Params

Get-ChildItem $Params.Folder

#endregion