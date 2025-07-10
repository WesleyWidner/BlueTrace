<div align="center">

# INSTALL.md

## 🚀 Blue Trace Installation Guide

This document explains how to install and launch **Blue Trace** (v2.0.0.0) on your Windows system.

---

## Prerequisites

**Supported Operating System:**  
Windows 10 version 1809 (build 17763) or later  
64-bit (x64) architecture

**.NET Runtime:**  
.NET 8.0 Desktop Runtime (included in MSIX package)  
No manual .NET installation required for most users

**Privileges:**  
Local **Administrator rights** required to run most scan modules

**Disk Space:**  
At least 250 MB free for installation and scan output

---

# Blue Trace Installation Guide

### **1. Download Blue Trace**

### **2. Unzip Blue Trace Release Folder**

Save the folder to your preferred destination.

### **3. Open Blue Trace Release Folder**

Open the `BlueTrace_2.0.0.0_Test` folder.

### **4. Install the Security Certificate**

Double-click `BlueTrace_2.0.0.0_x64 Security Certificate`.  
Click **Install Certificate**.  
For **Store Location**, select **Local Machine**.  
Choose **Place all certificates in the following store**, then select **Trusted Root Certification Authorities**.  
Click **Finish** to complete the certificate installation.

### **5. Install Blue Trace Application**

Return to the **Blue Trace Release** folder.  
Double-click the `BlueTrace` (**APPINSTALLER**) file.  
Click **Install** to begin the application installation.

### **6. Launch Blue Trace**

Once installed, open the **Start Menu** and search for **Blue Trace**.  
*(Optional)* Drag **Blue Trace** to your desktop for easy access.

---

## Troubleshooting

If you encounter issues during installation:

Ensure you are running Windows 10 (version 1809+) or newer.  
Make sure you have admin rights.  
Check for any group policy restrictions on MSIX/app installations.  
Refer to [Troubleshoot installation](https://docs.microsoft.com/en-us/windows/msix/app-installer/troubleshoot-app-installer) for more help.

---

## File Locations

**Installation Path:**  
Blue Trace is installed in the Windows Apps directory (managed by the system).

**Scan Output:**  
Reports and exported files are saved to your chosen output folder.  
Default: `Documents\BlueTrace\Scans`

---

## Uninstallation

Go to **Settings > Apps > Installed apps**, find "Blue Trace," and select **Uninstall**.  
Or, right-click the app in the Start Menu and choose **Uninstall**.

---

## Contact & Support

For installation help or bug reports, contact:  
**Email:** [Info@whitehatwes.com](mailto:Info@whitehatwes.com)

</div>
