# 📑 CHANGELOG

All notable changes to **Blue Trace** will be documented in this file.

---
---

## [3.0.0.0] – 2025-07-08

### ✨ Added

- **System Artifacts Page** with support for:
  - SOFTWARE hive
  - SYSTEM hive
  - SAM hive
  - SECURITY hive
  - LNK file artifacts
  - PREFETCH file artifacts

- **Multi-Artifact Correlation:**
  - Preconfigured scan profile: `Artifact Correlation`
  - JSON & CSV export formats
  - Sections include: LOADEDDLLS, POWERSHELLHISTORY, POWERSHELLOPERATIONALLOG, WINDOWSPOWERSHELLLOG, PARENTCHILDPROCESSTREE, PROCESSTREEWMI, RUNNINGPROCESSES, SCHEDULEDTASKS, REGISTRYRUNKEYS, RECENTAPPS, DESKTOPFILETIMESTAMPS, DOWNLOADSFOLDER, JUMPLISTS, RECENTDOCS, RECYCLEBINCONTENTS, SHELLBAGS, USERASSIST, LOGONEVENTS, RDPLOGONEVENTS, ACCOUNTLOCKOUTS, NETUSER, NETLOCALGROUP, WHOAMIGROUPS, NETSTATOUTPUT, NETWORKINTERFACES, DNSCACHE, IPCONFIGDISPLAYDNS, FIREWALLRULES, STARTUPFOLDERITEMS, WMIEVENTCONSUMERS, COMHIJACKINGENTRIES, DLLSEARCHORDERHIJACKS

- **7 PowerShell Scripts** for expanded scanning and data gathering

- **Preconfigured Artifact Collector Scan** on the Scan Types page
  - Includes Correlate Artifacts button for instant documentation

- **Persistent Scan History Page**
  - Records scan name, date/time, and status across sessions

- **Support for .SAVE Hive Exports**
  - Exports key registry hives into `BlueTraceReports` for offline analysis
  - Auto-organizes into folders named `LNK`, `PREFETCH`, or `.SAVE`

### 🛠 Changed

- **User & Policy Guide updated** to reflect latest capabilities and workflows
- **Interface scaled to fit any screen resolution** (including landscape/tablets)

---
---

## [2.0.0.0] – 2025-07-05

### ✨ Added

- **Modern dashboard UI:** Real-time scan progress, compliance indicators, and summary blocks.
- **Scan history:** Full session logging with metadata.
- **PDF report generation:** Create detailed PDF reports directly from JSON scan files.
- **Custom scan profiles:** Users can build, save, and rerun their own scan sets.
- **Expanded scan modules:** Support for 60+ forensic, system, and network artifacts (see README for the full list).
- **Automatic `BlueTraceReports` folder:** Preconfigured scans auto-create the correct report directory for PDF generation.
- **Privacy & security documentation:** Explicit data privacy statement and full security/disclosure policy included.

### 🛠 Changed

- **Upgraded to .NET 8.0 and latest PowerShell SDK** for improved stability and compatibility.
- **Enhanced error handling:** Improved user notifications for module failures and admin rights issues.
- **Export enhancements:** Unified XLSX, TXT, CSV, and JSON export experience.
- **UI/UX updates:** Improved accessibility and responsiveness.

### 🐞 Fixed

- **Bug fixes:** Resolved scan module stability issues, UI glitches, and improper handling of long file paths.
- **Special characters:** Improved output handling for file and folder names with special characters. 
