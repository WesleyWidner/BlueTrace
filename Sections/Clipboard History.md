<div align="center">

# 📋 Clipboard History Metadata

## **Information Pulled:**  
Name – The name of each file or item found in the Windows Clipboard history storage directory  
FullPath – The full file system path to each clipboard history item  
Size – The size (in bytes) of each clipboard history file  
Modified – The last modified timestamp of each clipboard history file (formatted as yyyy-MM-dd HH:mm:ss)  
Section – Static identifier labeling the data as `"ClipboardHistory"`

---

## **Purpose & Usefulness:**  
This function enumerates the contents of the Windows Clipboard history storage directory, collecting metadata for each item.

Name and FullPath provide precise identification and location of clipboard history items, supporting targeted analysis or retrieval.  
Size and Modified offer insights into the recency and potential relevance of clipboard usage, aiding timeline construction for user activity.  
Collecting clipboard history metadata is valuable for digital forensics, user activity monitoring, and incident response,  
as clipboard data may include sensitive information (such as passwords, copied files, or confidential data) that was recently accessed or transferred.

</div>
