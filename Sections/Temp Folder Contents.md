<div align="center">

# 🗃️ TEMP Folder Contents

## **Information Pulled:**  
FullName – The complete file system path to each file in the user's TEMP directory (recursively)  
Length – The size of each temporary file in bytes  
LastWriteTime – The last modified timestamp of each file (formatted as yyyy-MM-dd HH:mm:ss)  
SHA256 – The SHA-256 cryptographic hash of each file's contents  
Section – Static identifier labeling the data as `"TempFolderContents"`

---

## **Purpose & Usefulness:**  
This function collects metadata for all files found in the user's TEMP directory and its subfolders.

FullName identifies where each temporary file is stored, which is helpful in locating suspicious or potentially sensitive files that could be left behind by applications or malware.  
Length gives the size of each file, which helps in prioritizing analysis or cleanup.  
LastWriteTime shows when the file was last modified, which can help correlate temporary file creation or changes with system events or possible compromise.  
SHA256 provides a unique identifier for each file's contents, useful for integrity checking and for matching files against known malicious or sensitive file hashes.  
Collecting this data supports digital forensics, incident response, and system maintenance by highlighting transient files that may hold evidence of user or attacker activity.

</div>
