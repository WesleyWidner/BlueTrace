<div align="center">

# 🗂️ ShellBags Registry Metadata

## **Information Pulled:**  
Path – The registry path checked for ShellBag information (e.g., BagMRU, Bags under HKCU)  
Exists – Boolean indicating whether the registry key exists on the system  
LastWrite – The last modified timestamp of the registry key (formatted as yyyy-MM-dd HH:mm:ss or "N/A")  
Section – Static identifier labeling the data as `"ShellBags"`

---

## **Purpose & Usefulness:**  
This function checks for the existence and last modification time of key ShellBag registry entries, which Windows uses to store folder view settings and track folder access/navigation history.

Path and Exists indicate which ShellBag structures are present for the user, supporting validation and discovery during forensic analysis.  
LastWrite helps establish a timeline for when a user last interacted with or modified folder views, which can correlate with user activity or the presence of evidence in certain folders.  
Collecting ShellBag information is valuable for digital forensics and incident response,  
as ShellBags can reveal folder traversal and access even if files or shortcuts have been deleted or cleared.

</div>
