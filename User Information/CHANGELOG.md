<div align="center">

# 📑 CHANGELOG

All notable changes to **Blue Trace** will be documented in this file.

---

[3.2.0.0] – 2025-07-14
✨ Added
Persistent Storage Compatibility for MSIX Packages

Introduced DataStorageHelper.cs for dynamic storage path resolution

Ensures scan history (scan_history.json) and templates (Templates.json) persist in MSIX deployments

Uses %LOCALAPPDATA%\BlueTrace\ as writable storage for MSIX

Read-only resources (scripts, fonts, images) load from install directory

Thread-Safe UI Initialization

Resolved System.InvalidOperationException by using Dispatcher.Invoke() during Dashboard_Loaded

Ensures all UI updates run on the correct thread

Performance Monitoring System

Introduced PerformanceMonitor.cs for real-time tracking of load times, memory usage, and scan duration

Performance metrics now logged and can be retrieved on demand

🛠 Changed
Scan History System Overhaul

Full persistence system with atomic writes, file validation, and corruption recovery

Duplicate entry prevention and cross-session continuity

Clear functionality now resets persistent storage and memory cache with confirmation

Added ScanHistoryUtility.cs for testing, validation, and diagnostics

PowerShell Script Optimizations

Parallel processing for scan sections

Memory-efficient design with WMI/CIM connection pooling and caching

Added result size limits and timeouts to prevent freezing or overload

Batched registry and file operations to reduce scan time

Dashboard and Scan UI Improvements

Converted blocking calls to async operations using Task.Run with ConfigureAwait(false)

Dashboard system info loading now up to 80% faster

Scan progress UI now updates in real-time with section status colors and cancellation support

Code Quality Fixes (Build & IDE)

Removed collection expression syntax ([]) to support broader compatibility

Added platform guards (e.g., OperatingSystem.IsWindows()) for Windows-specific APIs

Fixed XAML and code-behind namespace mismatches

Removed unused fields and added explanatory comments to empty handlers

Project Configuration Cleanup

Removed invalid ComparisonDetails.xaml file causing XAML class conflicts

Renamed BlueTracev2 to BlueTracev2.csproj for proper build tool recognition

Consolidated and validated all XAML code-behind pairings

🐞 Fixed
❌ Resolved build errors related to class duplication, collection syntax, and namespace issues

❌ Fixed UI crashes from cross-thread access violations

❌ Fixed scan history not saving in MSIX-deployed versions

❌ Fixed slow dashboard and scan performance due to sequential execution

📈 Performance Gains (Measured)
Dashboard Load Time: ⬇️ ~70–80%

Scan Section Processing: ⬇️ ~2–4x faster

Memory Usage: ⬇️ ~40–50% peak memory consumption

UI Responsiveness: ✅ Completely smooth, no freezing

Application Startup: ⬇️ ~50–60% faster

---

## [3.1.0.0] – 2025-07-09

### ✨ Added

**Scan Templates Page:**

Lets users define and save custom scan configurations.  
Displays a table with columns: Scan Name, Format, File Path, Total Sections.  
Includes:  
A **Create Scan Template** button that redirects to the Scan Options page.  
A confirmation step that finalizes and saves the template to `Templates.json`.  
Checkboxes to **run** or **delete** templates directly.  
Navigation back to the dashboard.

**Investigation Playbooks Page:**

Provides expert guidance across 24 different forensic/investigative scenarios:  

