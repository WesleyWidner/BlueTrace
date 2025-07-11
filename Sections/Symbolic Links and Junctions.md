<div align="center">

# 🔗 Symbolic Links and Junction Points

## **Information Pulled:**  
FullName – The full file system path to each symbolic link or junction found on the C: drive  
Attributes – The file system attributes of each reparse point (as a string)  
LinkType – The type of reparse point detected ("SymbolicLink" for files or "Junction" for folders)  
Section – Static identifier labeling the data as `"SymbolicLinksAndJunctions"`

---

## **Purpose & Usefulness:**  
This function enumerates all symbolic links and junctions (reparse points) on the C: drive.

FullName allows identification and location of each link or junction, which is critical for understanding file system structure and navigation.  
Attributes provide additional context about the item, including its reparse point status and other file properties.  
LinkType distinguishes between file-based symbolic links and folder-based junction points, which may behave differently.  
Collecting information on symbolic links and junctions is valuable for security audits, digital forensics, and troubleshooting,  
as these features can be abused for persistence, evasion, or redirection by attackers, or can complicate file system analysis and data recovery.

</div>
