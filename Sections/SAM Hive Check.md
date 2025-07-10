<div align="center">

# 🔐 SAM Hive Metadata

## **Information Pulled:**  
Hive – The name of the registry hive ("SAM")  
Path – The file path to the SAM hive on disk  
Exists – Indicates whether the file was found ("Yes" or "No")  
Note – Description indicating that the SAM hive is in binary format and requires external tools (such as `reg save` or `secretsdump.py`) for analysis  
Section – Static identifier labeling the data as `"SAM Hive"`

---

## **Purpose & Usefulness:**  
This function checks for the presence of the Security Account Manager (SAM) registry hive, which stores local user account information, password hashes, and other sensitive security data.

Path and Exists help analysts confirm whether this critical security artifact is present and available for forensic extraction.  
Note guides further analysis by referencing common tools used to process or extract data from the binary hive.  
Collecting SAM hive information is essential for digital forensics, credential auditing, incident response, and post-compromise investigations,  
as it is often targeted by attackers and can provide evidence of user accounts, group memberships, and potential password compromise.

</div>
