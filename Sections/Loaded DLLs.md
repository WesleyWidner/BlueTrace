<div align="center">

# 🧬 Loaded DLLs in Running Processes

## **Information Pulled:**  
ProcessName – The name of the process in which each DLL/module is loaded  
PID – The process ID for each process  
ModuleName – The name of the loaded DLL or module  
FilePath – The file system path to the DLL or module file  
SHA256 – The SHA-256 cryptographic hash of the DLL file (or error indicator)  
Signature – The Authenticode digital signature status of the DLL file (e.g., Valid, Invalid, or error indicator)  
CompanyName – The company name from the DLL's version info (if available)  
SuspiciousPath – Boolean indicating whether the DLL is loaded from potentially suspicious locations (such as AppData, Temp, Roaming, or Downloads)  
Section – Static identifier labeling the data as `"LoadedDLLs"`

---

## **Purpose & Usefulness:**  
This function enumerates all DLLs (modules) loaded into running processes, along with relevant metadata for each.

ProcessName, PID, ModuleName, and FilePath provide precise context on which processes are using which DLLs and where those DLLs reside on disk.  
SHA256 uniquely identifies the DLL for integrity checks, threat intelligence matching, or further forensic analysis.  
Signature and CompanyName assist in distinguishing trusted, signed modules from unsigned or suspicious third-party code.  
SuspiciousPath flags modules loaded from unusual or high-risk directories, which are often used by malware or attackers for persistence or injection.  
Collecting this data is vital for security monitoring, digital forensics, malware detection, and understanding the operational context of system and third-party code in memory.

</div>
