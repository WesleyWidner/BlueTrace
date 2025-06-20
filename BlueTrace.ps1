# Blue Trace © 2025 Wesley Widner – All rights reserved.
# Licensed under the Blue Trace Proprietary License. No modification, redistribution, or commercial use allowed.

###################################################################################################################################


<#
.SYNOPSIS
    Comprehensive DFIR PowerShell Script - Collects, correlates, and exports system forensic artifacts into structured Excel and CSV outputs.

.DESCRIPTION
    This script performs wide-ranging digital forensics and incident response (DFIR) data collection from a live Windows system.
    It enumerates and documents:

    - System and hardware configuration
    - Installed applications and environment settings
    - User profiles and activity artifacts (NTUSER.DAT, Shellbags, Jump Lists, MRU entries)
    - Windows Event Logs (Setup, PowerShell, Logon, RDP, Lockouts)
    - Registry hives and forensic keys (MUICache, BAM/DAM, RunMRU, UserAssist, TypedPaths)
    - File system metadata (hidden files, ADS, downloads, LNK files, Prefetch, Amcache)
    - Network configuration (interfaces, MACs, ARP, DNS, netstat, firewall)
    - Web browser artifacts (History, Search Terms, Cookies, Cache presence)
    - Presence checks for SRUM, AppCompatCache, RecentFileCache, and registry hives (SAM, SECURITY, SYSTEM, SOFTWARE)

    Results are saved to Excel (.xlsx) and supporting CSV files on the current user’s Desktop. 
    Designed for DFIR analysts, SOC personnel, or blue team responders performing live triage or timeline reconstruction.

.VERSION
    3.1

.AUTHOR
    Wesley Widner (White Hat Wes)

.LASTMODIFIED
    2025-06-20

<#
.INSTRUCTIONS
    To run this script:

    1. Ensure you are running PowerShell as **Administrator**.
    2. Place the script (BlueTrace.ps1) on your Desktop or another accessible location.
    3. (Optional) For browser artifact collection, download and place `System.Data.SQLite.dll` in the same folder.
       - Available at: https://system.data.sqlite.org/index.html/doc/trunk/www/downloads.wiki
    4. Open a PowerShell window and navigate to the script directory:
         cd "$env:USERPROFILE\Desktop"
    5. Execute the script using:
         .\BlueTrace.ps1
    6. Upon completion:
       - Excel output: `DFIR_Report.xlsx` (saved to Desktop)
       - CSV output: `DFIR_Report.csv` (for environment variables and other structured data)

    NOTES:
    - Requires PowerShell 5.1+
    - SQLite DLL required for Chrome, Edge, Firefox data extraction
    - All errors are handled gracefully and logged to console or Excel
#>

###################################################################################################################################


# --- Section 0: Output Setup (Secured & Hardened) ---

# Set up output paths on the Desktop
$desktop     = [Environment]::GetFolderPath("Desktop")
$outputExcel = Join-Path $desktop "BlueTrace_Report.xlsx"
$outputCsv   = Join-Path $desktop "BlueTrace_Report.csv"

# Initialize Excel COM object securely
try {
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $workbook = $excel.Workbooks.Add()
} catch {
    Write-Error "Failed to start Excel. Ensure Microsoft Excel is installed and COM automation is enabled."
    exit 1
}

# Remove default sheets (Sheet1, Sheet2, Sheet3)
function Remove-DefaultSheets {
    try {
        $defaultSheetNames = @("Sheet1", "Sheet2", "Sheet3")
        foreach ($sheet in @($workbook.Sheets)) {
            if ($defaultSheetNames -contains $sheet.Name) {
                $sheet.Delete()
            }
        }
    } catch {
        Write-Warning "Could not remove one or more default sheets: $_"
    }
}

# Secure and reliable writing of data to Excel
function Save-ToExcelSheet {
    param (
        [string]$SheetName,
        [array]$Data
    )

    if (-not $Data -or $Data.Count -eq 0) {
        Write-Warning "No data provided for sheet '$SheetName'. Skipping."
        return
    }

    try {
        # Sanitize sheet name and limit to 31 characters
        $safeName = ($SheetName -replace '[\\/*\[\]:?]', '').Substring(0, [math]::Min($SheetName.Length, 31))
        $sheet = $workbook.Sheets.Add()
        $sheet.Name = $safeName

        $props = $Data[0].PSObject.Properties.Name

        # Write headers
        for ($col = 0; $col -lt $props.Count; $col++) {
            $sheet.Cells.Item(1, $col + 1) = $props[$col]
        }

        # Write data rows
        for ($row = 0; $row -lt $Data.Count; $row++) {
            for ($col = 0; $col -lt $props.Count; $col++) {
                $value = $Data[$row].PSObject.Properties[$props[$col]].Value
                $sheet.Cells.Item($row + 2, $col + 1) = $value
            }
        }

        # Auto-fit for readability
        $usedRange = $sheet.UsedRange
        $usedRange.Columns.AutoFit()
    } catch {
        Write-Error "Error writing to Excel sheet '$SheetName': $_"
    }
}


###################################################################################################################################


# --- Section 1: System Information ---
Write-Progress -Activity "Collecting System Info" -Status "Running"

# Gather system-level and user context information
$systemInfo = [PSCustomObject]@{
    Hostname        = $env:COMPUTERNAME
    UserDomain      = $env:USERDOMAIN
    Username        = $env:USERNAME
    SID             = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value
    IsAdmin         = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    SystemTimeLocal = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    SystemTimeUTC   = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm:ss")
    TimeZone        = (Get-TimeZone).Id
    BootTime        = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime.ToString("yyyy-MM-dd HH:mm:ss")
}

# Output system info to Excel
Save-ToExcelSheet -SheetName "System Information" -Data @($systemInfo)


###################################################################################################################################


# --- Section 2: Installed Programs ---
Write-Progress -Activity "Collecting Installed Programs" -Status "Running"

# Registry paths for both 64-bit, 32-bit, and current user
$registryPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

