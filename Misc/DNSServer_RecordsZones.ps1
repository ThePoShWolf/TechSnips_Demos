#region demo header
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
Remove-DnsServerZone 'northamerica.techsnipsdemo.org' -force
Remove-DnsServerZone 'europe.techsnipsdemo.org' -force
Remove-DnsServerZone '2.0.10.in-addr.arpa' -force
Invoke-Command -ComputerName DNS01 -ScriptBlock {
    Remove-DnsServerZone 'northamerica.techsnipsdemo.org' -force
    Remove-DnsServerZone '2.0.10.in-addr.arpa' -force
}
Remove-DnsServerResourceRecord -Name "ntp01" -ZoneName "techsnipsdemo.org" -RRType 'A'
Remove-DnsServerResourceRecord @CNAMERecord
Remove-DnsServerResourceRecord @MXRecord
Remove-DnsServerResourceRecord @SRVRecord
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
#Replication scope options: Forest,Domain,Legacy,Custom

#File backed
Add-DnsServerPrimaryZone -Name 'europe.techsnipsdemo.org' -ZoneFile 'europe.techsnipsdemo.org.dns'

#Reverse lookup
Add-DnsServerPrimaryZone -NetworkID '10.0.2.0/24' -ReplicationScope "Domain"

#Verify
Get-DnsServerZone

#endregion

#region Adding a secondary zone
#Secondary zone
Add-DnsServerSecondaryZone -Name 'northamerica.techsnipsdemo.org' -ZoneFile 'northamerica.techsnipsdemo.org.dns' -MasterServers 10.2.2.2

#Secondary reverse lookup zone
Add-DnsServerSecondaryZone -NetworkID '10.0.2.0/24' -ZoneFile '2.0.10.in-addr.arpa.dns' -MasterServers 10.2.2.2

#Verify
Get-DnsServerZone

#endregion

#region removing a zone
Remove-DnsServerZone -Name 'europe.techsnipsdemo.org' -Force

#endregion

#region Adding a resource record
Add-DnsServerResourceRecord

#A record
Add-DnsServerResourceRecord -A -Name "ntp01" -ZoneName "techsnipsdemo.org" -IPv4Address "10.0.2.200"

#CNAME
$CNAMERecord = @{
    CName = $True
    Name = "server"
    HostNameAlias = "dc01.techsnipsdemo.org"
    ZoneName = "techsnipsdemo.org"
    TimeToLive =  '01:00:00'
}
Add-DnsServerResourceRecord @CNAMERecord

#MX
$MXRecord = @{
    MX = $True
    Name = "."
    ZoneName = "techsnipsdemo.org"
    MailExchange = "ex01.techsnipsdemo.org"
    Preference = 10
}
Add-DnsServerResourceRecord @MXRecord

#SRV
$SRVRecord = @{
    SRV = $True
    Name = '_sip._tcp'
    DomainName = "sipdir.online.lync.com"
    Priority = 100
    Weight = 10
    Port = 443
    TimeToLive = '00:10:00'
    ZoneName = 'techsnipsdemo.org'
}
Add-DnsServerResourceRecord @SRVRecord
#endregion

#region Editting a resource record

#changing the IP
$old = $new = Get-DnsServerResourceRecord -ZoneName 'techsnipsdemo.org' -Name 'ntp01' -RRType 'A'
$new.RecordDate.IPv4Address = [ipaddress]'10.2.2.220'

Set-DnsServerResourceRecord -NewInputObject $new -OldInputObject $old -ZoneName 'techsnipsdemo.org'

#change the TTL
$old = $new = Get-DnsServerResourceRecord -ZoneName 'techsnipsdemo.org' -Name '_sip._tcp' -RRType 'SRV'
$new.TimeToLive = '01:00:00'

Set-DnsServerResourceRecord -NewInputObject $new -OldInputObject $old -ZoneName 'techsnipsdemo.org' -PassThru

#endregion

#region Removing a resource record
Remove-DnsServerResourceRecord -Name 'server' -RRType CNAME -ZoneName 'techsnipsdemo.org'

#endregion