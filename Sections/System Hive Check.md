<div align="center">

# 🧩 SYSTEM Hive Metadata

## **Information Pulled:**  
Hive – The name of the registry hive ("SYSTEM")  
Path – The full file system path to the SYSTEM hive  
Exists – Indicates whether the SYSTEM hive file is present ("Yes" or "No")  
Note – Guidance on usage (recommending offline registry parsing tools if found)  
Section – Static identifier labeling the data as `"SystemHive"`

---

## **Purpose & Usefulness:**  
This function checks for the presence of the SYSTEM registry hive file, which contains key configuration data for the operating system, hardware, and system services.

Path and Exists indicate whether the hive can be collected for forensic imaging or offline analysis.  
The Note field provides next steps, since SYSTEM is a binary file requiring specialized parsing tools.  
SYSTEM hive data is crucial for digital forensics, malware analysis, and incident response,  
as it reveals boot configuration, device drivers, service settings, and other OS-level details that can be used to investigate persistence, attacks, or system changes.

</div>