# Collect and normalize installed program info
$installedPrograms = foreach ($path in $registryPaths) {
    try {
        Get-ItemProperty $path -ErrorAction Stop |
        Where-Object { $_.DisplayName -and $_.DisplayName.Trim() -ne "" } |
        Select-Object `
            @{Name="DisplayName";Expression={$_.DisplayName}},
            @{Name="DisplayVersion";Expression={$_.DisplayVersion}},
            @{Name="Publisher";Expression={$_.Publisher}},
            @{Name="InstallDate";Expression={
                # Normalize InstallDate if present (can be YYYYMMDD or missing)
                if ($_.InstallDate -match '^\d{8}$') {
                    [datetime]::ParseExact($_.InstallDate, 'yyyyMMdd', $null).ToString('yyyy-MM-dd')
                } else {
                    $_.InstallDate
                }
            }}
    } catch {
        Write-Warning "Failed to read from registry path: $path"
    }
}

# Export to Excel
Save-ToExcelSheet -SheetName "Installed Programs" -Data $installedPrograms


###################################################################################################################################


# --- Section 3: Environment Variables ---
Write-Progress -Activity "Collecting Environment Variables" -Status "Running"

$envVars = @()

# Collect user-scoped environment variables
try {
    [System.Environment]::GetEnvironmentVariables("User").GetEnumerator() | ForEach-Object {
        $envVars += [PSCustomObject]@{
            Scope = "User"
            Name  = $_.Key
            Value = $_.Value
        }
    }
} catch {
    Write-Warning "Failed to collect user environment variables: $_"
}

# Collect system-scoped environment variables
try {
    [System.Environment]::GetEnvironmentVariables("Machine").GetEnumerator() | ForEach-Object {
        $envVars += [PSCustomObject]@{
            Scope = "System"
            Name  = $_.Key
            Value = $_.Value
        }
    }
} catch {
    Write-Warning "Failed to collect system environment variables: $_"
}

# Export to Excel
Save-ToExcelSheet -SheetName "Environment Variables" -Data $envVars

# Optional: Export all collected variables to CSV for flat review
$envVars | Sort-Object Scope, Name | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8


###################################################################################################################################


# --- Section 4: UAC Settings ---
Write-Progress -Activity "Collecting UAC Settings" -Status "Running"

$uacRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

try {
    $uac = Get-ItemProperty -Path $uacRegistryPath

    $translate = [PSCustomObject]@{
        ConsentPromptBehaviorAdmin = switch ($uac.ConsentPromptBehaviorAdmin) {
            0 {"No Prompt (Elevate silently)"} 
            1 {"Prompt for credentials on secure desktop"}
            2 {"Prompt for consent on secure desktop"} 
            3 {"Prompt for credentials"}
            4 {"Prompt for consent"} 
            5 {"Prompt for consent for non-Windows binaries"} 
            default {"Unknown"}
        }
        ConsentPromptBehaviorUser = switch ($uac.ConsentPromptBehaviorUser) {
            0 {"Automatically deny elevation"} 
            1 {"Prompt for credentials on secure desktop"}
            3 {"Prompt for consent"} 
            default {"Unknown"}
        }
        EnableLUA                   = if ($uac.EnableLUA -eq 1) { "UAC Enabled" } else { "UAC Disabled" }
        PromptOnSecureDesktop       = if ($uac.PromptOnSecureDesktop -eq 1) { "Secure desktop ON" } else { "Secure desktop OFF" }
        EnableVirtualization        = if ($uac.EnableVirtualization -eq 1) { "Enabled" } else { "Disabled" }
        ValidateAdminCodeSignatures = if ($uac.ValidateAdminCodeSignatures -eq 1) { "Validation Required" } else { "Not Required" }
        FilterAdministratorToken    = if ($uac.FilterAdministratorToken -eq 1) { "Split Token" } else { "Full Token" }
    }

    Save-ToExcelSheet -SheetName "UAC Settings" -Data @($translate)

} catch {
    Write-Host "[!] Unable to retrieve UAC settings: $_" -ForegroundColor Red
}


###################################################################################################################################


# --- Section 5: Windows Version Info ---
Write-Progress -Activity "Collecting Windows Version Info" -Status "Running"

function Safe-ToDateTime {
    param ($dmtfDate)
    if ([string]::IsNullOrWhiteSpace($dmtfDate) -or $dmtfDate -notmatch '^\d{14}\.') {
        return "Unavailable"
    }
    try {
        return [Management.ManagementDateTimeConverter]::ToDateTime($dmtfDate)
    } catch {
        return "Invalid Format"
    }
}

# Query OS version info via CIM
$os = Get-CimInstance Win32_OperatingSystem

# Construct output object
$winInfo = [PSCustomObject]@{
    Caption        = $os.Caption
    Version        = $os.Version
    BuildNumber    = $os.BuildNumber
    Architecture   = $os.OSArchitecture
    InstallDate    = Safe-ToDateTime $os.InstallDate
    LastBootUpTime = Safe-ToDateTime $os.LastBootUpTime
}

# Output to Excel
Save-ToExcelSheet -SheetName "Windows Version" -Data @($winInfo)


###################################################################################################################################


# --- Section 6: Desktop File Timestamps (Non-Recursive) ---
Write-Progress -Activity "Collecting Desktop File Timestamps" -Status "Running"

$targetPath = [Environment]::GetFolderPath("Desktop")
$files = Get-ChildItem -Path $targetPath -File -ErrorAction SilentlyContinue

$nonRecursiveFiles = @()
foreach ($file in $files) {
    $nonRecursiveFiles += [PSCustomObject]@{
        Name         = $file.Name
        FullPath     = $file.FullName
        LastModified = $file.LastWriteTime
    }
}

Save-ToExcelSheet -SheetName "Desktop File Timestamps" -Data $nonRecursiveFiles


###################################################################################################################################


# --- Section 7: File Metadata ---
Write-Progress -Activity "Collecting File Metadata" -Status "Scanning..."

$fileTimeData = @()
$userPath = $env:USERPROFILE

try {
    $allFiles = Get-ChildItem -Path $userPath -Recurse -File -Force -ErrorAction Stop
} catch {
    Write-Warning "Unable to enumerate files in ${userPath}: $_"
    $allFiles = @()
}

$total = $allFiles.Count
$count = 0

foreach ($file in $allFiles) {
    $count++
    Write-Progress -Activity "Collecting File Metadata" -Status "$count of $total files" -PercentComplete (($count / $total) * 100)

    $fileTimeData += [PSCustomObject]@{
        Name         = $file.Name
        FullPath     = $file.FullName
        CreationTime = $file.CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
        LastModified = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        LastAccessed = $file.LastAccessTime.ToString("yyyy-MM-dd HH:mm:ss")
    }
}

if ($fileTimeData.Count -gt 0) {
    Save-ToExcelSheet -SheetName "File Timestamps" -Data $fileTimeData
} else {
    Write-Warning "No files found under $userPath"
}


###################################################################################################################################


# --- Section 8: Hidden Files on C:\ ---
Write-Progress -Activity "Collecting Hidden Files" -Status "Running"

$hiddenData = @()

try {
    $hiddenFiles = Get-ChildItem -Path "C:\" -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Attributes -band [System.IO.FileAttributes]::Hidden }

    # Only capture accessible files
    foreach ($file in $hiddenFiles) {
        try {
            $hiddenData += [PSCustomObject]@{
                FullName   = $file.FullName
                SizeKB     = [math]::Round($file.Length / 1KB, 2)
                Created    = $file.CreationTime
                Modified   = $file.LastWriteTime
                Accessed   = $file.LastAccessTime
            }
        } catch {
            Write-Warning "Could not access metadata for: $($file.FullName) - $_"
        }
    }
} catch {
    Write-Warning "Error collecting hidden files from C:\: $_"
}

if ($hiddenData.Count -eq 0) {
    Write-Warning "No hidden files found on C:\ or access denied."
}


###################################################################################################################################


# --- Section 9: Alternate Data Streams (ADS) ---
Write-Progress -Activity "Collecting ADS Streams" -Status "Running"

$adsResults = @()
$adsPath = [Environment]::GetFolderPath("Desktop")

try {
    $files = Get-ChildItem -Path $adsPath -Recurse -File -Force -ErrorAction Stop

    foreach ($file in $files) {
        $streams = Get-Item -Path $file.FullName -Stream * -ErrorAction SilentlyContinue

        foreach ($stream in $streams) {
            # Skip default unnamed data stream
            if ($stream.Stream -ne '::$DATA') {
                $adsResults += [PSCustomObject]@{
                    File   = $file.FullName
                    Stream = $stream.Stream
                    Length = $stream.Length
                }
            }
        }
    }

    if ($adsResults.Count -gt 0) {
        Save-ToExcelSheet -SheetName "ADS" -Data $adsResults
    } else {
        Write-Warning "No alternate data streams found on $adsPath"
    }

} catch {
    Write-Warning "Error scanning for ADS on ${adsPath}: $_"
}


###################################################################################################################################


# --- Section 10: Files Accessed in Last 30 Days ---
Write-Progress -Activity "Collecting Recently Accessed Files" -Status "Running"

$daysBack = 30
$cutoffDate = (Get-Date).AddDays(-$daysBack)
$targetPath = "C:\"
$recentlyAccessed = @()

try {
    Get-ChildItem -Path $targetPath -Recurse -File -Force -ErrorAction SilentlyContinue |
    ForEach-Object {
        try {
            if ($_.LastAccessTime -gt $cutoffDate) {
                $recentlyAccessed += [PSCustomObject]@{
                    FullName        = $_.FullName
                    LastAccessTime  = $_.LastAccessTime
                    SizeKB          = [math]::Round($_.Length / 1KB, 2)
                    LastWriteTime   = $_.LastWriteTime
                    Created         = $_.CreationTime
                }
            }
        } catch {
            Write-Warning "Error accessing metadata for: $($_.FullName) - $_"
        }
    }
} catch {
    Write-Warning "Error collecting file access times on C:\: $_"
}

if ($recentlyAccessed.Count -eq 0) {
    Write-Warning "No recently accessed files found or access denied."
}


###################################################################################################################################


# --- Section 11: Recycle Bin Contents ---
Write-Progress -Activity "Collecting Recycle Bin Contents" -Status "Initializing"

$recycleBinData = @()

try {
    $shell = New-Object -ComObject Shell.Application
    $recycleBin = $shell.Namespace(0xA)
    $items = $recycleBin.Items()
    $total = $items.Count

    for ($i = 0; $i -lt $total; $i++) {
        Write-Progress -Activity "Collecting Recycle Bin Contents" -Status "$($i+1) of $total items" -PercentComplete ((($i+1) / $total) * 100)

        $item = $items.Item($i)

        $recycleBinData += [PSCustomObject]@{
            'Original Path' = $recycleBin.GetDetailsOf($item, 1)
            'Deleted Date'  = $recycleBin.GetDetailsOf($item, 2)
            'Size (bytes)'  = $recycleBin.GetDetailsOf($item, 3)
            'Name'          = $item.Name
        }
    }

    if ($recycleBinData.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Recycle Bin" -Data $recycleBinData
    } else {
        Write-Warning "No items found in Recycle Bin."
    }

} catch {
    Write-Warning "Failed to access Recycle Bin: $_"
}


###################################################################################################################################


# --- Section 12: Temp Folder Contents ---
Write-Progress -Activity "Collecting Temp Folder Contents" -Status "Running"

$tempPath = $env:TEMP
$tempFiles = @()

try {
    $items = Get-ChildItem -Path $tempPath -Recurse -Force -ErrorAction Stop

    foreach ($item in $items) {
        $tempFiles += [PSCustomObject]@{
            FullName       = $item.FullName
            Length         = $item.Length
            LastWriteTime  = $item.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        }
    }

    $tempFiles = $tempFiles | Sort-Object LastWriteTime -Descending

    if ($tempFiles.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Temp Folder" -Data $tempFiles
    } else {
        Write-Warning "No files found in TEMP folder: $tempPath"
    }

} catch {
    Write-Warning "Unable to scan TEMP folder at ${tempPath}: $_"
}


###################################################################################################################################


# --- Section 13: Volume Shadow Copies ---
Write-Progress -Activity "Collecting Volume Shadow Copies" -Status "Running"

$shadowCopies = @()

# Try WMI/CIM method first
try {
    $shadowInstances = Get-CimInstance -Namespace "root\cimv2" -ClassName Win32_ShadowCopy -ErrorAction Stop
    foreach ($shadow in $shadowInstances) {
        $shadowCopies += [PSCustomObject]@{
            ID          = $shadow.ID
            VolumeName  = $shadow.VolumeName
            InstallDate = $shadow.InstallDate
        }
    }
} catch {
    Write-Warning "WMI method failed: $_"
    Write-Warning "Attempting fallback using 'vssadmin list shadows'..."

    try {
        $vssOutput = vssadmin list shadows 2>&1
        $current = @{}
        foreach ($line in $vssOutput) {
            if ($line -match "Shadow Copy ID:\s+({.*})") {
                $current.ID = $matches[1]
            }
            elseif ($line -match "Original Volume:\s+(.*)") {
                $current.VolumeName = $matches[1]
            }
            elseif ($line -match "Creation Time:\s+(.*)") {
                $current.InstallDate = $matches[1]
                # Add the complete record when all fields are present
                $shadowCopies += [PSCustomObject]$current
                $current = @{}
            }
        }
    } catch {
        Write-Warning "Fallback to 'vssadmin' also failed: $_"
    }
}

if ($shadowCopies.Count -eq 0) {
    Write-Warning "No shadow copies found or access denied."
}


###################################################################################################################################


# --- Section 14: Symbolic Links and Junctions ---
Write-Progress -Activity "Collecting Symbolic Links and Junctions" -Status "Running"

$targetPath = "C:\"  # Modify this path if narrowing scope is necessary
$reparsePoints = @()

try {
    $reparsePoints = Get-ChildItem -Path "C:\" -Recurse -Force -ErrorAction Stop |
        Where-Object { $_.Attributes -match "ReparsePoint" } | ForEach-Object {
            [PSCustomObject]@{
                FullName   = $_.FullName
                Attributes = $_.Attributes
                LinkType   = $_.LinkType
            }
        }
} catch {
    Write-Warning "Failed to collect symbolic links from C:\: $_"
    $reparsePoints = @()
}


###################################################################################################################################


# --- Section 15: Running Processes ---
Write-Progress -Activity "Collecting Running Processes" -Status "Running"

$processList = @()

try {
    Get-Process | ForEach-Object {
        $proc = $_
        $name = $proc.Name
        $id   = $proc.Id

        # Initialize fallback values
        $path = "ACCESS_DENIED"
        $startTime = "ACCESS_DENIED"

        try {
            if ($proc.PSObject.Properties.Match('Path')) {
                $path = $proc.Path
            }
        } catch {
            Write-Warning "Access denied to path for process: $name ($id)"
        }

        try {
            $startTime = $proc.StartTime.ToString("yyyy-MM-dd HH:mm:ss")
        } catch {
            Write-Warning "Access denied to start time for process: $name ($id)"
        }

        $processList += [PSCustomObject]@{
            Name      = $name
            Id        = $id
            Path      = $path
            StartTime = $startTime
        }
    }

    $processList = $processList | Sort-Object StartTime
    Save-ToExcelSheet -SheetName "Running Processes" -Data $processList
} catch {
    Write-Warning "Failed to enumerate running processes: $_"
}



###################################################################################################################################


# --- Section 16: Loaded DLLs ---
Write-Progress -Activity "Collecting Loaded DLLs" -Status "Running"

function Get-FileHashSafe {
    param ($path)
    try {
        if (Test-Path $path) {
            return (Get-FileHash -Algorithm SHA256 -Path $path -ErrorAction Stop).Hash
        } else {
            return "N/A"
        }
    } catch {
        return "HashError"
    }
}

function Get-SignatureStatus {
    param ($path)
    try {
        if (Test-Path $path) {
            $sig = Get-AuthenticodeSignature -FilePath $path -ErrorAction Stop
            return $sig.Status.ToString()
        } else {
            return "N/A"
        }
    } catch {
        return "SigError"
    }
}

function Get-CompanyName {
    param ($path)
    try {
        if (Test-Path $path) {
            return (Get-Item -Path $path).VersionInfo.CompanyName
        } else {
            return "N/A"
        }
    } catch {
        return "Error"
    }
}

$dllList = @()
$allProcesses = Get-Process -ErrorAction SilentlyContinue
$total = $allProcesses.Count
$count = 0

foreach ($proc in $allProcesses) {
    $count++
    Write-Progress -Activity "Collecting Loaded DLLs" -Status "$count of $total processes" -PercentComplete (($count / $total) * 100)

    try {
        foreach ($mod in $proc.Modules) {
            $hash = Get-FileHashSafe -path $mod.FileName
            $sig  = Get-SignatureStatus -path $mod.FileName
            $company = Get-CompanyName -path $mod.FileName

            $suspiciousPath = if ($mod.FileName -match "AppData|Temp|Roaming|Downloads") { $true } else { $false }

            $dllList += [PSCustomObject]@{
                ProcessName    = $proc.Name
                PID            = $proc.Id
                ModuleName     = $mod.ModuleName
                FilePath       = $mod.FileName
                SHA256         = $hash
                Signature      = $sig
                CompanyName    = $company
                SuspiciousPath = $suspiciousPath
            }
        }
    } catch {
        # Fallback record if access is denied to modules
        $dllList += [PSCustomObject]@{
            ProcessName    = $proc.Name
            PID            = $proc.Id
            ModuleName     = "[ACCESS DENIED]"
            FilePath       = "N/A"
            SHA256         = "N/A"
            Signature      = "N/A"
            CompanyName    = "N/A"
            SuspiciousPath = $false
        }
    }
}

# Save with error protection
try {
    if ($dllList.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Loaded DLLs" -Data $dllList
    } else {
        Write-Warning "No DLLs collected from running processes."
    }
} catch {
    Write-Warning "Excel export failed. Writing to fallback CSV instead: $_"
    $dllList | Export-Csv -Path "$env:USERPROFILE\Desktop\Loaded_DLLs_Fallback.csv" -NoTypeInformation -Force
}


###################################################################################################################################


# --- Section 17: Process Tree ---
Write-Progress -Activity "Collecting Process Tree (WMI)" -Status "Running"

$processTree = @()

try {
    $wmiProcs = Get-WmiObject Win32_Process -ErrorAction Stop

    foreach ($proc in $wmiProcs) {
        try {
            # Initialize defaults
            $name       = $proc.Name
            $pid        = $proc.ProcessId
            $ppid       = $proc.ParentProcessId
            $cmdline    = $proc.CommandLine -as [string]
            $startTime  = "Unavailable"
            $user       = "Unavailable"

            # Safe DMTF date conversion
            try {
                if ($proc.CreationDate -and $proc.CreationDate -match '^\d{14}\.\d{6}\+\d{3}$') {
                    $startTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($proc.CreationDate).ToString("yyyy-MM-dd HH:mm:ss")
                } else {
                    Write-Warning "Skipping invalid CreationDate for $name ($pid)"
                }
            } catch {
                Write-Warning "Error parsing CreationDate for $name ($pid): $_"
            }

            # Get user context
            try {
                $owner = $proc.GetOwner()
                if ($owner.User) {
                    $user = "$($owner.Domain)\$($owner.User)"
                }
            } catch {
                Write-Warning "Unable to get user for $name ($pid): $_"
            }

            # Add result
            $processTree += [PSCustomObject]@{
                Name         = $name
                PID          = $pid
                ParentPID    = $ppid
                CommandLine  = if ($cmdline) { $cmdline } else { "Unavailable" }
                StartTime    = $startTime
                User         = $user
            }

        } catch {
            Write-Warning "Error processing WMI process object: $_"
        }
    }

    if ($processTree.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Process Tree" -Data $processTree
    } else {
        Write-Warning "No process tree data collected."
    }

} catch {
    Write-Warning "Failed to enumerate WMI process tree: $_"
}



###################################################################################################################################


# --- Section 18: PowerShell Command History ---
Write-Progress -Activity "Collecting PowerShell History" -Status "Running"

$psHistory = New-Object System.Collections.Generic.List[object]

# First check for PowerShell transcript logs
$transcriptPaths = @(
    "$env:USERPROFILE\Documents\PowerShell_transcript.*.txt",
    "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
)

$transcriptFound = $false

foreach ($path in $transcriptPaths) {
    $files = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        $lines = Get-Content $file.FullName -ErrorAction SilentlyContinue
        $lineNum = 0
        foreach ($line in $lines) {
            $lineNum++
            $psHistory.Add([PSCustomObject]@{
                Timestamp = (Get-Item $file.FullName).LastWriteTime
                LineNumber = $lineNum
                Command    = $line
            })
        }
        $transcriptFound = $true
    }
}

if (-not $transcriptFound) {
    Write-Warning "No transcript logs found. Falling back to raw ConsoleHost_history.txt"

    $histFile = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt"
    if (Test-Path $histFile) {
        $lines = Get-Content $histFile -ErrorAction SilentlyContinue
        $lineNum = 0
        foreach ($line in $lines) {
            $lineNum++
            $psHistory.Add([PSCustomObject]@{
                Timestamp  = (Get-Item $histFile).LastWriteTime
                LineNumber = $lineNum
                Command    = $line
            })
        }
    } else {
        Write-Warning "No PowerShell history or transcript logs found."
    }
}

Save-ToExcelSheet -SheetName "PS History" -Data $psHistory


###################################################################################################################################


# --- Section 19: Parent/Child Process Tree (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Parent/Child Process Tree" -Status "Running"

$processTree = New-Object System.Collections.Generic.List[object]

try {
    $allProcs = Get-CimInstance Win32_Process -ErrorAction Stop

    foreach ($proc in $allProcs) {
        try {
            $creationDate = if ($proc.CreationDate) {
                [Management.ManagementDateTimeConverter]::ToDateTime($proc.CreationDate).ToString("yyyy-MM-dd HH:mm:ss")
            } else {
                "Unavailable"
            }

            $processTree.Add([PSCustomObject]@{
                ProcessName     = $proc.Name
                ProcessId       = $proc.ProcessId
                ParentProcessId = $proc.ParentProcessId
                ExecutablePath  = $proc.ExecutablePath
                CommandLine     = $proc.CommandLine
                CreationDate    = $creationDate
            })
        } catch {
            Write-Warning "Error parsing process $($proc.Name): $_"
        }
    }

    $sortedTree = $processTree | Sort-Object CreationDate

    if ($sortedTree.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Proc Tree" -Data $sortedTree
    } else {
        Write-Warning "No process tree data was collected."
    }

} catch {
    Write-Warning "Unable to retrieve parent/child process data: $_"
}


###################################################################################################################################


# --- Section 20: WMI Activity Logs (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting WMI Activity Logs" -Status "Running"

$logName = "Microsoft-Windows-WMI-Activity/Operational"
$wmiEvents = New-Object System.Collections.Generic.List[object]

try {
    $logStatus = Get-WinEvent -ListLog $logName -ErrorAction SilentlyContinue
    if (-not $logStatus -or $logStatus.IsEnabled -eq $false) {
        Write-Warning "WMI Activity log '$logName' not found or disabled."
    } else {
        $events = Get-WinEvent -LogName $logName -MaxEvents 100 -ErrorAction Stop
        foreach ($evt in $events) {
            try {
                $eventXml = [xml]$evt.ToXml()
                $data = $eventXml.Event.EventData.Data
                $eventId = $evt.Id

                $eventType = switch ($eventId) {
                    5857 { "Query Execution Started" }
                    5858 { "Query Execution Completed" }
                    5859 { "Query Execution Error" }
                    5860 { "Query Cancelled" }
                    5861 { "Consumer Initialization" }
                    5862 { "Consumer Deactivation" }
                    default { "Other/Unknown" }
                }

                # Defensive extraction of WMI fields
                $processId = if ($data.Count -gt 0) { $data[0].'#text' } else { "Unavailable" }
                $user      = if ($data.Count -gt 1) { $data[1].'#text' } else { "Unavailable" }
                $operation = if ($data.Count -gt 2) { $data[2].'#text' } else { "Unavailable" }
                $namespace = if ($data.Count -gt 3) { $data[3].'#text' } else { "Unavailable" }
                $query     = if ($data.Count -gt 4) { $data[4].'#text' } else { "Unavailable" }

                $wmiEvents.Add([PSCustomObject]@{
                    TimeCreated = $evt.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
                    EventID     = $eventId
                    EventType   = $eventType
                    ProcessID   = $processId
                    User        = $user
                    Operation   = $operation
                    Namespace   = $namespace
                    Query       = $query
                })

            } catch {
                Write-Warning "Error parsing WMI event: $_"
                $wmiEvents.Add([PSCustomObject]@{
                    TimeCreated = $evt.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
                    EventID     = $evt.Id
                    EventType   = "ParseError"
                    Details     = "Error parsing XML or missing fields"
                })
            }
        }

        if ($wmiEvents.Count -gt 0) {
            Save-ToExcelSheet -SheetName "WMI Logs" -Data $wmiEvents
        } else {
            Write-Warning "No WMI Activity events were collected."
        }
    }
} catch {
    Write-Warning "Unable to collect WMI Activity logs: $_"
}


###################################################################################################################################


# --- Section 21: Scheduled Tasks (DFIR-Enhanced) ---
Write-Progress -Activity "Collecting Scheduled Tasks" -Status "Running"

function Get-FileHashSafe {
    param ($path)
    try {
        if ($path -and -not [string]::IsNullOrWhiteSpace($path) -and (Test-Path -Path $path -PathType Leaf)) {
            return (Get-FileHash -Path $path -Algorithm SHA256 -ErrorAction Stop).Hash
        }
        return "Not Found"
    } catch {
        return "HashError"
    }
}

$scheduledTasks = @()

try {
    $allTasks = Get-ScheduledTask -ErrorAction Stop

    foreach ($task in $allTasks) {
        try {
            $info = Get-ScheduledTaskInfo -TaskName $task.TaskName -TaskPath $task.TaskPath -ErrorAction Stop

            $actions = ($task.Actions | ForEach-Object { $_.Execute -as [string] }) -join '; '
            $triggers = ($task.Triggers | ForEach-Object { $_.StartBoundary }) -join '; '

            $suspiciousPath = if ($actions -match "AppData|Temp|Downloads|\\Users\\.*\\") { $true } else { $false }
            $suspiciousTrigger = if ($triggers -match "01:|02:|03:|04:|AtLogon|AtStartup|Repetition") { $true } else { $false }

            # Get the first executable path and sanitize
            $exePath = ($task.Actions | ForEach-Object { $_.Execute -as [string] })[0]
            $exePath = $exePath -replace '"', ''  # Remove any surrounding quotes
            $exePath = $exePath.Trim()

            # Attempt to resolve if path does not exist
            if ($exePath -and -not [string]::IsNullOrWhiteSpace($exePath) -and -not (Test-Path $exePath)) {
                $resolved = Get-Command $exePath -ErrorAction SilentlyContinue
                if ($resolved) { $exePath = $resolved.Source }
            }

            $sha256 = if ($exePath) { Get-FileHashSafe -path $exePath } else { "N/A" }

            $scheduledTasks += [PSCustomObject]@{
                TaskName           = $task.TaskName
                TaskPath           = $task.TaskPath
                State              = $task.State
                LastRunTime        = if ($info.LastRunTime) { $info.LastRunTime.ToString("yyyy-MM-dd HH:mm:ss") } else { "Never" }
                NextRunTime        = if ($info.NextRunTime) { $info.NextRunTime.ToString("yyyy-MM-dd HH:mm:ss") } else { "N/A" }
                LastResult         = $info.LastTaskResult
                Hidden             = $task.Settings.Hidden -as [bool]
                Principal          = $task.Principal.UserId -as [string]
                Action             = $actions
                Trigger            = $triggers
                SHA256             = $sha256
                SuspiciousPath     = $suspiciousPath
                SuspiciousTrigger  = $suspiciousTrigger
            }

        } catch {
            $scheduledTasks += [PSCustomObject]@{
                TaskName           = $task.TaskName
                TaskPath           = $task.TaskPath
                State              = $task.State
                LastRunTime        = "Unavailable"
                NextRunTime        = "Unavailable"
                LastResult         = "Unavailable"
                Hidden             = $task.Settings.Hidden -as [bool]
                Principal          = $task.Principal.UserId -as [string]
                Action             = "Unavailable"
                Trigger            = "Unavailable"
                SHA256             = "N/A"
                SuspiciousPath     = $false
                SuspiciousTrigger  = $false
            }
        }
    }

    if ($scheduledTasks.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Scheduled Tasks" -Data $scheduledTasks
    } else {
        Write-Warning "No scheduled tasks found."
    }

} catch {
    Write-Warning "Scheduled Task enumeration failed: $_"
}



###################################################################################################################################


# --- Section 22: Startup Folder Items (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Startup Folder Items" -Status "Running"

function Get-FileHashSafe {
    param ($path)
    try {
        if (Test-Path $path -PathType Leaf) {
            return (Get-FileHash -Algorithm SHA256 -Path $path -ErrorAction Stop).Hash
        }
        return "Not Found"
    } catch {
        return "HashError"
    }
}

function Get-StartupItems {
    param ([string]$user, [string]$folder)
    $items = @()
    if (Test-Path $folder) {
        Get-ChildItem -Path $folder -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
            $hash = Get-FileHashSafe -path $_.FullName
            $suspicious = if ($_.FullName -match 'AppData|Temp|Roaming|Downloads|\.ps1|\.vbs|\.bat|\.cmd|\.js|\.lnk') { $true } else { $false }

            $items += [PSCustomObject]@{
                User         = $user
                ItemName     = $_.Name
                FullPath     = $_.FullName
                LastModified = $_.LastWriteTime
                SHA256       = $hash
                Suspicious   = $suspicious
            }
        }
    }
    return $items
}

$startupItems = @()

# Current user
$currentUser = $env:USERNAME
$currentUserPath = Join-Path $env:APPDATA "Microsoft\\Windows\\Start Menu\\Programs\\Startup"
$startupItems += Get-StartupItems -user $currentUser -folder $currentUserPath

# All users
$commonStartup = "$env:ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"
$startupItems += Get-StartupItems -user "AllUsers" -folder $commonStartup

# All profile startup folders
$profiles = Get-ChildItem "C:\\Users" -Directory -ErrorAction SilentlyContinue
foreach ($profile in $profiles) {
    $userName = $profile.Name
    $profileStartup = Join-Path $profile.FullName "AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"
    $startupItems += Get-StartupItems -user $userName -folder $profileStartup
}

if ($startupItems.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Startup Folder" -Data $startupItems
} else {
    Write-Warning "No startup folder items found."
}


###################################################################################################################################


# --- Section 23: Registry Run Keys (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Registry Run Keys" -Status "Running"

function Get-FileHashSafe {
    param ($path)
    try {
        if (Test-Path $path -PathType Leaf) {
            return (Get-FileHash -Algorithm SHA256 -Path $path -ErrorAction Stop).Hash
        }
        return "Not Found"
    } catch {
        return "HashError"
    }
}

function Extract-ExecutablePath {
    param ($commandLine)
    if ($commandLine -match '"([^"]+\.exe)"') {
        return $matches[1]
    } elseif ($commandLine -match '^([^\s]+\.exe)') {
        return $matches[1]
    } elseif ($commandLine -match '^rundll32\.exe\s+([^\s,]+)') {
        return $matches[1]
    } else {
        return $null
    }
}

$runKeys = @(
    "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Run",
    "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce",
    "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\Run",
    "HKLM:\\Software\\Microsoft\\Windows\\CurrentVersion\\RunOnce"
)

$runEntries = @()

foreach ($key in $runKeys) {
    if (Test-Path $key) {
        Get-ItemProperty -Path $key -ErrorAction SilentlyContinue | ForEach-Object {
            $_.PSObject.Properties | Where-Object { $_.Name -notin "PSPath","PSParentPath","PSChildName","PSDrive","PSProvider" } | ForEach-Object {
                $name = $_.Name
                $val = $_.Value
                $exePath = Extract-ExecutablePath $val
                $hash = if ($exePath) { Get-FileHashSafe -path $exePath } else { "N/A" }
                $suspicious = if ($val -match "AppData|Temp|Roaming|Downloads|\.bat|\.ps1|\.vbs|\.js|rundll32\.exe") { $true } else { $false }

                $runEntries += [PSCustomObject]@{
                    RegistryPath  = $key
                    Name          = $name
                    Value         = $val
                    Executable    = $exePath
                    SHA256        = $hash
                    Suspicious    = $suspicious
                }
            }
        }
    }
}

if ($runEntries.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Registry Run Keys" -Data $runEntries
} else {
    Write-Warning "No Run key entries found."
}


###################################################################################################################################


# --- Section 24: Services (DFIR Enhanced + Signature Check) ---
Write-Progress -Activity "Collecting Service Information" -Status "Running"

function Get-FileHashSafe {
    param ($path)
    try {
        if ($path -and (Test-Path $path -PathType Leaf)) {
            return (Get-FileHash -Path $path -Algorithm SHA256 -ErrorAction Stop).Hash
        }
        return "Not Found"
    } catch {
        return "HashError"
    }
}

function Get-SignatureInfo {
    param ($path)
    try {
        if (Test-Path $path -PathType Leaf) {
            $sig = Get-AuthenticodeSignature -FilePath $path
            return @{
                IsSigned         = ($sig.Status -eq 'Valid')
                SignatureStatus  = $sig.Status.ToString()
                Publisher        = $sig.SignerCertificate.Subject
            }
        }
    } catch {
        return @{
            IsSigned         = $false
            SignatureStatus  = "CheckFailed"
            Publisher        = "Unknown"
        }
    }
    return @{
        IsSigned         = $false
        SignatureStatus  = "NotFound"
        Publisher        = "None"
    }
}

function Extract-BinaryPath {
    param ($pathString)
    if ($pathString -match '"([^"]+\.exe)"') {
        return $matches[1]
    } elseif ($pathString -match '^([^\s]+\.exe)') {
        return $matches[1]
    } elseif ($pathString -match 'rundll32\.exe\s+([^\s,]+)') {
        return $matches[1]
    } else {
        return $null
    }
}

$services = Get-CimInstance Win32_Service -ErrorAction SilentlyContinue | ForEach-Object {
    $exe = Extract-BinaryPath $_.PathName
    $hash = if ($exe) { Get-FileHashSafe -path $exe } else { "N/A" }
    $sig = if ($exe) { Get-SignatureInfo -path $exe } else {
        @{ IsSigned = $false; SignatureStatus = "N/A"; Publisher = "N/A" }
    }

    $suspicious = (
        $_.PathName -match "AppData|Temp|Roaming|Downloads|\.bat|\.vbs|\.ps1|\.js" -or
        -not $sig.IsSigned
    )

    [PSCustomObject]@{
        Name             = $_.Name
        DisplayName      = $_.DisplayName
        State            = $_.State
        StartMode        = $_.StartMode
        PathName         = $_.PathName
        Executable       = $exe
        SHA256           = $hash
        IsSigned         = $sig.IsSigned
        SignatureStatus  = $sig.SignatureStatus
        Publisher        = $sig.Publisher
        Suspicious       = $suspicious
        Description      = $_.Description
    }
}

Save-ToExcelSheet -SheetName "Services" -Data $services


###################################################################################################################################


# --- Section 25: WMI Event Consumers (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting WMI Event Consumers" -Status "Running"

$wmiConsumers = @()

try {
    # Get all base event consumers
    $baseConsumers = Get-WmiObject -Namespace "root\\subscription" -Class __EventConsumer -ErrorAction Stop

    foreach ($consumer in $baseConsumers) {
        $wmiConsumers += [PSCustomObject]@{
            Name         = $consumer.Name
            ConsumerType = $consumer.__CLASS
            CommandLine  = $consumer.CommandLine
            Executable   = if ($consumer.CommandLine -match '("([^"]+\.exe)"|^(\S+\.exe))') {
                              $matches[2] + $matches[3]
                          } else { $null }
            Suspicious   = if ($consumer.CommandLine -match "AppData|Temp|Roaming|Downloads|powershell|cmd|wscript|cscript|\.vbs|\.ps1|\.bat|\.js") { $true } else { $false }
        }
    }
} catch {
    Write-Warning "No WMI Event Consumers found or access was denied."
}

if ($wmiConsumers.Count -gt 0) {
    Save-ToExcelSheet -SheetName "WMI Consumers" -Data $wmiConsumers
} else {
    Write-Host "[*] No WMI Consumers found." -ForegroundColor Yellow
}


###################################################################################################################################


# --- Section 26: COM Hijacking Detection (DFIR Enhanced) ---
Write-Progress -Activity "Collecting COM Hijacking Entries" -Status "Running"

function Get-FileHashSafe {
    param ($path)
    try {
        if ($path -and (Test-Path $path -PathType Leaf)) {
            return (Get-FileHash -Path $path -Algorithm SHA256 -ErrorAction Stop).Hash
        }
        return "Not Found"
    } catch {
        return "HashError"
    }
}

function Get-SignatureInfo {
    param ($path)
    try {
        if (Test-Path $path -PathType Leaf) {
            $sig = Get-AuthenticodeSignature -FilePath $path
            return @{
                IsSigned         = ($sig.Status -eq 'Valid')
                SignatureStatus  = $sig.Status.ToString()
                Publisher        = $sig.SignerCertificate.Subject
            }
        }
    } catch {
        return @{
            IsSigned         = $false
            SignatureStatus  = "CheckFailed"
            Publisher        = "Unknown"
        }
    }
    return @{
        IsSigned         = $false
        SignatureStatus  = "NotFound"
        Publisher        = "None"
    }
}

$comHijackPaths = @(
    "HKCU:\\Software\\Classes\\CLSID",
    "HKLM:\\Software\\Classes\\CLSID"
)

$comHijackData = @()

foreach ($path in $comHijackPaths) {
    if (Test-Path $path) {
        Get-ChildItem -Path $path -ErrorAction SilentlyContinue | ForEach-Object {
            $clsidKey = $_.PSPath
            try {
                $inproc = Get-ItemProperty -Path "$clsidKey\\InprocServer32" -ErrorAction SilentlyContinue
                $dll = $inproc.'(default)'

                if ($dll -and $dll -ne "") {
                    $hash = Get-FileHashSafe -path $dll
                    $sig = Get-SignatureInfo -path $dll
                    $suspicious = (
                        $dll -match "AppData|Temp|Roaming|Downloads|\.ps1|\.bat|\.vbs|\.js" -or
                        -not $sig.IsSigned
                    )

                    $comHijackData += [PSCustomObject]@{
                        CLSIDPath        = $clsidKey
                        DLLPath          = $dll
                        SHA256           = $hash
                        IsSigned         = $sig.IsSigned
                        SignatureStatus  = $sig.SignatureStatus
                        Publisher        = $sig.Publisher
                        Suspicious       = $suspicious
                    }
                }
            } catch {}
        }
    }
}

if ($comHijackData.Count -gt 0) {
    Save-ToExcelSheet -SheetName "COM Hijacking" -Data $comHijackData
} else {
    Write-Host "[*] No COM hijack entries found." -ForegroundColor Yellow
}


###################################################################################################################################


# --- Section 27: DLL Search Order Hijacks (DFIR Enhanced) ---
Write-Progress -Activity "Collecting DLL Search Order Hijacks" -Status "Running"

function Get-FileHashSafe {
    param ($path)
    try {
        if (Test-Path $path -PathType Leaf) {
            return (Get-FileHash -Path $path -Algorithm SHA256 -ErrorAction Stop).Hash
        }
        return "Not Found"
    } catch {
        return "HashError"
    }
}

function Get-SignatureInfo {
    param ($path)
    try {
        if (Test-Path $path -PathType Leaf) {
            $sig = Get-AuthenticodeSignature -FilePath $path
            return @{
                IsSigned         = ($sig.Status -eq 'Valid')
                SignatureStatus  = $sig.Status.ToString()
                Publisher        = $sig.SignerCertificate.Subject
            }
        }
    } catch {
        return @{
            IsSigned         = $false
            SignatureStatus  = "CheckFailed"
            Publisher        = "Unknown"
        }
    }
    return @{
        IsSigned         = $false
        SignatureStatus  = "NotFound"
        Publisher        = "None"
    }
}

$dllDirs = @(
    "$env:SystemRoot",
    "$env:SystemRoot\\System32",
    "$env:TEMP",
    "$env:APPDATA",
    "$env:USERPROFILE\\AppData\\Local",
    "$env:ProgramData"
)

$dllData = @()

foreach ($dir in $dllDirs) {
    if (Test-Path $dir) {
        Get-ChildItem -Path $dir -Filter *.dll -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
            $hash = Get-FileHashSafe -path $_.FullName
            $sig = Get-SignatureInfo -path $_.FullName
            $suspicious = (
                $_.FullName -match "AppData|Temp|Roaming|Downloads" -or
                -not $sig.IsSigned
            )

            $dllData += [PSCustomObject]@{
                DLLName         = $_.Name
                Path            = $_.FullName
                LastWritten     = $_.LastWriteTime
                SHA256          = $hash
                IsSigned        = $sig.IsSigned
                SignatureStatus = $sig.SignatureStatus
                Publisher       = $sig.Publisher
                Suspicious      = $suspicious
            }
        }
    }
}

if ($dllData.Count -gt 0) {
    Save-ToExcelSheet -SheetName "DLL Search Order" -Data $dllData
} else {
    Write-Host "[*] No DLLs found in search order paths." -ForegroundColor Yellow
}


###################################################################################################################################


# --- Section 28: Security.evtx Logs (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Security Event Log" -Status "Running"

function Get-SecurityEventMeaning {
    param ($id)
    switch ($id) {
        4624 { "Account Logon Success" }
        4625 { "Account Logon Failure" }
        4672 { "Special Privileges Assigned" }
        4688 { "New Process Created" }
        4634 { "Account Logoff" }
        4648 { "Explicit Credential Logon Attempt" }
        4768 { "Kerberos TGT Request" }
        4769 { "Kerberos Service Ticket Request" }
        4776 { "NTLM Authentication Attempt" }
        4689 { "Process Terminated" }
        4627 { "Group Membership Enumerated" }
        default { "Other / Unknown" }
    }
}

$securityLogs = @()

try {
    $entries = Get-WinEvent -LogName "Security" -MaxEvents 100 -ErrorAction Stop
    foreach ($entry in $entries) {
        $eid = $entry.Id
        $securityLogs += [PSCustomObject]@{
            TimeCreated     = $entry.TimeCreated
            EventID         = $eid
            EventIDMeaning  = Get-SecurityEventMeaning $eid
            Level           = $entry.LevelDisplayName
            Message         = ($entry.Message -replace "`r`n", " ") -replace '\s{2,}', ' '
        }
    }

    if ($securityLogs.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Security Log" -Data $securityLogs
    } else {
        Write-Host "[*] No recent Security log events found." -ForegroundColor Yellow
    }

} catch {
    Write-Warning "[!] Unable to access the Security log. Run script as Administrator or elevate permissions."
}


###################################################################################################################################


# --- Section 29: System Event Log Collection (Enhanced) ---
Write-Progress -Activity "Collecting System Event Log" -Status "Running"

function Get-SystemEventMeaning {
    param ($id)
    switch ($id) {
        6005 { "Event Log Service Started" }
        6006 { "Event Log Service Stopped" }
        6008 { "Unexpected Shutdown" }
        7000 { "Service Failed to Start" }
        7001 { "Service Dependency Failed" }
        7023 { "Service Terminated Unexpectedly" }
        7040 { "Service Start Type Changed" }
        7045 { "Service Installed" }
        7026 { "Boot-start or system-start driver failed to load" }
        1014 { "DNS Name Resolution Timed Out" }
        7021 { "Connection telemetry event" }
        7003 { "Roam Complete" }
        6062 { "Low Power Idle Timeout Triggered" }
        default { "Unknown" }
    }
}

$systemLogs = @()

try {
    $entries = Get-WinEvent -LogName "System" -MaxEvents 100 -ErrorAction Stop
    foreach ($entry in $entries) {
        $eid = $entry.Id
        $systemLogs += [PSCustomObject]@{
            TimeCreated     = $entry.TimeCreated
            EventID         = $eid
            EventIDMeaning  = Get-SystemEventMeaning $eid
            Level           = $entry.LevelDisplayName
            Message         = ($entry.Message -replace "`r`n", " ") -replace '\s{2,}', ' '
        }
    }

    if ($systemLogs.Count -gt 0) {
        Save-ToExcelSheet -SheetName "System Log" -Data $systemLogs
    } else {
        Write-Host "[*] No recent System log events found." -ForegroundColor Yellow
    }
} catch {
    Write-Warning "[!] Failed to retrieve System log entries: $_"
}


###################################################################################################################################


# --- Section 30: Application.evtx Logs (Enhanced) ---
Write-Progress -Activity "Collecting Application Event Log" -Status "Running"

function Get-AppEventMeaning {
    param ($id)
    switch ($id) {
        1000   { "Application Error / Crash" }
        1001   { "Application Hang / Fault Bucket" }
        1026   { ".NET Runtime Error" }
        11707  { "Application Installed" }
        11708  { "Application Install Failed" }
        16384  { "Software Protection Service Restart" }
        16394  { "Offline Licensing Succeeded" }
        1003   { "Software Protection Licensing Status" }
        default { "Unknown" }
    }
}

$appLogs = @()

try {
    $entries = Get-WinEvent -LogName "Application" -MaxEvents 100 -ErrorAction Stop
    foreach ($entry in $entries) {
        $eid = $entry.Id
        $appLogs += [PSCustomObject]@{
            TimeCreated     = $entry.TimeCreated
            EventID         = $eid
            EventIDMeaning  = Get-AppEventMeaning $eid
            Level           = $entry.LevelDisplayName
            Message         = ($entry.Message -replace "`r`n", " ") -replace '\s{2,}', ' '
        }
    }

    if ($appLogs.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Application Log" -Data $appLogs
    } else {
        Write-Host "[*] No recent Application log events found." -ForegroundColor Yellow
    }

} catch {
    Write-Warning "[!] Unable to access Application event log: $_"
}


###################################################################################################################################


# --- Section 31: Setup.evtx Logs (DFIR Enhanced) ---
Write-Progress -Activity "Collecting Setup Event Log" -Status "Running"

function Get-SetupEventMeaning {
    param ($id)
    switch ($id) {
        1      { "Setup started" }
        2      { "Setup completed" }
        3      { "Setup failed" }
        4      { "Restore started" }
        5      { "Restore completed" }
        6      { "Restore failed" }
        30102  { "Feature Update Started" }
        30103  { "Feature Update Completed" }
        30104  { "Feature Update Failed" }
        20000  { "Windows Update install" }
        default { "Unknown" }
    }
}

function Get-KBFromMessage {
    param ($message)
    if ($message -match "(KB\d{6,7})") {
        return $matches[1]
    } else {
        return "N/A"
    }
}

$setupLogs = @()

try {
    $events = Get-WinEvent -LogName "Setup" -MaxEvents 200 -ErrorAction Stop
    foreach ($event in $events) {
        $eid = $event.Id
        $message = ($event.Message -replace "`r`n", " ") -replace '\s+', ' '
        $kb = Get-KBFromMessage $message

        $setupLogs += [PSCustomObject]@{
            TimeCreated    = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
            EventID        = $eid
            EventIDMeaning = Get-SetupEventMeaning $eid
            KB             = $kb
            Level          = $event.LevelDisplayName
            Message        = $message
        }
    }

    if ($setupLogs.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Setup Log" -Data $setupLogs
    } else {
        Write-Warning "No Setup events collected."
    }
} catch {
    Write-Warning "Failed to retrieve Setup event log entries: $_"
}


###################################################################################################################################


# --- Section 32: Windows PowerShell Event Log (DFIR Enhanced) ---
Write-Progress -Activity "Collecting Windows PowerShell Log" -Status "Running"

function Get-PSEventMeaning {
    param ($id)
    switch ($id) {
        400 { "Engine Lifecycle State Changed" }
        403 { "Command Started" }
        600 { "Provider Initialized" }
        800 { "Pipeline Execution Completed" }
        4035 { "Module Loaded" }
        default { "Other/Unknown" }
    }
}

$psLogs = @()

try {
    $events = Get-WinEvent -LogName "Windows PowerShell" -MaxEvents 100 -ErrorAction Stop
    foreach ($event in $events) {
        $id = $event.Id
        $msg = ($event.Message -replace "`r`n", " ") -replace '\s{2,}', ' '

        $psLogs += [PSCustomObject]@{
            TimeCreated    = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
            EventID        = $id
            EventIDMeaning = Get-PSEventMeaning $id
            Level          = $event.LevelDisplayName
            Message        = $msg
        }
    }

    if ($psLogs.Count -gt 0) {
        Save-ToExcelSheet -SheetName "WinPS Log" -Data $psLogs
    } else {
        Write-Warning "No Windows PowerShell events were collected."
    }

} catch {
    Write-Warning "Unable to collect Windows PowerShell event logs: $_"
}


###################################################################################################################################


# --- Section 33: Microsoft-Windows-PowerShell/Operational Log (DFIR Enhanced) ---
Write-Progress -Activity "Collecting PowerShell Operational Log" -Status "Running"

function Get-PSOpEventMeaning {
    param ($id)
    switch ($id) {
        4100 { "PowerShell Engine Lifecycle Error" }
        4103 { "Pipeline Execution Started" }
        4104 { "ScriptBlock Logging (Executed Code)" }
        4105 { "Command Started" }
        4106 { "Command Completed" }
        default { "Other/Unknown" }
    }
}

$psOperational = @()

try {
    $events = Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 100 -ErrorAction Stop

    foreach ($event in $events) {
        $psOperational += [PSCustomObject]@{
            TimeCreated    = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
            EventID        = $event.Id
            EventIDMeaning = Get-PSOpEventMeaning $event.Id
            Level          = $event.LevelDisplayName
            Message        = ($event.Message -replace "`r`n", " ") -replace '\s{2,}', ' '
        }
    }

    if ($psOperational.Count -gt 0) {
        Save-ToExcelSheet -SheetName "PS Operational Log" -Data $psOperational
    } else {
        Write-Warning "No PowerShell Operational events were collected."
    }

} catch {
    Write-Warning "Unable to collect PowerShell Operational event logs: $_"
}


###################################################################################################################################


# --- Section 34: NTUSER.DAT Presence (Enhanced for DFIR) ---
Write-Progress -Activity "Checking for NTUSER.DAT" -Status "Running"

$ntuserPaths = @()

try {
    Get-ChildItem -Path "C:\Users" -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $ntPath = Join-Path $_.FullName "NTUSER.DAT"
        if (Test-Path $ntPath -ErrorAction SilentlyContinue) {
            $ntuserPaths += [PSCustomObject]@{
                Username      = $_.Name
                NTUSERPath    = $ntPath
                LastModified  = (Get-Item $ntPath -ErrorAction SilentlyContinue).LastWriteTime
                SizeKB        = [math]::Round((Get-Item $ntPath -ErrorAction SilentlyContinue).Length / 1KB, 2)
            }
        }
    }
} catch {
    Write-Warning "Failed to check for NTUSER.DAT: $_"
}

Save-ToExcelSheet -SheetName "NTUSER.DAT" -Data $ntuserPaths


###################################################################################################################################


# --- Section 35: RecentDocs (HKCU) - Enhanced for DFIR ---
Write-Progress -Activity "Collecting RecentDocs" -Status "Running"

$recentDocs = @()

try {
    $baseKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs"
    
    if (Test-Path $baseKey) {
        $subKeys = Get-ChildItem -Path $baseKey -ErrorAction SilentlyContinue

        foreach ($subKey in $subKeys) {
            $subPath = $subKey.PSPath
            try {
                $props = Get-ItemProperty -Path $subPath -ErrorAction SilentlyContinue
                foreach ($prop in $props.PSObject.Properties) {
                    if ($prop.Name -ne "MRUListEx") {
                        $recentDocs += [PSCustomObject]@{
                            SubKey       = $subKey.PSChildName
                            ValueName    = $prop.Name
                            ValueType    = $prop.Value.GetType().Name
                            RawValue     = $prop.Value
                        }
                    }
                }
            } catch {
                Write-Warning "Error reading RecentDocs subkey ${subPath}: $_"
            }
        }
    } else {
        Write-Warning "RecentDocs registry key not found."
    }

} catch {
    Write-Warning "Error collecting RecentDocs: $_"
}

if ($recentDocs.Count -gt 0) {
    Save-ToExcelSheet -SheetName "RecentDocs" -Data $recentDocs
} else {
    Write-Warning "No RecentDocs data was collected."
}


###################################################################################################################################


# --- Section 36: UserAssist (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting UserAssist Keys" -Status "Running"

$userAssist = @()

try {
    $uaPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist"

    if (Test-Path $uaPath) {
        Get-ChildItem -Path $uaPath -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            $subkey = $_.PSPath
            try {
                $props = Get-ItemProperty -Path $subkey -ErrorAction SilentlyContinue
                foreach ($prop in $props.PSObject.Properties) {
                    if ($prop.Name -notmatch "^PS.*" -and $prop.Name -ne "UEME_RUNPATH") {
                        # Only include string and numeric data (skip raw binaries)
                        if ($null -ne $prop.Value -and ($prop.Value -is [string] -or $prop.Value -is [int] -or $prop.Value -is [datetime])) {
                            $userAssist += [PSCustomObject]@{
                                SubKey     = $_.Name
                                ValueName  = $prop.Name
                                ValueType  = $prop.Value.GetType().Name
                                RawValue   = $prop.Value
                            }
                        }
                    }
                }
            } catch {
                Write-Warning "Error reading UserAssist key ${subkey}: $_"
            }
        }
    } else {
        Write-Warning "UserAssist registry key not found."
    }

} catch {
    Write-Warning "Failed to collect UserAssist data: $_"
}

# Output to Excel with memory protection
try {
    if ($userAssist.Count -gt 0) {
        if ($userAssist.Count -gt 1048000) {
            Write-Warning "UserAssist results exceed Excel row limits. Trimming to first 1,048,000 entries."
            $userAssist = $userAssist[0..1047999]
        }

        Save-ToExcelSheet -SheetName "UserAssist" -Data $userAssist
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    } else {
        Write-Warning "No UserAssist data was collected."
    }
} catch {
    Write-Warning "Error writing UserAssist data to Excel: $_"
}


###################################################################################################################################


# --- Section 37: ShellBags Detection (Enhanced for DFIR) ---
Write-Progress -Activity "Checking ShellBags Registry Keys" -Status "Running"

$shellBagKeys = @(
    "HKCU:\Software\Microsoft\Windows\Shell\BagMRU",
    "HKCU:\Software\Microsoft\Windows\Shell\Bags"
)

$shellBags = @()

foreach ($key in $shellBagKeys) {
    try {
        $exists = Test-Path $key
        $lastWrite = if ($exists) {
            $regKey = Get-Item -Path $key -ErrorAction SilentlyContinue
            $regKey.LastWriteTime
        } else {
            $null
        }

        $shellBags += [PSCustomObject]@{
            Path         = $key
            Exists       = $exists
            LastWrite    = if ($lastWrite) { $lastWrite.ToString("yyyy-MM-dd HH:mm:ss") } else { "N/A" }
        }
    } catch {
        Write-Warning "Failed to check ShellBag key: $key"
    }
}

if ($shellBags.Count -gt 0) {
    Save-ToExcelSheet -SheetName "ShellBags" -Data $shellBags
} else {
    Write-Warning "No ShellBags registry keys found."
}


###################################################################################################################################


# --- Section 38: TypedPaths (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting TypedPaths" -Status "Running"

$typedPaths = @()

try {
    $typedKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths"
    if (Test-Path $typedKey) {
        $values = Get-ItemProperty -Path $typedKey -ErrorAction SilentlyContinue
        foreach ($name in $values.PSObject.Properties.Name) {
            if ($name -notin @("PSPath", "PSParentPath", "PSChildName", "PSDrive", "PSProvider")) {
                $typedPaths += [PSCustomObject]@{
                    EntryName = $name
                    PathValue = $values.$name
                }
            }
        }
    }
} catch {
    Write-Warning "Failed to collect TypedPaths registry data: $_"
}

if ($typedPaths.Count -gt 0) {
    Save-ToExcelSheet -SheetName "TypedPaths" -Data $typedPaths
} else {
    Write-Warning "No TypedPaths data found in registry."
}


###################################################################################################################################


# --- Section 39: RunMRU (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting RunMRU" -Status "Running"

$runMRU = @()

try {
    $runMRUKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
    if (Test-Path $runMRUKey) {
        $values = Get-ItemProperty -Path $runMRUKey -ErrorAction SilentlyContinue
        foreach ($name in $values.PSObject.Properties.Name) {
            if ($name -notin @("MRUList", "PSPath", "PSParentPath", "PSChildName", "PSDrive", "PSProvider")) {
                $runMRU += [PSCustomObject]@{
                    EntryKey = $name
                    Command  = $values.$name
                }
            }
        }
    }
} catch {
    Write-Warning "Failed to retrieve RunMRU entries: $_"
}

if ($runMRU.Count -gt 0) {
    Save-ToExcelSheet -SheetName "RunMRU" -Data $runMRU
} else {
    Write-Warning "No RunMRU data found or registry key empty."
}


###################################################################################################################################


# --- Section 40: Jump Lists Presence Check (Enhanced for DFIR) ---
Write-Progress -Activity "Checking Jump Lists" -Status "Running"

$jumpListFolder = "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations"
$jumpListResults = @()

try {
    if (Test-Path $jumpListFolder) {
        Get-ChildItem -Path $jumpListFolder -Filter "*.automaticDestinations-ms" -ErrorAction Stop | ForEach-Object {
            $jumpListResults += [PSCustomObject]@{
                FileName  = $_.Name
                FullPath  = $_.FullName
                Modified  = $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
            }
        }
    } else {
        Write-Warning "Jump List directory not found: $jumpListFolder"
    }
} catch {
    Write-Warning "Failed to enumerate Jump Lists: $_"
}

if ($jumpListResults.Count -gt 0) {
    Save-ToExcelSheet -SheetName "JumpLists" -Data $jumpListResults
} else {
    Write-Warning "No Jump List (.automaticDestinations-ms) files found."
}


###################################################################################################################################


# --- Section 41: Clipboard History (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Clipboard History" -Status "Running"

$clipHistoryPath = "$env:LOCALAPPDATA\Microsoft\Windows\Clipboard"
$clipboardResults = @()

try {
    if (Test-Path $clipHistoryPath) {
        Get-ChildItem -Path $clipHistoryPath -Recurse -ErrorAction Stop | ForEach-Object {
            $clipboardResults += [PSCustomObject]@{
                Name     = $_.Name
                FullPath = $_.FullName
                Size     = $_.Length
                Modified = $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
            }
        }
    } else {
        Write-Warning "Clipboard history folder does not exist on this system."
    }
} catch {
    Write-Warning "Failed to collect clipboard history data: $_"
}

if ($clipboardResults.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Clipboard History" -Data $clipboardResults
} else {
    Write-Warning "No clipboard history data found or access was denied."
}


###################################################################################################################################


# --- Section 42: Account Lockouts (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Account Lockouts" -Status "Running"

$lockouts = @()

try {
    $events = Get-WinEvent -LogName "Security" -FilterXPath "*[System[(EventID=4740)]]" -MaxEvents 100 -ErrorAction Stop

    foreach ($evt in $events) {
        try {
            $message = ($evt.Message -replace "`r`n", " ") -replace '\s+', ' '
            $user = if ($message -match "Account Name:\s+([^\s]+)") { $matches[1] } else { "Unknown" }

            $lockouts += [PSCustomObject]@{
                TimeCreated = $evt.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
                User        = $user
                Message     = $message
            }
        } catch {
            $lockouts += [PSCustomObject]@{
                TimeCreated = $evt.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
                User        = "ParseError"
                Message     = "Failed to parse message content"
            }
        }
    }

    if ($lockouts.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Account Lockouts" -Data $lockouts
    } else {
        Write-Warning "No account lockout events found in the Security log."
    }

} catch {
    Write-Warning "Failed to retrieve account lockout events: $_"
}


###################################################################################################################################


# --- Section 43: Credential Manager (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Credential Manager Items" -Status "Running"

$credData = @()

try {
    $creds = cmdkey /list 2>&1
    $target = $null

    foreach ($line in $creds) {
        if ($line -match "^Target: (.+)$") {
            $target = $matches[1]
        }
        elseif ($line -match "^User: (.+)$" -and $target) {
            $credData += [PSCustomObject]@{
                Target     = $target
                Username   = $matches[1]
                Retrieved  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }
            $target = $null
        }
    }
} catch {
    $credData += [PSCustomObject]@{
        Target    = "ERROR"
        Username  = "Failed to retrieve credentials"
        Retrieved = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

if ($credData.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Credential Manager" -Data $credData
} else {
    Write-Warning "No Credential Manager entries were collected or access was denied."
}


###################################################################################################################################


# --- Section 44: net user Output (Enhanced for DFIR) ---
Write-Progress -Activity "Running 'net user'" -Status "Running"

$netUsers = @()

try {
    $output = net user
    foreach ($line in $output) {
        if ($line -match "^\s*(\w+)\s*$" -and $line -notmatch "The command completed successfully") {
            $netUsers += [PSCustomObject]@{
                Username   = $matches[1]
                Collected  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }
        }
    }
} catch {
    $netUsers += [PSCustomObject]@{
        Username  = "ERROR"
        Collected = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

if ($netUsers.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Net User" -Data $netUsers
} else {
    Write-Warning "No output returned from 'net user' or access denied."
}


###################################################################################################################################


# --- Section 45: net localgroup Output (Enhanced for DFIR) ---
Write-Progress -Activity "Running 'net localgroup'" -Status "Running"

$localGroups = @()

try {
    $groups = net localgroup
    foreach ($line in $groups) {
        if ($line -match "^\*?\s*(.+?)\s*$" -and $line -notmatch "^(Alias|---|The command|completed successfully)") {
            $localGroups += [PSCustomObject]@{
                GroupName  = $matches[1].Trim()
                Collected  = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
            }
        }
    }
} catch {
    $localGroups += [PSCustomObject]@{
        GroupName = "ERROR"
        Collected = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

if ($localGroups.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Local Groups" -Data $localGroups
} else {
    Write-Warning "No local groups retrieved or access denied."
}


###################################################################################################################################


# --- Section 46: whoami /groups Output (Enhanced for DFIR) ---
Write-Progress -Activity "Running 'whoami /groups'" -Status "Running"

$whoamiGroups = @()
try {
    $lines = whoami /groups
    $parse = $false
    foreach ($line in $lines) {
        if ($line -match "^Group Name\s+SID") {
            $parse = $true
            continue
        }
        if ($parse -and $line.Trim() -ne "") {
            $cols = $line -split '\s{2,}'
            if ($cols.Count -ge 2) {
                $whoamiGroups += [PSCustomObject]@{
                    GroupName  = $cols[0].Trim()
                    SID        = $cols[1].Trim()
                    Attributes = if ($cols.Count -ge 3) { $cols[2..($cols.Count - 1)] -join ', ' } else { "None" }
                }
            }
        }
    }
} catch {
    $whoamiGroups += [PSCustomObject]@{
        GroupName  = "ERROR"
        SID        = "N/A"
        Attributes = $_.Exception.Message
    }
}

if ($whoamiGroups.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Whoami Groups" -Data $whoamiGroups
} else {
    Write-Warning "Unable to retrieve group membership from whoami."
}


###################################################################################################################################


# --- Section 47: MAC Addresses (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting MAC Addresses" -Status "Running"

$macData = @()

try {
    $adapters = Get-NetAdapter -Physical -ErrorAction Stop | Where-Object { $_.Status -eq "Up" }
    foreach ($adapter in $adapters) {
        $macData += [PSCustomObject]@{
            InterfaceAlias = $adapter.Name
            MACAddress     = $adapter.MacAddress
            LinkSpeed      = $adapter.LinkSpeed
        }
    }
} catch {
    $macData += [PSCustomObject]@{
        InterfaceAlias = "ERROR"
        MACAddress     = "N/A"
        LinkSpeed      = $_.Exception.Message
    }
}

if ($macData.Count -gt 0) {
    Save-ToExcelSheet -SheetName "MAC Addresses" -Data $macData
} else {
    Write-Warning "No physical adapters with status 'Up' found."
}


###################################################################################################################################


# --- Section 48: Hosts File (Enhanced for DFIR) ---
Write-Progress -Activity "Reading Hosts File" -Status "Running"

$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$hostsEntries = @()

try {
    if (Test-Path $hostsPath) {
        Get-Content $hostsPath | ForEach-Object {
            $line = $_.Trim()
            if ($line -match "^\d{1,3}(\.\d{1,3}){3}") {
                $tokens = $line -split "\s+"
                if ($tokens.Count -ge 2) {
                    $hostsEntries += [PSCustomObject]@{
                        IPAddress = $tokens[0]
                        Hostname  = $tokens[1]
                    }
                }
            }
        }
    } else {
        Write-Warning "Hosts file not found at expected location."
    }
} catch {
    $hostsEntries += [PSCustomObject]@{
        IPAddress = "ERROR"
        Hostname  = $_.Exception.Message
    }
}

if ($hostsEntries.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Hosts File" -Data $hostsEntries
} else {
    Write-Warning "No valid hosts entries were found."
}


###################################################################################################################################


# --- Section 49: Firewall Rules (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Firewall Rules" -Status "Running"

function Get-FwProfileMeaning {
    param ($val)
    switch ($val) {
        0 { "All" }
        1 { "Domain" }
        2 { "Private" }
        4 { "Public" }
        6 { "Private, Public" }
        3 { "Domain, Private" }
        5 { "Domain, Public" }
        7 { "Domain, Private, Public" }
        default { "Unknown" }
    }
}

function Get-FwDirection {
    param ($val)
    switch ($val) {
        1 { "Inbound" }
        2 { "Outbound" }
        default { "Unknown" }
    }
}

function Get-FwAction {
    param ($val)
    switch ($val) {
        1 { "Allow" }
        2 { "Block" }
        default { "Unknown" }
    }
}

function Get-FwEnabled {
    param ($val)
    switch ($val) {
        1 { "True" }
        2 { "False" }
        default { "Unknown" }
    }
}

$firewallRules = Get-NetFirewallRule | ForEach-Object {
    [PSCustomObject]@{
        Name        = $_.DisplayName
        Enabled     = Get-FwEnabled $_.Enabled
        Direction   = Get-FwDirection $_.Direction
        Action      = Get-FwAction $_.Action
        Profile     = Get-FwProfileMeaning $_.Profile
    }
}

Save-ToExcelSheet -SheetName "Firewall Rules" -Data $firewallRules


###################################################################################################################################


# --- Section 50: DNS Cache (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting DNS Cache" -Status "Running"

$dnsCache = ipconfig /displaydns 2>&1 | Where-Object { $_ -match "^\s*Record Name|Record Type|Time To Live|Data" } | ForEach-Object {
    $_ -replace "^\s+", ""
}

$dnsFormatted = @()
for ($i = 0; $i -lt $dnsCache.Count; $i += 4) {
    try {
        $entry = [PSCustomObject]@{
            RecordName = $dnsCache[$i]   -replace "Record Name\s+:\s+", ""
            RecordType = switch ($dnsCache[$i+1] -replace "Record Type\s+:\s+", "") {
                "1"  { "A (Host Address)" }
                "5"  { "CNAME (Canonical Name)" }
                "28" { "AAAA (IPv6 Address)" }
                default { "Other" }
            }
            TTL        = $dnsCache[$i+2] -replace "Time To Live\s+:\s+", ""
            Data       = $dnsCache[$i+3] -replace "Data\s+:\s+", ""
        }
        $dnsFormatted += $entry
    } catch {
        # Skip malformed entry
        continue
    }
}

Save-ToExcelSheet -SheetName "DNS Cache" -Data $dnsFormatted


###################################################################################################################################


# --- Section 51: ARP Cache (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting ARP Cache" -Status "Running"

$arpData = @()
try {
    $arpData = arp -a | Where-Object { $_ -match "^\s*\d" } | ForEach-Object {
        $cols = ($_ -replace "^\s+", "") -split "\s+"
        if ($cols.Count -eq 3) {
            [PSCustomObject]@{
                IPAddress  = $cols[0]
                MACAddress = $cols[1]
                Type       = $cols[2]
            }
        }
    }

    if ($arpData.Count -gt 0) {
        Save-ToExcelSheet -SheetName "ARP Cache" -Data $arpData
    } else {
        Write-Warning "No ARP cache entries found."
    }
} catch {
    Write-Warning "Failed to collect ARP Cache: $_"
}


###################################################################################################################################


# --- Section 52: Logon Events (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Logon Events" -Status "Running"

$logonEvents = @()
try {
    $events = Get-WinEvent -FilterHashtable @{
        LogName = "Security"
        ID      = 4624
    } -MaxEvents 100 -ErrorAction Stop

    foreach ($evt in $events) {
        $message = ($evt.Message -replace "`r`n", " ") -replace '\s+', ' '
        $accountName = if ($message -match "Account Name:\s+(\S+)") { $matches[1] } else { "Unknown" }
        $logonType = if ($message -match "Logon Type:\s+(\d+)") { $matches[1] } else { "N/A" }
        $logonID = if ($message -match "Logon ID:\s+(\S+)") { $matches[1] } else { "N/A" }

        $logonEvents += [PSCustomObject]@{
            TimeCreated = $evt.TimeCreated
            EventID     = $evt.Id
            Account     = $accountName
            LogonType   = $logonType
            LogonID     = $logonID
            Message     = $message
        }
    }

    if ($logonEvents.Count -gt 0) {
        Save-ToExcelSheet -SheetName "Logon Events" -Data $logonEvents
    } else {
        Write-Warning "No logon events found."
    }
} catch {
    Write-Warning "Failed to retrieve logon events: $_"
}


###################################################################################################################################


# --- Section 53: BAM/DAM Activity (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting BAM/DAM Activity" -Status "Running"

$bamPath = "HKLM:\SYSTEM\CurrentControlSet\Services\bam\UserSettings"
$bamData = @()

if (Test-Path $bamPath) {
    try {
        Get-ChildItem $bamPath -ErrorAction Stop | ForEach-Object {
            $sid = $_.PSChildName
            $properties = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
            if ($properties) {
                $properties.PSObject.Properties | Where-Object { $_.Name -ne "PSPath" -and $_.Name -ne "PSParentPath" -and $_.Name -ne "PSChildName" -and $_.Name -ne "PSDrive" -and $_.Name -ne "PSProvider" } | ForEach-Object {
                    $lastUsedRaw = $_.Value
                    $lastUsed = try {
                        ([datetime]::FromFileTimeUtc($lastUsedRaw)).ToString("yyyy-MM-dd HH:mm:ss")
                    } catch {
                        "Unreadable Timestamp"
                    }

                    $bamData += [PSCustomObject]@{
                        UserSID    = $sid
                        Executable = $_.Name
                        LastUsed   = $lastUsed
                    }
                }
            }
        }

        if ($bamData.Count -gt 0) {
            Save-ToExcelSheet -SheetName "BAM_DAM" -Data $bamData
        } else {
            Write-Warning "No BAM/DAM entries found."
        }
    } catch {
        Write-Warning "Failed to enumerate BAM/DAM activity: $_"
    }
} else {
    Write-Warning "BAM registry path not found."
}


###################################################################################################################################


# --- Section 54: Netstat Output (Enhanced for DFIR) ---
Write-Progress -Activity "Collecting Netstat Output" -Status "Running"

$netstatRaw = netstat -ano | Select-String "TCP|UDP"
$netstatData = @()

foreach ($line in $netstatRaw) {
    $parts = ($line -replace "\s+", " ").Trim() -split " "
    if ($parts.Length -eq 5) {
        $netstatData += [PSCustomObject]@{
            Protocol       = $parts[0]
            LocalAddress   = $parts[1]
            ForeignAddress = $parts[2]
            State          = $parts[3]
            PID            = $parts[4]
        }
    } elseif ($parts.Length -eq 4) {
        $netstatData += [PSCustomObject]@{
            Protocol       = $parts[0]
            LocalAddress   = $parts[1]
            ForeignAddress = $parts[2]
            State          = "N/A"
            PID            = $parts[3]
        }
    }
}

if ($netstatData.Count -gt 0) {
    Save-ToExcelSheet -SheetName "Netstat" -Data $netstatData
} else {
    Write-Warning "No active network connections found."
}


###################################################################################################################################



# --- Section 55: ipconfig /displaydns (Enhanced for DFIR) ---
Write-Progress -Activity "Running ipconfig /displaydns" -Status "Running"

$dnsOutput = ipconfig /displaydns 2>&1
$dnsFiltered = $dnsOutput | Where-Object { $_ -match "^\s*(Record Name|Record Type|Time To Live|Data)" }

$parsedDns = @()
for ($i = 0; $i -lt $dnsFiltered.Count; $i += 4) {
    try {
        $parsedDns += [PSCustomObject]@{
            RecordName = ($dnsFiltered[$i] -split ":\s*", 2)[1].Trim()
            RecordType = ($dnsFiltered[$i+1] -split ":\s*", 2)[1].Trim()
            TTL        = ($dnsFiltered[$i+2] -split ":\s*", 2)[1].Trim()
            Data       = ($dnsFiltered[$i+3] -split ":\s*", 2)[1].Trim()
        }
    } catch {
        Write-Warning "Skipping malformed DNS cache entry at index $i"
    }
}

if ($parsedDns.Count -gt 0) {
    Save-ToExcelSheet -SheetName "ipconfig_dns" -Data $parsedDns
} else {
    Write-Warning "No DNS cache entries collected."
}


###################################################################################################################################


# --- Section 56: RDP Logon Events (Event ID 1149) ---
Write-Progress -Activity "Collecting RDP Logon Events" -Status "Running"

$rdpLogons = Get-WinEvent -LogName "Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational" `
    -FilterXPath "*[System[(EventID=1149)]]" -MaxEvents 100 -ErrorAction SilentlyContinue | ForEach-Object {
        [PSCustomObject]@{
            TimeCreated = $_.TimeCreated
            EventID     = $_.Id
            Message     = ($_.Message -replace "`r`n", " ") -replace '\s+', ' '
        }
    }

Save-ToExcelSheet -SheetName "RDP Logons" -Data $rdpLogons


###################################################################################################################################


# --- Section 57: Network Interfaces ---
Write-Progress -Activity "Collecting Network Interfaces" -Status "Running"

$netAdapters = Get-NetAdapter | ForEach-Object {
    [PSCustomObject]@{
        Name        = $_.Name
        Status      = $_.Status
        MACAddress  = $_.MacAddress
        LinkSpeed   = $_.LinkSpeed
        InterfaceID = $_.InterfaceIndex
    }
}
Save-ToExcelSheet -SheetName "Network Interfaces" -Data $netAdapters


###################################################################################################################################


# --- Section 58: AppCompatCache (ShimCache) ---
Write-Progress -Activity "Collecting AppCompatCache" -Status "Running"

$appCompatCache = @()

try {
    $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache"
    $cache = Get-ItemProperty -Path $regPath -ErrorAction Stop
    $appCompatCache += [PSCustomObject]@{
        Note = "AppCompatCache value exists, but requires binary parsing (Volatility/ShimCacheParser)"
    }
} catch {
    $appCompatCache += [PSCustomObject]@{
        Note = "AppCompatCache not available or inaccessible"
    }
}

Save-ToExcelSheet -SheetName "AppCompatCache" -Data $appCompatCache


###################################################################################################################################


# --- Section 59: MUICache ---
Write-Progress -Activity "Collecting MUICache" -Status "Running"

$muiPath = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache"
$muiEntries = @()

try {
    if (Test-Path $muiPath) {
        $props = Get-ItemProperty -Path $muiPath -ErrorAction Stop
        $props.PSObject.Properties | Where-Object { $_.Name -ne "(default)" -and $_.Name -ne "LangID" } | ForEach-Object {
            $name = $_.Name
            $desc = if ($_.Value -ne $null) { $_.Value.ToString().Trim() } else { "N/A" }

            $muiEntries += [PSCustomObject]@{
                Executable  = $name
                Description = $desc
            }
        }
    }

    # Excel-safe write
    try {
        if ($muiEntries.Count -gt 0) {
            if ($muiEntries.Count -gt 1048000) {
                Write-Warning "MUICache entries exceed Excel limit. Trimming."
                $muiEntries = $muiEntries[0..1047999]
            }
            Save-ToExcelSheet -SheetName "MUICache" -Data $muiEntries
        } else {
            Save-ToExcelSheet -SheetName "MUICache" -Data @([PSCustomObject]@{ Executable = "None"; Description = "No entries found" })
        }
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    } catch {
        Write-Warning "Excel export failed for MUICache: $_"
    }

} catch {
    Write-Warning "Error collecting MUICache: $_"
}


###################################################################################################################################


# --- Section 60: RecentApps ---
Write-Progress -Activity "Collecting RecentApps" -Status "Running"

$recentAppsKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\RecentApps"
$recentApps = @()

try {
    if (Test-Path $recentAppsKey) {
        Get-ChildItem $recentAppsKey -ErrorAction Stop | ForEach-Object {
            try {
                $app = Get-ItemProperty -Path $_.PSPath -ErrorAction Stop
                $recentApps += [PSCustomObject]@{
                    AppID          = $_.PSChildName
                    Executable     = $app.Executable
                    LastAccessTime = $app.LastAccessTime
                }
            } catch {
                Write-Warning "Error reading RecentApps entry at $($_.PSPath): $_"
            }
        }
    }

    if ($recentApps.Count -gt 0) {
        Save-ToExcelSheet -SheetName "RecentApps" -Data $recentApps
    } else {
        Save-ToExcelSheet -SheetName "RecentApps" -Data @([PSCustomObject]@{
            AppID = "None"
            Executable = "No RecentApps data found"
            LastAccessTime = "N/A"
        })
    }
} catch {
    Write-Warning "Failed to access RecentApps key: $_"
}


###################################################################################################################################


# --- Section 61: RecentFileCache.bcf ---
Write-Progress -Activity "Checking RecentFileCache.bcf" -Status "Running"

$recentFileCachePath = "$env:SystemRoot\AppCompat\Programs\RecentFileCache.bcf"
$recentFileCacheData = @()

try {
    if (Test-Path $recentFileCachePath) {
        $recentFileCacheData += [PSCustomObject]@{
            Path = $recentFileCachePath
            Note = "File exists. Binary format. Use external tools like PECmd or AppCompatParser to extract data."
        }
    } else {
        $recentFileCacheData += [PSCustomObject]@{
            Path = "N/A"
            Note = "File not found"
        }
    }

    Save-ToExcelSheet -SheetName "RecentFileCache" -Data $recentFileCacheData
} catch {
    Write-Warning "Failed to check RecentFileCache.bcf: $_"
}


###################################################################################################################################


# --- Section 62: SRUM Activity ---
Write-Progress -Activity "Collecting SRUM Data" -Status "Running"

$srumPath = "$env:windir\System32\sru\SRUDB.dat"
$srumResults = @()

try {
    if (Test-Path $srumPath) {
        $srumResults += [PSCustomObject]@{
            SRUDB_Path = $srumPath
            Note       = "SRUM database exists. Use external parser like SRUM-Dump or SQLite tools for analysis."
        }
    } else {
        $srumResults += [PSCustomObject]@{
            SRUDB_Path = "Not Found"
            Note       = "SRUDB.dat not found."
        }
    }

    Save-ToExcelSheet -SheetName "SRUM" -Data $srumResults
} catch {
    Write-Warning "Failed to check SRUM data: $_"
}


###################################################################################################################################


# --- Section 63: SAM Hive Detection ---
Write-Progress -Activity "Checking SAM Hive" -Status "Running"

$samPath = "$env:SystemRoot\System32\config\SAM"
$samCheck = @()

try {
    if (Test-Path $samPath) {
        $samCheck += [PSCustomObject]@{
            Hive   = "SAM"
            Path   = $samPath
            Exists = "Yes"
            Note   = "Binary format, use tools like `reg save` or `secretsdump.py` for analysis"
        }
    } else {
        $samCheck += [PSCustomObject]@{
            Hive   = "SAM"
            Path   = $samPath
            Exists = "No"
            Note   = "File not found"
        }
    }

    Save-ToExcelSheet -SheetName "SAM Hive" -Data $samCheck
} catch {
    Write-Warning "Error checking SAM hive: $_"
}


###################################################################################################################################


# --- Section 64: SECURITY Hive Detection ---
Write-Progress -Activity "Checking SECURITY Hive" -Status "Running"

$securityPath = "$env:SystemRoot\System32\config\SECURITY"
$securityCheck = @()

try {
    if (Test-Path $securityPath) {
        $securityCheck += [PSCustomObject]@{
            Hive   = "SECURITY"
            Path   = $securityPath
            Exists = "Yes"
            Note   = "Binary format, use offline parsing tools for detailed content"
        }
    } else {
        $securityCheck += [PSCustomObject]@{
            Hive   = "SECURITY"
            Path   = $securityPath
            Exists = "No"
            Note   = "File not found"
        }
    }

    Save-ToExcelSheet -SheetName "SECURITY Hive" -Data $securityCheck
} catch {
    Write-Warning "Error checking SECURITY hive: $_"
}


###################################################################################################################################


# --- Section 65: USRCLASS.DAT ---
Write-Progress -Activity "Checking USRCLASS.DAT" -Status "Running"

$usrclassPath = "$env:LOCALAPPDATA\Microsoft\Windows\UsrClass.dat"
$usrclassCheck = @()

try {
    if (Test-Path $usrclassPath) {
        $usrclassCheck += [PSCustomObject]@{
            File   = "UsrClass.dat"
            Path   = $usrclassPath
            Exists = "Yes"
            Note   = "ShellBag and jump list data. Use Registry Explorer or shellbag parser"
        }
    } else {
        $usrclassCheck += [PSCustomObject]@{
            File   = "UsrClass.dat"
            Path   = $usrclassPath
            Exists = "No"
            Note   = "File not found"
        }
    }

    Save-ToExcelSheet -SheetName "USRCLASS.DAT" -Data $usrclassCheck
} catch {
    Write-Warning "Error checking USRCLASS.DAT: $_"
}


###################################################################################################################################


# --- Section 66: Prefetch Files ---
Write-Progress -Activity "Collecting Prefetch Files" -Status "Running"

$prefetchPath = "$env:SystemRoot\Prefetch"
$prefetchFiles = @()

try {
    if (Test-Path $prefetchPath) {
        Get-ChildItem $prefetchPath -Filter *.pf -ErrorAction SilentlyContinue | ForEach-Object {
            $prefetchFiles += [PSCustomObject]@{
                Name     = $_.Name
                Path     = $_.FullName
                SizeKB   = [math]::Round($_.Length / 1KB, 2)
                Modified = $_.LastWriteTime
            }
        }
    } else {
        $prefetchFiles += [PSCustomObject]@{
            Name     = "Prefetch Folder Not Found"
            Path     = $prefetchPath
            SizeKB   = ""
            Modified = ""
        }
    }

    Save-ToExcelSheet -SheetName "Prefetch Files" -Data $prefetchFiles
} catch {
    Write-Warning "Failed to collect Prefetch data: $_"
}


###################################################################################################################################


# --- Section 67: Amcache.hve ---
Write-Progress -Activity "Checking Amcache.hve" -Status "Running"

$amcachePath = "$env:SystemRoot\AppCompat\Programs\Amcache.hve"
$amcacheCheck = @()

try {
    if (Test-Path $amcachePath) {
        $amcacheCheck += [PSCustomObject]@{
            File   = "Amcache.hve"
            Path   = $amcachePath
            Exists = "Yes"
            Note   = "Binary hive file. Use external parser (e.g., AmcacheParser)"
        }
    } else {
        $amcacheCheck += [PSCustomObject]@{
            File   = "Amcache.hve"
            Path   = $amcachePath
            Exists = "No"
            Note   = "File not found"
        }
    }

    Save-ToExcelSheet -SheetName "Amcache" -Data $amcacheCheck
} catch {
    Write-Warning "Failed to collect Amcache.hve status: $_"
}


###################################################################################################################################


# --- Section 68: Downloads Folder Contents ---
Write-Progress -Activity "Collecting Downloads Folder" -Status "Running"

$downloads = @()
$downloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"

try {
    if (Test-Path $downloadsPath) {
        Get-ChildItem -Path $downloadsPath -Recurse -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
            $downloads += [PSCustomObject]@{
                Name     = $_.Name
                Path     = $_.FullName
                SizeKB   = [math]::Round($_.Length / 1KB, 2)
                Modified = $_.LastWriteTime
            }
        }
    } else {
        $downloads += [PSCustomObject]@{
            Name     = "Downloads folder not found"
            Path     = $downloadsPath
            SizeKB   = ""
            Modified = ""
        }
    }

    Save-ToExcelSheet -SheetName "Downloads" -Data $downloads
} catch {
    Write-Warning "Failed to collect Downloads folder contents: $_"
}


###################################################################################################################################


# --- Section 69: USB Device History ---
Write-Progress -Activity "Collecting USB History" -Status "Running"

$usbHistory = @()
$usbKey = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"

try {
    if (Test-Path $usbKey) {
        Get-ChildItem $usbKey -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
                $usbHistory += [PSCustomObject]@{
                    Device       = $_.PSChildName
                    FriendlyName = $props.FriendlyName
                    Service      = $props.Service
                    ContainerID  = $props.ContainerID
                    PSPath       = $_.PSPath
                }
            } catch {
                $usbHistory += [PSCustomObject]@{
                    Device       = $_.PSChildName
                    FriendlyName = "Access Error"
                    Service      = "N/A"
                    ContainerID  = "N/A"
                    PSPath       = $_.PSPath
                }
            }
        }
    } else {
        $usbHistory += [PSCustomObject]@{
            Device       = "USBSTOR Registry Key Not Found"
            FriendlyName = ""
            Service      = ""
            ContainerID  = ""
            PSPath       = $usbKey
        }
    }

    Save-ToExcelSheet -SheetName "USB History" -Data $usbHistory
} catch {
    Write-Warning "Failed to retrieve USB history: $_"
}