*Initial Triage (Suspicious Behavior Detected)*  
*USB Data Exfiltration Investigation*  
*Persistence & Privilege Escalation Detection*  
*Suspicious PowerShell or Scripting Use*  
*User Behavior Reconstruction*  
*Account Misuse or Lockout Analysis*  
*Data Protection & Encryption Review*  
*Software Inventory & Licensing*  
*Patch & Update Verification*  
*Suspicious Network Activity*  
*Anti-Forensics & Tampering Check*  
*Sensitive File Access Investigation*  
*Data Exfiltration via Cloud or Browser*  
*Evidence of File Deletion or Wiping*  
*Suspected Malware Execution*  
*Living-off-the-Land Binaries (LOLBins) Use*  
*System Hardening Baseline Check*  
*Unusual Program Installation Audit*  
*Remote Desktop Abuse Detection*  
*Credential Theft or Enumeration Attempt*  
*Insider Threat – Unusual Behavior*  
*Script Kiddie or Tool Use Investigation*  
*User Access Review (Least Privilege)*  
*Audit Trail Verification*

---

## [3.0.0.0] – 2025-07-08

### ✨ Added

**System Artifacts Page** with support for:  
SOFTWARE hive  
SYSTEM hive  
SAM hive  
SECURITY hive  
LNK file artifacts  
PREFETCH file artifacts

**Multi-Artifact Correlation:**  
Preconfigured scan profile: `Artifact Correlation`  
JSON & CSV export formats  
Sections include:  
LOADEDDLLS, POWERSHELLHISTORY, POWERSHELLOPERATIONALLOG, WINDOWSPOWERSHELLLOG,  
PARENTCHILDPROCESSTREE, PROCESSTREEWMI, RUNNINGPROCESSES, SCHEDULEDTASKS, REGISTRYRUNKEYS,  
RECENTAPPS, DESKTOPFILETIMESTAMPS, DOWNLOADSFOLDER, JUMPLISTS, RECENTDOCS,  
RECYCLEBINCONTENTS, SHELLBAGS, USERASSIST, LOGONEVENTS, RDPLOGONEVENTS,  
ACCOUNTLOCKOUTS, NETUSER, NETLOCALGROUP, WHOAMIGROUPS, NETSTATOUTPUT,  
NETWORKINTERFACES, DNSCACHE, IPCONFIGDISPLAYDNS, FIREWALLRULES, STARTUPFOLDERITEMS,  
WMIEVENTCONSUMERS, COMHIJACKINGENTRIES, DLLSEARCHORDERHIJACKS

**7 PowerShell Scripts** for expanded scanning and data gathering

**Preconfigured Artifact Collector Scan** on the Scan Types page  
Includes Correlate Artifacts button for instant documentation

**Persistent Scan History Page**  
Records scan name, date/time, and status across sessions

**Support for .SAVE Hive Exports**  
Exports key registry hives into `BlueTraceReports` for offline analysis  
Auto-organizes into folders named `LNK`, `PREFETCH`, or `.SAVE`

### 🛠 Changed

**User & Policy Guide updated** to reflect latest capabilities and workflows  
**Interface scaled to fit any screen resolution** (including landscape/tablets)

---

## [2.0.0.0] – 2025-07-05

### ✨ Added

**Modern dashboard UI:** Real-time scan progress, compliance indicators, and summary blocks  
**Scan history:** Full session logging with metadata  
**PDF report generation:** Create detailed PDF reports directly from JSON scan files  
**Custom scan profiles:** Users can build, save, and rerun their own scan sets  
**Expanded scan modules:** Support for 60+ forensic, system, and network artifacts (see README for the full list)  
**Automatic `BlueTraceReports` folder:** Preconfigured scans auto-create the correct report directory for PDF generation  
**Privacy & security documentation:** Explicit data privacy statement and full security/disclosure policy included

### 🛠 Changed

**Upgraded to .NET 8.0 and latest PowerShell SDK** for improved stability and compatibility  
**Enhanced error handling:** Improved user notifications for module failures and admin rights issues  
**Export enhancements:** Unified XLSX, TXT, CSV, and JSON export experience  
**UI/UX updates:** Improved accessibility and responsiveness

### 🐞 Fixed

**Bug fixes:** Resolved scan module stability issues, UI glitches, and improper handling of long file paths  
**Special characters:** Improved output handling for file and folder names with special characters

</div>
