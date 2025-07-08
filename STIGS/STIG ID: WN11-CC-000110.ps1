<#
.SYNOPSIS
    According to this STiG, Windows 11 must be configured to audit other Logon/Logoff Events Successes. The below Powershell satisfies this
STIG and also confirms by printing a confirmation or a failure message.

.NOTES
    Author          : Charlie Mathe
    LinkedIn        : www.linkedin.com/in/karoly-charlie-mathe
    GitHub          : https://github.com/CharlieMathe
    Date Created    : 08/July/2025
    Last Modified   : 08/July/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000110

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000110.ps1 
#>


#-----------------------------#
# 1.  Configuration section   #
#-----------------------------#
$regKey     = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers'
$valueName  = 'DisableHTTPPrinting'
$desiredVal = 1   # 1 = block printing over HTTP

#-----------------------------#
# 2.  Apply the setting       #
#-----------------------------#
# Ensure parent key exists
if (-not (Test-Path $regKey)) {
    New-Item -Path $regKey -Force | Out-Null
    Write-Host "Created key: $regKey"
}

# Set the policy value
Set-ItemProperty -Path $regKey -Name $valueName -Type DWord -Value $desiredVal -Force
Write-Host "Set $valueName = $desiredVal"

#-----------------------------#
# 3.  Verification step       #
#-----------------------------#
$actualVal = (Get-ItemProperty -Path $regKey -Name $valueName).$valueName

if ($actualVal -eq $desiredVal) {
    Write-Host "`n✅ SUCCESS: HTTP printing is disabled (DisableHTTPPrinting = $actualVal)." -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n❌ FAILURE: DisableHTTPPrinting is $actualVal (expected $desiredVal)." -ForegroundColor Red
    exit 1
}
