<div align="center">

# 🧬 DLL Search Order Hijack Scan

## **Information Pulled:**  
DLLName – The file name of each DLL found in target directories  
Path – The full file system path to each DLL  
LastWritten – The last modified timestamp of the DLL (formatted as yyyy-MM-dd HH:mm:ss)  
SHA256 – The SHA-256 hash of the DLL file  
IsSigned – Boolean indicating if the DLL is digitally signed and valid  
SignatureStatus – The status of the digital signature (e.g., Valid, NotSigned, CheckFailed)  
Publisher – The publisher or subject of the signing certificate (if available)  
Suspicious – Boolean flag indicating if the DLL is potentially suspicious (e.g., found in risky folders or unsigned)  
Section – Static identifier labeling the data as `"DLLSearchOrderHijacks"`

---

## **Purpose & Usefulness:**  
This function scans common and high-risk directories for DLL files, collecting metadata that helps detect DLL search order hijacking risks.

DLLName and Path identify DLL files and their locations, which is important because DLL search order hijacks occur  
when malicious DLLs are placed in locations loaded preferentially by Windows or specific applications.  
LastWritten provides file timeline information, aiding in forensic analysis and detecting recent unauthorized changes.  
SHA256, IsSigned, SignatureStatus, and Publisher enable file integrity checks and help distinguish trusted DLLs from potentially malicious ones.  
Suspicious flags highlight unsigned DLLs or those found in user-writable or high-risk directories, supporting prioritization in investigations.  
Collecting this data is crucial for security audits, incident response, digital forensics, and threat hunting,  
as DLL search order hijacking is a common persistence and code injection technique used by attackers.

</div>
