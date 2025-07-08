<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Security event log is 1024000 KB or greater

.NOTES
    Author          : Charlie Mathe
    LinkedIn        : www.linkedin.com/in/karoly-charlie-mathe
    GitHub          : https://github.com/CharlieMathe
    Date Created    : 07/05/2025
    Last Modified   : 07/05/2025
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


# Set variables
$RegKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security'
$ValueName = 'MaxSize'
$ValueData = 1024000  # 1,024,000 KB for STIG compliance

# Ensure the Security key exists
if (-not (Test-Path $RegKey)) {
    New-Item -Path $RegKey -Force | Out-Null
    Write-Output "Created key: $RegKey"
} else {
    Write-Output "Key already exists: $RegKey"
}

# Set the MaxSize value
New-ItemProperty -Path $RegKey -Name $ValueName -PropertyType DWord -Value $ValueData -Force | Out-Null
Write-Output "Set $ValueName = $ValueData in $RegKey"

# Verify the key and value
if (Test-Path $RegKey) {
    $props = Get-ItemProperty -Path $RegKey
    if ($props.$ValueName -eq $ValueData) {
        Write-Host "`nSUCCESS: Registry key and value exist as required for STIG." -ForegroundColor Green
        Write-Host "$RegKey`n$ValueName = $($props.$ValueName)" -ForegroundColor Green
    } else {
        Write-Host "`nERROR: Registry value is not set correctly." -ForegroundColor Red
        Write-Host "$ValueName = $($props.$ValueName)" -ForegroundColor Red
    }
} else {
    Write-Host "`nERROR: Registry key was not created!" -ForegroundColor Red
}
