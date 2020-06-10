 # AWS CLI V2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Add-Type -AssemblyName System.IO.Compression.FileSystem
Invoke-WebRequest https://awscli.amazonaws.com/AWSCLIV2.msi -OutFile ~\Downloads\AWSCLIV2.msi
~\Downloads\AWSCLIV2.msi /quiet
$env:Path += ";C:\Program Files\Amazon\AWSCLIV2\"

# Kubernetes kubectl
New-Item -ItemType Directory -Path 'C:\Program Files\Kubernetes\bin' -Force
Invoke-WebRequest https://storage.googleapis.com/kubernetes-release/release/v1.16.10/bin/windows/amd64/kubectl.exe -OutFile 'C:\Program Files\Kubernetes\bin\kubectl.exe'

# Setup Path, may require reboot, or logout/logon
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH).path
$newPath = “$oldPath;C:\Program Files\Kubernetes\bin\”
Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH -Value $newPath
$env:Path += ";C:\Program Files\Kubernetes\bin\"

# Helm
Invoke-WebRequest https://get.helm.sh/helm-v2.16.1-windows-amd64.zip -OutFile ~\Downloads\helm2-windows.zip
$zipFile = (Get-ChildItem -Path ~/Downloads -Filter helm2-windows.zip -File).FullName
$outPath = 'C:\Program Files\Kubernetes\bin\'
[System.IO.Compression.ZipFile]::ExtractToDirectory($zipFile, $outPath)
$helmFiles = Get-ChildItem -Path 'C:\Program Files\Kubernetes\bin\windows-amd64\'
foreach ( $file in $helmFiles ) {
    Move-Item -Path $file.Fullname -Destination 'C:\Program Files\Kubernetes\bin\' -Force
}

Invoke-WebRequest https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/windows/amd64/aws-iam-authenticator.exe -OutFile 'C:\Program Files\Kubernetes\bin\aws-iam-authenticator.exe'
Invoke-WebRequest https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/windows/amd64/aws-iam-authenticator.exe.sha256 -OutFile ~\Downloads\aws-iam-authenticator.sha256
$exeHash = (Get-FileHash 'C:\Program Files\Kubernetes\bin\aws-iam-authenticator.exe').Hash
$validHash = (Get-Content ~\Downloads\aws-iam-authenticator.sha256).Split(" ")[0]
if ( $exeHash -ne $validHash ) {
    Write-Error "The hash for aws-iam-authenticator.exe doesn't match"
}

# splicectl
Invoke-WebRequest https://github.com/splicemaahs/homebrew-utility/raw/master/bin/windows/amd64/splicectl.exe -OutFile 'C:\Program Files\Kubernetes\bin\splicectl.exe'

# krew plugin
Invoke-WebRequest https://github.com/kubernetes-sigs/krew/releases/download/v0.3.4/krew.exe -OutFile 'C:\Program Files\Kubernetes\bin\krew.exe'
Invoke-WebRequest https://github.com/kubernetes-sigs/krew/releases/download/v0.3.4/krew.exe.sha256 -OutFile ~\Downloads\krew.exe.sha256
Invoke-WebRequest https://github.com/kubernetes-sigs/krew/releases/download/v0.3.4/krew.yaml -OutFile 'C:\Program Files\Kubernetes\bin\krew.yaml'
$exeHash = (Get-FileHash 'C:\Program Files\Kubernetes\bin\krew.exe').Hash
$validHash = (Get-Content ~\Downloads\krew.exe.sha256).Split(" ")[0]
if ( $exeHash -ne $validHash ) {
    Write-Error "The hash for krew.exe doesn't match"
}
krew install --manifest='C:\Program Files\Kubernetes\bin\krew.yaml'
# Setup Path, may require reboot, or logout/logon
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH).path
$newPath = “$oldPath;%USERPROFILE%\.krew\bin”
Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Environment' -Name PATH -Value $newPath
$env:Path += ";%USERPROFILE%\.krew\bin\"

# git command line, requried by krew plugin
if ( -Not (Get-Command "git.exe" -ErrorAction SilentlyContinue) )
{ 
    Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.26.2.windows.1/Git-2.26.2-64-bit.exe -OutFile ~\Downloads\Git-2.26.2-64-bit.exe
    ~\Downloads\Git-2.26.2-64-bit.exe /SILENT /VERYSILENT
    $env:Path += ";C:\Program Files\Git\cmd"
}
 
