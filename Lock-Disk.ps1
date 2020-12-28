# Must be run as Administrator

Function Lock-Disk(){
	Get-Disk
	$n =  Read-Host "Which disk to lock?"
	Set-Disk -Number $n -IsReadOnly $True
}

Function Unlock-Disk(){
	Get-Disk
	$n =  Read-Host "Which disk to unlock?"
	Set-Disk -Number $n -IsReadOnly $False
}
