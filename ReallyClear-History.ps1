function Remove-AllHistory(){
	Clear-History
	Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\*"
}
Remove-AllHistory

