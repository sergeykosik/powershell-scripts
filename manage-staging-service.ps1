<#
.SYNOPSIS
    Start / Stop / Info specified TaskRunner-STAGING-* service on the Staging server.
    Run the script and provide the params: .\manage-staging-service.ps1 -docNum 11957 -action stop
    To stop: -action stop
    To start: -action start
    Display status: no action param
#>
param($docNum, $action)

$computerName = "aws-svr-001";

# | Where-Object {$_.Status -eq "Running"}
$targetSrv = get-service -ComputerName $($computerName) | Where-Object {$_.Name -like "*TaskRunner-STAGING-DOC-$($docNum)*"};

if($targetSrv) {
  if ($action  -eq "stop") {
    $targetSrv.Stop();
    Write-Host "`r`n...Service '$($targetSrv | Select-Object -expandproperty Displayname)' is stopping...`r`n" -ForegroundColor Green;
    exit;
  }
  if ($action  -eq "start") {
    $targetSrv.Start();
    Write-Host "`r`n...Service '$($targetSrv | Select-Object -expandproperty Displayname)' is starting...`r`n" -ForegroundColor Green;
    exit;
  }
  $targetSrv | Select-Object Displayname,Status;
  
} else {
  Write-Host "`r`n...TaskRunner Service with DOC-$($docNum) not found...`r`n" -ForegroundColor Red
}