param(
    [Parameter(Mandatory = $false)][string]$rdpPort = "3389"
)

Process {
    $scriptPath = "."
    $deploylogfile = "$scriptPath\deploymentlog.log"
    if ($PSScriptRoot) {
        $scriptPath = $PSScriptRoot
    }
    else {
        $scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
    }

    #Install stuff

    $temptime = Get-Date -f yyyy-MM-dd--HH:mm:ss
    "Starting deployment script - $temptime" | Out-File $deploylogfile
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        
    #Add RDP listening ports if needed
    if ($rdpPort -ne 3389) {
        netsh.exe interface portproxy add v4tov4 listenport=$rdpPort connectport=3389 connectaddress=127.0.0.1 
        netsh.exe advfirewall firewall add rule name="Open Port $rdpPort" dir=in action=allow protocol=TCP localport=$rdpPort
    }

    $temptime = Get-Date -f yyyy-MM-dd--HH:mm:ss
    "Ending deployment script - $temptime" | Out-File $deploylogfile -Append
}