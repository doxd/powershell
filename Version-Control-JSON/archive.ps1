#------------------------------------------------------------------------------
# Creates timestamped archives of working files for reference
# * Will copy files to target_directory\yyyyMMdd_HHmmss
# * Copy specified by JSON file files.json
# * For literal paths, use strings. Patterns or directories should use
# *   objects as shown below
#
#   Sample files.json:
#  {
#    "source_directory" : "~/powershell",
#    "target_directory" : "/tmp/backup",
#    "files":[
#      "Get-CleanHosts.ps1",
#      "Get-WikiEmphasis.ps1",
#      {"type":"recurse", "path":"Remote-Shells"},
#      {"type":"pattern", "path":"h*"},
#      "Update-Timestamp.ps1"
#      ]
#    }
#
#------------------------------------------------------------------------------

Function Create-Archive(){
  try{
    $fileObj = (Get-Content files.json) | ConvertFrom-JSON
    $backupPath = New-Item -Type directory $(Join-Path $fileObj.target_directory $(Get-Date -f yyyyMMdd_HHmmss))

    # Get and store log message for this commit
    $msg = Read-Host "[*] Enter log message"
    $msg | Out-File -FilePath $backupPath\log.txt

    # Copy files for this commit
    $fileObj.files | foreach {
      if ($_ -is [string]){
        Write-Host " [*] Copying $_"
        Copy-Item -Destination $backupPath -LiteralPath $(Join-Path $fileObj.source_directory $_)
        Write-Host -fore green " [*] Copied $_"
      }else{
        Write-Host " [*] Copying $($_.path)"
        if($_.type -eq "recurse"){
          Copy-Item -Destination $backupPath -Recurse $(Join-Path $fileObj.source_directory $_.path)
        }elseif($_.type -eq "pattern"){
          Copy-Item -Destination $backupPath $(Join-Path $fileObj.source_directory $_.path)
        }
        Write-Host -fore green " [*] Copied  $($_.path)"
      }
    }
  }catch{
    Write-Host -fore red " [x] Error in archive:"
    Write-Host -fore red " [x] `t$_"
    Write-Host -fore red " [x] Terminating"
    return
  }
}

Create-Archive