###################################################################################################################################


# --- Section 70: LNK Files ---
Write-Progress -Activity "Collecting .lnk Files" -Status "Running"

$lnkFiles = @()
$userDirs = Get-ChildItem "$env:SystemDrive\Users" -Directory -ErrorAction SilentlyContinue

foreach ($user in $userDirs) {
    $lnkPath = Join-Path $user.FullName "AppData\Roaming\Microsoft\Windows\Recent"
    if (Test-Path $lnkPath) {
        Get-ChildItem -Path $lnkPath -Filter *.lnk -Force -ErrorAction SilentlyContinue | ForEach-Object {
            $lnkFiles += [PSCustomObject]@{
                User        = $user.Name
                FileName    = $_.Name
                FullPath    = $_.FullName
                Modified    = $_.LastWriteTime
                SizeKB      = [math]::Round($_.Length / 1KB, 2)
            }
        }
    } else {
        $lnkFiles += [PSCustomObject]@{
            User        = $user.Name
            FileName    = "N/A"
            FullPath    = $lnkPath
            Modified    = "Path Missing"
            SizeKB      = "N/A"
        }
    }
}

Save-ToExcelSheet -SheetName "LNK Files" -Data $lnkFiles


###################################################################################################################################


# --- Section 71: SYSTEM Hive Check ---
Write-Progress -Activity "Checking SYSTEM Hive" -Status "Running"

