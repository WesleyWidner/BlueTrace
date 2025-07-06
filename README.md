# 🚨 Windows Forensic Artifact Collector (v2.0) 🚨

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

| Section Name                     | Description                                              |
|-------------------------------|----------------------------------------------------------|
| SYSTEMINFORMATION             | Collects detailed system and hardware information         |
| INSTALLEDPROGRAMS             | Lists installed applications and software                 |
| ENVIRONMENTVARIABLES          | Extracts system environment variables                     |
| UACSETTINGS                   | Checks User Account Control configuration                 |
| WINDOWSVERSIONINFO            | Retrieves Windows version and build information           |
| DESKTOPFILETIMESTAMPS         | Reports access and creation times of desktop files        |
| FILEMETADATA                  | Gathers metadata for specified files                      |
| HIDDENFILESONC                | Identifies hidden files on the C:\ drive                  |
| ALTERNATEDATASTREAMS          | Detects files containing alternate data streams           |
| FILESACCESSEDLAST14DAYS       | Lists files accessed within the last 14 days              |
| RECYCLEBINCONTENTS            | Extracts current contents of the Recycle Bin              |
| TEMPFOLDERCONTENTS            | Lists contents of temporary folders                       |
| VOLUMESHADOWCOPIES            | Detects existing Volume Shadow Copies                     |
| SYMBOLICLINKSANDJUNCTIONS     | Identifies symbolic links and junction points             |
| RUNNINGPROCESSES              | Lists currently running processes                         |
| LOADEDDLLS                    | Extracts loaded DLLs in memory                            |
| PROCESSTREEWMI                | Generates process tree using WMI                          |
| POWERSHELLHISTORY             | Retrieves PowerShell command history                      |
| PARENTCHILDPROCESSTREE        | Maps full parent-child process relationships              |
| WMIACTIVITYLOGS               | Extracts WMI activity logs                                |
| SCHEDULEDTASKS                | Lists scheduled tasks configured on the system            |
| STARTUPFOLDERITEMS            | Reports items in startup folders                          |
| REGISTRYRUNKEYS               | Extracts Run and RunOnce registry keys                    |
| SERVICEINFORMATION            | Provides status of Windows services                       |
| WMIEVENTCONSUMERS             | Detects WMI event consumers                               |
| COMHIJACKINGENTRIES           | Identifies suspicious COM hijacking registry entries      |
| DLLSEARCHORDERHIJACKS         | Detects potential DLL search order hijacks                |
| SECURITYEVENTLOG              | Extracts entries from the Security Event Log              |
| SYSTEMEVENTLOG                | Extracts entries from the System Event Log                |
| APPLICATIONEVENTLOG           | Extracts entries from the Application Event Log           |
| SETUPEVENTLOG                 | Extracts entries from the Setup Event Log                 |
| WINDOWSPOWERSHELLLOG          | Retrieves standard PowerShell logs                        |
| POWERSHELLOPERATIONALLOG      | Retrieves PowerShell operational logs                     |
| NTUSERDAT                     | Extracts user-specific NTUSER.DAT data                    |
| RECENTDOCS                    | Lists recently opened documents                          |
| USERASSIST                    | Extracts UserAssist registry artifacts                    |
| SHELLBAGS                     | Reports ShellBag (folder view) artifacts                  |
| TYPEDPATHS                    | Extracts TypedPaths registry entries                      |
| RUNMRU                        | Retrieves Run Most Recently Used (MRU) entries            |
| JUMPLISTS                     | Extracts JumpLists application usage data                 |
| CLIPBOARDHISTORY              | Retrieves clipboard history                               |
| ACCOUNTLOCKOUTS               | Reports account lockout events                            |
| CREDENTIALMANAGER             | Extracts saved credentials from Credential Manager        |
| NETUSER                       | Lists user accounts                                       |
| NETLOCALGROUP                 | Lists local group memberships                             |
| WHOAMIGROUPS                  | Reports current user's group memberships                  |
| MACADDRESSES                  | Lists MAC addresses of network interfaces                 |
| HOSTSFILE                     | Extracts entries from the Hosts file                      |
| FIREWALLRULES                 | Lists configured Windows Firewall rules                   |
| DNSCACHE                      | Extracts current DNS resolver cache                       |
| ARPCACHE                      | Lists entries from the ARP cache                          |
| LOGONEVENTS                   | Reports logon and logoff events                           |
| BAMDAMACTIVITY                | Extracts BAM/DAM (application activity) data              |
| NETSTATOUTPUT                 | Lists active network connections                          |
| IPCONFIGDISPLAYDNS            | Retrieves IP configuration and DNS cache                  |
| RDPLOGONEVENTS                | Reports Remote Desktop logon events                       |
| NETWORKINTERFACES             | Lists network interfaces and configurations               |
| APPCOMPATCACHE                | Extracts AppCompatCache execution artifacts               |
| MUICACHE                      | Reports MUI (application display name) cache              |
| RECENTAPPS                    | Lists recently used applications                          |
| RECENTFILECACHE               | Extracts recent file cache information                    |
| SRUM                          | Retrieves System Resource Usage Monitor (SRUM) data       |
| SAMHIVE                       | Extracts Security Account Manager (SAM) registry hive     |
| SECURITYHIVE                  | Extracts Security registry hive                           |
| USRCLASSDAT                   | Reports UsrClass.dat shell configuration data             |
| PREFETCHFILES                 | Analyzes Prefetch files for application execution         |
| AMCACHECHECK                  | Extracts Amcache registry artifacts                       |
| DOWNLOADSFOLDER               | Inventories contents of the Downloads folder              |
| USBHISTORY                    | Reports USB device connection history                     |
| LNKFILES                      | Extracts shortcut (.lnk) file artifacts                   |
| SYSTEMHIVE                    | Extracts System registry hive                             |
| SOFTWAREHIVE                  | Extracts Software registry hive                           |
| BITLOCKERSTATUS               | Reports BitLocker encryption status                       |
| GROUPPOLICYRESULTS            | Extracts applied Group Policy results                     |
| WINDOWSDEFENDERSTATUS         | Reports Windows Defender and AV status                    |
| WERCRASHDUMPS                 | Extracts Windows Error Reporting (WER) crash dumps        |
| IMAGESVIDEOSINVENTORY         | Inventories image and video files                         |
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




