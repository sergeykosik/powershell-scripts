# Remove from both hosts and web.debug
# Make sure to set $repoName in Remove-From-WebDebug

function Remove-From-Hosts {
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
}

function Remove-From-WebDebug {

  param([string]$repoName = "ocrex.autoentry")

  $configFilePath = "c:\Users\sergey.kosik\code\$($repoName)\src\Web.DocuRec\Web.Debug.config"
  $configFile = Get-Content $configFilePath
  Write-Host "About to remove ngrok url from Web.Debug.config of $repoName" -ForegroundColor Gray

  $configFile -replace ",http:\/\/[a-z0-9]*.ngrok.io:80\/" | Out-File $configFilePath
  Write-Host " done"
}


Remove-From-Hosts

Remove-From-WebDebug
