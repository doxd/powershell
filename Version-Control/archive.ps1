$backupPath = New-Item -Type Directory archive\$(Get-Date -f yyyyMMdd_HHmmss)

# Get and store log message for this commit
$msg = Read-Host "[*] Enter log message"
$msg | Out-File -FilePath $backupPath\log.txt

# Copy files for this commit
Copy-Item -Destination $backupPath "\\hostname\path\file.ext"
Copy-Item -Recurse -Destination $backupPath  "\\hostname\path\directory"
