<div align="center">

# 🚀 Startup Folder Items

## **Information Pulled:**  
User – The user account associated with each Startup folder item  
ItemName – The name of the file (shortcut, script, or executable) found in a Startup folder  
FullPath – The complete file system path to the Startup item  
LastModified – The last modified timestamp of the Startup item  
SHA256 – The SHA-256 cryptographic hash of the Startup item (for integrity and threat hunting)  
Suspicious – Boolean flag indicating if the item is potentially suspicious (e.g., located in risky folders or is a script or shortcut file)  
Section – Static identifier labeling the data as `"StartupFolderItems"`

---

## **Purpose & Usefulness:**  
This function enumerates all files in the Startup folders for the current user, all users, and each profile on the system, collecting detailed metadata for each item.

User, ItemName, and FullPath allow clear attribution and location of auto-starting programs, which is essential for investigating persistence mechanisms.  
LastModified shows when each item was last changed, supporting timeline analysis and detecting recent additions or modifications.  
SHA256 uniquely identifies each file for integrity checks and correlation with threat intelligence or known malware.  
Suspicious flags quickly highlight items that might represent malicious persistence (such as scripts, links, or items in risky locations).  
Collecting this information is vital for digital forensics, incident response, security auditing,  
and detection of unauthorized or malicious programs set to run at login or system start.

</div>
