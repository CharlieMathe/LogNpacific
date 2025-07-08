<#
.SYNOPSIS
    According to this STiG, the system must be configured to audit Policy Change - Authentication Policy Change successes. The below Powershell satisfies this
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
    STIG-ID         : WN11-AU-000105

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000105.ps1 
#>

#-----------------------------#
# 1.  Configuration section   #
#-----------------------------#
$auditSubCat = 'Authentication Policy Change'   # STIG-required sub-category
$desired     = 'Success'                        # Required setting

#-----------------------------#
# 2.  Apply the audit policy  #
#-----------------------------#
Write-Host "`n🔧 Configuring Audit Policy: $auditSubCat → $desired"
AuditPol.exe /set /subcategory:"$auditSubCat" /success:enable /failure:disable | Out-Null

# Give the OS a heartbeat to register the new setting
Start-Sleep -Seconds 1

#-----------------------------#
# 3.  Verification step       #
#-----------------------------#
$report = AuditPol.exe /get /subcategory:"$auditSubCat" | Out-String
$line   = ($report -split "`n") | Where-Object { $_ -match $auditSubCat }

if ($line) {
    $setting = ($line.Trim().Split()[-1])
    if ($setting -eq $desired) {
        Write-Host "`n✅ SUCCESS: '$auditSubCat' is auditing $desired as required." -ForegroundColor Green
    } else {
        Write-Host "`n❌ FAILURE: Detected setting is '$setting' (expected '$desired')." -ForegroundColor Red
        Write-Host "Line:`n$line"
    }
} else {
    Write-Host "`n❌ FAILURE: '$auditSubCat' not found in AuditPol output!" -ForegroundColor Red
    Write-Host "Full output:`n$report"
}

# Optional: return 0 on success, 1 on failure
if ($setting -eq $desired) { exit 0 } else { exit 1 }
