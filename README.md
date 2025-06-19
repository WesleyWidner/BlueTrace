# BlueTrace
DFIR Blue Team Tool

Introduction

The Combined DFIR PowerShell Script is a comprehensive Windows forensic collection tool developed by Wesley Widner (White Hat Wes) for blue teamers, SOC analysts, and digital forensic responders. It automates the acquisition of critical system and user-level artifacts, preparing them for immediate review in Excel and CSV formats. This script is tailored for live triage, incident response, and timeline reconstruction scenarios.

Use Case

You should use this script when:

Performing live incident response on compromised systems.

Gathering artifacts for timeline analysis or initial compromise investigations.

Collecting user activity and system configuration data without relying on third-party agents.

Auditing endpoint hygiene, browser usage, logon history, or USB connections.


Section 0: Output Setup

Purpose
This section initializes the output framework used throughout the DFIR script. It prepares structured logging and reporting by configuring paths and Excel export functionality.

Functionality Overview
Output Path Configuration:
Defines the file paths for the final forensic report in both .xlsx and .csv formats. These are saved to the current user's Desktop for easy access.

Excel COM Automation Initialization:
Launches a hidden instance of Microsoft Excel using COM automation. Adds a new workbook that will be populated with forensic data throughout the script. Ensures Excel is present and fails gracefully with an error if not.

Sheet Cleanup:
Removes the default sheets (Sheet1, Sheet2, Sheet3) that Excel includes by default in new workbooks to maintain a clean and professional report format.

Excel Writing Function (Save-ToExcelSheet):
Dynamically creates and names new Excel sheets based on input. Sanitizes and truncates sheet names to avoid Excel naming issues or special character conflicts. Writes structured data (headers and content) into the sheets row by row. Auto-fits columns for improved readability. Includes error handling to ensure the script continues executing even if Excel writing fails for any section.
Security and Operational Considerations

Microsoft Excel Requirement:
This section depends on the presence of Microsoft Excel and Windows COM automation. It will not function on macOS/Linux or systems without Excel installed.

Permissions:
Does not require administrative privileges but must be run in a context that allows COM object creation and file writing to the user Desktop.

Sanitization and Hardening:
Sheet names are sanitized to prevent invalid character usage. Excel visibility is disabled to prevent pop-ups or UI interruptions during forensic collection. All write actions are wrapped in try/catch blocks to prevent partial failures from halting execution.

Output
DFIR_Report.xlsx: Structured Excel report with a separate sheet for each artifact category. DFIR_Report.csv: Placeholder path for possible flat CSV output if needed elsewhere in the script.




Section 1: System Information

Purpose
This section collects critical identification and timing data from the system where the DFIR script is executed. This foundational metadata is used to establish machine identity, timeline context, and execution authority, supporting accurate correlation with logs, registry hives, and other forensic artifacts.

Functionality Overview
Activity Indicator:
Uses Write-Progress to show the status of system information collection.

Data Collected:
Hostname: The machine name
UserDomain: Indicates whether the account is part of a domain or local machine.
Username: The account name under which the script is running.
SID: Security Identifier associated with the user, useful for linking registry artifacts (e.g., NTUSER.DAT, UserAssist, ShellBags).
IsAdmin: Boolean flag indicating whether the current user has administrative privileges. This is important for verifying the integrity and completeness of collected data.
SystemTimeLocal: Local system time in a human-readable format.
SystemTimeUTC: Coordinated Universal Time to support time zone-independent correlation across multiple systems.
TimeZone: The configured Windows time zone identifier (e.g., Central Standard Time).
BootTime: The system's last boot timestamp, helpful for constructing event timelines and understanding system uptime at the time of collection.

Output
Structured into an Excel worksheet titled "System Information".

Security and Operational Considerations
This section uses built-in PowerShell and .NET features only — no external dependencies or elevated permissions are required beyond read access. The inclusion of both local and UTC timestamps ensures analysts can compare time-based artifacts across systems in different regions. The IsAdmin flag allows downstream logic (or analysts) to validate that full forensic data collection was possible.

Use Case in Incident Response
This metadata forms the header or context page of the forensic workbook. It enables SOC analysts, IR teams, or auditors to: Identify the source system and user context of the investigation. Validate script execution authority. Align timestamps from event logs, file system timestamps, and network flows.




Section 2: Installed Programs

Purpose
This section enumerates all user- and system-level software installed on the machine by inspecting known uninstall registry paths. It supports forensic analysis by capturing the software footprint of the host, identifying potentially unauthorized, outdated, or vulnerable applications.

Functionality Overview
Registry Inspection:
Queries the following locations:
HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* (64-bit apps)
HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* (32-bit apps)
HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* (user-installed apps)

Extracted Fields:
DisplayName: Human-readable name of the application.
DisplayVersion: The version number reported at install time.
Publisher: Software vendor or origin.
InstallDate: Original installation date, formatted to YYYY-MM-DD if valid.

Output:
Compiled into the Excel sheet "Installed Programs", one row per program.
Security and Operational Considerations
No additional installations required – uses built-in PowerShell and registry access.
Robust error handling ensures inaccessible registry keys don't halt execution.
Supports both 32-bit and 64-bit application discovery, which is essential for completeness on modern Windows systems.
Install date normalization improves timeline construction for incident correlation and system baselining.

Use Case in Incident Response
This data can help DFIR analysts: Identify suspicious, outdated, or unauthorized software. Cross-reference versions with known vulnerabilities (e.g., CVEs). Map software installation against user activity, persistence mechanisms, or lateral movement tactics.














Section 3: Environment Variables

Purpose
This section collects all environment variables from both the current user and the system scope. These values are essential for understanding execution context, script behavior, system configuration, and potentially identifying anomalous paths or malicious modifications.

Functionality Overview
Environment Variable Sources:
User: Variables specific to the currently logged-in user (e.g., TEMP, OneDrive, Path).
System: Global machine-level variables (e.g., ComSpec, SystemRoot, ProgramData).

Data Collected:
Scope: Indicates whether the variable belongs to the user or system context.
Name: The environment variable name (e.g., TEMP, PATH).
Value: The assigned value or file path.

Output:
Data is stored in an Excel sheet named "Environment Variables".
A CSV version of this data is also written to the predefined output path for flat analysis or ingestion into automated tools.




Security and Operational Considerations

No additional tools or elevated privileges are required.
Environment variables can reveal:
Script or executable hijacking via PATH manipulation.
Presence of cloud sync clients (e.g., OneDrive).
Indicators of compromise (e.g., malicious binaries in TEMP or shadow variables).
Variables are gathered using .NET’s built-in environment management, ensuring cross-version compatibility and system stability.

Use Case in Incident Response
IR analysts can use this section to:
Determine if malicious programs are injected via environment variable paths.
Identify discrepancies in user/system environments across compromised hosts.
Confirm system startup configurations and command execution contexts.









Section 4: UAC Settings
Purpose
This section retrieves and interprets User Account Control (UAC) settings from the system registry. UAC configurations are critical in determining how elevation requests are handled for administrators and standard users, which directly impacts security posture and privilege escalation resistance.

Functionality Overview
Registry Inspection:
Reads from:
HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System

Extracted and Translated Fields:
ConsentPromptBehaviorAdmin: Defines how administrator accounts are prompted for elevation.
ConsentPromptBehaviorUser: Defines how standard user accounts are prompted.
EnableLUA: Indicates if UAC is enabled at all.
PromptOnSecureDesktop: Determines whether elevation prompts occur on a secure desktop (which helps prevent spoofing).
EnableVirtualization: Enables legacy app virtualization for non-admin processes (mitigating legacy compatibility issues).
ValidateAdminCodeSignatures: Specifies whether code signatures are required for admin-elevated operations.
FilterAdministratorToken: Controls whether full administrator tokens are filtered into limited "split tokens" for user processes (core UAC behavior).

Output:
Compiled into the Excel worksheet "UAC Settings", where each setting is human-readable for analysts and auditors.
Security and Operational Considerations
No additional permissions or modules required.
UAC settings directly affect:
Elevation control
Local privilege escalation risk
Process isolation and integrity levels
The script translates binary registry values into readable explanations, improving clarity for security analysts.

Use Case in Incident Response
This data helps DFIR analysts:
Assess system hardening level against privilege escalation techniques.
Determine if UAC was weakened or disabled by malware.
Compare UAC posture across fleet baselines to detect anomalies.
Validate secure desktop use to prevent elevation spoofing attacks.











Section 5: Windows Version Info

Purpose
This section captures core operating system version information using CIM (Common Information Model). These details help analysts verify system patch levels, architecture compatibility, and establish system baselines for comparison or anomaly detection.

Functionality Overview
WMI/CIM Query:
Uses the Win32_OperatingSystem class via Get-CimInstance to retrieve Windows version data.

Extracted Fields:
Caption: Friendly OS name (e.g., “Microsoft Windows 11 Pro”).
Version: Full version number (e.g., 10.0.26100).
BuildNumber: Windows build identifier (e.g., 26100).
Architecture: 32-bit or 64-bit OS platform.
InstallDate: Date the OS was installed, converted from WMI format. May be "Unavailable" if corrupted or null.
LastBootUpTime: Last time the system was booted. Also normalized from WMI DMTF format.

Output:
This data is written to the "Windows Version" sheet in Excel, providing a one-row summary of the OS-level attributes.



Security and Operational Considerations
No elevated permissions are required to access this information.
DMTF datetime values used by WMI can sometimes be null or malformed; this is handled gracefully with "Unavailable" or "Invalid Format" markers.
CIM queries are preferred over WMI for modern Windows environments due to better performance and compatibility.


Use Case in Incident Response
This information allows DFIR analysts to:
Verify if a system is up to date or potentially running a vulnerable build.
Identify environment type (e.g., endpoint, server, VM) by OS and architecture.
Cross-reference boot time with other artifacts to build a complete event timeline.
Detect potential tampering or rollback scenarios (e.g., repeated boot loops, spoofed install dates).










Section 6: Desktop File Timestamps (Non-Recursive)

Purpose
This section scans the current user’s desktop and collects metadata for all top-level files. The intent is to capture file names, their absolute paths, and last modified timestamps for forensic review, change tracking, or artifact correlation.

Functionality Overview
Target Directory:
Pulls the desktop path from [Environment]::GetFolderPath("Desktop").

Collection Method:
Uses Get-ChildItem to list all non-recursive files (ignores subdirectories).
For each file, extracts:
Name: File name only (e.g., Combined.ps1)
FullPath: Absolute path to the file
LastModified: Last write timestamp (LastWriteTime)

Output:
Saved into the "Desktop File Timestamps" worksheet in Excel. Each row corresponds to a single file on the user’s desktop.




Security and Operational Considerations
No elevated privileges required.
Uses safe enumeration with -ErrorAction SilentlyContinue to avoid script failure due to permissions or file locks.
Capturing only non-recursive files reduces noise and focuses attention on intentional or user-facing content.
Last modified timestamps may indicate:
When suspicious scripts were altered or created
Activity timelines aligned with attack behavior or user sessions
Evidence of tampering or post-intrusion cleanup attempts

Use Case in Incident Response
This output helps DFIR analysts:
Quickly identify potentially malicious files dropped on the desktop.
Spot suspicious .ps1, .bat, .lnk, or .jpg files used in attacks (e.g., shortcut-based malware).
Compare file modification times with event logs or registry artifacts.
Detect data staging behavior or exfiltration prep.








Section 7: File Metadata
Purpose
This section recursively collects timestamp metadata for all files located under the current user’s profile directory. It captures creation, last modification, and last access times to support forensic timeline analysis, tamper detection, and identification of suspicious or recently modified artifacts.

Functionality Overview
Target Scope:
Scans the entire user profile (C:\Users\<username>)
Includes hidden and system files (-Force)
Processes all nested directories recursively

