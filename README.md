# 🚨 Blue Trace – Comprehensive Windows Forensic Artifact Collector 🚨

Blue Trace is a robust, modular, and analyst-driven PowerShell tool designed for digital forensics, incident response, and live evidence acquisition on Windows endpoints. **Whether you’re investigating targeted attacks, insider threats, malware outbreaks, or simply building a comprehensive timeline, Blue Trace puts all the critical artifacts at your fingertips—clean, structured, and export-ready.**

---

## 🧬 What is Blue Trace?

**Blue Trace** is an open-source, extensible DFIR (Digital Forensics and Incident Response) artifact collector and evidence packager. It’s engineered to sweep, extract, and organize *hundreds of key Windows artifacts*—from volatile memory data and user activity logs, to deep registry analysis and browser forensics.

Blue Trace outputs findings directly into a well-organized Excel workbook (and supporting CSVs), making review, triage, and reporting seamless for analysts and investigators.

---

## 🕵️‍♂️ Key Features

- **End-to-End Artifact Coverage:** Gathers user, system, network, persistence, and anti-forensic artifacts in one automated pass.
- **DFIR-Ready Documentation:** Each artifact collection module is annotated for analysts, with explanations, practical usage notes, and investigation tips.
- **Live & Triage-Ready:** Designed for use in both incident response and proactive threat hunting—run on live systems, VMs, or suspicious endpoints.
- **Modular & Extensible:** Add, customize, or disable collection modules as needed for your workflow or case requirements.
- **Clean, Audit-Friendly Output:** All results are exported to a structured, multi-tab Excel workbook, ideal for evidence review, chain of custody, and reporting.

---

## 🎯 What Blue Trace Collects

Blue Trace covers the evidence spectrum, including but not limited to:

- **Registry Hives:** SAM, SYSTEM, SECURITY, SOFTWARE, NTUSER.DAT, USRCLASS.DAT, Amcache, AppCompatCache, and more
- **File System Artifacts:** Prefetch, LNK/shortcut files, Jump Lists, Shellbags, RecentApps, Downloads, and custom locations
- **User & Credential Artifacts:** RunMRU, RecentDocs, UserAssist, Credential Manager, account lockouts, logon/logoff events, RDP sessions
- **Network & Endpoint Activity:** DNS/ARP/Netstat, firewall rules, MAC addresses, network interface configs, SRUM data
- **Web & Browser Evidence:** History, cookies, search terms, cache presence, downloads, SQLite artifact extraction
- **USB & External Device History:** Complete USB device history via registry and event log analysis
- **Volatile & Anti-Forensic Checks:** Clipboard, process lists, BAM/DAM activity, presence of common anti-forensic evidence
- **And much more…**

---

## ⚡️ Why Use Blue Trace?

- **Rapid Response:** Collect all critical artifacts in a single run, dramatically reducing time-to-triage.
- **Battle-Tested:** Built for modern IR—avoids anti-forensic pitfalls, collects volatile and non-volatile data, and exports in formats analysts actually use.
- **Human-Readable + Machine-Processable:** Every output is both ready for human review and suitable for further parsing, timeline building, or SIEM ingestion.
- **Open and Auditable:** PowerShell source included. No obfuscation, no secrets—just practical DFIR engineering.
- **Analyst-Centric Documentation:** Each section explains *what is collected, why it matters, and how to use it in an investigation*.

---

## 📦 Output Example

- **Excel Workbook (`BlueTrace_Report.xlsx`)** – Each worksheet contains one artifact category with field explanations and timestamps.
- **CSV files** (optional) – For automation, SIEM, or bulk ingestion.
