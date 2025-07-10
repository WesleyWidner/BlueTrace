<div align="center">

# 🚨 Windows Forensic Artifact Collector 🚨

**Blue Trace** is a modular, analyst-driven Windows artifact collector designed for digital forensics, incident response, system health, and compliance monitoring.  
With one click, Blue Trace extracts a comprehensive set of artifacts and system details, packaging them in structured formats for investigation, triage, and reporting.

---

## ✨ Key Features

**End-to-End Artifact Collection:**  
Gathers user, system, network, security, and forensic artifacts in a single automated pass.

**Custom & Preconfigured Scans:**  
Choose from incident response, networking, system health, compliance, or design your own scan sets.

**Dashboard, History & Templates:**  
Visualize current device health, access past scans across sessions, and manage reusable scan templates.

**Investigation Playbooks:**  
Get expert guidance through 24 built-in investigative scenarios tailored for real-world forensics.

**Multi-Artifact Correlation:**  
Automatically link related behaviors across system and user activity to support root cause analysis.

**Multiple Export Formats:**  
Export scan results as **JSON**, **XLSX**, **TXT**, or **CSV**.  
JSON scans can be converted into full **PDF** reports.

---

## 🖥️ System Dashboard Overview

The dashboard displays real-time and historical insights, including:

**Basic Information:** Device name, MAC address, hostname, user name, etc.  
**Security Status:** UAC, encryption, antivirus status, etc.  
**System Health:** Disk usage, RAM utilization, CPU load, Windows Update status.  
**Recent Scan History:** View prior scans with name, timestamp, and status.  
**Quick Navigation:** Launch new scans, manage templates, or explore history.

---

## 🛠️ Scan Modules

Blue Trace supports a wide array of forensic and diagnostic modules.  
Each scan can be run individually or grouped into scan profiles.  
See the full list in the original post above (unchanged).

---

## 🧩 Scan Templates

Define and save custom scan configurations for future reuse.  
Each template includes: **Scan Name**, **Format**, **File Path**, **Total Sections**.  
Launch or delete templates directly from the interface.  
Templates are stored in `Templates.json` and persist across sessions.  
Easily create templates from the Scan Options page.

---

## 📖 Investigation Playbooks

Access 24 detailed guides that align collected artifacts with investigative objectives.  
Topics include:

Suspicious Behavior Detection  
USB Data Exfiltration  
PowerShell and Scripting Abuse  
Persistence & Privilege Escalation  
File Deletion or Wiping Evidence  
Cloud or Browser-Based Data Exfiltration  
Credential Theft and Enumeration  
Insider Threat & User Behavior  
Anti-Forensics Detection  
Remote Desktop Abuse  
Account Misuse & Lockouts  
Patch & Software Inventory Auditing  
Network Anomaly & LOLBins Usage  
Group Policy and System Hardening Reviews  
Application and Script Misuse  
And many more...

---

## 🧠 Artifact Correlation

Blue Trace can automatically correlate related artifacts across modules to help identify:

Process lineage and parent/child relationships  
PowerShell usage tied to file modifications  
Recently opened or deleted documents  
Scheduled tasks and autoruns linked to user behavior  
Security events matched with process or login activity  
RDP, logon, and network session traces

This is available as a dedicated **Artifact Correlation** scan profile, ideal for deep triage and behavioral analysis.

---

## 📂 Output Formats

**JSON** – Raw structured output, supports full report generation  
**XLSX** – Spreadsheet format for data analysis  
**TXT** – Plain text output  
**CSV** – Flat file format for databases or scripting  
**PDF (via JSON)** – Professionally styled, easy-to-read investigation reports

---

## 📊 Dashboard, History & Templates

**Dashboard:** Live system insights, security posture, scan activity, and quick links  
**Scan History:** Persistent scan records with names, timestamps, and outcome summaries  
**Templates Management:** Central place to store, run, and edit scan templates for routine use

---

## 🧑‍💻 Custom Scans & Profiles

You can:

**Run Any Module Individually**  
**Create Custom Scans** by selecting any combination of modules  
**Use Predefined Profiles** such as:  
Incident Response  
Networking  
System Health  
Compliance  
Artifact Correlation

---

## ❓ FAQ

**Q: What permissions does Blue Trace require?**  
**A:** Local administrator rights for complete artifact access.

**Q: Are results private?**  
**A:** Yes. All scan data is stored and exported **locally only** unless you explicitly choose to share it.

---

## 📢 About

**Blue Trace** is built by analysts, for analysts and system administrators who need **clarity, speed, and reliability** in Windows evidence collection.

For more, visit: [https://whitehatwes.com](https://whitehatwes.com)

---

</div>