Collected Fields:
Name: File name only (e.g., NTUSER.DAT)
FullPath: Full absolute path to the file
CreationTime: Time the file was created on the filesystem (can differ from original creation)
LastModified: Time the file contents were last changed
LastAccessed: Time the file was last opened or read

Output:
Results are saved into the Excel worksheet "File Timestamps"
Timestamps are normalized to the YYYY-MM-DD HH:MM:SS format for consistency and analysis readiness
Write-Progress is displayed to track scan completion across large datasets

Security and Operational Considerations
Does not require elevated permissions; scans only within the current user context
Includes error handling to safely bypass inaccessible files or directories
Handles large file sets without crashing by writing results incrementally to memory
Timestamp artifacts may be manipulated by adversaries (e.g., timestomping) or system operations (e.g., AV scanning or file copying)

Use Case in Incident Response
DFIR analysts can use this section to:
Identify unauthorized or suspicious files based on recent creation or modification
Reconstruct a timeline of attacker behavior during initial access, persistence, or staging
Correlate file activity with registry entries, logon sessions, and other system events
Detect cleanup attempts or signs of antiforensic activity (e.g., anomalously old timestamps or mass file changes)









Section 8: Hidden Files on C:\
Purpose
This section identifies and documents all files marked with the Hidden attribute on the root system drive (C:\). Hidden files can include legitimate system components or intentionally concealed malicious artifacts.

Functionality Overview
Target Scope:
Searches the entire C:\ volume recursively for files.
Includes protected and hidden system files using the -Force flag.
Filters only those with the Hidden file attribute.

Collected Fields:
Name: The file name (e.g., pagefile.sys, desktop.ini)
Path: Full path to the file
Size: File size in bytes
Modified: Last write timestamp, formatted as YYYY-MM-DD HH:MM:SS

Output:
Data is written to the "Hidden Files" sheet in Excel.
One row per hidden file discovered under the C:\ directory.





Security and Operational Considerations
Accessing C:\ requires sufficient read permissions; some folders may be inaccessible to non-admin users.
Hidden files may include:
System files (e.g., hiberfil.sys, swapfile.sys)
User artifacts (e.g., desktop.ini, .log.tmp)
Malware or persistence mechanisms (e.g., hidden scripts, renamed executables)
Bitwise comparison ensures only files explicitly flagged as Hidden are included, avoiding misclassification.

Use Case in Incident Response
This section supports DFIR efforts by:
Revealing concealed persistence mechanisms
Identifying suspicious files dropped by threat actors (e.g., renamed tools or payloads)
Allowing comparison across baseline systems to detect anomalies
Supporting timeline correlation using the Modified timestamp










Section 9: Alternate Data Streams (ADS)
Purpose
This section detects alternate data streams (ADS) attached to files within the current user's Desktop directory. ADS can be used by attackers to conceal scripts, payloads, or metadata that are not visible in standard file listings, making them a critical component of forensic visibility.

Functionality Overview
Target Scope:
Recursively scans the current user's Desktop directory
Uses -Stream * to enumerate all named streams attached to files

Collected Fields:
File: Full path of the host file containing the stream
Stream: Name of the alternate data stream (e.g., Zone.Identifier, custom names)
Length: Size of the stream content in bytes

Output:
Results are written to the Excel sheet "ADS"
One row per detected alternate data stream






Security and Operational Considerations
No elevated permissions required, but hidden or system-level ADS may be inaccessible without admin rights
Alternate data streams may be used by:
Malware for hidden execution or payload storage
Web downloads (e.g., Zone.Identifier) to tag file origin
Internal scripts/tools to hide configuration or activity data
Stream visibility depends on NTFS file system support (ADS is not supported on FAT32)

Use Case in Incident Response
This section enables DFIR analysts to:
Detect hidden content embedded within otherwise benign files
Uncover persistence or staging techniques using non-primary file streams
Identify scripts or commands smuggled alongside documents or executables
Examine web-downloaded files for zone-based execution policy indicators (Zone.Identifier)









Section 10: Files Accessed in Last 30 Days
Purpose
This section identifies all files on the C:\ drive that have been accessed within the past 30 days. It helps highlight recent user or system activity, detect staging areas, and correlate execution timelines in incident response investigations.

Functionality Overview
Target Scope:
Scans the full C:\ volume, recursively
Includes hidden and system files via -Force
Filters results by access timestamp (LastAccessTime)

Collected Fields:
FullName: Full path of each accessed file
LastAccessTime: Timestamp of the most recent access, formatted for consistency

Output:
Excel sheet titled "Accessed <30 Days"
Sorted by LastAccessTime descending to prioritize the most recent activity






Security and Operational Considerations
No elevated permissions are required, but some directories (e.g., System32) may produce access errors if permissions are restricted
LastAccessTime tracking must be enabled on the volume; by default, it may be disabled in Windows for performance
You can verify or enable it using:
fsutil behavior query DisableLastAccess
fsutil behavior set DisableLastAccess 0
The accuracy of LastAccessTime can be influenced by:
Antivirus or backup processes
NTFS timestamp suppression
Manual or malicious tampering

Use Case in Incident Response
This section enables analysts to:
Spot files accessed by malware or during unauthorized user sessions
Detect staging or execution of local payloads
Identify forensic evidence relevant to a specific time window
Correlate user behavior with logon events and registry access







Section 11: Recycle Bin Contents
Purpose
This section captures metadata about deleted files residing in the Windows Recycle Bin. It helps reconstruct user activity, recover deleted evidence, and identify suspicious deletion patterns that may indicate tampering or data staging.

Functionality Overview
Access Method:
Uses the Windows Shell COM object to access special folder namespace 0xA, which maps to the Recycle Bin

Collected Fields:
Original Path: The full original file location before deletion
Deleted Date: The timestamp when the file was deleted
Size (bytes): Size of the deleted file in bytes
Name: File name

Output:
Results are exported to the Excel sheet "Recycle Bin"
Includes dynamic progress feedback for large data sets

Security and Operational Considerations
Uses Windows COM objects, which require Windows OS and may fail in locked-down environments or remote PowerShell sessions
Does not require elevated permissions but may yield limited results depending on user context
Recycle Bin contents can persist across sessions unless emptied or purged by the system
Use Case in Incident Response
This section enables forensic analysts to:
Recover deleted evidence related to malware staging, script testing, or user activity
Correlate deletion times with suspicious login sessions or privilege escalation
Determine if sensitive files were moved to the Recycle Bin during or after an intrusion
Identify behavioral patterns (e.g., repeated deletion of same-named scripts or working directory artifacts)


















Section 12: Temp Folder Contents
Purpose
This section collects metadata for all files in the current user's temporary directory (%TEMP%). The Windows Temp folder is a common location for malware, exploits, payload staging, and logs. Reviewing its contents can provide insight into transient activity or evidence of compromise.

Functionality Overview
Target Scope:
Scans the user's %TEMP% path (typically C:\Users\<user>\AppData\Local\Temp)
Includes hidden files via -Force
Recurses through all nested subdirectories

Collected Fields:
FullName: Absolute path of each file
Length: File size in bytes
LastWriteTime: Timestamp of the last modification, formatted for consistency

Output:
Data is exported to the Excel sheet "Temp Folder"
Results are sorted by most recently modified to prioritize active files




Security and Operational Considerations
No elevated permissions are required, but scanning may hit locked files
TEMP folders often include:
Auto-generated update/install logs
Downloaded scripts or DLLs used during attacks
Crash dumps or tool output (including from malicious binaries)
This area is volatile: content can change rapidly and is often cleared on reboot or by maintenance tools

Use Case in Incident Response
Analysts can use this section to:
Detect suspicious artifacts such as staged PowerShell scripts or payload droppers
Identify which executables or script-based tools were recently unpacked or written to disk
Correlate Temp file timestamps with known malicious activity or logon sessions
Identify tampering, failed exploits, or temporary use of native tools by threat actors








Section 13: Volume Shadow Copies
Purpose
This section queries the system for registered Volume Shadow Copies (VSS), which are used to store previous versions of files, create restore points, and support backup operations. In digital forensics, these snapshots can preserve deleted or altered evidence.

Functionality Overview
Query Method:
Uses WMI/CIM to pull data from the Win32_ShadowCopy class in the root\cimv2 namespace

Collected Fields:
ID: Shadow copy unique identifier (GUID)
VolumeName: Volume path associated with the shadow copy
InstallDate: Timestamp of when the shadow copy was created (converted from DMTF format)

Output:
Data is exported to the Excel sheet "Volume Shadow Copies"
If no shadow copies exist or permission is denied, no sheet is generated and a warning is shown






Security and Operational Considerations
Requires administrative privileges to retrieve shadow copy metadata
If run under a standard user account or with limited WMI access, the query may return nothing
Shadow copies may be missing entirely due to:
System protection being disabled
Third-party cleanup tools or group policy settings
Disk space limitations or manual deletion

Use Case in Incident Response
This section supports DFIR analysts by:
Confirming whether historical artifacts may still exist in VSS
Identifying potential evidence preservation paths
Guiding decisions for VSS mounting and targeted retrieval
Highlighting suspicious deletions of restore points or backups during attack timelines











Section 14: Symbolic Links and Junctions
Purpose
This section identifies all symbolic links, junction points, and reparse points on the system volume (C:\). These constructs can be used for legitimate file system redirection—or malicious persistence, obfuscation, or evasion.

Functionality Overview
Target Scope:
Scans C:\ recursively for files/folders marked with the ReparsePoint attribute
Includes hidden and system items
Collected Fields:
FullName: Absolute path of the symbolic link or junction
Attributes: Raw file system attributes (e.g., ReparsePoint, Directory)
LinkType: Type of redirection (e.g., SymbolicLink, Junction, MountPoint)

Output:
Written to Excel sheet "Symbolic Links"
One row per symbolic link or junction discovered






Security and Operational Considerations
No elevated permissions are required, but access to protected directories may be limited
Reparse points can be abused by attackers to:
Redirect system processes (DLL hijacking)
Evade detection by AV and EDR tools
Maintain persistence by masking payload locations
Some symbolic links are benign system artifacts (e.g., C:\Documents and Settings → C:\Users)

Use Case in Incident Response
This section allows analysts to:
Detect suspicious reparse points pointing to hidden or nonstandard directories
Correlate link creation with malicious activity
Identify potential redirection paths used in malware staging or evasion
Validate system integrity and redirection structure (e.g., ProgramData, Temp)










Section 15: Running Processes
Purpose
This section enumerates all active processes on the system at the time of script execution. It captures process identifiers, names, paths, and start times, which are critical for detecting unauthorized software, understanding system behavior, and building forensic timelines.

Functionality Overview
Source:
Uses PowerShell’s Get-Process cmdlet to gather process metadata
Queries accessible properties for each process, including path and start time

Collected Fields:
Name: Name of the process executable (e.g., svchost, powershell)
Id: Unique process identifier (PID)
Path: Full executable path (may return ACCESS_DENIED for protected processes)
StartTime: When the process began execution (also may be inaccessible)

Output:
Data is sorted by StartTime and exported to the Excel sheet "Running Processes"





Security and Operational Considerations
Does not require admin rights, but some fields like Path and StartTime may be inaccessible for system or protected processes (especially those owned by SYSTEM or kernel mode)
Process list is a snapshot in time—malicious processes may terminate before collection
High-privilege enumeration tools (e.g., Sysinternals Process Explorer, EDR telemetry) may offer more complete data

Use Case in Incident Response
This section allows analysts to:
Identify unrecognized or suspicious processes running in user or system space
Correlate process start times with user activity, login sessions, or attacks
Investigate processes running from nonstandard paths (e.g., %TEMP%, %APPDATA%)
Detect injected or renamed binaries (e.g., malware using svchost.exe)











