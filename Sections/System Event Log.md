<div align="center">

# 🖥️ Windows System Event Log

## **Information Pulled:**  
TimeCreated – The timestamp when each System event log entry was generated (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The numeric ID of the event (e.g., 6008 for unexpected shutdown, 7045 for service installation)  
EventIDMeaning – A friendly description of the event type (e.g., "Unexpected Shutdown", "Service Installed", or "Unknown")  
Level – The severity or level of the event (e.g., Information, Warning, Error)  
Message – The event log message text (condensed for readability)  
Section – Static identifier labeling the data as `"SystemEventLog"`

---

## **Purpose & Usefulness:**  
This function retrieves and summarizes recent entries from the Windows System Event Log.

TimeCreated and Level allow for quick filtering and timeline analysis of system-related activity and incidents.  
EventID and EventIDMeaning help analysts understand the type and relevance of each event, aiding in event triage and system health monitoring.  
Message provides detailed context for system events, supporting troubleshooting, digital forensics, and compliance auditing.  
Collecting and interpreting System event logs is critical for detecting service issues, boot problems, hardware failures,  
and other significant operational or security events on a Windows system.

</div>
