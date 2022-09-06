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

function Remove-Add-WebDebug {

  param(
    [Parameter(Mandatory=$false)]
    [string]$repoName = "ocrex.autoentry",

    [Parameter(Mandatory=$true)]
    [string]$ngrokUrl
  )

  $configFilePath = "c:\Users\sergey.kosik\code\$($repoName)\src\Web.DocuRec\Web.Debug.config"
  $configFile = Get-Content $configFilePath

  Write-Host "About to remove ngrok url from Web.Debug.config of $repoName" -ForegroundColor Gray
  $clearedConfig = $configFile -replace ",http:\/\/[a-z0-9]*.ngrok.io:80\/"

  Write-Host "About to add $ngrokUrl url into Web.Debug.config of $repoName" -ForegroundColor Gray
  $clearedConfig -replace ",http:\/\/localhost-autoentry.com:80\/`"",",http://localhost-autoentry.com:80/,$($ngrokUrl):80/`"" | Out-File $configFilePath
  Write-Host " done"
}

function Add-To-Hosts {

  param(
    [string]$DesiredIP = "127.0.0.1",
    
    [Parameter(Mandatory=$true)]
    [string]$Hostname,

    [bool]$CheckHostnameOnly = $false
  )
  
  # Adds entry to the hosts file.
  # Requires -RunAsAdministrator
  $hostsFilePath = "$($Env:WinDir)\system32\Drivers\etc\hosts"
  $hostsFile = Get-Content $hostsFilePath

  Write-Host "About to add $desiredIP for $Hostname to hosts file" -ForegroundColor Gray

  $escapedHostname = [Regex]::Escape($Hostname)
  $patternToMatch = If ($CheckHostnameOnly) { ".*\s+$escapedHostname.*" } Else { ".*$DesiredIP\s+$escapedHostname.*" }
  If (($hostsFile) -match $patternToMatch)  {
      Write-Host $desiredIP.PadRight(20," ") "$Hostname - not adding; already in hosts file" -ForegroundColor DarkYellow
  } 
  Else {
      Write-Host $desiredIP.PadRight(20," ") "$Hostname - adding to hosts file... " -ForegroundColor Yellow -NoNewline
      Add-Content -Encoding UTF8  $hostsFilePath ("$DesiredIP".PadRight(20, " ") + "$Hostname")
      Write-Host " done"
  }
}

function Send-Email {
  param(
    [Parameter(Mandatory=$true)]
    [string]$ngrokUrl
  )

  $email = "from@example.com" 
  $pass = "xxx"  
  $smtpServer = "smtp.gmail.com" 

  $to = "recepient@example.com"
  
  $msg = new-object Net.Mail.MailMessage 
  $smtp = new-object Net.Mail.SmtpClient($smtpServer) 
  $smtp.EnableSsl = $true 
  $msg.From = "$email"  
  $msg.To.Add("$to") 
  $msg.BodyEncoding = [system.Text.Encoding]::Unicode 
  $msg.SubjectEncoding = [system.Text.Encoding]::Unicode 
  $msg.IsBodyHTML = $true  
  $msg.Subject = "Active Ngrok end-point" 
  $msg.Body = "$ngrokUrl"  

  Write-Host "About to send email"

  $SMTP.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass"); 
  $smtp.Send($msg)

  Write-Host " Done."
}
