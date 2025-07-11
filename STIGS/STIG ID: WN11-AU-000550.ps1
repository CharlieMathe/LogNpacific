<#
.SYNOPSIS
    According to this STIG, Windows 11 must be configured to audit Other Policy Change Events Successes. The below :Powershell satisfies this STIG and also
    confirms by print a confirmation or a failure message

.NOTES
    Author          : Charlie Mathe
    LinkedIn        : www.linkedin.com/in/karoly-charlie-mathe
    GitHub          : https://github.com/CharlieMathe
    Date Created    : 06/July/2025
    Last Modified   : 06/July/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000550

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000550.ps1 
#>

# Set audit policy
$audit_category = "Policy Change"
$audit_subcat = "Other Policy Change Events"

# Set policy to Success only (disabling failure auditing)
AuditPol.exe /set /category:"$audit_category" /subcategory:"$audit_subcat" /success:enable /failure:disable | Out-Null

# Allow policy processing to take effect
Start-Sleep -Seconds 1

# Get the current setting and parse output
$policy_output = AuditPol.exe /get /category:"$audit_category"
$lines = $policy_output -split "`n"

# Find the line containing the subcategory
$target = $lines | Where-Object { $_ -match "$audit_subcat" }

if ($null -eq $target) {
    Write-Host "`n❌ FAILURE: $audit_subcat setting not found in output!" -ForegroundColor Red
    Write-Host "Output:`n$policy_output"
} else {
    # Extract just the setting (last word in the line)
    $setting = $target.Trim().Split()[-1]
    if ($setting -eq "Success") {
        Write-Host "`n✅ SUCCESS: $audit_subcat is auditing Success as required." -ForegroundColor Green
    } else {
        Write-Host "`n❌ FAILURE: $audit_subcat auditing is not set correctly. Detected: $setting" -ForegroundColor Red
        Write-Host "Line:`n$target"
    }
}
