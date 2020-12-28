
# Import-Module ./Get-WikiEmphasis.ps1
# -or-
# iex (iwr "https://raw.githubusercontent.com/doxd/powershell/master/Get-WikiEmphasis.ps1").content; Loop-WikiEmphasis

Function Get-WikiEmphasis($word){
	# Try to match: First, from the declension table. If not, try the russian header
	#               If none of these works, return the original word itself
	$regexDecl = '(?m)class="Cyrl.*?" lang="ru">.*?title="' + $word + '">(\w+)</'
	$regexHead = '<strong class="Cyrl headword" lang="ru">(\w+)</strong>'
	try{
		$resp = iwr "https://en.wiktionary.org/wiki/$word"
		$result = [regex]::match($resp.Content, $regexDecl).Groups[1].Value
		if($result -eq ""){
			$result = [regex]::match($resp.Content, $regexHead).Groups[1].Value
		}
		if ($result -eq ""){
			return $word
		}else{
			return $result
		}
	}catch{
		return $word
	}
}

Function Loop-WikiEmphasis{
	Write-Host "`nEnter words or sentences to emphasizify. Enter 'quit' when done`n"
	do{
		$word = Read-Host "Слово"
		if($word -ne "quit"){
			$words = -split $word
			($words | foreach {Get-WikiEmphasis $_.ToLower()}) -join " "
		}
	}while($word -ne "quit")
}
