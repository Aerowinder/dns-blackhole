$base = [environment]::getfolderpath("mydocuments") + "\GitHub\dns-blackhole\"
$dir_block = $base + 'block\'

$search = Read-Host -Prompt 'Input search term (wildcards implied)'
$search = '*' + $search + '*'
$blackhole = Get-Content -Path ($dir_block + "blackhole.txt") | Where-Object {$_ -Like $search}

Write-Host
Write-Host 'Search Term:' $search '| Results:' $blackhole.Length -ForegroundColor Yellow
Write-Host
foreach ($entry in $blackhole) {Write-Host $entry -ForegroundColor Green}
Write-Host
