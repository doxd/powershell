echo `n`n
echo "----------------------------------------------------------------------------------------------------------"
echo "+                                            Commit Log                                                  +"
echo "----------------------------------------------------------------------------------------------------------"
echo `n

$fileObj = (Get-Content files.json) | ConvertFrom-JSON
$fileArray = @(Get-ChildItem $fileObj.target_directory -Recurse -filter log.txt | Sort-Object -property LastWriteTime)
$fileArray | foreach { echo "$($_.CreationTime) `t $(Get-Content $_.FullName)"}
echo `n`n
