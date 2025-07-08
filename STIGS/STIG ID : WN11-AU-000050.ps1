<#
.SYNOPSIS
    According to this STiG, the system must be configured to audit Detailed Tracking - Process Creation successes. The below Powershell satisfies this
STIG and also
    confirms by printing a confirmation or a failure message.

.NOTES
    Author          : Charlie Mathe
    LinkedIn        : www.linkedin.com/in/karoly-charlie-mathe
    GitHub          : https://github.com/CharlieMathe
    Date Created    : 08/July/2025
    Last Modified   : 08/July/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000050

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000050.ps1 
#>

<#
 STIG ID : WN11-AU-000050
 Title   : Audit Detailed Tracking – Process Creation (successes)
 Author  : your-name
 Purpose : Enables auditing of **Process Creation** for **Success** only and
           verifies the setting.
#>

#-----------------------------#
# 1.  Configuration section   #
#-----------------------------#
$auditSubCat = 'Process Creation'   # STIG-required sub-category
$desired     = 'Success'            # What the STIG wants

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
# Get the single-subcategory read-back
$report  = AuditPol.exe /get /subcategory:"$auditSubCat" | Out-String
$line    = ($report -split "`n") | Where-Object { $_ -match $auditSubCat }

# Extract the last token on that line (column = Setting)
if ($line) {
    $setting = ($line.Trim().Split()[-1])
    if ($setting -eq $desired) {
        Write-Host "`n✅ SUCCESS: '$auditSubCat' is auditing $desired as required." -ForegroundColor Green
    } else {
        Write-Host "`n❌ FAILURE: Detected setting is '$setting' (expected '$desired')." -ForegroundColor Red
        Write-Host "Line:`n$line"
    }
} else {
    Write-Host "`n❌ FAILURE: Could not find '$auditSubCat' in AuditPol output!" -ForegroundColor Red
    Write-Host "Full output:`n$report"
}

#-----------------------------#
# 4.  Exit code (optional)    #
#-----------------------------#
# $LASTEXITCODE = 0 for success, 1 for failure
if ($setting -eq $desired) { exit 0 } else { exit 1 }
