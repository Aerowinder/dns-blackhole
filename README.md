# dns-blackhole

**Get-List.ps1** downloads all of the below host files and strips out the information that isn't needed (like comments and whitespace) and combines them together for a singular entry into your preferred DNS blackhole application.

**Search-Blackhole.ps1** searches the completed domain block file (block.txt) for your query, showing everything that matches. Can be useful to help fish out additional domains that may require allow listing.


The dns-blackhole project aggregates the below host file lists:

| Name | Link |
| ---- | ---- |
StevenBlack | https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
anudeepND | https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt
AssoEchap | https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts
crazy-max | https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt
DandelionSprout | https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt
Spam404 | https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt
lists.disconnect.me | https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt
lists.disconnect.me | https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt
Firebog | https://v.firebog.net/hosts/AdguardDNS.txt
Firebog | https://v.firebog.net/hosts/Admiral.txt
Firebog | https://v.firebog.net/hosts/Easylist.txt
Firebog | https://v.firebog.net/hosts/Easyprivacy.txt
Firebog | https://v.firebog.net/hosts/RPiList-Malware.txt
Firebog | https://v.firebog.net/hosts/RPiList-Phishing.txt
Firebog | https://v.firebog.net/hosts/Prigent-Ads.txt
Firebog | https://v.firebog.net/hosts/Prigent-Crypto.txt
Firebog | https://v.firebog.net/hosts/static/w3kbl.txt
ethanr | https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt
quidsup | https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt
Phishing Army | https://phishing.army/download/phishing_army_blocklist_extended.txt

<br><br>


### Technitium DNS Block
Technitium is a DNS server that supports DNS blackhole. Strongly recommend using this or similar project instead of Pi-hole or AdGuard Home.

Example block list for Technitium - note the first entry starts with **!**, this indicates **\<NOT\>**. In other words, allow.
```
!https://raw.githubusercontent.com/Aerowinder/dns-blackhole/main/txt/allow-home.txt
https://raw.githubusercontent.com/Aerowinder/dns-blackhole/main/txt/block.txt
```








