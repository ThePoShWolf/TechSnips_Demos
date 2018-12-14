# Get App Key
# https://trello.com/app-key
# Auth string format:
# key=<APIKey>&token=<AccessToken>
# I've stored my auth string in $AuthString

# Docs: https://developers.trello.com/

$PSVersionTable

$baseUrl = 'https://api.trello.com/1'

#region Get Board ID
$BoardsIDURL = "$baseUrl/members/me/boards?$AuthString"
$boards = Invoke-RestMethod -Uri $BoardsIDURL -Method Get
$board = $boards | Where-Object Name -eq "REST API testing"
$board
#endregion

#region Get List ID
$listIDURL = "$baseUrl/board/$($board.id)/lists?$AuthString"
$lists = Invoke-RestMethod -Uri $listIDURL -Method Get
$list = $lists | Where-Object Name -eq "First List"
$list
#endregion

#region Create card
$createCardURL = "$baseURL/cards?$AuthSTring"
$body = @{
    'idList' = $list.id
    'name' = 'PS Core card'
    'desc' = 'This is the description'
}
$card = Invoke-RestMethod -Uri $createCardURL -Method Post -Body $body
$card
#endregion

#region Move the card
$list02 = $lists | Where-Object Name -eq 'Second list'
$list02
$moveCardURL = "$baseURL/cards/$($card.id)?idList=$($list02.id)&$AuthString"
Invoke-RestMethod -Uri $moveCardURL -Method Put
#endregion

#region Add comment
$commentURL = "$baseUrl/cards/$($card.id)/actions/comments?$AuthString"
$body = @{
    text = "This card's move was initiated from PS Core."
}
Invoke-RestMethod -Uri $commentURL -Method Post -Body $body
#endregion