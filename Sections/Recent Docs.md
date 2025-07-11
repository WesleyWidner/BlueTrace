<div align="center">

# 📄 Recent Documents Registry Entries

## **Information Pulled:**  
SubKey – The subkey under RecentDocs (typically representing file type or grouping)  
ValueName – The name of the registry value storing the recent document reference  
ValueType – The data type of the registry value  
RawValue – The raw value stored in the registry (often a file path or filename)  
SHA256 – The SHA-256 hash of the referenced file (if accessible and not a folder), or "N/A"/error indicator  
Section – Static identifier labeling the data as `"RecentDocs"`

---

## **Purpose & Usefulness:**  
This function retrieves and parses the Windows RecentDocs registry key, collecting references to files that have been recently accessed by the current user.

SubKey, ValueName, and RawValue reveal the types of documents accessed and their actual paths or identifiers, helping to reconstruct user activity and document usage.  
ValueType provides insight into how the recent document reference is stored, which can aid in further analysis.  
SHA256 enables integrity checking and identification of specific files accessed, which is valuable for digital forensics, user activity monitoring, and incident response.  
Collecting this data is important for tracking user actions, understanding recent file access patterns, and identifying potentially sensitive or exfiltrated documents.

</div>
