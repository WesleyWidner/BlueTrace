<div align="center">

# 📂 Files Accessed in the Last 7 Days (C:\ Drive)

## **Information Pulled:**  
FullName – The full file system path to each file accessed within the last 7 days on the C: drive  
LastAccessTime – The timestamp when each file was last accessed  
SizeKB – The size of each file in kilobytes (rounded to two decimals)  
LastWriteTime – The timestamp when each file was last modified  
Created – The creation timestamp of each file  
SHA256 – The SHA-256 cryptographic hash of each file's contents  
Section – Static identifier labeling the data as `"FilesAccessedLast14Days"`

---

## **Purpose & Usefulness:**  
This function collects metadata about every file on the C: drive that has been accessed within the last 7 days.

FullName provides the precise file locations, enabling investigators to see exactly which files have been recently interacted with.  
LastAccessTime, LastWriteTime, and Created timestamps give a comprehensive view of file activity and lifecycle, aiding in establishing timelines or detecting unusual access patterns.  
SizeKB helps quickly assess file relevance based on size.  
SHA256 supplies a cryptographic fingerprint for each file, which is useful for checking integrity, tracking changes, or matching files against known threat intelligence databases.  
This information is especially valuable for incident response, data loss prevention, and forensic investigations,  
as it highlights potentially sensitive or suspicious files that have been recently opened or used.

</div>
