<div align="center">

# 🖥️ Desktop File Timestamps

## **Information Pulled:**  
Name – The name of each file on the user's Desktop  
FullPath – The full file system path to each Desktop file  
LastModified – The last modified timestamp for each file (formatted as yyyy-MM-dd HH:mm:ss)  
SHA256 – The SHA-256 cryptographic hash of each file's contents  
Section – Static identifier labeling the data as `"DesktopFileTimestamps"`

---

## **Purpose & Usefulness:**  
This function gathers detailed information about all files located on the user's Desktop.

Name and FullPath identify where files are located and what they are called, which can be important in tracking user activity and understanding file organization.  
LastModified records when files were last changed, which is valuable for forensic analysis, incident response, or detecting recent suspicious activity.  
SHA256 provides a unique hash for each file, enabling reliable file identification, detecting tampering, or checking for known malicious files by hash comparison.  
Collecting this information helps monitor critical user-facing files, supports investigations into data exfiltration or modification,  
and assists in compliance with security policies regarding sensitive files.

</div>
