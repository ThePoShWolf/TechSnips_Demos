#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region New-ADReplicationSite

#region First site

#We have no replication sites besides the default
Get-ADReplicationSite | Format-Table Name

#So lets create one
New-ADReplicationSite Moon

Get-ADReplicationSite Moon
#endregion

#region Site with schedule

#Or another with a schedule
$schedule = New-Object -TypeName System.DirectoryServices.ActiveDirectory.ActiveDirectorySchedule
$schedule.ResetSchedule()
$schedule.SetDailySchedule("Twenty","Zero","TwentyThree","FortyFive")
New-ADReplicationSite -Name 'Mars' -ReplicationSchedule $schedule -Description 'Where men are from'

Get-ADReplicationSite -Identity 'Mars'
(Get-ADReplicationSite -Identity 'Mars').ReplicationSchedule
#endregion

#region Third one is the most charming

#And a third because I want three
$Site2Copy = Get-ADReplicationSite 'Mars'
New-ADReplicationSite -Name 'Venus' -Description 'Where women are from' -Instance $Site2Copy

Get-ADReplicationSite -Identity 'Venus'
(Get-ADReplicationSite -Identity 'Venus').ReplicationSchedule
#endregion

#endregion

#region Set-ADReplicationSite

#region Basic usage

#Match up the replication schedules
Set-ADReplicationSite 'Moon' -ReplicationSchedule $schedule
#endregion

#region Setting for multiple sites

#Reset the schedule
$schedule.ResetSchedule()
$schedule.SetDailySchedule("TwentyOne","Zero","TwentyThree","FortyFive")
Get-ADReplicationSite -Filter {Name -notlike '*default*'} | Set-ADReplicationSite -ReplicationSchedule $schedule

#Other properties
Get-ADReplicationSite -Filter * | Set-ADReplicationSite -ScheduleHashingEnabled $false

Get-ADReplicationSite -Filter * -Properties ScheduleHashingEnabled | Format-Table Name,ScheduleHashingEnabled
#endregion

#region ISTG

#Intersite topology generator
Set-ADReplicationSite 'Mars' -InterSiteTopologyGenerator 'Prod-DC'
#endregion

#endregion

#region Remove-ADReplicationSite

#region Remove one site

Remove-ADReplicationSite 'Moon'

Get-ADReplicationSite 'Moon'
#endregion

#region Remove sites using a filter
$20mAgo = (Get-Date).AddMinutes(-20)
Get-ADReplicationSite -Filter {WhenCreated -gt $20mAgo}

Get-ADReplicationSite -Filter {WhenCreated -gt $20mAgo} | Remove-ADReplicationSite -Confirm:$false

Get-ADReplicationSite -Filter {WhenCreated -gt $20mAgo}
#endregion

#endregion