$systemHivePath = "$env:SystemRoot\System32\config\SYSTEM"
$systemCheck = @()

if (Test-Path $systemHivePath) {
    $systemCheck += [PSCustomObject]@{
        Hive   = "SYSTEM"
        Path   = $systemHivePath
        Exists = "Yes"
        Note   = "Use offline registry parsing tools to analyze"
    }
} else {
    $systemCheck += [PSCustomObject]@{
        Hive   = "SYSTEM"
        Path   = $systemHivePath
        Exists = "No"
        Note   = "File not found"
    }
}

Save-ToExcelSheet -SheetName "SYSTEM Hive" -Data $systemCheck


###################################################################################################################################


# --- Section 72: SOFTWARE Hive Check ---
Write-Progress -Activity "Checking SOFTWARE Hive" -Status "Running"

$softwareHivePath = "$env:SystemRoot\System32\config\SOFTWARE"
$softwareCheck = @()

if (Test-Path $softwareHivePath) {
    $softwareCheck += [PSCustomObject]@{
        Hive   = "SOFTWARE"
        Path   = $softwareHivePath
        Exists = "Yes"
        Note   = "Use offline registry parsing tools to analyze"
    }
} else {
    $softwareCheck += [PSCustomObject]@{
        Hive   = "SOFTWARE"
        Path   = $softwareHivePath
        Exists = "No"
        Note   = "File not found"
    }
}

