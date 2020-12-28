echo `n`n
echo "----------------------------------------------------------------------------------------------------------"
echo "+                                            Commit Log                                                  +"
echo "----------------------------------------------------------------------------------------------------------"
echo `n

$fileArray = @(Get-ChildItem -Recurse -filter log.txt)
$fileArray | foreach { echo "$($_.CreationTime) `t $(Get-Content $_.FullName)"}
echo `n`n
