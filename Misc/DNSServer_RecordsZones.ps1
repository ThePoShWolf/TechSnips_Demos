#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
Remove-DnsServerZone 'northamerica.techsnipsdemo.org' -force
Remove-DnsServerZone 'europe.techsnipsdemo.org' -force
Remove-DnsServerZone '2.0.10.in-addr.arpa' -force
#endregion

#prerequisite
Get-Module DNSServer

#region Getting current zones
#All zones
Get-DnsServerZone

#Remote DNS server
Get-DnsServerZone -ComputerName DC01

#Specific zone
Get-DnsServerZone techsnipsdemo.org

#endregion

#region Adding a primary zone
#AD integrated
Add-DnsServerPrimaryZone -Name 'northamerica.techsnipsdemo.org' -ReplicationScope "Forest"
#Rep scope: Forest,Domain,Legacy,Custom

#File backed
Add-DnsServerPrimaryZone -Name 'europe.techsnipsdemo.org' -ZoneFile 'europe.techsnipsdemo.org.dns'

#Reverse lookup
Add-DnsServerPrimaryZone -NetworkID '10.0.2.0/24' -ReplicationScope "Domain"

#Verify
Get-DnsServerZone

#endregion

#region Adding a secondary zone
Add-DnsServerSecondaryZone

#endregion

#region removing a zone
Remove-DnsServerZone

#endregion

#region Adding a resource record
Add-DnsServerResourceRecord

#endregion

#region Editting a resource record
Set-DnsServerResourceRecord

#endregion

#region Removing a resource record
Remove-DnsServerResourceRecord

#endregion