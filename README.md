# 🚨 Blue Trace – Windows Forensic Artifact Collector (v2.0) 🚨

**Blue Trace** is a modular, analyst-driven Windows artifact collector designed for digital forensics, incident response, system health, and compliance monitoring. With one click, Blue Trace extracts a comprehensive set of artifacts and system details, packaging them in structured formats for investigation, triage, and reporting.

---

## ✨ Key Features

* **End-to-End Artifact Collection:** Gathers user, system, network, security, and forensic artifacts in a single automated pass.
* **Custom & Preconfigured Scans:** Choose from incident response, networking, system health, compliance, or design your own scan sets.
* **Dashboard & Scan History:** Visualize current device health, past scans, and track system changes over time.
* **Multiple Export Formats:** Export scan results as **JSON**, **XLSX**, **TXT**, or **CSV**. JSON scans can be converted to full PDF reports.

---

## 🖥️ System Dashboard Overview

The dashboard displays real-time and historical insights, including:

* **Basic Information:** Device name, MAC address, hostname, user name, etc.
* **Security Status:** UAC, encryption, antivirus status, etc.
* **System Health:** Disk usage, RAM utilization, CPU load, Windows Update status.
* **Recent Scan History:** Identify previous scans ran during the session.

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




