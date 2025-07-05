# INSTALL.md

## 🚀 Blue Trace Installation Guide

This document explains how to install and launch **Blue Trace** (v2.0.0.0) on your Windows system.

---

## Prerequisites

* **Supported Operating System:**

  * Windows 10 version 1809 (build 17763) or later
  * 64-bit (x64) architecture

* **.NET Runtime:**

  * .NET 8.0 Desktop Runtime (included in MSIX package)
  * No manual .NET installation required for most users

* **Privileges:**

  * Local **Administrator rights** required to run most scan modules

* **Disk Space:**

  * At least 250 MB free for installation and scan output

---

## Installation Steps

### **1. Download Blue Trace**

* Obtain the latest MSIX/installer bundle from your trusted source or release page:

  ```
  BlueTrace_2.0.0.0_x64.msixbundle
  ```

### **2. Install the Application**

* **Double-click** the `.msixbundle` file to start the installation with the Windows App Installer.
* Follow the on-screen prompts:

  * Click **"Install"** or **"Reinstall"** if upgrading.
  * Accept any security or trust dialogs (the publisher should display as **White Hat Wes Cybersecurity**).

**Note:**
If Windows blocks the installation, right-click the installer, select **Properties**, and check **"Unblock"** at the bottom if available.

### **3. Launch Blue Trace**

* Once installed, **click "Launch"** in the installer window or find "Blue Trace" in your Start Menu.
* The main dashboard will appear.

---

## Quick Start

1. **Open Blue Trace** from your Start Menu.
2. **Select a scan profile** (Incident Response, Networking, System Health, Compliance) or create a custom scan.
3. **Click "Start Scan"** and follow the progress bar.
4. **View scan results** on the dashboard, export them in your preferred format, or generate a PDF report.
5. **Review past scans** in the Scan History tab.

---

## Troubleshooting

* If you encounter issues during installation:

  * Ensure you are running Windows 10 (version 1809+) or newer.
  * Make sure you have admin rights.
  * Check for any group policy restrictions on MSIX/app installations.
  * Refer to [Troubleshoot installation](https://docs.microsoft.com/en-us/windows/msix/app-installer/troubleshoot-app-installer) for more help.

---

## File Locations

* **Installation Path:**

  * Blue Trace is installed in the Windows Apps directory (managed by the system).
* **Scan Output:**

  * Reports and exported files are saved to your chosen output folder. Default: `Documents\BlueTrace\Scans`

---

## Uninstallation

* Go to **Settings > Apps > Installed apps**, find "Blue Trace," and select **Uninstall**.
* Or, right-click the app in the Start Menu and choose **Uninstall**.

---

## Contact & Support

For installation help or bug reports, contact:
**Email:** [Info@whitehatwes.com](mailto:Info@whitehatwes.com)
