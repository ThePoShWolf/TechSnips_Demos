#region Reservations

Get-DhcpServerv4Reservation -ScopeID 10.3.0.0

#New reservation
$Reservation = @{
    ScopeID = '10.3.0.0'
    IPAddress = '10.3.0.100'
    ClientId = '00-14-38-ea-56-58'
    Description = 'Desk printer'
}
Add-DhcpServerv4Reservation @Reservation

#Reservation from lease
Get-DhcpServerv4Lease -ComputerName dc01 -IPAddress 10.2.2.21

Get-DhcpServerv4Lease -ComputerName dc01 -IPAddress 10.2.2.21 | Add-DhcpServerv4Reservation -ComputerName dc01

Get-DhcpServerv4Reservation -ComputerName dc01 -ScopeID 10.2.2.0
#endregion