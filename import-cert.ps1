<#
.SYNOPSIS
    Generate https certificate and install it into cert store
    prerequisite:
    - install mkcert ()

    - and git is installed which has openssl (change the $opensslPath if not in default location)
#>

$pass = "changeit"
$securePass = ConvertTo-SecureString $pass -AsPlainText -Force
$pfxPath = "../.ssl/dev-cert.pfx"
$certPath = "../.ssl/dev-cert.pem"
$certKeyPath = "../.ssl/dev-cert-key.pem"
$opensslPath = 'C:\"Program Files"\Git\usr\bin\openssl.exe'

Write-Host "Creating certificate..." -ForegroundColor Yellow
mkcert -cert-file $certPath -key-file $certKeyPath localhost localhost-docurec.com localhost2-docurec.com localhost-autoenry.com localhost2-autoenry.com ::1

Write-Host "Creating pfx from pem..." -ForegroundColor Yellow
cmd.exe /c $opensslPath pkcs12 -export -out $pfxPath -inkey $certKeyPath -in $certPath -passout pass:$pass
Write-Host "Created "dev-cert.pfx"" -ForegroundColor Yellow


Write-Host "Installing certificate into Cert Stores..." -ForegroundColor Yellow
Import-PfxCertificate -FilePath $pfxPath -CertStoreLocation Cert:\LocalMachine\My -Password $securePass
Import-PfxCertificate -FilePath $pfxPath -CertStoreLocation Cert:\LocalMachine\CA -Password $securePass
Write-Host "Installed certificate into "Local Computer/Personal/Certificates"" -ForegroundColor Yellow
Write-Host "Installed certificate into "Intermediate Certification Authorities/Certificates"" -ForegroundColor Yellow