Section 16: Loaded DLLs
Purpose
This section provides a comprehensive audit of all DLLs loaded by active processes, integrating forensic-grade indicators such as digital signatures, hashes, company metadata, and anomaly flags to detect DLL injection, sideloading, or unauthorized code execution.

Collected Fields
ProcessName – Host process name
PID – Process ID
ModuleName – Name of the DLL
FilePath – Full file path of the DLL
SHA256 – Hash of the DLL (used for threat intelligence matching or malware scanning)
Signature – Digital signature status (e.g., Valid, NotSigned)
CompanyName – Publisher metadata if present
SuspiciousPath – Boolean flag if DLL was loaded from Temp, AppData, Downloads, or similar non-standard locations

Output
Written to Excel sheet: "Loaded DLLs"
If Excel export fails due to COM/memory errors, it falls back to:
~/Desktop/Loaded_DLLs_Fallback.csv





Security & IR Use Cases
Identifies unsigned or forged DLLs used for sideloading/persistence
Enables rapid triage of unfamiliar modules with unknown hashes
Flags DLLs loaded from high-risk directories commonly used by malware
Provides metadata for pivoting in threat intelligence tools (VT, InQuest, AnyRun)




















Section 17: Open Network Connections
Purpose
This section gathers all current TCP network connections and maps them to their owning processes. It provides deep visibility into local services, remote endpoints, and potential backdoors or command-and-control activity.

Functionality Overview
Source:
Get-NetTCPConnection: Queries all active TCP sessions (includes LISTENING, ESTABLISHED, etc.)
Get-Process: Used to resolve process names by PID

Collected Fields:
ProcessName: The name of the process that owns the socket
PID: Process ID (OwningProcess)
LocalAddress / LocalPort: The IP address and port bound on the local host
RemoteAddress / RemotePort: The IP address and port of the remote endpoint
State: TCP state (e.g., Listen, Established, TimeWait, Closed)
IsListening: Boolean indicating if the socket is listening
IsExternal: Boolean flag to indicate connections with non-local (external) addresses

Output:
Results saved to "Net Connections" in Excel
Prioritized by listening and external connections for quick triage

Security and Operational Considerations
No admin rights required, but may be incomplete if restricted by policy
System processes may not resolve correctly ([Unavailable]), especially for PID 4 or kernel services
DNS is not resolved by default—remote IPs are retained for attribution and threat intelligence matching

Use Case in Incident Response
This section enables analysts to:
Detect unauthorized listeners or reverse shells (e.g., suspicious services bound to 0.0.0.0)
Identify connections to suspicious or foreign IPs
Correlate network activity with running processes
Isolate lateral movement or data exfiltration attempts














Section 18: PowerShell Command History with Timestamps
Purpose
This section collects and parses historical PowerShell command execution data from both PSReadLine’s history file and transcript logs. It enables analysts to reconstruct console-based user activity, identify attacker behavior, and correlate command-line events with other system artifacts using timestamps.

Functionality Overview
Data Sources:
Transcript Logs (PowerShell_transcript*.txt)
Location: %USERPROFILE%\Documents and %TEMP%
Format: Includes timestamps, user context, and commands

PSReadLine History (ConsoleHost_history.txt)
Location: %APPDATA%\Microsoft\Windows\PowerShell\PSReadline\
Format: Raw commands, no timestamps (used only as fallback)

Collected Fields:
LineNumber: Sequential index of the command
Timestamp:
Exact date/time if from transcript logs
[No Timestamp - From ConsoleHost_history.txt] if fallback
Command: The raw PowerShell command (e.g., ipconfig /all, Expand-Archive, netstat)


Output:
Excel worksheet named “PS History”
Entries sorted chronologically if timestamped
Clearly labeled source (transcript vs raw history)

Security and Operational Considerations:
Transcript logging must be manually enabled via Start-Transcript or GPO configuration to capture timestamps
History only exists for interactive sessions using PSReadLine (default in modern PowerShell)
Does not capture elevated (RunAs) or hidden session activity unless those sessions also had transcript enabled
Fallback logic ensures at least raw command visibility even if transcript is unavailable

DFIR Use Cases:
This section enables forensic analysts to:
Establish a timeline of command-line activity before/during/after compromise
Detect use of post-exploitation frameworks (PowerView, Invoke-Mimikatz, Empire, etc.)
Identify attempts to stage tools or exfiltrate data (e.g., Compress-Archive, certutil, curl, wget)
Correlate user behavior with logon sessions, registry changes, and file access





Section 19: Parent/Child Process Tree
Purpose
This section enumerates active processes and their parent-child relationships, providing visibility into how each process was spawned. This is critical in DFIR for identifying anomalous process chains, unauthorized execution paths, and lateral movement techniques.

Functionality Overview
Source:
Uses Get-CimInstance -ClassName Win32_Process to collect process hierarchy and metadata

Collected Fields:
ProcessName: Executable name of the process (e.g., cmd.exe, svchost.exe)
ProcessId: The unique PID of the process
ParentProcessId: The PID of the parent process
ExecutablePath: Full path to the binary on disk
CommandLine: Full execution command (including arguments)
CreationDate: Timestamp of when the process was created (converted to local time)

Output:
Excel sheet titled “Proc Tree”
Sorted by CreationDate for temporal clarity



Security and Operational Considerations
No admin rights required, though some fields like ExecutablePath or CommandLine may be inaccessible for protected processes
CreationDate is parsed from WMI’s DMTF format and may not always be present
CommandLine arguments are essential for spotting malicious behavior in otherwise legitimate binaries (e.g., powershell -enc, rundll32 payload.dll)

Use Case in Incident Response
DFIR analysts can use this data to:
Detect process injection, sideloading, or abnormal parent-child chains
Identify suspicious children spawned from explorer.exe, svchost.exe, or lsass.exe
Spot living-off-the-land binaries (LOLBins) like mshta.exe, rundll32.exe, regsvr32.exe in unexpected chains
Correlate process creation with user activity and timestamps from file and registry forensics











Section 20: WMI Activity Logs
Purpose
This section collects recent Windows Management Instrumentation (WMI) operational event logs, which provide insight into system and user activity involving WMI-based queries, scripting, or persistence. These logs are vital in detecting lateral movement, remote execution, and attacker reconnaissance via WMI.

Functionality Overview
Event Log Source:
Log Name: Microsoft-Windows-WMI-Activity/Operational
Extracts the 100 most recent entries

Collected Fields:
TimeCreated – Event timestamp
EventID – Numeric event code (e.g., 5857, 5858)
EventType – Human-readable description of the event
ProcessID – PID of the process that triggered the event
User – Security principal who initiated the query
Operation – Method or action invoked
Namespace – WMI namespace targeted
Query – The WMI query string used
Details – If full data is unavailable, flags as “EventData missing or incomplete”

Output:
Exported to Excel sheet "WMI Logs"
Timestamped and categorized by query phase (e.g., started, completed, error)
Security and Operational Considerations
Requires elevation to access this event log reliably
WMI logs may be disabled by default on some systems
Events 5857–5858 show valid queries; 5859 indicates execution error; 5861–5862 indicate scripted WMI persistence (e.g., Event Consumers)

Use Case in Incident Response
This section helps DFIR analysts:
Detect attacker use of wmic, PowerShell, or scripts to query system info
Identify suspicious or high-frequency WMI activity
Correlate WMI queries with command-line logs, parent-child process trees, or lateral movement attempts
Uncover WMI-based persistence (e.g., malicious __EventConsumer objects)













Section 21: Scheduled Tasks
Purpose
This section analyzes all registered scheduled tasks for signs of persistence, abuse, automation, or suspicious behavior. By including file hashes and flagging unusual task metadata, it helps analysts quickly isolate threats and maintain situational awareness during incident response.

Functionality Overview
Data Collected From:
Get-ScheduledTask – gathers metadata for each registered task
Get-ScheduledTaskInfo – runtime info (next run, last run, exit status)
Get-FileHash – SHA256 hashing of task execution path
Settings.Hidden, Triggers, and Principal are used to surface stealth or risk

Collected Fields
Field	Description
TaskName	Friendly name of the scheduled task
TaskPath	Registration path in Task Scheduler registry
State	Current task state: Ready, Running, Disabled
LastRunTime	When the task last executed
NextRunTime	When the task is next scheduled to execute
LastResult	Exit code from the last task run (0 = success)
Hidden	Indicates if the task is hidden from Task Scheduler UI
Principal	User or security group that owns the task
Action	The command, binary, or script launched by the task
Trigger	When the task is scheduled to run
SHA256	Cryptographic hash of the main executable or script
SuspiciousPath	True if action path includes AppData, Temp, Downloads, or user folders
SuspiciousTrigger	True if task is triggered during off-hours (e.g., 01:00–04:59)

Output
Excel export as “Scheduled Tasks” tab
Easily sortable and filterable for:
Hidden tasks
Unknown or unsigned binaries
High-risk user context or execution times

Use Case in Incident Response
Use this data to:
Identify task-based malware persistence or beaconing (e.g., C2 callback every 5 min)
Spot task hijacking (malware replacing a legit task action)
Detect suspicious task execution paths and off-hour triggers
Generate hashes for threat intelligence pivoting (VirusTotal, MISP, etc.)


Section 22: Startup Folder
Purpose
This section identifies programs or scripts set to auto-run at user login via Windows Startup folders. It is essential in DFIR investigations for detecting persistence mechanisms, staged payloads, or unauthorized executables configured to launch silently.

Functionality Overview
Sources Scanned:
Current user Startup folder:
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
Common (all users) Startup folder:
%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup
All C:\Users\<username> profiles for roaming startup items

Collected Fields:
User: Username or “AllUsers” for global tasks
ItemName: Name of the shortcut, script, or file
FullPath: Absolute location of the startup item
LastModified: Timestamp of last modification (for persistence timing)
SHA256: File hash for IOC tracking and threat intelligence matching
Suspicious: Boolean flag if:
File is a script (.ps1, .bat, .vbs, .js)
File resides in AppData, Temp, or Roaming
File is a shortcut (.lnk) pointing to unusual locations

Output:
Excel sheet: “Startup Folder”
Clearly flagged suspicious entries
Sortable by user, path, and hash

Security and Operational Considerations
Low-friction persistence technique: attacker places payload in a startup directory
File may be renamed to blend in (e.g., OneDriveService.vbs)
Adversaries may use .lnk to obscure payload execution paths

Use Case in Incident Response
DFIR teams use this data to:
Identify unauthorized persistence or RAT payloads
Compare hashes against threat feeds (e.g., VirusTotal, MISP)
Establish modification timeline (first execution time = login event)
Flag user-level persistence that survives reboots and bypasses AV









Section 23: Registry Run Keys
Purpose
This section identifies persistence via registry-based auto-start mechanisms. The Windows “Run” and “RunOnce” keys are commonly abused by malware to gain execution at logon without triggering typical AV detection mechanisms.

Functionality Overview
Registry Paths Scanned:
HKCU:\Software\Microsoft\Windows\CurrentVersion\Run
HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce
HKLM:\Software\Microsoft\Windows\CurrentVersion\Run
HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce

Collected Fields:
Field	Description
RegistryPath	Path in the registry where the key is stored
Name	Value name under the Run/RunOnce key
Value	Full command line launched
Executable	Extracted executable or DLL path from the value
SHA256	Hash of the extracted executable
Suspicious	Flags paths in AppData, Temp, or script-based launch methods

Output
Exported to Excel as “Registry Run Keys”
Enables sorting by SHA256 hash, suspiciousness, or location
Security and Operational Considerations
HKCU keys persist only for the specific user, while HKLM affects all users
rundll32.exe and powershell.exe launches are often indicative of evasive payloads
Persistence may be obfuscated through encoded commands, path redirection, or use of DLL side-loading

