<#
.SYNOPSIS
    This PowerShell script creates or updates a Group Policy Object (GPO) to configure BitLocker settings that require additional authentication at startup, enforcing either a TPM startup PIN or a TPM startup key and PIN, and applies the changes to the local system.

.NOTES
    Author          : Derrick Horton
    LinkedIn        : linkedin.com/in/derrickjhorton
    GitHub          : github.com/derrickhorton
    Date Created    : 2025-01-26
    Last Modified   : 2025-01-26
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000031

.TESTED ON
    Date(s) Tested  : 2025-01-26
    Tested By       : Derrick Horton
    Systems Tested  : Windows 10 19045.5247
    PowerShell Ver. : v1.0

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# Import the Active Directory module for Group Policy cmdlets
Import-Module GroupPolicy

# Define the GPO settings
$GpoName = "STIG BitLocker Policy"
$PolicyPath = "SOFTWARE\Policies\Microsoft\FVE"
$RegistryKey = "HKLM:\$PolicyPath"

# Create or find the GPO
if (!(Get-GPO -Name $GpoName -ErrorAction SilentlyContinue)) {
    Write-Host "Creating GPO: $GpoName"
    New-GPO -Name $GpoName
} else {
    Write-Host "GPO already exists: $GpoName"
}

# Configure the "Require additional authentication at startup" policy
Write-Host "Configuring policy: Require additional authentication at startup"
Set-GPRegistryValue -Name $GpoName -Key $PolicyPath -ValueName "UseAdvancedStartup" -Type DWORD -Value 1

# Configure "TPM startup PIN required"
Write-Host "Configuring TPM startup PIN requirement"
Set-GPRegistryValue -Name $GpoName -Key $PolicyPath -ValueName "UseTPM" -Type DWORD -Value 2
Set-GPRegistryValue -Name $GpoName -Key $PolicyPath -ValueName "UsePIN" -Type DWORD -Value 1

# Optional: Configure "TPM startup key and PIN" (uncomment if needed)
# Set-GPRegistryValue -Name $GpoName -Key $PolicyPath -ValueName "UseKeyAndPIN" -Type DWORD -Value 1

# Force the GPO update on the local system
Write-Host "Applying Group Policy changes to the local system"
gpupdate /force

Write-Host "Configuration complete. Verify the settings via Group Policy or the registry."