Save-ToExcelSheet -SheetName "SOFTWARE Hive" -Data $softwareCheck


###################################################################################################################################


# --- Section 73: SQLite Browser Data Reader & History Collector ---
Write-Progress -Activity "Scanning Browser Artifacts" -Status "Initializing SQLite module"

# Define SQLite DLL location and download URL
$sqlitePath = "$PSScriptRoot\System.Data.SQLite.dll"
$sqliteUrl  = "https://github.com/phxsqlite/sqlite-dotnet/releases/download/v1.0.115.5/System.Data.SQLite.dll"

# Download SQLite DLL if missing
if (-not (Test-Path $sqlitePath)) {
    try {
        Write-Progress -Activity "Downloading SQLite DLL" -Status "Fetching from GitHub..."
        Invoke-WebRequest -Uri $sqliteUrl -OutFile $sqlitePath -UseBasicParsing -ErrorAction Stop
        Write-Output "Downloaded System.Data.SQLite.dll to $sqlitePath"
    } catch {
        Write-Warning "Failed to download SQLite assembly: $($_.Exception.Message)"
    }
}

# Load SQLite assembly
try {
    Add-Type -Path $sqlitePath -ErrorAction Stop
} catch {
    Write-Warning ("Failed to load SQLite assembly from " + $sqlitePath + ": " + $_.Exception.Message)
}

