$ngrokUrl = "http://22222a.ngrok.io:80/"
$configFilePath = "c:\Users\sergey.kosik\code\ocrex.autoentry\src\Web.DocuRec\Web.Debug.config"
$configFile = Get-Content $configFilePath

Write-Host "About to remove ngrok url from Web.Debug.config file" -ForegroundColor Gray
$clearedConfig = $configFile -replace ",http:\/\/[a-z0-9]*.ngrok.io:80\/"

Write-Host "About to add ngrok url into Web.Debug.config" -ForegroundColor Gray
$clearedConfig -replace ",http:\/\/localhost-autoentry.com:80\/`"",",http://localhost-autoentry.com:80/,$($ngrokUrl)`"" | Out-File $configFilePath
Write-Host " done"