<#
.SYNOPSIS
  Restarts the File Conversion Service (OCRex.Convert).
    
.DESCRIPTION
  The File Conversion Service needs to be restarted due to a memory leak bug. This script was created
  to enable business teams to restart the service.
  
  
  Users in the Active Directory group 'Dev-Restart-Service-FileConversion' will be able to restart the service.
  
  NOTE:
  
    The following configuration must be performed on the server for this to work from a remote machine.
    
    1. Enable Firewall Rule via cmd:
  
      netsh advfirewall firewall set rule group="Remote Service Management" new enable=yes
  
    2. Grant Access to restart the server via cmd:
  
        sc sdset scmanager D:(A;;0x0015;;;S-1-5-21-1861021790-2432407240-1216284069-4890)(A;;CC;;;AU)(A;;CCLCRPRC;;;IU)(A;;CCLCRPRC;;;SU)(A;;CCLCRPWPRC;;;SY)(A;;KA;;;BA)(A;;CC;;;AC)S:(AU;FA;KA;;;WD)(AU;OIIOFA;GA;;;WD)
        "c:\Program Files (x86)\Windows Resource Kits\Tools\subinacl.exe" /service OCRex.Web.ConvertDocument-* /grant=ocrex\Dev-Restart-Service-FileConversion=PTOSE
 
 
        Note:
            Access rights (0x0015) derived from https://docs.microsoft.com/en-us/windows/desktop/services/service-security-and-access-rights#access-rights-for-the-service-control-manager
 
            0x0015 is equivalent to these XOR'd:
                SC_MANAGER_CONNECT (0x0001)
                SC_MANAGER_ENUMERATE_SERVICE (0x0004)
                SC_MANAGER_QUERY_LOCK_STATUS (0x0010)
  
.PARAMETER BuildConfiguration
  The build configuration of the installed service. Multiple build configurations may be installed on the same computer.
    
.PARAMETER ComputerName
  The computer where the service is installed.
    
#>
  
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("Debug", "Staging", "UAT", "Release", IgnoreCase = $false)]
    $BuildConfiguration,
  
    [Parameter(Mandatory=$true)]
    [string]
    $ComputerName = ".",
  
    [switch]
    $WhatIf
)
  
$services = Get-Service -ComputerName $ComputerName -Name "OCRex.Web.ConvertDocument-$BuildConfiguration*"
  
Write-Host "File Conversion Services found on '$ComputerName':"
Write-Host "    " -NoNewline
Write-Host ($services -Join ", ")
  
if($services.Length -eq 0) {
    Write-Host §"No service with the name 'OCRex.Web.ConvertDocument-$BuildConfiguration*' was found on '$ComputerName'."
    return
}
  
if($services.Length -gt 1) {
    throw "ERROR: There is more than one File Conversion Service on '$ComputerName'. " +
        "This script will exit because there are too many '$BuildConfiguration' services on '$ComputerName'."
}
  
$serviceName = $services.ServiceName
  
Write-Host "Stopping service '$serviceName'."
  
if(-Not $WhatIf) {
    Stop-Service $services
}
  
Write-Host "Starting service '$serviceName'."
  
if(-Not $WhatIf) {
    Start-Service $services
}