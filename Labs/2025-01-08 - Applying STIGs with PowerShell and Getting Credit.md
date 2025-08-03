23:55 UTC Begin

First step is to create a Windows 10 VM.

When creating in Azure, there were no problems. However, due to limitations on the Lab Environment using Public IPs, I have implemented mine without a Public IP and am attempting to connect over Bastian. I have done this in the past successfully, however this time I am unable to connect to the VM.

Error messages:

![[Screenshot 2025-01-09 at 00.27.36.png]]

![[Screenshot 2025-01-09 at 00.27.55.png]]

This keeps repeating. I am certain of the username and password, so I am unsure the problem. Attempting to reset them now and try again before reaching out to the community for assistance.

Resetting password:
![[Screenshot 2025-01-09 at 00.33.44.png]]

Re-attempting login:
![[Screenshot 2025-01-09 at 00.34.44.png]]

That did not work. Same error messages appearing:

![[Screenshot 2025-01-09 at 00.27.36.png]]

![[Screenshot 2025-01-09 at 00.27.55.png]]


Reaching out to community for assistance:

https://www.skool.com/cyber-community/the-network-connection-to-bastion-host-appears-unstable?p=20b60a67

Issue resolved.

---

### Log into Windows 10 VM in Azure (Using Bastion)

### Turn OFF Windows Firewall

### Create Advanced Network Scan in Tenable

Searching for STIGs
Private IP:   10.0.0.16

![[Screenshot 2025-01-09 at 07.14.27.png]]



![[Screenshot 2025-01-09 at 07.15.16.png]]


Search for **WN10-AU-000500**

![[Screenshot 2025-01-09 at 07.16.04.png]]

Example of this problem in the VM:

![[Screenshot 2025-01-09 at 07.20.58.png]]

Explanation of STIG:

https://stigaview.com/products/win10/v2r8/WN10-AU-000500/


![[Screenshot 2025-01-09 at 07.25.28.png]]


Restarting Machine

Event Viewer shows the Max Log Size has changed:
![[Screenshot 2025-01-09 at 07.32.01.png]]

---

### Scan again on Tenable

![[Screenshot 2025-01-09 at 07.39.18.png]]

Search for **WN10-AU-000500**

![[Screenshot 2025-01-09 at 07.40.05.png]]

Success!!

---
### Undo the change that we did manually 

(...So that we can do it with PowerShell.)

Export Application Folder, call it WN10-AU-000500.reg and save to Desktop on VM

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application]
"MaxSize"=dword:00008000
```

Restart VM

---

### Run STIG Scan Again

(To prove the fix is gone and the problem has returned)

![[Screenshot 2025-01-09 at 07.58.13.png]]

Search for **WN10-AU-000500**

![[Screenshot 2025-01-09 at 07.59.20.png]]

Good! It failed. That means the fix I put in place manually has been removed now.

---

Figure out how to use PowerShell to create that registry key to perform the fix programmatically.
### Using ChatGPT:

Please implement this with PowerShell, assume whatever version is native to the latest version of Windows 10:

[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application]
"MaxSize"=dword:00008000

```
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
```
#### Explanation:

1. **`$registryPath`**: Specifies the path to the registry key.
2. **`$propertyName`**: Specifies the property name (`MaxSize`).
3. **`$propertyValue`**: Sets the desired value in hexadecimal format (`0x8000` is equivalent to `00008000` in hexadecimal).
4. **`New-Item`**: Creates the registry key if it doesn't exist.
5. **`New-ItemProperty`**: Creates or updates the property with the specified value.
6. **`-Force`**: Ensures the operation completes even if the property already exists.

Save this script as a `.ps1` file (e.g., `Set-EventLogMaxSize.ps1`) and run it in an elevated PowerShell session (Run as Administrator) to apply the change.

That worked!

![[Screenshot 2025-01-09 at 08.17.15.png]]

Restart VM again

---
### Re-scan the VM again

Results:

![[Screenshot 2025-01-09 at 08.33.00.png]]

It worked!

![[Screenshot 2025-01-09 at 08.33.37.png]]

The PowerShell script implemented the STIG!

---

### Upload PowerShell file to GitHub


 https://github.com/derrickhorton/CyberRange/blob/main/STIGs/WN10-AU-000500.ps1

---
### Add STIG Completion to Internship Credit

Delete VM.

Lab completed.

08:43 UTC End
