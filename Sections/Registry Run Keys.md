<div align="center">

# 🔑 Registry Run and RunOnce Keys

## **Information Pulled:**  
RegistryPath – The full registry path of the Run or RunOnce key where the entry is found  
Name – The name of the registry value (the autostart entry label)  
Value – The full command line or value stored in the registry for autostart  
Executable – The path to the executable or script (extracted from the command line where possible)  
SHA256 – The SHA-256 hash of the executable file (if found and accessible)  
Suspicious – Boolean flag indicating if the entry is potentially suspicious (e.g., launches from risky folders or runs scripts, batch files, or rundll32)  
Section – Static identifier labeling the data as `"RegistryRunKeys"`

---

## **Purpose & Usefulness:**  
This function enumerates all autorun entries from common "Run" and "RunOnce" registry keys for both the current user and the system.

RegistryPath, Name, and Value reveal what is set to launch automatically on startup or user login, which is critical for finding persistence mechanisms.  
Executable and SHA256 help identify the actual file being run and enable integrity checks or threat intelligence correlation.  
Suspicious highlights risky or non-standard entries (such as scripts or items launched via rundll32 or from temp/user folders) for further investigation.  
Collecting this data is essential for digital forensics, security auditing, and incident response,  
as malware and attackers often use these registry keys to maintain persistence.

</div>
