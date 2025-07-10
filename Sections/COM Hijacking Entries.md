<div align="center">

# 🧬 COM Hijacking Entry Scan

## **Information Pulled:**  
CLSIDPath – The registry path for each COM object’s CLSID key  
DLLPath – The path to the DLL file registered for that CLSID’s InprocServer32 (the file loaded by the COM object)  
SHA256 – The SHA-256 hash of the DLL file (if found and accessible)  
IsSigned – Boolean indicating if the DLL file is digitally signed and valid  
SignatureStatus – The status of the DLL’s digital signature (e.g., Valid, NotSigned, CheckFailed)  
Publisher – The publisher or subject of the DLL’s signing certificate (if available)  
Suspicious – Boolean flag indicating if the DLL path is potentially suspicious (e.g., located in AppData, Temp, Roaming, Downloads, or is unsigned)  
Section – Static identifier labeling the data as `"COMHijackingEntries"`

---

## **Purpose & Usefulness:**  
This function scans CLSID entries in the registry for both the current user and the system, extracting DLL paths and related metadata for each registered COM object.

CLSIDPath and DLLPath help identify which DLLs are set to load for COM objects, which is crucial for detecting COM hijacking attacks (a stealthy persistence technique).  
SHA256, IsSigned, SignatureStatus, and Publisher enable integrity checks and help distinguish trusted system DLLs from potentially malicious ones.  
Suspicious flags quickly highlight risky or non-standard DLL locations and unsigned files, which may indicate unauthorized persistence or code injection.  
Collecting this data is important for digital forensics, incident response, and security audits,  
as malicious actors may register their own DLLs for auto-loading via COM object hijacking.

</div>
