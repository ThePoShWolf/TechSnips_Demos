#region Getting started

#region How -match works
'string' -match 'string'
#endregion

#region But -like does the same thing...
'string' -like 'string'
#endregion

#region Basic regular expression
'str1ng' -match '\d'
#endregion

#region $Matches variable
$Matches
#endregion

#region Return the value specifically
$Matches[0]
#endregion
#endregion

#region Real world example

$string = "I've worked in IT for 30 years."

#region Matching numbers
If($string -match '\d'){
    $Matches[0]
}
#endregion

#region More than one
If($string -match '\d+'){
    $Matches[0]
}
#endregion

#region Considering acceptable range
If($string -match '(1)?\d{2}'){
    $Matches[0]
}
#endregion

$string = "I've worked in IT for 130 years."
$string = "I've worked in IT for 201 years."

#region Better matching
If($string -match '[\D1]\d{2}\D'){
    $Matches[0]
}
#endregion
#endregion