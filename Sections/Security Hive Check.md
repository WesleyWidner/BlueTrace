<div align="center">

# 🔐 SECURITY Hive Metadata

## **Information Pulled:**  
Hive – The name of the registry hive ("SECURITY")  
Path – The file path to the SECURITY hive on disk  
Exists – Indicates whether the file was found ("Yes" or "No")  
Note – Description explaining that this is a binary hive file and should be parsed offline with specialized tools for detailed analysis  
Section – Static identifier labeling the data as `"SECURITY Hive"`

---

## **Purpose & Usefulness:**  
This function checks for the presence of the SECURITY registry hive, which contains sensitive local security policy information, user rights assignments, and security identifiers.

Path and Exists allow analysts to confirm the presence and availability of this critical system hive for forensic imaging or offline analysis.  
Note provides guidance for proper handling and analysis, since the hive is in binary format and not human-readable.  
Collecting the SECURITY hive is important for digital forensics, security auditing, and incident response,  
as it contains historical and current security policy configurations, audit policy, and account rights information that can be used to track changes, detect unauthorized privilege escalation, or support investigations of malicious activity.

</div>