Use Case in Incident Response
DFIR analysts can:
Detect persistence entries used by malware or unauthorized tools
Correlate executable hashes with known IOCs or VT submissions
Track initial execution times based on last modified registry key or user logon















Section 24: Services (with Signature Verification)
Purpose
This section enumerates all services registered in the system and evaluates each for suspicious attributes, including unsigned binaries, untrusted paths, and abnormal launch behavior. Services are commonly exploited by attackers to persist, escalate privileges, or blend into legitimate activity.

Functionality Overview
Collected from:
Win32_Service (via Get-CimInstance)
Get-FileHash (SHA256 hashing)
Get-AuthenticodeSignature (for digital signature validation)

Collected Fields
Field	Description
Name	Internal name of the service
DisplayName	Friendly label displayed in GUI tools
State	Current status (e.g., Running, Stopped)
StartMode	Launch mode (Auto, Manual, Disabled)
PathName	Full service launch command or binary path
Executable	Parsed .exe or DLL path from PathName
SHA256	File hash of the service binary (if accessible)
IsSigned	Boolean indicating whether binary has a valid Authenticode signature
SignatureStatus	Signature validity (e.g., Valid, UnknownError, NotSigned, HashMismatch)
Publisher	Common Name (CN) of the signer certificate, if signed
Suspicious	True if the binary is unsigned, in a userland path, or script-based
Description	Text description provided by the software/vendor

Output
Saved to Excel sheet “Services”
Sorted and filterable by State, IsSigned, SHA256, and Suspicious
Flagged entries allow rapid triage by DFIR teams

Security and Operational Considerations
Suspicion Criteria	Reason
Unsigned Executables	Higher likelihood of being untrusted or malware
Launch from AppData, Temp, Roaming, Downloads	Common attacker persistence paths
Use of scripts or rundll32	Obfuscation tactics often used to mask payload execution
No Signature or Invalid Signature	Indicates tampered, custom, or non-vetted software




Use Case in Incident Response
This section enables:
Identification of unauthorized service implants
Attribution of binaries to known or unknown publishers
SHA256 hash pivoting into threat intelligence platforms (e.g., VirusTotal, Hybrid Analysis)
Correlation with autoruns, scheduled tasks, and network activity





















Section 25: WMI Event Consumers
Purpose
This section detects WMI-based persistence, a stealthy technique often used by malware and red teamers to execute payloads based on system or user activity (e.g., logon, time triggers). WMI consumers are rarely modified in legitimate environments, making them excellent indicators of compromise.

Functionality Overview
WMI Namespace Queried:
root\subscription

Classes Inspected:
__EventConsumer (base class for all consumer types, including CommandLineEventConsumer, ActiveScriptEventConsumer, LogFileEventConsumer)

Collected Fields:
Field	Description
Name	Registered name of the WMI consumer
ConsumerType	Type of consumer (e.g., CommandLineEventConsumer, ActiveScriptEventConsumer)
CommandLine	Payload execution command (PowerShell, cmd, script, etc.)
Executable	Parsed executable from command line (if applicable)
Suspicious	True if command path includes scripts, AppData, Temp, or encoded content


Output
Excel worksheet: “WMI Consumers”
Entries are flagged if execution paths indicate malicious or stealthy persistence behavior

Security and Operational Considerations
WMI consumers can:
Persist across reboots without files on disk
Execute payloads without creating scheduled tasks or registry entries
Be invisible to basic tools like Task Manager or Autoruns
Use cases include:
CommandLineEventConsumer launching PowerShell
ActiveScriptEventConsumer executing VBScript from memory
Use of FilterToConsumerBinding (not shown here) to map events to consumers

Use Case in Incident Response
DFIR analysts can:
Detect WMI-based malware or fileless persistence
Correlate command lines with known attacker behavior
Pivot on command patterns (e.g., base64 PowerShell, rundll32 abuse)
Map WMI consumers to event filters (additional step if needed)





Section 26: COM Hijacking
Purpose
This section scans the Windows Registry for COM CLSID entries that point to DLLs—potentially abused to hijack legitimate COM object behavior for persistence, privilege escalation, or stealth execution. COM hijacking is commonly used by malware to maintain presence without triggering traditional autorun alerts.

Functionality Overview
Registry Paths Scanned:
HKCU:\Software\Classes\CLSID
HKLM:\Software\Classes\CLSID

DLL Inspection:
Checks the InprocServer32 default value to extract the referenced DLL path.
Computes SHA256 hash and evaluates the digital signature of each referenced DLL.

Collected Fields
Field	Description
CLSIDPath	Full registry path for the CLSID registration
DLLPath	Path to the DLL registered to execute with that CLSID
SHA256	File hash of the registered DLL
IsSigned	Boolean indicating whether the DLL has a valid digital signature
SignatureStatus	Status of signature (e.g., Valid, NotSigned, UnknownError)
Publisher	Publisher information from the signer certificate (if signed)
Suspicious	True if DLL is unsigned or lives in suspicious paths like AppData, etc.

Output
Sheet Name: "COM Hijacking"
Filterable by unsigned status, path location, or hash

Security & DFIR Considerations
Indicator	Risk
DLL in userland path	Likely attacker-written binary
Unsigned DLL	Not verified, high chance of malware
COM hijacks in HKCU	User-level persistence not requiring admin
Rundll32 or scripting abuse	Obfuscation of malicious payloads

Use Case in Incident Response
Detect COM hijack persistence not flagged by standard autorun tools
Correlate DLL paths to loaded modules, autoruns, or scheduled tasks
Use SHA256 to pivot into threat intel feeds
Use signature info to filter out known-good signed binaries


Section 27: DLL Search Order Hijacking
Purpose
This section inspects common directories in the DLL search path to identify suspicious DLLs that may be used in DLL sideloading or search order hijacking attacks. This is a tactic often leveraged by malware to gain execution under the context of trusted processes.

Functionality Overview
Directories Scanned:
%SystemRoot%
%SystemRoot%\System32
%TEMP%
%APPDATA%
%USERPROFILE%\AppData\Local
%ProgramData%

Checks Performed:
Hashing via SHA256
Digital signature validation via Get-AuthenticodeSignature
Suspicious flagging based on path or unsigned status

Collected Fields
Field	Description
DLLName	Name of the DLL file
Path	Full path to the DLL
LastWritten	Last modified time (used to assess timeline of possible tampering)
SHA256	File hash for correlation and IOC use
IsSigned	Indicates whether the DLL is digitally signed
SignatureStatus	Status of the digital signature (e.g., Valid, NotSigned, Unknown)
Publisher	Publisher CN from the certificate, if signed
Suspicious	True if DLL is unsigned or in userland paths (e.g., AppData, Temp)

Output
Excel sheet: "DLL Search Order"
Flagged DLLs (Suspicious = True) are ideal candidates for further review

Security and Operational Considerations
Threat Type	Description
Unsigned DLL in AppData	Likely injected/sideloaded by malware
Recently written DLLs	May correlate with attacker activity or persistence setup
Non-Microsoft Publisher	Should be verified unless whitelisted
Executables that load DLLs	Should be analyzed with procmon or static inspection tools




Use Case in Incident Response
Correlate flagged DLLs with:
Running Processes
Loaded DLLs
Startup Items
Use SHA256 to query threat intel feeds (e.g., VirusTotal, Any.run)
Detect tampered DLLs posing as legitimate system components




















Section 28: Security Event Logs
Purpose
This section extracts critical Windows Security events from Security.evtx, focusing on logon attempts, privilege escalations, process executions, and authentication events that are central to intrusion detection and forensic timeline construction.

Functionality Overview
Source:
Windows Security Event Log (Security.evtx) via Get-WinEvent

Event Types Monitored (Partial List):
Event ID	Meaning
4624	Account Logon (Success)
4625	Account Logon (Failure)
4672	Admin / Privileged Logon
4688	New Process Created
4689	Process Terminated
4648	Logon with Explicit Credentials
4768	Kerberos Ticket Granting Ticket (TGT)
4769	Kerberos Service Ticket Request
4776	NTLM Authentication Attempt
4627	Group Membership Enumeration



Collected Fields
Field	Description
TimeCreated	Date/time the event occurred
EventID	Numerical ID representing the Windows Security event
EventIDMeaning	Human-readable summary of what the event represents
Level	Informational, Warning, Error, Success Audit, etc.
Message	Full, flattened event message for quick scanning

Output
Sheet Name: "Security Log"
Sorted by most recent events
Useful for pivoting by time, user activity, or privilege escalation indicators

Security & Operational Considerations
Concern Type	Details
No events returned	May indicate permissions issue (script not run as Admin) or audit disabled
4688 without 4624	Suggests background task, service, or scheduled job activity
4625 surges	Possible brute force attempts or lateral movement probing
4672 without MFA	Flag privilege escalation attempts

Use Case in Incident Response
DFIR teams can use this data to:
Build a logon timeline
Detect credential theft or brute force
Identify initial access and persistence events
Correlate with process creation, network access, and registry modifications

Recommendations
Always run with Administrator privileges for full visibility
Tune audit policy to log:
Logon events
Process creations
Object access
Export flagged EventIDs to correlate with user sessions and startup artifacts













Section 29: System Event Logs
Purpose
This section captures a snapshot of recent operational activity and kernel-mode events from System.evtx, aiding in the detection of system instability, failed service starts, DNS issues, unexpected shutdowns, and low-level persistence attempts.

Functionality Overview
Log Source:
Windows System Event Log (System.evtx)

Expanded Event ID Descriptions Included:
Event ID	Description
6005	Event Log Service Started
6006	Event Log Service Stopped
6008	Unexpected shutdown
7000	Service failed to start
7001	Dependency failure
7021	Connection telemetry (usage data)
7023	Service crashed
7026	Boot/system driver failed to load
7040	Start type changed (e.g., Manual → Auto)
7045	Service installed
1014	DNS name resolution timed out
6062	Low-power timeout triggered
7003	Roam complete (network handoff)
Collected Fields
Field	Description
TimeCreated	Date/time the event occurred
EventID	Numeric Windows system event identifier
EventIDMeaning	Human-readable summary of the event's purpose
Level	Event level (e.g., Information, Warning, Error)
Message	Flattened event description for simplified parsing or keyword search

Output
Worksheet: "System Log"
Sorted chronologically for timeline reconstruction
Ideal for cross-referencing DNS failures, shutdown behavior, and service registration anomalies

Use Case in Incident Response
Investigation Goal	Use Events Like...
Detect service persistence	7045 (install), 7040 (start type)
Identify network connectivity issues	1014 (DNS timeout), 6062
Triage system instability	6008 (unexpected shutdowns)
Trace failed or suspicious service loads	7000, 7023, 7026



Security and Operational Recommendations
Flag DNS Event 1014 entries with repeated wpad resolution failures – may indicate man-in-the-middle or proxy misuse
Investigate service failures (7000/7023) and unexpected installations (7045) for stealthy persistence
6008 and 7026 events can reveal tampering, abrupt shutdowns, or driver manipulation by rootkits or threat actors






















Section 30: Application Event Logs
Purpose
This section captures and classifies critical entries from the Windows Application.evtx log, including software installations, runtime crashes, .NET issues, and software licensing operations. It enables security teams to identify application instability, licensing failures, or malicious software behavior.

Functionality Overview
Log Source:
Application event log (Application.evtx) via Get-WinEvent

Event Types and Their Meaning:
Event ID	Description
1000	Application crash or fault
1001	Application hang or fault bucket
1026	.NET runtime error
11707	Successful software installation
11708	Software installation failure
16384	Software Protection Service restart
16394	Offline licensing operation succeeded
1003	Software Protection licensing status check





