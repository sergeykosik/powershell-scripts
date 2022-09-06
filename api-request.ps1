<#
.SYNOPSIS
    Invoke get http request (bypassing cert errors).
    Run the script and provide the params: .\api-request.ps1 -url.
    If no params provided, then check uat:
#>
#param($url1, $url2)

$url1 = "https://uat1.autoentry.com/health/version";
$url2 = "https://uat2.autoentry.com/health/version";
$url3 = "https://uat2.docurec.com/health/version";

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Ssl3, [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12

Write-Host "`r`nChecking $($url1)'...`r`n" -ForegroundColor Yellow;
Invoke-RestMethod -Method Get -Uri $url1
Write-Host "`r`nChecking $($url2)'...`r`n" -ForegroundColor Yellow;
Invoke-RestMethod -Method Get -Uri $url2
Write-Host "`r`nChecking $($url3)'...`r`n" -ForegroundColor Yellow;
Invoke-RestMethod -Method Get -Uri $url3
Write-Host "`r`n";