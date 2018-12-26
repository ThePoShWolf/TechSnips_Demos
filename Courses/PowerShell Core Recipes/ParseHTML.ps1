# Page to read from
$url = 'https://en.wikipedia.org/wiki/PowerShell'

#region Get one section's text
# Retrieve page
$page = Invoke-WebRequest -Uri $url -UseBasicParsing

# Split at each new line
$content = $page.Content -Split "`n"

# Get the index of the 'Background' header
$page.Content -match '\<h2\>.*Comparison.*\<\/h2\>'
$a = $content.IndexOf($Matches[0])

# Get the index of the 'Design' header
$page.Content -match '\<h2\>.*Extension.*\<\/h2\>'
$b = $content.IndexOf($Matches[0])

# Add that section to a dedicated variable
$text = $content[$($a+1)..$($b-1)]

# Check for images in this section
$text | Where-Object {$_ -like '*img*'}

# Find all image HTML on the page that is in this section
$caughtImages = $content[$($a+1)..$($b-1)] | ForEach-Object{
    ForEach($image in $page.images){
        If($_ -like "*$($image.outerHTML)*"){
            $_
        }
    }
}

# Remove them
$text = $text | Where-Object {$caughtImages -notcontains $_}

# Find any tables
$tables = @()
For($x=0;$x -lt $text.Count; $x++){
    If($text[$x] -match '\<table'){
        $startIndex = $x
        $tableHeaders = @()
        $rows = @()
        While($text[$x+1] -notmatch '\<\/table'){
            $x++
            If($text[$x] -match '\<tr.*\>'){ # Match table row <tr> tag
                If(-not($tableHeaders.Count)){ # If $tableheaders has no value, this must be the first row
                    $headerRow = $true
                }Else{
                    $newRow = @()
                    $column = 0
                }
                While($text[$x+1] -notmatch '\<\/tr'){
                    $x++
                    If($text[$x] -match '\<th|\<td'){ # Match a table header <th> or table cell <td>
                        $text[$x] -match '\>(?<contents>[^<>]+)' | Out-Null # Match the contents of the cell
                        $cellContents = ($matches['contents'] -replace '\<[^>]*\>','').Trim()
                        $cellContents = ($cellContents -replace '&#91;','[') -replace '&#93;',']' # Clean up []
                        If($headerRow){
                            $tableHeaders += $cellContents
                        }Else{
                            If($column -eq 0){
                                $newRow = [pscustomobject]@{ # Start the row with a header
                                    "$($tableHeaders[$column])" = $cellContents
                                }
                            }Else{
                                $newRow | Add-Member -MemberType NoteProperty -Name "$($tableHeaders[$column])" -Value $cellContents
                            }
                        }
                        $column++
                    }
                }
                $rows += $newRow
                $headerRow = $false
            }
        }
    }
    If($text[$x] -match '\<\/table\>'){
        $tables += ,@($rows) # Keeping rows as it's own array
        If($startIndex -eq 0){ # Remove table from $text
            $text = $text[$x..-1]
        }Else{
            $text = $text[0..$($startIndex-1)] + $text[($x+1)..($text.count)]
        }
        $rows = $newRow = $tableHeaders = $Null
    }
}

# Remove any '<' or '>' and content between
$text = $text | ForEach-Object {($_ -replace '\<[^>]*\>','').Trim()}

# Add the square brackets
$text = $text | ForEach-Object {$_ -replace '&#91;','['} | ForEach-Object {$_ -replace '&#93;',']'}
$text | Out-File .\test.txt
code .\test.txt
#endregion

#region Automatically find the headers and get their text
# Find all headers
$headers = $content | ForEach-Object{If($_ -match '\<h2\>.*\>(?<header>[a-zA-Z0-9 ]+)\<.*\[.*\<\/h2\>'){$matches.header}}

$allText = @()
For($t=0;$t -lt $headers.count-1;$t++){
    $page.Content -match "\<h2\>.*$($headers[$t]).*\<\/h2\>"
    $a = $content.IndexOf($Matches[0])

    $page.Content -match "\<h2\>.*$($headers[$t+1]).*\<\/h2\>"
    $b = $content.IndexOf($Matches[0])

    $text = $content[$($a+1)..$($b-1)]

    $caughtImages = $content[$($a+1)..$($b-1)] | ForEach-Object{
        ForEach($image in $page.images){
            If($_ -like "*$($image.outerHTML)*"){
                $_
            }
        }
    }

    $text = $text | Where-Object {$caughtImages -notcontains $_}

    $tables = @()
    For($x=0;$x -lt $text.Count; $x++){
        If($text[$x] -match '\<table'){
            $startIndex = $x
            $tableHeaders = @()
            $rows = @()
            While($text[$x+1] -notmatch '\<\/table'){
                $x++
                If($text[$x] -match '\<tr.*\>'){ # Match table row <tr> tag
                    If(-not($tableHeaders.Count)){ # If $tableheaders has no value, this must be the first row
                        $headerRow = $true
                    }Else{
                        $newRow = @()
                        $column = 0
                    }
                    While($text[$x+1] -notmatch '\<\/tr'){
                        $x++
                        If($text[$x] -match '\<th|\<td'){
                            $text[$x] -match '\>(?<contents>[^<>]+)' | Out-Null # Match the contents of the cell
                            $cellContents = ($matches['contents'] -replace '\<[^>]*\>','').Trim()
                            $cellContents = ($cellContents -replace '&#91;','[') -replace '&#93;',']' # Clean up []
                            If($headerRow){
                                $tableHeaders += $cellContents
                            }Else{
                                If($column -eq 0){
                                    $newRow = [pscustomobject]@{ # Start the row with a header
                                        "$($tableHeaders[$column])" = $cellContents
                                    }
                                }Else{
                                    $newRow | Add-Member -MemberType NoteProperty -Name "$($tableHeaders[$column])" -Value $cellContents
                                }
                            }
                            $column++
                        }
                    }
                    $rows += $newRow
                    $headerRow = $false
                }
            }
        }
        If($text[$x] -match '\<\/table\>'){
            $tables += ,@($rows) # Keeping rows as it's own array
            If($startIndex -eq 0){ # Remove table from $text
                $text = $text[$x..-1]
            }Else{
                $text = $text[0..$($startIndex-1)] + $text[($x+1)..($text.count)]
            }
            $rows = $newRow = $tableHeaders = $Null
        }
    }
    $text = $text | ForEach-Object {($_ -replace '\<[^>]*\>','').Trim()}
    $text = $text | ForEach-Object {$_ -replace '&#91;','['} | ForEach-Object {$_ -replace '&#93;',']'}

    $allText += [PSCustomObject]@{
        Header = $headers[$t]
        Text = $text
        Tables = $tables
    }
    $tables = $text = $null
}
#endregion