Collected Fields
Field	Description
TimeCreated	Timestamp of the event
EventID	Windows event identifier
EventIDMeaning	Friendly label for analyst understanding
Level	Severity level (Information, Warning, Error, etc.)
Message	Flattened event content for readability and parsing

Output
Sheet Name: "Application Log"
Events sorted in order of occurrence for DFIR timeline assembly
Replaces newlines and extra whitespace in logs for readability

Use Case in Incident Response
Scenario	Useful Events
Software unexpectedly crashing	1000 / 1001 / 1026
Trace user software installs	11707 / 11708
Detect tampering w/ licensing	1003 / 16384 / 16394
Timeline process integrity	Correlate w/ section 15





Threat Hunting & Security Notes
Multiple .NET runtime errors (1026) or install failures (11708) may signal payload execution failure
Software Protection Service events (1003, 16384) may indicate tampering with activation mechanisms
Any persistent failures or install loops tied to the same AppID should be reviewed in tandem with:
Services (Section 24)
Registry Run Keys (Section 23)
WMI Consumers (Section 25)

Recommendations
Monitor for high volumes of application failures across short time spans
Correlate suspicious licensing behavior with known pirated or trojanized software
Export events related to a specific AppID to support malware variant analysis












Section 31: Setup.evtx Logs
Purpose
This section collects and enriches data from the Setup.evtx Windows Event Log, which captures installation events for Windows features, updates, component setup actions, and rollback operations. It is valuable for post-incident analysis, patch verification, and update-related root cause tracing.

Functionality Overview
Primary Source:
Event Log: Setup

Collected Fields:
TimeCreated: When the setup event occurred
EventID: Windows Event ID for the setup event
EventIDMeaning: Friendly label for the event type (e.g., Setup completed, Restore failed)
KB: Extracted Knowledge Base ID from the message (e.g., KB5019274)
Level: Log level (Information, Warning, Error)
Message: Sanitized full message string from the event

Output
Saved to Excel under the “Setup Log” sheet
Enriched with KB number extraction for filtering and triage
Message formatting normalized for clean CSV/XLSX parsing



Security and IR Considerations
Setup failures (EventID 3, 30104) may indicate patch blocking, rollback loops, or tampering
High volume of Setup completed entries for uncommon KBs can reveal staged implants or side-loaded drivers
Staged updates with no follow-through completion can indicate incomplete patching (e.g., crash or kill-switch)
Useful for verifying patch timelines during ransomware or 0-day response

Example Use Cases in DFIR
Trace which KBs were attempted prior to system failure or compromise
Correlate failed updates with security patch windows
Confirm success of specific mitigations (e.g., post-March 2025 Patch Tuesday)
Identify misuse of setup logs by malware (e.g., spoofing update behavior)

Suggested Analyst Actions
Review failed installs for critical CVE patches
Check for KBs known to be backdoored or driver-exploited
Correlate setup times with suspicious process execution (e.g., DLLs, scripts)






Section 32: Windows PowerShell Event Log
Purpose
This section collects telemetry from the Windows PowerShell event log, focusing on engine lifecycle, provider registration, and command execution metadata. It supports forensic review of console PowerShell usage and can highlight suspicious script activity or tool execution.

Functionality Overview
Primary Source:
Event Log: Windows PowerShell

Collected Fields:
TimeCreated: Timestamp of the log entry
EventID: PowerShell-specific event ID
EventIDMeaning: Human-readable interpretation (e.g., command started, provider initialized)
Level: Severity level (Information, Warning, Error)
Message: Cleaned event message string









Mapped EventID Interpretations:
Event ID	Description
400	Engine state changed (startup/shutdown)
403	Command execution started
600	Provider initialized (e.g., Alias, Function)
800	Execution complete
4035	Module loaded

Output
Saved to Excel sheet "WinPS Log"
Cleaned and normalized event messages
Interpreted EventID values for faster triage

Security and IR Considerations
Repeated 600s = Provider initialization (e.g., during PowerShell startup or module injection)
Unusual 403 or 800 sequences may indicate execution of suspicious scripts
4035 events can help track malicious module loads (e.g., PowerView, Invoke-Mimikatz)
Useful for timing correlation against file writes or process trees






Suggested Analyst Actions
Look for engine state changes followed by command executions and module loads
Filter for rare or non-default providers
Combine with Microsoft-Windows-PowerShell/Operational log for full scriptblock tracing
Pivot on TimeCreated to file system and registry artifacts





















Section 33: PowerShell Operational Log
Purpose
This section logs events from the Microsoft-Windows-PowerShell/Operational log. It is one of the most critical sources for monitoring actual PowerShell code execution, command pipelines, and suspicious script behavior in forensic and incident response investigations.

Functionality Overview
Primary Source:
Event Log: Microsoft-Windows-PowerShell/Operational

Collected Fields:
TimeCreated: Event timestamp
EventID: ID of the PowerShell operational event
EventIDMeaning: Human-readable explanation of what the event ID means
Level: Severity (e.g., Warning, Information)
Message: Sanitized and flattened message body

Mapped EventID Interpretations:
Event ID	Meaning
4100	PowerShell engine error
4103	Pipeline execution started
4104	ScriptBlock logging (PowerShell code executed)
4105	Command invocation started
4106	Command invocation completed

Output
Saved to Excel sheet "PS Operational Log"
Normalized messages for easier reading
EventIDMeaning column added to assist with triage

Security and IR Considerations
4104 events expose the actual PowerShell commands executed, including encoded/malicious payloads
Events often show:
Suspicious encoded content (-enc)
AMSI bypass attempts
Credential dumping tools (e.g., Invoke-Mimikatz)
Errors (4100) may indicate blocked execution or tampering with the engine

Suggested Analyst Actions
Filter for 4104 events and extract base64-encoded or obfuscated content
Flag commands that use Invoke-Expression, DownloadString, or FromBase64String
Correlate with Scheduled Tasks or parent processes (e.g., via Event ID 4688)
If 4100 errors occur repeatedly, investigate PowerShell tampering or crashes





Section 34: NTUSER.DAT Presence
Purpose
This section verifies the existence and attributes of each user’s NTUSER.DAT file, which contains per-user registry settings and user-specific configuration data.

Functionality Overview
Primary Data Source:
Files located at C:\Users\<username>\NTUSER.DAT
Collected Fields:
Username: Profile directory name under C:\Users
NTUSERPath: Full path to the NTUSER.DAT file
LastModified: File system timestamp of the last write (indicates recent user activity or modification)
SizeKB: File size in kilobytes

Output
Written to Excel sheet: “NTUSER.DAT”
Provides quick visibility into which profiles exist and their recent use

Security and IR Considerations
The presence of a recently modified NTUSER.DAT may indicate recent logon activity or malware persistence (via autostart entries or hijacked registry keys).
Missing NTUSER.DAT entries for expected user accounts may indicate profile deletion or corruption.
Useful in correlation with other artifact timelines (ShellBags, RunMRU, Jump Lists).

Section 35: RecentDocs (HKCU)
Purpose
This section collects user-specific RecentDocs registry entries, which track recently accessed files by extension or folder type under HKCU. This helps identify user activity, file access patterns, and potential staging paths.

Functionality Overview
Primary Data Source:
HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs
Collected Fields:
SubKey: File type or folder name represented by the subkey (e.g., .docx, .pdf, Folder)
ValueName: Registry value name (binary entries tracking file access)
ValueType: Type of value stored (e.g., Byte[], String)
RawValue: Raw registry value for forensic inspection (often in binary format)

Output
Written to Excel sheet: “RecentDocs”
Registry data flattened for quick analysis and enrichment







Security and IR Considerations
RecentDocs can indicate specific documents or files accessed during a compromise
May reveal staging files, copied payloads, or lateral movement tool usage
Entries persist even if the files are deleted unless manually cleared or overwritten

Note
The script reads from the current user (HKCU). To enumerate all users' RecentDocs, registry hives must be loaded manually from each NTUSER.DAT (e.g., using reg load and querying HKEY_USERS).

















Section 36: UserAssist
Purpose
This section extracts registry data from HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist, which tracks programs and files executed via the GUI (Start Menu, Explorer, etc.). It is commonly used in DFIR to identify user interaction history and application usage.

Functionality Overview
Primary Data Source:
HKCU\UserAssist registry key and its Count subkeys

Collected Fields:
SubKey: The specific subkey or GUID container (e.g., Count)
ValueName: Encoded or obfuscated registry value name (e.g., ROT13)
ValueType: Data type of the value (e.g., Byte[])
RawValue: Raw registry value, useful for offline decoding or forensic review

Output
Written to Excel sheet: "UserAssist"
Organized by subkey, decoded fields can be optionally post-processed






Security and IR Considerations
UserAssist reveals GUI-based application usage (e.g., tools run via Start Menu or Explorer)
Key values are ROT13-encoded strings (e.g., Rkprcgvat Zrpunavfz.rkr = Expecting Mechanics.exe)
Often used to identify suspicious or anomalous program usage on endpoints

