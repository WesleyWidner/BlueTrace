<div align="center">

# 🪟 Application Event Log (Windows Event Log)

## **Information Pulled:**  
TimeCreated – The timestamp when each Application event log entry was generated (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The numeric ID of the event (e.g., 1000 for application error, 11707 for application installed)  
EventIDMeaning – A friendly description of the event type (e.g., "Application Error / Crash", "Application Installed", or "Unknown")  
Level – The severity or level of the event (e.g., Information, Warning, Error)  
Message – The event log message text (condensed for readability)  
Section – Static identifier labeling the data as `"ApplicationEventLog"`

---

## **Purpose & Usefulness:**  
This function retrieves and summarizes recent entries from the Windows Application Event Log.

TimeCreated and Level support quick filtering and timeline analysis of application-related events.  
EventID and EventIDMeaning help analysts rapidly understand the relevance and type of each event for efficient triage and troubleshooting.  
Message supplies detailed context for application errors, installation events, runtime issues, and software licensing actions, supporting incident response and compliance audits.  
Collecting and interpreting Application event logs is vital for detecting software failures, installation issues, and .NET/runtime errors on Windows systems.

</div>
