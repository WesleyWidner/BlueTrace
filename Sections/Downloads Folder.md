<div align="center">

# 📥 Downloads Folder Scan

## **Information Pulled:**  
Name – The name of each file found in the Downloads folder  
Path – The full path to each file  
SizeKB – The size of each file in kilobytes  
Modified – The last modified timestamp of each file  
SHA256 – The SHA-256 hash of each file (or an error message if hash generation fails)  
Section – Static identifier labeling the data as `"DownloadsFolder"`

---

## **Purpose & Usefulness:**  
This function recursively scans the user's Downloads folder, collecting metadata and hashes for all files found.

Name, Path, SizeKB, and Modified provide critical triage and evidence information for each download, helping identify when files were received and their details.  
SHA256 ensures files can be uniquely identified, correlated with threat intelligence, and checked for tampering or malicious content.  
Collecting Downloads folder data is important for digital forensics, incident response, and malware investigations,  
as this location is a common source for new, suspicious, or harmful files downloaded by the user or attacker.

</div>
