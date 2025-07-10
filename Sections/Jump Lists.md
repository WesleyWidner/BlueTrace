<div align="center">

# 📄 Jump List Metadata (AutomaticDestinations)

## **Information Pulled:**  
FileName – The name of each Jump List file found in the AutomaticDestinations folder  
FullPath – The full file system path to each Jump List file  
Modified – The last modified timestamp of each Jump List file (formatted as yyyy-MM-dd HH:mm:ss)  
Section – Static identifier labeling the data as `"JumpLists"`

---

## **Purpose & Usefulness:**  
This function enumerates Jump List files from the user's AutomaticDestinations folder, which Windows uses to track recently and frequently accessed files and destinations for applications pinned to the taskbar or Start menu.

FileName and FullPath allow for precise identification and further analysis of each Jump List, which may contain references to user activity and file access history.  
Modified gives a timeline for when the Jump List was last updated, supporting investigations into recent user actions.  
Collecting Jump List metadata is important for digital forensics, user activity monitoring, and incident response, as these files can reveal valuable information about what documents and applications the user has interacted with, even if other traces have been deleted.

</div>
