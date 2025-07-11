<div align="center">

# 📁 File Metadata – User Profile Directory

## **Information Pulled:**  
Name – The name of each file in the user's profile directory (recursively)  
FullPath – The complete file system path to each file  
CreationTime – The timestamp when each file was created (formatted as yyyy-MM-dd HH:mm:ss)  
LastModified – The timestamp when each file was last modified (formatted as yyyy-MM-dd HH:mm:ss)  
LastAccessed – The timestamp when each file was last accessed (formatted as yyyy-MM-dd HH:mm:ss)  
SHA256 – The SHA-256 cryptographic hash of each file's contents  
Section – Static identifier labeling the data as `"FileMetadata"`

---

## **Purpose & Usefulness:**  
This function collects comprehensive metadata for all files within the user's profile directory, including subdirectories.

Name and FullPath allow precise identification and location of files, which is vital for investigations and audits.  
CreationTime, LastModified, and LastAccessed provide a complete activity timeline for each file, useful for forensic analysis, incident response, and detecting unusual or suspicious behavior (such as unauthorized access or changes).  
SHA256 supplies a unique cryptographic fingerprint for each file, enabling file integrity checks, tampering detection, and correlation with known malicious files or threat intelligence databases.  
This detailed file inventory supports data loss prevention, compliance efforts, and investigations into user activity or potential security incidents.

</div>
