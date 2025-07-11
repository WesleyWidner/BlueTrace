<div align="center">

# 🔐 Successful Logon Events (Event ID 4624)

## **Information Pulled:**  
TimeCreated – The timestamp when each logon event was generated (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The event log ID (should be 4624, indicating a successful logon)  
Account – The username/account name that logged in (extracted from the event message)  
LogonType – The numeric logon type (e.g., 2 for interactive, 3 for network, etc.)  
LogonID – The unique logon session ID (from the event)  
Message – The full event log message (condensed for readability)  
Section – Static identifier labeling the data as `"LogonEvents"`

---

## **Purpose & Usefulness:**  
This function retrieves recent successful logon events (Event ID 4624) from the Security Event Log and extracts key fields for each.

TimeCreated, Account, LogonType, and LogonID allow you to reconstruct user authentication activity, track specific sessions, and identify logon methods.  
Message provides the raw context for deeper forensic review or correlation.  
Collecting this data is critical for digital forensics, security monitoring, and incident response,  
as it helps identify legitimate or suspicious logons, detect lateral movement, and support investigations into unauthorized access.

</div>
