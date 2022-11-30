param([ValidateSet("add-commit-push")][string]$git)

[string]$base = $PSScriptRoot
$dir_txt = $base + '\txt\'
$dir_txt_dl = $dir_txt + 'download\'
$hostlist = $dir_txt + 'host-list.txt'
$blocklist = $dir_txt + 'block.txt'

$regex_http = "^http:\/\/.*|^https:\/\/.*" # Allows comments and spacing in the host file list; ^http:\/\/.* = line starts with http:// | ^https:\/\/.* = line starts with https://
$regex_line_cleanup = "^127\.0\.0\.1\s*|^0\.0\.0\.0\s*|\s*#.*$" # Lines that contain a domain, but contain other data as well; ^127\.0\.0\.1\s = line starts with '127.0.0.1 ' | ^0\.0\.0\.0\s = line starts with '0.0.0.0 ' | \s*#.*$ = inline comment
$regex_line_junk = "^#|^\s*#|^\s*$|::" # Lines that do not contain a domain; ^# = line starts with # | ^\s*# = line starts with whitespace and goes until # (ie. '     #') | ^\s*$ = empty line | :: = literal (ie. IPv6 address)

New-Item -Path $dir_txt_dl -ItemType Directory -Force | Out-Null

$i = 1
$ProgressPreference = "SilentlyContinue" # Hide WebRequest download progess bar
foreach ($entry in Get-Content -Path $hostlist) {
    if ($entry -NotMatch $regex_http) {continue}

    $filepath = $dir_txt_dl + "$i" + '.txt'
    $filename = "$i" + '.txt'

    Write-Host "Downloading $filename ..."
    Invoke-WebRequest -URI $entry -OutFile $filepath

    Write-Host "Removing garbage from $filename ..."
    switch ($filename) {
        "1.txt" {$list_content = Get-Content -Path $filepath | Select-Object -Skip 39 | Where-Object { $_ -NotMatch $regex_line_junk }} #Steven Black - contains non-commented data that will be difficult to filter later
        default {$list_content = Get-Content -Path $filepath | Where-Object { $_ -NotMatch $regex_line_junk }}
    }

    Write-Host "Combining $filename with previous downloads..."
    $list_combined += $list_content

    Write-Host
    $i += 1
}

Remove-Item -Path $dir_txt_dl -Recurse -Confirm:$false

Write-Host "Performing final cleanup..."
$list_combined = $list_combined  -Replace $regex_line_cleanup, '' | Sort-Object | Get-Unique

Write-Host "Saving block list..."
Set-Content -Path $blocklist -Value $list_combined

if ($git -eq 'add-commit-push') {
    $dt = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    git -C $base add $blocklist #-C $base so script can be executed outside of the working directory.
    git -C $base commit -m "Updated: $dt"
    git -C $base push origin main
}
