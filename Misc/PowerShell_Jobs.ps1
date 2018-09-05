#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

<# Notes
Start-Job
Get-Job
Receive-Job
Remove-Job
#>

#Source: https://moz.com/top500
$Top500Websites = Import-Csv 'D:\TechSnips\top500.domains.05.18.csv'