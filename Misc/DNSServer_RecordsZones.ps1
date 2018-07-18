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

#A record
Add-DnsServerResourceRecord -ZoneName "techsnipsdemo.org" -A -Name "ntp01" -IPv4Address "10.0.2.200"

#CNAME
Add-DnsServerResourceRecord -CName -Name "server" -HostNameAlias "dc01.techsnipsdemo.org" -ZoneName "techsnipsdemo.org" -AllowUpdateAny  -TimeToLive 01:00:00

#MX
Add-DnsServerResourceRecord -Name "." -MX -ZoneName "techsnipsdemo.org" -MailExchange "ex01.techsnipsdemo.org" -Preference 10

#SRV
Add-DnsServerResourceRecord -Srv -Name "@" -ZoneName "techsnipsdemo.org" -DomainName "_sip._tcp.sipdir.online.lync.com" -Priority 100 -Weight 10 -Port 443 -TimeToLive 01:00:00
#endregion

#region Editting a resource record
Set-DnsServerResourceRecord

#endregion

#region Removing a resource record
Remove-DnsServerResourceRecord

#endregion