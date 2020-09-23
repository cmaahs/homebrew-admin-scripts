function Sort-HelmManifest {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true,
            Position = 0)]
        [Alias('Manifest')]
        [string]
        $ManifestFile
    )

    Begin {
        $continueProcessing = $true
        $m_manifestList = @()
        $m_manifestDestiny = @{}
        $manifest = Get-Content $ManifestFile
    }

    Process {
        if ( $continueProcessing -eq $true ) {
            Write-Verbose "Adding $($ManifestFile)"
            $m_manifestList += $ManifestFile
        }
    }

    End {
        if ( $continueProcessing -eq $true ) {
            foreach ( $m in $m_manifestList ) {
                $manifest = Get-Content $m
                $fileData = ""
                $kind = ""
                $name = ""
                $haveFileName = $false
                $inMetadata = $false
                foreach ( $line in $manifest ) {
                    if ( $line.StartsWith("---") ) {
                        # Write-Output $fileData | Out-File -Path ~/tmp/$fileName -Width 9000
                        if ( $fileName -eq $null ) {
                            $guid = New-Guid
                            $kind = "header"
                            $name = "noname"
                            $fileName = "_HEADER-$($guid)"
                        }
                        $writeKey = "$($fileName)__$($kind)__$($name)"
                        Write-Verbose "Add Section: $($writeKey)"
                        $m_manifestDestiny.Add($writeKey, $fileData)
                        $fileData = ""
                        $haveFileName = $false
                        $kind = ""
                        $name = ""
                        $inMetadata = $false
                    }
                    else {
                        if ( $haveFileName -eq $false ) {
                            if ( $line.StartsWith("# Source") ) {
                                if ( $line.StartsWith("# Source:") ) {
                                    $fileName = ($line.Split(":")[1]).Trim().ToLower()
                                }
                                if ( $line.StartsWith("# Source https") ) {
                                    $fileName = ($line.Replace(" https://", ":").Split(":")[1]).Trim().ToLower()
                                }
                                $fileName = ($line.Split(":")[1]).Trim().ToLower()
                                Write-Verbose "Filename $($fileName)" -Verbose
                                $haveFileName = $true
                            }
                        } else {
                            if ( $line.StartsWith("kind:") ) {
                                $kind = ($line.Split(":")[1]).Trim().ToLower()
                            }
                            if ( $line.StartsWith("metadata:") ) {
                                $inMetadata = $true
                            }
                            if ( $inMetadata -eq $true ) {
                                if ( -not $line.StartsWith("  ") ) {
                                    $inMetadata = $false
                                }
                                if ( $line.StartsWith("  name:") ) {
                                    $name = ($line.Split(":")[1]).Trim().ToLower()
                                }
                            }
                        }
                        $fileData += "$($line)`n"
                    }
                }
                $newData = ""
                $keyList = $m_manifestDestiny.keys | Sort-Object
                foreach ($key in $keyList) {
                    $newData += $m_manifestDestiny[$key]
                }
                Write-Output $newData | Out-File -Path "~/tmp/$($m)" -Width 9000
            }

        }
    }
}