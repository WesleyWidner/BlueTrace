<div align="center">

# 🧾 Amcache Hive Presence Check

## **Information Pulled:**  
File – The name of the file checked (`Amcache.hve`)  
Path – The full file path to `Amcache.hve`  
Exists – Indicates whether the file was found (`Yes` or `No`)  
Note – Description indicating the file is a binary registry hive and suggesting use of an external parser (such as AmcacheParser)  
Section – Static identifier labeling the data as `"AmcacheCheck"`

---

## **Purpose & Usefulness:**  
This function checks for the presence of the `Amcache.hve` registry hive, which contains historical data about executables, installers, and device drivers that have run on the system.

`Amcache.hve` is a valuable forensic artifact that records program execution and can be parsed to build a timeline of software usage and installation.  
Path and Exists help determine if this artifact is available for deeper forensic analysis.  
Note guides the analyst to appropriate tools for parsing, since the file is in binary format.  
Collecting Amcache information is important for digital forensics, incident response, and threat hunting,  
as it often preserves evidence of execution even after files or logs have been deleted.

</div>
