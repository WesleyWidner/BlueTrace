# 🚨 Blue Trace – Windows Forensic Artifact Collector (v2.0) 🚨

**Blue Trace** is a modular, analyst-driven Windows artifact collector designed for digital forensics, incident response, system health, and compliance monitoring. With one click, Blue Trace extracts a comprehensive set of artifacts and system details, packaging them in structured formats for investigation, triage, and reporting.

---

## ✨ Key Features

* **End-to-End Artifact Collection:** Gathers user, system, network, security, and forensic artifacts in a single automated pass.
* **Custom & Preconfigured Scans:** Choose from incident response, networking, system health, compliance, or design your own scan sets.
* **Dashboard & Scan History:** Visualize current device health, review past scans, and track system changes over time.
* **Multiple Export Formats:** Export scan results as **JSON**, **XLSX**, **TXT**, or **CSV**. JSON scans can be converted to full PDF reports.

---

## 🖥️ System Dashboard Overview

The dashboard displays real-time and historical insights, including:

* **Basic Information:** Device name, MAC address, hostname, user name, etc.
* **Security Status:** UAC, encryption, antivirus status, etc.
* **System Health:** Disk usage, RAM utilization, CPU load, Windows Update status.
* **Recent Scan History:** Quick access to all previous scan results and reports.

---

## 🛠️ Scan Modules

Blue Trace supports a wide array of forensic and diagnostic modules. Each scan can be run individually or grouped into scan profiles:

| Scan Name                 | Function                             |
| ------------------------- | ------------------------------------ |
| SYSTEMINFORMATION         | System details & hardware info       |
| INSTALLEDPROGRAMS         | Installed applications inventory     |
| ENVIRONMENTVARIABLES      | Environment variables                |
| UACSETTINGS               | User Account Control status          |
| WINDOWSVERSIONINFO        | OS version & build info              |
| DESKTOPFILETIMESTAMPS     | Desktop file access & creation times |
| FILEMETADATA              | Metadata for specified files         |
| HIDDENFILESONC            | Hidden files on C:\\                 |
| ALTERNATEDATASTREAMS      | Files with alternate data streams    |
| FILESACCESSEDLAST14DAYS   | Files accessed in last 14 days       |
| RECYCLEBINCONTENTS        | Current Recycle Bin files            |
| TEMPFOLDERCONTENTS        | Temp folder contents                 |
| VOLUMESHADOWCOPIES        | Volume Shadow Copies                 |
| SYMBOLICLINKSANDJUNCTIONS | Symbolic links and junction points   |
| RUNNINGPROCESSES          | Active process list                  |
| LOADEDDLLS                | Loaded DLLs in memory                |
| PROCESSTREEWMI            | WMI-based process tree               |
| POWERSHELLHISTORY         | PowerShell command history           |
| PARENTCHILDPROCESSTREE    | Full parent-child process map        |
| WMIACTIVITYLOGS           | WMI activity logs                    |
| SCHEDULEDTASKS            | Scheduled Tasks                      |
| STARTUPFOLDERITEMS        | Startup folder entries               |
| REGISTRYRUNKEYS           | Run/RunOnce registry keys            |
| SERVICEINFORMATION        | Windows services status              |
| WMIEVENTCONSUMERS         | WMI event consumers                  |
| COMHIJACKINGENTRIES       | Suspicious COM registry entries      |
| DLLSEARCHORDERHIJACKS     | Potential DLL hijacks                |
| SECURITYEVENTLOG          | Security event log extract           |
| SYSTEMEVENTLOG            | System event log extract             |
| APPLICATIONEVENTLOG       | Application event log extract        |
| SETUPEVENTLOG             | Setup event log extract              |
| WINDOWSPOWERSHELLLOG      | PowerShell logs                      |
| POWERSHELLOPERATIONALLOG  | PowerShell operational logs          |
| NTUSERDAT                 | User NTUSER.DAT checks               |
| RECENTDOCS                | Recently opened documents            |
| USERASSIST                | UserAssist registry data             |
| SHELLBAGS                 | ShellBag artifacts                   |
| TYPEDPATHS                | TypedPaths registry entries          |
| RUNMRU                    | Run MRU entries                      |
| JUMPLISTS                 | JumpLists data                       |
| CLIPBOARDHISTORY          | Clipboard history                    |
| ACCOUNTLOCKOUTS           | Account lockout events               |
| CREDENTIALMANAGER         | Credential Manager items             |
| NETUSER                   | User accounts                        |
| NETLOCALGROUP             | Local group memberships              |
| WHOAMIGROUPS              | Whoami group membership              |
| MACADDRESSES              | Network interface MAC addresses      |
| HOSTSFILE                 | Hosts file entries                   |
| FIREWALLRULES             | Firewall rules                       |
| DNSCACHE                  | DNS resolver cache                   |
| ARPCACHE                  | ARP cache                            |
| LOGONEVENTS               | Logon/logoff events                  |
| BAMDAMACTIVITY            | BAM/DAM user activity                |
| NETSTATOUTPUT             | Active network connections           |
| IPCONFIGDISPLAYDNS        | IP config / display DNS              |
| RDPLOGONEVENTS            | RDP logon events                     |
| NETWORKINTERFACES         | Network interfaces                   |
| APPCOMPATCACHE            | AppCompatCache data                  |
| MUICACHE                  | MUI cache artifacts                  |
| RECENTAPPS                | Recent app usage                     |
| RECENTFILECACHE           | Recent file cache                    |
| SRUM                      | SRUM usage data                      |
| SAMHIVE                   | SAM registry hive                    |
| SECURITYHIVE              | Security registry hive               |
| USRCLASSDAT               | UsrClass.dat checks                  |
| PREFETCHFILES             | Prefetch file analysis               |
| AMCACHECHECK              | Amcache registry artifacts           |
| DOWNLOADSFOLDER           | Downloads folder inventory           |
| USBHISTORY                | USB device history                   |
| LNKFILES                  | Shortcut (.lnk) files                |
| SYSTEMHIVE                | System registry hive                 |
| SOFTWAREHIVE              | Software registry hive               |
| BITLOCKERSTATUS           | BitLocker status                     |
| GROUPPOLICYRESULTS        | Group Policy Results                 |
| WINDOWSDEFENDERSTATUS     | Defender/AV status                   |
| WERCRASHDUMPS             | Windows Error Reporting crash dumps  |
| IMAGESVIDEOSINVENTORY     | Image and video file inventory       |

