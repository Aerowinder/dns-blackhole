[string]$base = $PSScriptRoot
$dir_txt = $base + '\txt\'

$search = Read-Host -Prompt 'Input search term (wildcards implied)'
$search = '*' + $search + '*'
$blackhole = @(Get-Content -Path ($dir_txt + "block.txt") | Where-Object {$_ -Like $search}) # The @() forces the output to be an array. Previously, if one 1 result was returned, it would return as a string, and .Count would count the number of characters instead of total lines.

Write-Host
Write-Host 'Search Term:' $search '| Results:' $blackhole.Length -ForegroundColor Yellow
Write-Host
foreach ($entry in $blackhole) {Write-Host $entry -ForegroundColor Green}
Write-Host
