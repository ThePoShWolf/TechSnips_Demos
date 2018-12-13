#region Basic query to Stack Exchange
$baseURL = 'https://api.stackexchange.com'
$version = '2.2'
$method = 'questions/unanswered'

#region Parameters
$parameters = @(
    'order=desc'
    'sort=activity'
    'site=stackoverflow'
) -join '&'

#endregion

#region Building the URL and executing the query
$url = "$baseURL/$version/$method`?$parameters"

$result = Invoke-RestMethod -Method Get -Uri $url

#endregion

#region Looking at the results
$result | Get-Member

$result.has_more

$result.quota_max

$result.quota_remaining

$result.items

$result.items.Count

#endregion

#region Formatting the results
$result.items | Format-Table Title,tags

$result.items | Where-Object tags -Contains 'powershell'

Start-Process ($result.items | Where-Object tags -Contains 'sql')[0].link

#endregion
#endregion

#region Adding other parameters
$baseURL = 'https://api.stackexchange.com'
$version = '2.2'
$method = 'questions/unanswered'

$parameters = @(
    'order=desc'
    'sort=activity'
    'site=stackoverflow'
    'tagged=powershell-core'
    'pagesize=50'
) -join '&'

$url = "$baseURL/$version/$method`?$parameters"

$result = Invoke-RestMethod -Method Get -Uri $url

#region Looking at the results
$result.quota_remaining

$result.items.count

$result.has_more

$result.items | Format-Table Title

Start-Process ($result.items | Where-Object tags -Contains 'powershell')[0].link

Start-Process $result.items[0].link

#endregion
#endregion