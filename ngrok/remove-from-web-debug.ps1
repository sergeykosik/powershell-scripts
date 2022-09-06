
$configFilePath = "c:\Users\sergey.kosik\code\ocrex.autoentry\src\Web.DocuRec\Web.Debug.config"
$configFile = Get-Content $configFilePath
Write-Host "About to remove ngrok url from Web.Debug.config file" -ForegroundColor Gray

$configFile -replace ",http:\/\/[a-z0-9]*.ngrok.io:80\/" | Out-File $configFilePath
Write-Host " done"
