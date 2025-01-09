<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Derrick Horton
    LinkedIn        : linkedin.com/in/derrickjhorton
    GitHub          : github.com/derrickhorton
    Date Created    : 2025-01-09
    Last Modified   : 2025-01-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 2025-01-09
    Tested By       : Derrick Horton
    Systems Tested  : Windows 10 19045.5247
    PowerShell Ver. : v1.0

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# Define the registry key path
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"

# Define the property name and value
$propertyName = "MaxSize"
$propertyValue = 0x8000  # Equivalent to dword:00008000

# Check if the registry key exists, and create it if it doesn't
if (-not (Test-Path -Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry property
New-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue -PropertyType DWord -Force

# Output a success message
Write-Output "Registry key and property set successfully."
