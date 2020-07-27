#region demo
Throw "This is a demo, dummy!"
#endregion

`
<#
 
 ` | 1 | 2 | 3
 Tab | Q | W
 Caps | A | S

#>

#region Escaping characters in strings
# $ preceding a string: $10
"$10"
"`$10"
'$10'

# $ preceding a space
"$ "
"$-"

# Not sure? Escaping won't hurt
"$` "
'$` '

# Quotes in quotes: This "should" work
"This "Should" work"
"This `"Should`" work"
'This "Should" work'
"This 'Should' work"

# Joining to variables together inside ""
# This should end up as: Filename_07-27.txt
$name = 'FileName'
$date = Get-Date -Format 'MM-dd'
$ext = '.txt'

"$name_$date$ext"

"$name`_$date$ext"

#endregion

#region Special characters (https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters)
# Line break
"This is the first line`n`nAnd this is the second."

# Tab
"This is on the left`t`tAnd this is tabbed to the right."

#endregion

#region Line continuation
New-Item -Path "C:\Users\Anthony\AppData\Local\Temp" -Name "Anthony_Test.txt" -ItemType File | Remove-Item

New-Item -Path "C:\Users\Anthony\AppData\Local\Temp" `
-Name "Anthony_Test.txt" -ItemType File | Remove-Item

# Consider splatting!
$splat = @{
    Path = "C:\Users\Anthony\AppData\Local\Temp"
    Name = "Anthony_Test.txt"
    ItemType = 'File'
}
New-Item @splat | Remove-Item

#endregion