Additional Notes
This script does not decode ROT13 automatically; decoding can be scripted later as needed.
To extract for all users, mount and parse each NTUSER.DAT file with loaded hives or use a forensic registry parser (e.g., Eric Zimmerman's RECmd or Registry Explorer).















Section 37: ShellBags Detection
Purpose
This section checks for the presence and basic metadata of ShellBags-related registry keys. ShellBags record folder viewing and navigation preferences in Windows Explorer and can be leveraged to reconstruct user file access history, including for deleted folders.

Functionality Overview
Primary Data Sources:
HKCU\Software\Microsoft\Windows\Shell\BagMRU
HKCU\Software\Microsoft\Windows\Shell\Bags

Collected Fields:
Path: Full registry path being checked
Exists: Boolean indicating presence of the key
LastWrite: Timestamp when the key was last modified (if available)

Output
Saved to Excel sheet: "ShellBags"
Output lists key status and timestamps
Can be used to determine if further ShellBag forensic parsing is possible





Security and IR Considerations
ShellBags persist even after folders are deleted—useful for reconstructing access to wiped directories
Presence confirms that the system is recording GUI navigation data
For complete forensic reconstruction, tools like ShellBags Explorer or SBECmd.exe (Eric Zimmerman's toolset) are required





















Section 38: TypedPaths
Purpose
This section queries the registry for entries under the TypedPaths key, which stores the history of paths manually typed into File Explorer address bars. This artifact can help DFIR analysts identify user navigation behaviors and access to local or remote directories.

Functionality Overview
Primary Data Source:
HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths

Collected Fields:
EntryName: Registry value name (e.g., url1, url2, etc.)
PathValue: Typed path string such as C:\Temp, \\Server\Share, or URLs

Output
Written to Excel sheet "TypedPaths"
Only meaningful entries (not registry metadata) are included
If no values are present, the output sheet may be empty or skipped







Security and IR Considerations
TypedPaths can reveal:
Manually accessed sensitive directories
Attempts to browse network shares
Traces of deleted folders or shares
Useful for timeline correlation when combined with UserAssist or ShellBag data
May not populate if user primarily navigates using shortcuts or pinned folders



















Section 39: RunMRU
Purpose
This section extracts the RunMRU registry values, which store commands typed into the Windows Run dialog box (Win+R). These entries can reveal direct access to applications, scripts, or administrative tools executed by the user.

Functionality Overview
Primary Data Source:
HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU

Collected Fields:
EntryKey: Alphabetical identifier used by the registry for ordering (e.g., a, b, c, etc.)
Command: Full command or executable path that was typed into the Run dialog

Output
Written to Excel sheet "RunMRU"
Sorted by registry entry key
Will be empty if the user has never used the Run dialog

Security and IR Considerations
Useful for identifying:
Direct access to suspicious binaries or control panel items
Manual command executions not found in standard logs
Legacy tools or unusual admin commands
Complements PowerShell history and UserAssist data in timeline construction

Section 40: Jump Lists Presence Check
Purpose
This section checks for the presence and metadata of Jump List files in the AutomaticDestinations directory. Jump Lists track recent file access and interactions per application and are valuable for user activity and application usage analysis.

Functionality Overview
Primary Data Source:
%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations

Collected Fields:
FileName: The hashed .automaticDestinations-ms filename, which maps to a specific app (e.g., Word, Excel)
FullPath: Complete path to the Jump List file
Modified: Last modified timestamp indicating most recent activity

Output
Written to Excel sheet "JumpLists"
Formatted with readable timestamp (yyyy-MM-dd HH:mm:ss)
Results vary depending on user activity and app usage history







Security and IR Considerations
Jump Lists are commonly used to:
Determine if a user accessed sensitive documents
Timeline application usage (via file access)
Confirm whether a document or tool was used even if it has been deleted
Filenames are cryptographic hashes tied to app IDs and require decoding to map to specific programs




















Section 41: Clipboard History
Purpose
This section attempts to enumerate files stored by the Windows Clipboard History feature, available on systems running Windows 10 version 1809 and later (if enabled). Clipboard history can include previously copied text, images, and files.

Functionality Overview
Primary Data Source:
%LOCALAPPDATA%\Microsoft\Windows\Clipboard

Collected Fields:
Name: Name of the clipboard file
FullPath: Absolute path of the file
Size: File size in bytes
Modified: Last write timestamp of the clipboard artifact

Output
Written to Excel sheet "Clipboard History"
Results will be empty if clipboard history is disabled, policy-restricted, or purged

Security and IR Considerations
Clipboard history may expose:
Recently copied credentials, sensitive text, or binary content
Timestamps of clipboard activity
Often overlooked, but useful for forensic timelines and identifying what data was staged before being exfiltrated

Section 42: Account Lockouts
Purpose
This section identifies failed logon attempts that resulted in account lockouts by querying Windows Security Event ID 4740. These events are valuable indicators of brute-force attacks, password spray attempts, or user error.

Functionality Overview
Primary Data Source:
Security.evtx via Event ID 4740

Collected Fields:
TimeCreated: When the lockout event occurred
User: The account that was locked out
Message: Full event message content, normalized into a single line for readability

Output
Written to Excel sheet: “Account Lockouts”
Sorted chronologically for timeline correlation

Security and IR Considerations
Lockout frequency and timing may indicate brute-force attempts or automated enumeration
Correlate usernames with system activity and login sources to identify malicious IPs or compromised accounts
Absence of expected lockout logs may suggest audit policy misconfiguration or log tampering


Section 43: Credential Manager
Purpose
This section extracts saved credentials from the Windows Credential Manager via the cmdkey utility. It's useful for identifying cached logins, RDP targets, saved domain credentials, or service accounts stored on the system.

Functionality Overview
Primary Data Source:
cmdkey /list (built-in Windows utility for viewing stored credentials)

Collected Fields:
Target: The system, share, or domain the credentials are stored for
Username: The user associated with the stored credential
Retrieved: Timestamp when the credential was enumerated during script execution

Output
Written to Excel sheet: “Credential Manager”
Timestamped with collection time for timeline correlation

Security and IR Considerations
Cached credentials may contain sensitive access tokens for remote systems (e.g., RDP, SMB, VPN)
Useful in lateral movement analysis and credential harvesting detection
High-value accounts (e.g., domain admins) stored here should be reviewed for privilege abuse
Section 44: net user Output
Purpose
This section uses the native Windows net user command to enumerate all local user accounts. This is critical for identifying local persistence, unexpected accounts, and signs of privilege abuse or account creation by malware.

Functionality Overview
Primary Data Source:
net user (built-in Windows command-line utility)

Collected Fields:
Username: Local account name returned by net user
Collected: Timestamp when the account data was gathered

Output
Written to Excel sheet: “Net User”
Provides a raw but timestamped inventory of local Windows accounts

Security and IR Considerations
Review for suspicious or generic account names (e.g., test, admin2, backup)
Accounts not tied to actual user activity may be used for persistence
Correlate with SAM, Security.evtx, and NTUSER.DAT for logon/use context



Section 45: net localgroup Output
Purpose
This section enumerates all local groups configured on the system. Understanding group structure is essential for assessing privilege delegation and lateral movement opportunities.

Functionality Overview
Primary Data Source:
net localgroup (built-in Windows CLI tool)

Collected Fields:
GroupName: Name of each local group on the host
Collected: Timestamp when data was collected

Output
Written to Excel sheet: “Local Groups”
Provides a point-in-time view of all system-defined and custom local groups

Security and IR Considerations
Unexpected or custom-named groups could indicate privilege staging
Combine this with net localgroup <groupname> output to enumerate group members
Lateral movement often involves abusing loosely managed groups (e.g., Remote Desktop Users, Administrators)



Section 46: whoami /groups Output
Purpose
This section identifies the groups that the current user context is a member of. This provides insight into access levels, privileges, and effective security posture.

Functionality Overview
Primary Data Source:
whoami /groups (native Windows command)

Collected Fields:
GroupName: Name of the group the current user belongs to
SID: Security Identifier for the group
Attributes: Associated group attributes such as Mandatory, Enabled, Owner, DenyOnly, etc.

Output
Written to Excel sheet: “Whoami Groups”
Includes security identifiers (SIDs) and descriptive group attributes
Helps profile the user's effective access and potential for privilege escalation

Security and IR Considerations
Groups like Administrators, Backup Operators, or Remote Desktop Users may provide elevated access
DenyOnly attributes can indicate partial or restricted group membership (e.g., from token filtering)
Useful when cross-referencing with access control entries (ACEs) or audit policy enforcement
Section 47: MAC Addresses
Purpose
This section collects Media Access Control (MAC) addresses for all active physical network adapters. MAC addresses help identify hardware uniquely on a network and can be crucial for tracking device communications.

Functionality Overview
Primary Data Source:
Get-NetAdapter -Physical

Collected Fields:
InterfaceAlias: Friendly name of the network interface (e.g., Wi-Fi, Ethernet)
MACAddress: Hardware-level address used for LAN communication
LinkSpeed: Current operational speed of the network interface

Output
Written to Excel sheet: “MAC Addresses”
Filtered to include only interfaces that are physically present and currently up
Provides visibility into which network interfaces are in use and their operational status






Security and IR Considerations
MAC addresses can be mapped to manufacturers for asset validation
High link speeds may indicate active or recently used interfaces
MAC address spoofing is a common technique in evasion/persistence scenarios
Useful in correlating DHCP leases, ARP cache, or wireless access logs during investigations




















Section 48: Hosts File
Purpose
This section parses the system’s hosts file to identify custom name resolution entries. These entries override DNS lookups and may be used for both legitimate and malicious redirection.

Functionality Overview
Primary Data Source:
C:\Windows\System32\drivers\etc\hosts

Collected Fields:
IPAddress: The resolved IP address
Hostname: The corresponding domain or host label

Output
Written to Excel sheet: “Hosts File”
Only entries beginning with valid IPv4 addresses are included
Ignores comments and empty lines

Security and IR Considerations
Malicious actors often manipulate the hosts file to:
Redirect users to phishing sites
Block access to security vendor updates
Commonly abused entries include fake AV domains, C2 IPs, or localhost redirections
Correlation with proxy logs and DNS failures can expose tampering


Section 49: Firewall Rules
Purpose
This section extracts and decodes Windows Defender Firewall rule configurations for both inbound and outbound traffic. Understanding these rules helps determine the allowed/blocked traffic paths on a host and potential lateral movement or data exfiltration vectors.

Functionality Overview
Primary Data Source:
• Get-NetFirewallRule – Lists all configured firewall rules.

Decoded Fields:
Name: Friendly name of the firewall rule
Enabled: Whether the rule is active (True/False)
Direction: Direction of traffic the rule applies to (Inbound, Outbound)
Action: The rule’s behavior (Allow, Block)
Profile: Network profile(s) the rule applies to:
Domain – When joined to a domain
Private – Trusted network (e.g., home)
Public – Untrusted network (e.g., coffee shop Wi-Fi)
All – Rule applies regardless of profile

Output
Written to Excel sheet: Firewall Rules
All numeric codes are translated to human-readable labels





Security and IR Considerations
Outbound rules rarely exist by default—custom outbound blocks or unusual allows can indicate tampering or exfiltration attempts
Inbound “Allow” rules on non-standard ports or legacy services (e.g., SMBv1) may be high risk
Firewall rule audit trails help identify defensive gaps in endpoint containment strategy






















Section 50: DNS Cache
Purpose
Collects and parses the DNS resolver cache. Identifies recently queried domain names and their resolution results. Useful for detecting anomalous network behavior or recently visited domains.

Functionality Overview
Primary Data Source: 
Output from ipconfig /displaydns

Parsed Fields:
RecordName: Queried domain or hostname.
RecordType: DNS type translated for clarity:
1 → A (IPv4)
5 → CNAME (Alias)
28 → AAAA (IPv6)
TTL: Time (in seconds) the record remains cached.
Data: IP address or CNAME target.

Output
Saved to the Excel sheet: DNS Cache
Fields decoded and normalized for human-readable analysis





Security and IR Considerations
Reveals recent system communications and web traffic.
Cached CNAME/A/AAAA entries can be correlated with known malicious infrastructure.
Long TTL values on odd domains may indicate suspicious persistence (e.g., DNS tunneling).
Helps trace back to compromised systems by linking DNS queries to suspicious domains.




















Section 51: ARP Cache
Purpose
Collects the current contents of the Address Resolution Protocol (ARP) cache. This is useful in DFIR to identify recent IP-to-MAC address mappings on the system.

Functionality Overview
Primary Data Source
arp -a (built-in Windows CLI tool)

Collected Fields:
IPAddress: The resolved IP address on the local network.
MACAddress: The hardware address associated with that IP.
Type: The type of mapping (usually dynamic or static).

Output
Excel Sheet: ARP Cache
Structured table view with IP, MAC, and type columns.
Helpful for identifying lateral movement or suspicious devices on the same subnet.

Security and IR Considerations
Dynamic ARP entries may reveal recent peer communications.
Repeated or spoofed MAC addresses across multiple IPs may indicate ARP spoofing or MITM (Man-In-The-Middle) activity.
ARP cache timing correlates with active network sessions and can aid timeline analysis.


Section 52: Logon Events
Purpose
This section extracts Windows Security Log event ID 4624, which represents successful logon attempts. It provides insight into user authentication activity, useful in identifying unauthorized access or lateral movement.

Functionality Overview
Primary Data Source:
Security.evtx – Event ID 4624

Collected Fields:
TimeCreated: Timestamp of the logon event
EventID: Always 4624 (successful logon)
Account: Username associated with the logon
LogonType: Numeric code indicating how the logon occurred
LogonID: Unique identifier for the logon session
Message: Flattened raw message from the event log

Common Logon Types:
2 – Interactive (local keyboard)
3 – Network (shared folder, SMB)
4 – Batch (scheduled task)
5 – Service logon
7 – Unlock
10 – Remote Interactive (RDP)
11 – Cached Interactive (domain logon while offline)

Output
Excel Sheet: Logon Events
Tabulated with timestamps, accounts, and session types
Message field retains contextual details for investigation

Security and IR Considerations
Useful for detecting suspicious logons (e.g., late-night interactive or RDP sessions)
Repeated logons from a system account (e.g., PCWIDNER$) may indicate automated tasks or lateral movement
LogonType 3 and 10 should be reviewed for potential remote access
















Section 53: BAM/DAM Activity
Purpose
This section extracts application usage data from the Background Activity Moderator (BAM) and Desktop Activity Moderator (DAM) registry keys. It can indicate which executables were recently run per user SID, even if forensic logs were cleared.

Functionality Overview
Primary Data Source:
HKLM\SYSTEM\CurrentControlSet\Services\bam\UserSettings

Collected Fields:
UserSID: Security Identifier of the user profile
Executable: Path of the executable tracked by BAM
LastUsed: FileTime timestamp of the executable’s last activity, converted to readable UTC format

Output
Excel Sheet: BAM_DAM
Provides raw evidence of program usage per user
Converts timestamp from FILETIME to UTC yyyy-MM-dd HH:mm:ss format
Skips default PowerShell object properties to avoid noise






Security and IR Considerations
BAM data may reveal attacker tool execution (e.g., mimikatz.exe, powershell.exe, or cobaltstrike_beacon.exe)
Useful for identifying stealthy or short-lived execution outside of full event logs
Timeline of BAM LastUsed timestamps helps reconstruct activity during gaps in standard logs





















Section 54: Netstat Output
Purpose
This section collects real-time network connection and listening port data using netstat -ano, capturing associated processes (PIDs). It provides insight into open ports, remote connections, and running services.

Functionality Overview
Primary Data Source:
netstat -ano output parsed into structured format

Collected Fields:
Protocol: TCP or UDP
LocalAddress: IP and port the system is listening on or using
ForeignAddress: Remote IP and port (if established)
State: Connection state (e.g., LISTENING, ESTABLISHED, TIME_WAIT)
PID: Process ID associated with the connection

Output
Excel Sheet: Netstat
Normalized spacing ensures consistent parsing
Includes both TCP and UDP entries
Automatically handles missing "State" field (e.g., for UDP)




Security and IR Considerations
Identifies unknown or unauthorized services listening on ports (e.g., reverse shells, RATs)
Helps correlate PIDs with suspicious processes or binaries
Useful for mapping lateral movement, tunneling, or external C2 callbacks
Cross-reference with tasklist /svc or Get-Process to validate ownership of connections




















Section 55: ipconfig /displaydns
Purpose
This section parses DNS client cache output from the ipconfig /displaydns command. It reveals recently resolved domain names, TTL values, and associated IP data cached by the system.

Functionality Overview
Primary Data Source:
Output of ipconfig /displaydns

Collected Fields:
RecordName: Fully qualified domain name (FQDN) recently resolved
RecordType: DNS type (e.g., 1 = A, 5 = CNAME, 28 = AAAA)
TTL: Time To Live – seconds until record expires in cache
Data: Associated IP address, canonical name, or alias data

Output
Excel Sheet: ipconfig_dns
Each row represents a discrete DNS resolution event from the local resolver cache
Data is sorted in 4-line chunks per record for accurate parsing







Security and IR Considerations
Cached domains can reveal:
Recently contacted C2 infrastructure
Internal/external web applications
Signs of phishing attempts or domain generation algorithm (DGA) usage
Helps correlate outbound communication attempts with threat actor infrastructure
Useful in DNS tunneling investigations and temporal access analysis


















Section 56: RDP Logon Events
Purpose
This section captures Event ID 1149 from the RDP connection manager log, which signals successful user authentication attempts to a Remote Desktop Protocol (RDP) session before logon is fully established.
Functionality Overview
Primary Data Source:
Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational log
Event ID: 1149

Collected Fields:
TimeCreated: Timestamp when the RDP session attempt occurred
EventID: Should always be 1149
Message: Flattened event description (username, domain, session ID)

Output
Excel Sheet: RDP Logons
One row per connection attempt via RDP
Useful for identifying remote access behaviors and session origins






Security and IR Considerations
Multiple 1149 events in succession may indicate brute-force or password spraying
Helps correlate external access attempts to local user logons
Useful in identifying lateral movement or administrative RDP abuse
Can aid in tracking access patterns during and post-compromise





















Section 57: Network Interfaces
Purpose
This section gathers metadata about all network interfaces present on the system. It provides operational visibility into active, inactive, virtual, and disconnected interfaces, which is critical for network mapping and DFIR triage.
Functionality Overview

Primary Data Source:
Get-NetAdapter

Collected Fields:
Name: Friendly name of the network adapter (e.g., “Wi-Fi”, “Ethernet”)
Status: Current operational status (Up, Down, Disconnected)
MACAddress: Unique hardware address of the adapter
LinkSpeed: Reported link speed (e.g., “1 Gbps”, “100 Mbps”)
InterfaceID: Index identifier used by Windows networking stack

Output
Excel Sheet: Network Interfaces
Presents an organized view of adapter hardware and link-level configuration






Security and IR Considerations
Virtual adapters (e.g., VMware, Hyper-V) can reveal sandbox or analysis environments
Interfaces with unusually high speeds but no traffic may indicate spoofing or tunneling
Disconnected interfaces still retain identity info (e.g., MAC addresses) for historical mapping
MAC addresses can be cross-referenced with OUIs to identify vendor/manufacturer




















Section 59: MUICache
Purpose
This section extracts items from the MUICache registry key, which records metadata about executables that have been run, including their file names and associated descriptions as displayed by Windows.
Functionality Overview

Primary Data Source:
HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache

Collected Fields:
Executable: The path or name of the executable file
Description: User-visible application label extracted by the OS for display

Output
Excel Sheet: MUICache
Outputs each entry except LangID and (default) to avoid noise

Security and IR Considerations
This artifact is useful for identifying executables run by the user
Persistence and execution by malware may leave traces in MUICache
Can be used to correlate with other execution artifacts such as ShimCache, Prefetch, and Jump Lists
Absence of data may indicate profile wiping or a new user context

Section 60: RecentApps
Purpose
This section collects data about recently used applications from the Windows Search “RecentApps” registry key. It is valuable for timeline reconstruction and understanding user behavior.
Functionality Overview

Primary Data Source:
HKCU\Software\Microsoft\Windows\CurrentVersion\Search\RecentApps

Collected Fields:
AppID: Registry subkey name (usually a hash or GUID associated with the app usage)
Executable: The path to the executable file that was accessed
LastAccessTime: Timestamp indicating the last time the application was used

Output
Excel Sheet: RecentApps
Each row corresponds to one recent app entry
Includes last access time and full executable path for context








Security and IR Considerations
Tracks per-user application access — useful for determining what apps were opened recently
Helpful for detecting unauthorized use or validating legitimate user behavior
Complements other evidence like Prefetch, MUICache, Jump Lists, and UserAssist
Absence of this data may indicate user profile reset, tampering, or group policy restrictions




















Section 61: RecentFileCache.bcf
Purpose
This section checks for the existence of the RecentFileCache.bcf artifact, which is used by Windows Application Compatibility to track recently executed programs. Although the contents are binary, the presence of this file is a strong indicator of execution history.
Functionality Overview

Primary Data Source:
%SystemRoot%\AppCompat\Programs\RecentFileCache.bcf

Collected Fields:
Path: Full file path (if exists)
Note: Status message (e.g., "File exists", "File not found", or "Binary format")

Output
Excel Sheet: RecentFileCache
Provides simple visibility into whether the file exists and if it can be further analyzed

Security and IR Considerations
The .bcf file is binary and requires post-processing with third-party tools (e.g., PECmd from Eric Zimmerman or NirSoft utilities)
Useful for uncovering past file execution, especially portable executables (PEs) and scripts
Presence without analysis provides a lead; absence may indicate deletion or Windows version/config mismatch

Section 62: SRUM Activity
Purpose
This section identifies the presence of the System Resource Usage Monitor (SRUM) database, which tracks detailed metrics on user and application behavior including network usage, app launches, and resource consumption.
Functionality Overview

Primary Data Source:
%windir%\System32\sru\SRUDB.dat

Collected Fields:
SRUDB_Path: Full path to the SRUDB.dat file
Note: Indicates whether the file exists and advises on analysis tools

Output
Excel Sheet: SRUM
Reports if the SRUM database is present and flags its analytical value

Security and IR Considerations
SRUM contains forensic evidence on app usage, energy/network activity per executable, and historical session data
The .dat file is a SQLite database and must be parsed using tools like:
Eric Zimmerman's srum-dump.exe
Custom SQLite queries via sqlite3.exe or DB Browser for SQLite
Helps correlate application launches, user activity periods, and lateral movement
Section 63: SAM Hive Detection
Purpose
This section checks for the presence of the Security Account Manager (SAM) registry hive, which contains hashed local user credentials and group membership details.
Functionality Overview

Primary Data Source:
%SystemRoot%\System32\config\SAM

Collected Fields:
Hive: Static label "SAM"
Path: Full path to the SAM file
Exists: Whether the file exists
Note: Analysis and usage guidance for the binary hive

Output
Excel Sheet: SAM Hive
Indicates availability of the SAM hive and informs on further analysis tooling

Security and IR Considerations
The SAM hive is high-value for post-exploitation and lateral movement scenarios Tools like secretsdump.py (Impacket) or reg save + pwdump are required to extract and decode password hashes
Useful for:
Offline credential extraction
Hash comparison
Account enumeration
Section 64: SECURITY Hive Detection
Purpose
This section identifies the presence and accessibility of the Windows SECURITY registry hive, which holds local security policy data including LSA secrets and system credentials.
Functionality Overview

Primary Data Source:
%SystemRoot%\System32\config\SECURITY

Collected Fields:
Hive: Static identifier ("SECURITY")
Path: Full filesystem path to the SECURITY hive
Exists: Whether the hive file is present
Note: Guidance for further analysis and tool usage

Output
Excel Sheet: SECURITY Hive
Displays binary hive presence and availability status

Security and IR Considerations
The SECURITY hive contains sensitive system-level secrets, such as service account credentials, cached logins, and policy objects
Offline parsing is required using tools like:
secretsdump.py (Impacket)
reg save + lsasecretsview or pwdump
Often used in advanced post-compromise credential access and for detecting misconfigurations or domain trust issues
Section 65: USRCLASS.DAT Detection
Purpose
This section verifies the presence of the UsrClass.dat file, which stores per-user class registrations and ShellBag artifacts that indicate folder access patterns.
Functionality Overview

Primary Data Source
%LOCALAPPDATA%\Microsoft\Windows\UsrClass.dat

Collected Fields
File: Static name identifier (UsrClass.dat)
Path: Full file path to the user-specific registry hive
Exists: Whether the file is present on the filesystem
Note: Contextual analysis note for DFIR

Output
•	Excel Sheet: USRCLASS.DAT
•	Clearly indicates availability and analysis relevance

Security and IR Considerations
UsrClass.dat contains ShellBag artifacts useful for detecting folder access and historical navigation within the Windows GUI
Also includes Jump List behavior traces, often used to corroborate file usage or staging activity
Must be parsed using tools such as:
Eric Zimmerman's Registry Explorer
shellbags.py (KAPE Module or standalone)
Forensic suites with ShellBag interpretation
Section 66: Prefetch Files
Purpose
This section collects metadata about .pf (Prefetch) files from the Windows Prefetch directory. These files track recently executed programs and can indicate program execution timelines and frequency.
Functionality Overview
Primary Data Source
C:\Windows\Prefetch

Collected Fields
Name: The filename of the prefetch entry (typically PROGRAM.EXE-<HASH>.pf)
Path: Full path to the prefetch file
SizeKB: File size in kilobytes
Modified: Last write time (often reflects last run)

Output
Excel Sheet: Prefetch Files
Each row represents one .pf file with metadata relevant to execution context








Security and IR Considerations
Prefetch files reveal:
What was executed (based on filename)
When it was last run (LastWriteTime)
Frequency and context of execution (via specialized tools)
.pf files are generated only on non-SSD systems by default (unless explicitly enabled)
For deep analysis, use:
PECmd.exe (Eric Zimmerman's Prefetch parser)
WinPrefetchView (GUI-based)
Windows Timeline correlation tools

















Section 67: Amcache.hve
Purpose
This section checks for the presence of the Amcache.hve file, which stores historical execution metadata for binaries on the system. It’s a critical artifact for tracking program usage and installation paths.
Functionality Overview
Primary Data Source
C:\Windows\AppCompat\Programs\Amcache.hve

Collected Fields
File: Static name Amcache.hve
Path: Full file path
Exists: "Yes" if present, "No" if not
Note: Guidance on next steps, typically suggesting external tools

Output
Excel Sheet: Amcache
Single-line status per system









Security and IR Considerations
Amcache.hve contains execution traces including:
File name
File path
SHA1 hash
Last modified timestamps
Program ID and install source
It is not human-readable directly and must be parsed using tools like:
AmcacheParser
KAPE module AmcacheMap
Valuable for attribution, lateral movement analysis, and locating dropped executables post-compromise.















Section 68: Downloads Folder Contents
Purpose
This section enumerates all files located within the current user’s Downloads directory, including their name, path, file size, and last modification timestamp. This is especially useful for identifying potentially malicious payloads, user-downloaded tools, or unauthorized data exfiltration preparation.
Functionality Overview
Primary Data Source
%USERPROFILE%\Downloads

Collected Fields
Name: File name
Path: Full file system path to the file
SizeKB: File size in kilobytes (rounded to 2 decimals)
Modified: Last modification time of the file

Output
Excel Sheet: Downloads
Results sorted in natural order as returned by Get-ChildItem
Includes hidden/system files via -Force

Security and IR Considerations
Presence of desktop.ini is normal; large or recently modified .exe, .ps1, .zip, or .dll files should be investigated
Review for unauthorized tools or scripts dropped in this user-accessible folder
Timestamp correlation with user logon, browser history, or USB activity can support findings

Section 69: USB Device History
Purpose
This section retrieves historical data about USB storage devices connected to the system, based on Windows registry entries under the USBSTOR key. It's useful for tracking potential data exfiltration, identifying unauthorized removable device usage, or building a forensic timeline of user activity.
Functionality Overview
Primary Data Source
HKLM\SYSTEM\CurrentControlSet\Enum\USBSTOR

Collected Fields
Device: Device identifier string
FriendlyName: Descriptive name of the device (e.g., "SanDisk USB Device")
Service: Associated driver/service used to interact with the device
ContainerID: Unique GUID assigned to the physical device (if present)
PSPath: Full PowerShell registry path for traceability

Output
Excel Sheet: USB History
Includes both device metadata and registry path to support deeper investigation
Graceful fallback for access-denied keys




Security and IR Considerations
Presence of unknown or unauthorized USB devices can indicate exfiltration or malicious code delivery
Pair this data with Prefetch, Logon Events, Jump Lists, and SRUM timestamps for a more complete picture
Long-standing USB device entries with no matching shellbag/recent use may indicate stealth exfiltration





















Section 70: LNK Files
Purpose
This section collects metadata for .lnk (shortcut) files from each user’s "Recent" folder. LNK files are artifacts of user interaction with files, folders, and executables, making them vital for timeline reconstruction and identifying access patterns.
Functionality Overview
Primary Data Source
%SystemDrive%\Users\<User>\AppData\Roaming\Microsoft\Windows\Recent\*.lnk

Collected Fields
User: Name of the user profile from which the .lnk was found
FileName: Shortcut file name (e.g., resume.docx.lnk)
FullPath: Absolute file system path to the .lnk file
Modified: Last modification timestamp (typically matches file access time)
SizeKB: Size of the .lnk file in kilobytes

Output
Excel Sheet: LNK Files
Includes per-user breakdown
Captures modification time and size for forensic correlation






Security and IR Considerations
.lnk files may reveal files recently opened by a user, even if the original files have been deleted
Helpful for tracking lateral movement (e.g., .lnk files pointing to network shares)
Combine with Jump Lists, RecentDocs, and Shellbags for robust user activity profiling





















Section 71: SYSTEM Hive Check
Purpose
This section checks for the presence of the SYSTEM registry hive, a critical component that contains system-wide configuration, driver load order, and hardware profile information essential for forensic and incident response analysis.
Functionality Overview
Primary Data Source
C:\Windows\System32\config\SYSTEM

Collected Fields
Hive: Identifies the registry hive checked (i.e., SYSTEM)
Path: Full path to the hive file on disk
Exists: Indicates if the file exists (Yes/No)
Note: Advises on how to further analyze the hive (e.g., with offline tools)

Output
Excel Sheet: SYSTEM Hive
Confirms presence of SYSTEM hive file for offline examination








Security and IR Considerations
The SYSTEM hive can be parsed for information such as:
Mounted devices
Services and drivers loaded at boot
Control sets and boot sequences
Valuable in malware investigations, persistence analysis, and post-exploitation review
Recommended tools: RegRipper, KAPE, or Eric Zimmerman's Registry Explorer



















Section 72: SOFTWARE Hive Check
Purpose
This section checks for the presence of the SOFTWARE registry hive, which stores critical information about installed programs, system configurations, services, drivers, and applications used on the system.
Functionality Overview
Primary Data Source
C:\Windows\System32\config\SOFTWARE

Collected Fields
Hive: Registry hive name (SOFTWARE)
Path: File system path to the SOFTWARE hive
Exists: Boolean indicating presence of the hive
Note: Guidance for further parsing with external tools

Output
Excel Sheet: SOFTWARE Hive
Indicates if the hive is available and where to locate it

Security and IR Considerations
The SOFTWARE hive is essential for:
Enumerating installed applications and versioning
Identifying persistence mechanisms (e.g., Run keys)
Investigating third-party software configurations
Use tools like Registry Explorer, RegRipper, or KAPE modules to extract actionable artifacts


Section 73: SQLite Browser Data Reader & History Collector
Purpose
This section collects and parses local browser history databases (SQLite format) for Chrome, Edge, and Firefox. It identifies which URLs were visited, their titles, timestamps of access, and associates the entries with their corresponding browser. The SQLite .NET provider is dynamically loaded or downloaded if missing, ensuring compatibility without manual setup.

Functionality Overview
Primary Data Sources:
Chrome:
%LOCALAPPDATA%\Google\Chrome\User Data\*\History
Edge:
%LOCALAPPDATA%\Microsoft\Edge\User Data\*\History
Firefox:
%APPDATA%\Mozilla\Firefox\Profiles\*\places.sqlite

Collected Fields:
url: The website or resource visited
title: The page title (if available)
LastVisit: Timestamp (UTC) of last visit, converted from WebKit or Firefox epoch
Browser: Identifies Chrome, Edge, or Firefox

SQLite Loader Logic:
Checks for System.Data.SQLite.dll in $PSScriptRoot
If missing, attempts to download the DLL from a GitHub mirror
Loaded via Add-Type for use in querying browser databases
Output:
Sheet name: Browser History
Includes up to 50 most recent entries per browser
Timestamp converted to ISO8601 format for easy correlation

Security and IR Considerations
Tracks user browsing behavior across multiple browsers
Provides insight into last user activity, attempted connections, or research related to a compromise
Crucial in web-based phishing, credential harvesting, or post-exploitation investigations
SQLite errors (such as locked databases or missing DLLs) are gracefully captured in the Error and Details columns for review

Dependencies
PowerShell Internet access (to auto-fetch SQLite DLL if not bundled)
.NET runtime compatible with System.Data.SQLite assembly
Internet access required only for dynamic assembly resolution










Section 74: Browser Cache (Presence Check Only)
Purpose
This section checks whether browser cache directories for Chrome, Edge, and Firefox are present on the system. Presence alone can suggest browser use and may warrant deeper analysis with dedicated cache viewers or forensic tools.
Functionality Overview
Primary Data Sources:
Chrome:
%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache
Edge:
%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache
Firefox:
%APPDATA%\Mozilla\Firefox\Profiles

Collected Fields:
Browser: Name of the browser (e.g., Chrome, Edge, Firefox)
Path: Full directory path to the browser's cache
Exists: Indicates if the folder was found (Yes/No)
Note: Brief description of result status

Output
Written to Excel sheet: Browser Cache
Useful for confirming if browser activity may have cached elements suitable for timeline reconstruction or artifact recovery



Security and IR Considerations
Cache folders can retain evidence of file downloads, site visits, session tokens, and other forensic residue.
Folder presence alone does not indicate content usefulness—binary parsing tools (e.g., ChromeCacheView, MozCacheView) are required for deeper insights.






















Section 75: Browser Search Terms
Purpose
This section extracts search terms recently used in Chromium-based browsers (Google Chrome and Microsoft Edge) by querying their internal SQLite database (History) using keyword search mappings.
Functionality Overview
Primary Data Source:
SQLite History files:
%LOCALAPPDATA%\Google\Chrome\User Data\*\History
%LOCALAPPDATA%\Microsoft\Edge\User Data\*\History

Collected Fields:
term: The keyword or phrase the user searched
LastUsed: Timestamp of the most recent occurrence (converted from Chrome’s Webkit epoch)
Browser: Source browser (Chrome or Edge)

Output
Written to Excel sheet: Browser Search Terms
Includes only the top 50 most recent search terms per browser

Security and IR Considerations
Search term data may reveal user intent, targeted reconnaissance, or recent activity.
Data extraction requires working SQLite .NET assemblies—errors may indicate missing binaries or locked DBs.
Firefox is excluded by design as it does not persist search queries in a similar schema.

Section 76: Browser Cookies
Purpose
This section extracts browser cookie data from SQLite-based cookie stores used by Chrome, Edge, and Firefox. Cookies often persist login sessions, analytics, or tracking activity.
Functionality Overview
Primary Data Source:
SQLite databases:
Chrome/Edge: Cookies database in %LOCALAPPDATA%\...\User Data\*\Cookies
Firefox: cookies.sqlite in %APPDATA%\Mozilla\Firefox\Profiles\*

Collected Fields:
host_key / host: Domain or site origin of the cookie
name: Name of the cookie variable
value: Stored cookie value (plaintext)
LastAccess: UTC timestamp when the cookie was last accessed (converted)

Output
Excel sheet titled: Browser Cookies
Displays 50 most recently accessed cookies per browser, enriched with source browser information





Security and IR Considerations
Cookies may contain sensitive session identifiers or authentication tokens
Presence of cookies from suspicious domains can indicate user tracking, phishing, or prior compromise
Data is stored in plaintext; consider redacting or protecting cookie values during handling
Encrypted cookie values are not decrypted in this script (Chromium-based browsers store encrypted values on disk; decryption requires DPAPI context)



















Final Section: Cleanup and Save
Purpose
This final section finalizes all operations by saving the collected forensic data into an Excel workbook (.xlsx) and ensuring a clean exit from the Excel COM interface.
Functionality Overview
Key Actions:
Remove-DefaultSheets: Custom function to remove default/empty worksheets before saving
$workbook.SaveAs(...): Saves the active workbook in modern .xlsx format (OpenXML, code 51)
$workbook.Close($true): Closes the workbook and commits all changes
$excel.Quit(): Gracefully exits the Excel COM application to free system resources
Write-Host: Outputs success messages for visual confirmation

Output
Excel workbook written to: "$outputExcel" (typically on Desktop)
Environment variables (if exported separately): "$outputCsv"

Security and IR Considerations
Proper closure of Excel COM objects prevents lingering background Excel.exe processes
Final messages confirm successful generation and location of output artifacts
If Excel save fails (e.g., permission issues, locked file), no retry mechanism is currently included—consider adding try/catch logic if needed for production use