# Function: Query SQLite database
function Read-SQLiteData {
    param (
        [string]$DatabasePath,
        [string]$Query,
        [string]$Browser
    )

    $result = @()
    try {
        $connection = New-Object System.Data.SQLite.SQLiteConnection("Data Source=$DatabasePath;Version=3;Read Only=True;")
        $connection.Open()

        $command = $connection.CreateCommand()
        $command.CommandText = $Query

        $adapter = New-Object System.Data.SQLite.SQLiteDataAdapter $command
        $table = New-Object System.Data.DataTable
        $adapter.Fill($table) | Out-Null

        foreach ($row in $table.Rows) {
            $rowObj = [PSCustomObject]@{}
            foreach ($col in $table.Columns) {
                $rowObj | Add-Member -NotePropertyName $col.ColumnName -NotePropertyValue $row[$col.ColumnName] -Force
            }
            $rowObj | Add-Member -NotePropertyName Browser -NotePropertyValue $Browser -Force
            $rowObj | Add-Member -NotePropertyName SourceDB -NotePropertyValue $DatabasePath -Force
            $result += $rowObj
        }

        $connection.Close()
    } catch {
        Write-Warning ("Failed to read SQLite DB " + $DatabasePath + ": " + $_.Exception.Message)
        $result += [PSCustomObject]@{
            Error     = "Failed to read $DatabasePath"
            Details   = $_.Exception.Message
            Browser   = $Browser
            SourceDB  = $DatabasePath
        }
    }

    return $result
}

