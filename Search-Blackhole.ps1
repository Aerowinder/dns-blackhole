[string]$base = $PSScriptRoot
$dir_txt = $base + '\txt\'

$search = Read-Host -Prompt 'Input search term (wildcards implied)'
$blackhole = @(Get-Content -Path ($dir_txt + "block.txt") | Where-Object {$_ -Like $search}) # The @() forces the output to be an array. Previously, if one 1 result was returned, it would return as a string, and .Count would count the number of characters instead of total lines.

Write-Host
Write-Host 'Search Term:' $search '| Results:' $blackhole.Length -ForegroundColor Yellow
Write-Host
foreach ($entry in $blackhole) {Write-Host $entry -ForegroundColor Green}
Write-Host

#Changelog
#2022-12-02 - AS - v1, First release.
#2024-03-18 - AS - v2, Cleanup.