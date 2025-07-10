<div align="center">

# 🗄️ SRUM Database Check (SRUDB.dat)

## **Information Pulled:**  
SRUDB_Path – The file path to SRUDB.dat (the System Resource Usage Monitor database), or "Not Found" if the file does not exist  
Note – A short message indicating whether the database exists and, if so, that external tools like SRUM-Dump or SQLite tools are needed for analysis  
Section – Static identifier labeling the data as `"SRUM"`

---

## **Purpose & Usefulness:**  
This function checks for the existence of the SRUM database, which contains detailed system resource usage information, including app/network usage, energy consumption, and some user activity history.

SRUDB_Path and Note inform an analyst of the presence of this key forensic artifact and provide next steps for deeper analysis.  
The SRUM database is important for digital forensics, incident response, and activity reconstruction,  
as it can reveal patterns of application/network usage, logon activity, and system events even when traditional event logs have been cleared.

</div>