# Function: Locate browser profile databases
function Get-BrowserProfilePaths {
    $paths = @()

    # Chrome
    $chrome = Join-Path $env:LOCALAPPDATA "Google\Chrome\User Data"
    if (Test-Path $chrome) {
        Get-ChildItem "$chrome\*\History" -ErrorAction SilentlyContinue | ForEach-Object {
            $paths += [PSCustomObject]@{ Browser = "Chrome"; Path = $_.FullName }
        }
    }

    # Edge
    $edge = Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data"
    if (Test-Path $edge) {
        Get-ChildItem "$edge\*\History" -ErrorAction SilentlyContinue | ForEach-Object {
            $paths += [PSCustomObject]@{ Browser = "Edge"; Path = $_.FullName }
        }
    }

    # Firefox
    $firefox = Join-Path $env:APPDATA "Mozilla\Firefox\Profiles"
    if (Test-Path $firefox) {
        Get-ChildItem $firefox -Directory | ForEach-Object {
            $places = Join-Path $_.FullName "places.sqlite"
            if (Test-Path $places) {
                $paths += [PSCustomObject]@{ Browser = "Firefox"; Path = $places }
            }
        }
    }

    return $paths
}

# Query and collect browser history
$browserHistory = @()
Write-Progress -Activity "Collecting Browser History" -Status "Querying SQLite databases"