---

## 🗂️ Output Formats

* **JSON**: Raw structured data (used for report generation)
* **XLSX**: Tabular format for analysis in Excel/LibreOffice
* **TXT**: Plain text for easy review or parsing
* **CSV**: Flat file for spreadsheet or database import
* **PDF (via JSON)**: Beautiful, comprehensive reports 

---

## 📊 Dashboard & History

* **Dashboard:** See live status of device health, security, and recent scan results.
* **Scan History:** Display of all scans ran during the session.

---

## 🧑‍💻 Custom Scans & Profiles

You can:

* **Run Any Module Individually:** Pick only the artifacts you want.
* **Create Custom Scans:** Combine any modules into your own profiles.
* **Use Predefined Profiles:** Quick-start options for:

  * **Incident Response**
  * **Networking**
  * **System Health**
  * **Compliance**

---

## ❓ FAQ

* **Q: What permissions does Blue Trace require?**
  A: Local administrator rights for complete artifact access.

* **Q: Are results private?**
  A: All scan data is stored and exported **locally only** unless you choose to share.

---

## 📢 About

**Blue Trace** is built by analysts, for analysts and system administrators who need **clarity, speed, and reliability** in Windows evidence collection.
For more information, visit https://whitehatwes.com

---

## 📄 License

\[Insert your license type or terms here.]


## GUI
![image](https://github.com/user-attachments/assets/e0999d94-0ec1-4155-847c-c86e833caaa4)

![image](https://github.com/user-attachments/assets/c42d01de-11c0-42e6-9474-0e65e13fbaa5)

![image](https://github.com/user-attachments/assets/c57925f5-d10d-46bf-9388-b0fd8b36006f)

![image](https://github.com/user-attachments/assets/f803cd15-5bfb-4ae3-9ac5-9d8f1a10ed7a)

![image](https://github.com/user-attachments/assets/3cbd019a-aff0-4475-8597-80ac2e9aff62)

![image](https://github.com/user-attachments/assets/77c298c6-cb78-4cd7-92e8-8767a24ee2c2)

![image](https://github.com/user-attachments/assets/7a9eeb19-083b-4f5b-9460-7182ce1874f7)

## 📄 License

Copyright (c) 2024 White Hat Wes Cybersecurity. All rights reserved.

This software and its associated files ("Blue Trace") are the exclusive property of White Hat Wes Cybersecurity.

Permission is hereby granted to the original licensee to use this software for personal or internal business purposes only, subject to the following restrictions:

1. **No Modification:**  
   You may not modify, adapt, reverse engineer, decompile, or create derivative works based on any part of this software.

2. **No Sale or Redistribution:**  
   You may not sell, resell, lease, rent, sublicense, distribute, or otherwise transfer this software or any derivative works to any third party, whether for commercial or non-commercial purposes.

3. **No Commercial Use Beyond Original Licensee:**  
   Use of this software is restricted solely to the original licensee and may not be provided as a service or included in any commercial offering.

4. **Proprietary Notices:**  
   You must not remove or obscure any copyright, trademark, or other proprietary notices from the software.

5. **No Warranty:**  
   This software is provided "as is", without warranty of any kind, express or implied. In no event shall White Hat Wes Cybersecurity be liable for any damages arising from the use of this software.

For inquiries about additional rights or commercial licensing, please contact:  
**White Hat Wes Cybersecurity**  
info@whitehatwes.com





