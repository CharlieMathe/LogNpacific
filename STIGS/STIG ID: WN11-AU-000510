<#
.SYNOPSIS
    This PowerShell script ensures that The System event log size is configured to 32768 KB or greater. The script also includes a verification step which
will print a confirmation of the registry key being created or a failure.

.NOTES
    Author          : Charlie Mathe
    LinkedIn        : www.linkedin.com/in/karoly-charlie-mathe
    GitHub          : https://github.com/CharlieMathe
    Date Created    : 06/July/2025
    Last Modified   : 06/July/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000505

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000505.ps1 
#>

# Variables for STIG enforcement
$RegKey   = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System'
$ValueName = 'MaxSize'
$ValueData = 32768   # 32,768 KB per STIG

# Create the registry key if it doesn't exist
if (-not (Test-Path $RegKey)) {
    New-Item -Path $RegKey -Force | Out-Null
    Write-Host "Created key: $RegKey"
} else {
    Write-Host "Key already exists: $RegKey"
}

# Set the MaxSize value
New-ItemProperty -Path $RegKey `
    -Name $ValueName `
    -PropertyType DWord `
    -Value $ValueData `
    -Force | Out-Null
Write-Host "Set $ValueName = $ValueData in $RegKey"

# Verification step
if (Test-Path $RegKey) {
    $props = Get-ItemProperty -Path $RegKey
    if ($props.$ValueName -ge $ValueData) {
        Write-Host "`n✅ SUCCESS: STIG WN11-AU-000510 is satisfied." -ForegroundColor Green
        Write-Host "$RegKey`n$ValueName = $($props.$ValueName)" -ForegroundColor Green
    } else {
        Write-Host "`n❌ FAILURE: Registry value is less than required." -ForegroundColor Red
        Write-Host "$ValueName = $($props.$ValueName) (expected ≥ $ValueData)" -ForegroundColor Red
    }
} else {
    Write-Host "`n❌ FAILURE: Registry key was not created!" -ForegroundColor Red
}
