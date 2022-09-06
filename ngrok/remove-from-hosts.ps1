$Hostname = "127.0.0.1 xxxxxxx.ngrok.io"
$hostsFilePath = "$($Env:WinDir)\system32\Drivers\etc\hosts"
$hostsFile = Get-Content $hostsFilePath
Write-Host "About to remove $Hostname from hosts file" -ForegroundColor Gray
$escapedHostname = [Regex]::Escape($Hostname)
If (($hostsFile) -match ".*127.0.0.1.*ngrok.io.*")  {
    Write-Host "$Hostname - removing from hosts file... " -ForegroundColor Yellow -NoNewline
    $hostsFile -notmatch ".*127.0.0.1.*ngrok.io.*" | Out-File $hostsFilePath 
    Write-Host " done"
} 
Else {
    Write-Host "$Hostname - not in hosts file (perhaps already removed); nothing to do" -ForegroundColor DarkYellow
}

# testing in the command line:
# [regex]::Match('127.0.0.1 fecf4b8fb5dc.ngrok.io','.*127.0.0.1.*ngrok.io.*')