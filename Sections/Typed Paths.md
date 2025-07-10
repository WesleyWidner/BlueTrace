<div align="center">

# 📝 Typed Paths (Explorer Address Bar)

## **Information Pulled:**  
EntryName – The name of the registry value (typically in the format url1, url2, etc.)  
PathValue – The actual path or URL typed by the user into Windows Explorer's address bar  
Section – Static identifier labeling the data as `"TypedPaths"`

---

## **Purpose & Usefulness:**  
This function retrieves data from the TypedPaths registry key, which tracks file system paths and URLs entered by the user into the Windows Explorer address bar.

EntryName and PathValue reveal direct user navigation, showing what locations have been accessed or browsed, regardless of whether the user used links or shortcuts.  
Collecting this data is useful for digital forensics, user activity monitoring, and incident response,  
as it provides insight into user intent and access history—potentially exposing attempted access to sensitive, remote, or otherwise noteworthy folders or shares.

</div>
