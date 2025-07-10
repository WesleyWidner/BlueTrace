<div align="center">

# 🔐 Account Lockout Event Data (Event ID 4740)

## **Information Pulled:**  
TimeCreated – The timestamp when each account lockout event was generated (formatted as yyyy-MM-dd HH:mm:ss)  
User – The username associated with the lockout event (extracted from the event message if available)  
Message – The full event log message text (condensed for readability)  
Section – Static identifier labeling the data as `"AccountLockouts"`

---

## **Purpose & Usefulness:**  
This function retrieves and parses recent account lockout events (Event ID 4740) from the Windows Security Event Log.

TimeCreated and User allow for identification of when and for which account lockouts occurred, aiding in timeline and user-specific analysis.  
Message provides detailed context for each lockout event, supporting forensic investigations and detection of brute-force attacks, misconfigurations, or suspicious account activity.  
Collecting account lockout data is important for security monitoring, incident response, and compliance,  
as repeated or unexplained lockouts can be an indicator of attempted unauthorized access or account misuse.

</div>
