<#
.SYNOPSIS
    According to this STIG, Windows 11 must be configured to audit Other Policy Change Events Failures. The below Powershell satisfies this STIG and also
    confirms by printing a confirmation or a failure message.

.NOTES
    Author          : Charlie Mathe
    LinkedIn        : www.linkedin.com/in/karoly-charlie-mathe
    GitHub          : https://github.com/CharlieMathe
    Date Created    : 06/July/2025
    Last Modified   : 06/July/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000555

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000555.ps1 
#>

# Variables
$audit_category = "Policy Change"
$audit_subcat   = "Other Policy Change Events"

# Apply audit policy: enable Failure only
AuditPol.exe /set /category:"$audit_category" /subcategory:"$audit_subcat" /failure:enable /success:disable | Out-Null
Start-Sleep -Seconds 1

# Retrieve current policy
$output = AuditPol.exe /get /category:"$audit_category"
$lines = $output -split "`n"

# Find the relevant line
$target = $lines | Where-Object { $_ -match "^.*$audit_subcat" }

if (-not $target) {
    Write-Host "`n❌ FAILURE: '$audit_subcat' not found." -ForegroundColor Red
    Write-Host "AuditPol output:`n$output"
} else {
    $setting = ($target.Trim().Split()[-1])
    if ($setting -eq "Failure") {
        Write-Host "`n✅ SUCCESS: '$audit_subcat' is correctly auditing for Failure." -ForegroundColor Green
    } else {
        Write-Host "`n❌ FAILURE: Audit setting is incorrect. Detected: '$setting' (expected 'Failure')." -ForegroundColor Red
        Write-Host "Line:`n$target"
    }
}
