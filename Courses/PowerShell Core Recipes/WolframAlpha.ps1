#region Basic Wolfram Alpha call
# Retrieve from Wolfram Alpha account
$global:appID = ''

# Retrieved from API docs (https://products.wolframalpha.com/short-answers-api/documentation/)
$baseURL = 'http://api.wolframalpha.com/v1/result'
$query = 'How far is Los Angeles from New York?'

# Need to URL Encode the query:
$encodedQuery = [System.Web.HttpUtility]::UrlEncode($query)

# Build the URL
$url = "$baseURL`?appid=$appID&i=$encodedQuery"

# Make the call
Invoke-RestMethod -Uri $url -Method Get
#endregion

#region Turn it into a function
Function Get-WolframAlphaResult {
    Param(
        [ValidateNotNullOrEmpty()]
        [string]$Question,
        [ValidateNotNullOrEmpty()]
        [string]$apiKey = $appID
    )
    $baseURL = 'http://api.wolframalpha.com/v1/result'
    $encodedQuery = [System.Web.HttpUtility]::UrlEncode($Question)
    $url = "$baseURL`?appid=$apiKey&i=$encodedQuery"
    Invoke-RestMethod -Uri $url -Method Get
}



#endregion