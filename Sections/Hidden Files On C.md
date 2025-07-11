<div align="center">

# 🕵️ Hidden Files on C: Drive

## **Information Pulled:**  
FullName – The full file system path to each hidden file on the C: drive  
SizeKB – The size of each hidden file in kilobytes (rounded to two decimals)  
Created – The creation timestamp of each hidden file (formatted as yyyy-MM-dd HH:mm:ss)  
Modified – The last modified timestamp of each hidden file (formatted as yyyy-MM-dd HH:mm:ss)  
Accessed – The last accessed timestamp of each hidden file (formatted as yyyy-MM-dd HH:mm:ss)  
SHA256 – The SHA-256 cryptographic hash of each file's contents  
Section – Static identifier labeling the data as `"HiddenFilesOnC"`

---

## **Purpose & Usefulness:**  
This function searches for and collects metadata about all hidden files on the system's C: drive.

FullName provides exact locations of hidden files, which are often overlooked and may contain sensitive or suspicious data.  
SizeKB, Created, Modified, and Accessed timestamps allow investigators to analyze the activity, creation, and potential relevance of these hidden files, aiding in forensic timelines and root cause analysis.  
SHA256 enables reliable file identification and integrity checking, supporting detection of known malicious files or tracking unauthorized changes.  
Collecting and analyzing hidden file information is important for security audits, malware investigations, and monitoring for signs of compromise,  
as hidden files are commonly used by attackers to conceal their presence or data.

</div>
