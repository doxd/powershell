# Downloads the latest malware- and adware- blocking hosts file
#   and filters out any potentially non-legit lines 
#     (e.g. those that don't begin with "0.0.0.0 ")

Invoke-WebRequest  "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" -OutFile hosts_raw
$hosts = Get-Content hosts_raw
$hosts = $hosts | Where-Object { $_ -like "0.0.0.0 *"}
$hosts | Out-File "hosts" -Encoding ascii
Get-Content hosts | where { $_ -notlike "0.0.0.0 *"}
