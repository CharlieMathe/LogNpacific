<#
.SYNOPSIS
    According to this STIG,The built-in guest account must be renamed. The below Powershell satisfies this STIG and also
   checks if a Guest account is present. It disables it if present and it is enabled. It will clearly communicate if it is missing , already disabled, or has 
   just been disabled.
   
.NOTES
    Author          : Charlie Mathe
    LinkedIn        : www.linkedin.com/in/karoly-charlie-mathe
    GitHub          : https://github.com/CharlieMathe
    Date Created    : 06/July/2025
    Last Modified   : 06/July/2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000025

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-SO-000025.ps1 
#>

# Find the built-in Guest account by RID 501
$guest = Get-LocalUser | Where-Object { $_.SID -like '*-501' }

if ($null -eq $guest) {
    Write-Host "✅ Guest account (RID 501) does not exist. Already compliant!" -ForegroundColor Green
} else {
    Write-Host "🔍 Guest account detected: $($guest.Name) (Enabled: $($guest.Enabled))"

    if (-not $guest.Enabled) {
        Write-Host "✅ Guest account '$($guest.Name)' is already disabled. STIG satisfied." -ForegroundColor Green
    } else {
        try {
            Disable-LocalUser -Name $guest.Name
            Write-Host "🔒 Guest account '$($guest.Name)' has been disabled." -ForegroundColor Yellow
        } catch {
            Write-Host "❌ ERROR: Could not disable Guest account. $_" -ForegroundColor Red
        }
        # Re-check status
        $guest = Get-LocalUser | Where-Object { $_.SID -like '*-501' }
        if (-not $guest.Enabled) {
            Write-Host "✅ Guest account '$($guest.Name)' is now disabled. STIG satisfied." -ForegroundColor Green
        } else {
            Write-Host "❌ FAILURE: Guest account '$($guest.Name)' is still enabled!" -ForegroundColor Red
        }
    }
}
