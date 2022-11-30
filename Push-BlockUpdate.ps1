$dt = Get-Date -Format 'yyyy-MM-dd HH.mm.ss'

git add txt\block.txt
git commit -m "Updated: $dt"
git push origin main