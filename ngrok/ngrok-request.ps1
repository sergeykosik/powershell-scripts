<#
.SYNOPSIS
    Invoke get http request
#>
$r = Invoke-RestMethod -Uri http://localhost:4040/api/tunnels

$ngrokUrl = $r.tunnels[0].public_url
Write-Host "Found url: $($ngrokUrl) `r`n"