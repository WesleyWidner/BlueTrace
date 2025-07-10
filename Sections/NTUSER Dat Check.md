<div align="center">

# 🧾 NTUSER.DAT Hive Metadata

## **Information Pulled:**  
Username – The user account associated with each NTUSER.DAT file found under `C:\Users`  
NTUSERPath – The full file system path to the NTUSER.DAT registry hive file  
LastModified – The last modified timestamp of the NTUSER.DAT file (formatted as yyyy-MM-dd HH:mm:ss)  
SizeKB – The size of the NTUSER.DAT file in kilobytes (rounded to two decimals)  
SHA256 – The SHA-256 cryptographic hash of the NTUSER.DAT file  
Section – Static identifier labeling the data as `"NTUSERDat"`

---

## **Purpose & Usefulness:**  
This function enumerates all NTUSER.DAT files for user profiles on the system, collecting key metadata for each.

Username and NTUSERPath provide attribution and location of the per-user registry hive,  
which stores personal settings, user-specific configuration, and sometimes persistence mechanisms.  
LastModified and SizeKB help identify recent changes or abnormal file sizes,  
which may indicate malware or unauthorized modification of user registry data.  
SHA256 supplies a unique identifier for the file, supporting file integrity checks and forensic comparisons across systems or over time.  
Collecting this information is valuable for digital forensics, incident response, and monitoring for suspicious changes to user-specific registry hives  
that may impact security or system stability.

</div>
