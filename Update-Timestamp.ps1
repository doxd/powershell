$file = ".\file.name"
$date0 = new-object system.datetime 1970,1,1,0,0,0

(gci $file).CreationTime = $date0
(gci $file).LastAccessTime = Get-Date
(gci $file).LastWriteTime = Get-Date