foreach ($entry in Get-BrowserProfilePaths) {
    switch ($entry.Browser) {
        "Chrome" {
            $query = "SELECT url, title, datetime(last_visit_time/1000000-11644473600, 'unixepoch') AS LastVisit FROM urls ORDER BY last_visit_time DESC LIMIT 50"
        }
        "Edge" {
            $query = "SELECT url, title, datetime(last_visit_time/1000000-11644473600, 'unixepoch') AS LastVisit FROM urls ORDER BY last_visit_time DESC LIMIT 50"
        }
        "Firefox" {
            $query = "SELECT url, title, datetime(last_visit_date/1000000, 'unixepoch') AS LastVisit FROM moz_places ORDER BY last_visit_date DESC LIMIT 50"
        }
        default {
            Write-Warning "No query defined for browser: $($entry.Browser)"
            continue
        }
    }

    $results = Read-SQLiteData -DatabasePath $entry.Path -Query $query -Browser $entry.Browser
    $browserHistory += $results
}

# Output the results
if ($browserHistory.Count -gt 0) {
    try {
        Save-ToExcelSheet -SheetName "Browser History" -Data $browserHistory
    } catch {
        Write-Warning "Excel write failed, exporting as CSV instead."
        $csvPath = Join-Path $env:USERPROFILE\Desktop "Browser_History.csv"
        $browserHistory | Export-Csv -Path $csvPath -NoTypeInformation -Force
    }
} else {
    Write-Warning "No browser history was collected."
}



###################################################################################################################################


# --- Section 74: Browser Cache (Presence Check Only - Enhanced) ---
Write-Progress -Activity "Collecting Browser Cache Info" -Status "Running"

$browserCache = @()

$cacheLocations = @(
    @{ Browser = "Chrome";  Path = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" },
    @{ Browser = "Edge";    Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache" },
    @{ Browser = "Firefox"; Path = "$env:APPDATA\Mozilla\Firefox\Profiles" }
)

foreach ($entry in $cacheLocations) {
    if (Test-Path $entry.Path) {
        $browserCache += [PSCustomObject]@{
            Browser = $entry.Browser
            Path    = $entry.Path
            Exists  = "Yes"
            Note    = "Cache folder present"
        }
    } else {
        $browserCache += [PSCustomObject]@{
            Browser = $entry.Browser
            Path    = $entry.Path
            Exists  = "No"
            Note    = "Cache folder not found"
        }
    }
}

Save-ToExcelSheet -SheetName "Browser Cache" -Data $browserCache


###################################################################################################################################


# --- Section 75: Browser Search Terms ---
Write-Progress -Activity "Collecting Browser Search Terms" -Status "Running"

$searchTerms = @()

foreach ($entry in (Get-BrowserProfilePaths | Where-Object { $_.Type -eq "History" })) {
    switch ($entry.Browser) {
        "Chrome" {
            $query = "SELECT term, datetime(last_visit_time/1000000-11644473600, 'unixepoch') as LastUsed FROM keyword_search_terms JOIN urls ON keyword_search_terms.url_id = urls.id ORDER BY last_visit_time DESC LIMIT 50"
        }
        "Edge" {
            $query = "SELECT term, datetime(last_visit_time/1000000-11644473600, 'unixepoch') as LastUsed FROM keyword_search_terms JOIN urls ON keyword_search_terms.url_id = urls.id ORDER BY last_visit_time DESC LIMIT 50"
        }
        "Firefox" {
            continue  # Firefox does not store search terms in its SQLite schema
        }
        default {
            continue
        }
    }

    $searchTerms += Read-SQLiteData -DatabasePath $entry.Path -Query $query | ForEach-Object {
        $_ | Add-Member -NotePropertyName Browser -NotePropertyValue $entry.Browser -Force
        $_
    }
}

Save-ToExcelSheet -SheetName "Browser Search Terms" -Data $searchTerms


###################################################################################################################################


# --- Section 76: Browser Cookies ---
Write-Progress -Activity "Collecting Browser Cookies" -Status "Running"

$cookieData = @()
foreach ($entry in (Get-BrowserProfilePaths | Where-Object { $_.Type -eq "Cookies" })) {
    switch ($entry.Browser) {
        "Chrome" {
            $query = "SELECT host_key, name, value, datetime(last_access_utc/1000000-11644473600, 'unixepoch') as LastAccess FROM cookies ORDER BY last_access_utc DESC LIMIT 50"
        }
        "Edge" {
            $query = "SELECT host_key, name, value, datetime(last_access_utc/1000000-11644473600, 'unixepoch') as LastAccess FROM cookies ORDER BY last_access_utc DESC LIMIT 50"
        }
        "Firefox" {
            $query = "SELECT host, name, value, datetime(lastAccessed/1000000, 'unixepoch') as LastAccess FROM moz_cookies ORDER BY lastAccessed DESC LIMIT 50"
        }
        default {
            continue
        }
    }

    $cookieData += Read-SQLiteData -DatabasePath $entry.Path -Query $query | ForEach-Object {
        $_ | Add-Member -NotePropertyName Browser -NotePropertyValue $entry.Browser -Force
        $_
    }
}
Save-ToExcelSheet -SheetName "Browser Cookies" -Data $cookieData


###################################################################################################################################


# --- Final Section: Cleanup and Save ---
Remove-DefaultSheets

$xlOpenXMLWorkbook = 51  # Excel file format for .xlsx
$workbook.SaveAs($outputExcel, $xlOpenXMLWorkbook)
$workbook.Close($true)
$excel.Quit()

Write-Host "`nExcel saved to: $outputExcel"
Write-Host "Environment variable CSV saved to: $outputCsv"


###################################################################################################################################
