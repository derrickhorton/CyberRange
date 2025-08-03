23:55 UTC Begin

First step is to create a Windows 10 VM.

When creating in Azure, there were no problems. However, due to limitations on the Lab Environment using Public IPs, I have implemented mine without a Public IP and am attempting to connect over Bastian. I have done this in the past successfully, however this time I am unable to connect to the VM.

Error messages:

![9469d8c114c4f5b174ba75db0cc64626.png](attachment/9469d8c114c4f5b174ba75db0cc64626.png)

![](attachment/13df79dffd2a855769229a92c978d2e9.png)

This keeps repeating. I am certain of the username and password, so I am unsure the problem. Attempting to reset them now and try again before reaching out to the community for assistance.

Resetting password:
![](attachment/012f86744d248fbdfcd54a02b0616229.png)

Re-attempting login:
![](attachment/86b19b4ad170fedc32c7b2e9bfc8952b.png)

That did not work. Same error messages appearing:

![](attachment/9469d8c114c4f5b174ba75db0cc64626.png)

![](attachment/13df79dffd2a855769229a92c978d2e9.png)


Reaching out to community for assistance:

https://www.skool.com/cyber-community/the-network-connection-to-bastion-host-appears-unstable?p=20b60a67

Issue resolved.

---

### Log into Windows 10 VM in Azure (Using Bastion)

### Turn OFF Windows Firewall

### Create Advanced Network Scan in Tenable

Searching for STIGs
Private IP:   10.0.0.16

![](attachment/564cbe77eb1c0a635f4ad4636ddbddde.png)



![](attachment/34b9973c4b119ae666cdcf619fcf0788.png)


Search for **WN10-AU-000500**

![](attachment/f5aa1d55b7db22f9758e79cf3bf53b89.png)

Example of this problem in the VM:

![](attachment/e7a3ac88a79704b7587434f4ab87104d.png)

Explanation of STIG:

https://stigaview.com/products/win10/v2r8/WN10-AU-000500/


![](attachment/9d4750661a1e835775411bbfb08dac70.png)


Restarting Machine

Event Viewer shows the Max Log Size has changed:
![](attachment/1f5c62f490bcd606bf3d5fbe8a0fdf61.png)

---

### Scan again on Tenable

![](attachment/3c43d96cfcac5acb4bd453f9ea198705.png)

Search for **WN10-AU-000500**

![](attachment/620141c80a0f4862b7569b92a51fab4a.png)

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

![](attachment/5ae5fa9943ae47209fd43d9b04a89756.png)

Search for **WN10-AU-000500**

![](attachment/9e837db503cc2ddf4c1183e370afe30c.png)

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

![](attachment/da2c807d769b636b4188691bad11dfda.png)

Restart VM again

---
### Re-scan the VM again

Results:

![](attachment/c504cb7b8bf2cee11137f7770ab35508.png)

It worked!

![](attachment/84230dc70703d1779fba6571a0c32d34.png)

The PowerShell script implemented the STIG!

---

### Upload PowerShell file to GitHub


 https://github.com/derrickhorton/CyberRange/blob/main/STIGs/WN10-AU-000500.ps1

---
### Add STIG Completion to Internship Credit

Delete VM.

Lab completed.

08:43 UTC End
