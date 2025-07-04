<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Charlie Mathe
    LinkedIn        : www.linkedin.com/in/karoly-charlie-mathe
    GitHub          : https://github.com/CharlieMathe
    Date Created    : 2025-07-04
    Last Modified   : 2025-07-04
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AU-000500.ps1 
#>

# YOUR CODE GOES HERE


# Define the registry path
$RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\EventLog\Application'

# Check if the registry path exists, create if it does not
If (-Not (Test-Path -Path $RegPath)) {
>>     New-Item -Path $RegPath -Force | Out-Null
>> }

 # Set the MaxSize registry value
PS C:\Users\Daiunnume> New-ItemProperty -Path $RegPath `
>>                  -Name "MaxSize" `
>>                  -PropertyType DWord `
>>                  -Value 0x00008000 `
>>                  -Force


MaxSize      : 32768
PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\EventLog\Application
PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\EventLog
PSChildName  : Application
PSDrive      : HKLM
PSProvider   : Microsoft.PowerShell.Core\Registry
