<div align="center">

# 📂 Prefetch File Metadata

## **Information Pulled:**  
Name – The name of each Prefetch file (.pf)  
Path – The full file system path to the Prefetch file  
SizeKB – The size of the Prefetch file in kilobytes  
Modified – The last modified timestamp of the Prefetch file  
Section – Static identifier labeling the data as `"PrefetchFiles"`

---

## **Purpose & Usefulness:**  
This function checks for the existence of the Windows Prefetch folder and collects metadata on all available Prefetch files.

Prefetch files (.pf) are created by Windows to optimize application startup and track program execution history.  
Name, Path, SizeKB, and Modified provide information for triage and further offline analysis  
(using forensic tools like PECmd or WinPrefetchView).  
Collecting Prefetch metadata is crucial for digital forensics, incident response, and activity reconstruction,  
as these files reveal when and how often programs were run, last execution time,  
and sometimes the path to the executed binary—even if the program or logs have been deleted.

</div>
