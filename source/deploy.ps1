$scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition

# Change into the deployment root directory.
Set-Location $scriptPath

function Set-WebAppOffline()
{
	Copy-Item -Path "Web\App_Offline.htm.deploy" -Destination "Web\App_Offline.htm" -Force
}

function Set-WebAppOnline()
{
	Remove-Item -Path "Web\App_Offline.htm" -Force
}

# Runs all command line arguments as functions.
$args | ForEach-Object { & $_ }

# Hack, MSDeploy would run PowerShell endlessly.
Get-Process -Name "powershell" | Stop-Process