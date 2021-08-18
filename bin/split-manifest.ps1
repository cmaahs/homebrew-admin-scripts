$manifest = Get-Content /Users/christopher.maahs/tmp/new-operator-manifest.yaml

$fileData = ""
$haveFileName = $false
foreach ( $line in $manifest ) {
	if ( $line.StartsWith("---") ) {
		Write-Verbose "Write File" -Verbose
                Write-Output $fileData | Out-File -Path ~/tmp/$fileName -Width 9000
		$fileData = ""
		$haveFileName = $false
	} else {
                if ( $haveFileName -eq $false ) {
			if ( $line.StartsWith("kind:") ) {
				$fileName = ($line.Split(":")[1]).Trim().ToLower()
			}
			if ( $line.StartsWith("  name:") ) {
				$fileName = "$($fileName)-$(($line.Split(":")[1]).Trim().ToLower())"
				$fileName += ".yaml"
				Write-Verbose "Filename $($fileName)" -Verbose
				$haveFileName = $true
			}
                }
		$fileData += "$($line)`n"
	}
}
