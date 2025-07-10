<div align="center">

# 🔒 Windows Security Event Log

## **Information Pulled:**  
TimeCreated – The timestamp when each Security event log entry was generated (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The numeric ID of the event (e.g., 4624 for logon success, 4688 for process creation)  
EventIDMeaning – A friendly description of the event type (e.g., "Account Logon Success", "New Process Created", or "Other / Unknown")  
Level – The severity or level of the event (e.g., Information, Warning, Error)  
Message – The event log message text (condensed for readability)  
Section – Static identifier labeling the data as `"SecurityEventLog"`

---

## **Purpose & Usefulness:**  
This function retrieves and parses recent entries from the Windows Security Event Log, providing both raw data and summarized descriptions.

TimeCreated and Level allow for quick filtering and timeline analysis of security-relevant activity.  
EventID and EventIDMeaning help analysts understand the type and context of each event, supporting incident triage and security monitoring.  
Message provides the detailed event context needed for forensic investigations, threat hunting, and audit compliance.  
Collecting and interpreting Security event logs is crucial for detecting suspicious authentication, privilege escalation, process creation, and other potentially malicious activity.

</div>
