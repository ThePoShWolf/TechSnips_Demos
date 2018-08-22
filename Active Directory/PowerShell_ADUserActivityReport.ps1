#region demo
Throw "This is a demo, dummy!"
#endregion

#region clean
Function Prompt(){}
Clear-Host
#endregion

#region Getting started
#Event IDs to look for
#4648 is explicit logon, 4647 is logoff
$EventIds = 4647,4648

#Get those events from the security event log
Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = $EventIds
}
#endregion

#region Parse the events for relevant data

$Events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = $EventIds
}

#Message
$Events[0].Message

#Properties
$Events[0].Properties

#Account
$Events[0].Properties[5].Value

#Event ID
$Events[0].ID

#Other Event ID
($Events | Where-Object ID -ne $Events[0].ID)[0].Message

#Account
($Events | Where-Object ID -ne $Events[0].ID)[0].Properties[1].Value

ForEach($event in $Events){
    Switch($event.ID){
        4647 {
            $Account = $event.Properties[1].Value
            $Domain = $event.Properties[2].Value
        }
        4648 {
            $Account = $event.Properties[5].Value
            $Domain = $event.Properties[6].Value
        }
    }
    [PSCustomObject]@{
        ComputerName = $env:ComputerName #Standin until we introduce remoting
        Time = $event.TimeCreated
        Account = $Account
        Domain = $Domain
    }
}

#endregion



#Region Bring it together with a function
Function Get-ADUserActivityReport{
    Param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Name')]
        [string]$ComputerName
    )
    Begin{
        $EventIDs = 4647,4648
    }
    Process{
        $events = Get-WinEvent -ComputerName $ComputerName -FilterHashtable {
            LogName = 'Security'
            ID = $EventIDs
        } 
        ForEach($event in $events){
            Switch($event.ID){
                4647 {
                    $Account = $event.Properties[1].Value
                    $Domain = $event.Properties[2].Value
                }
                4648 {
                    $Account = $event.Properties[5].Value
                    $Domain = $event.Properties[6].Value
                }
            }
            [PSCustomObject]@{
                ComputerName = $ComputerName
                Time = $event.TimeCreated
                Account = $Account
                Domain = $Domain
            }
        }
    }
    End{}
}

Get-ADUserActivityReport -ComputerName 'Prod-DC'

Get-ADComputer -Filter * -SearchBase
#endregion