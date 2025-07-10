<div align="center">

# 🛠️ Windows Setup Event Log

## **Information Pulled:**  
TimeCreated – The timestamp when each Setup event log entry was generated (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The numeric ID of the event (e.g., 1 for setup started, 30103 for feature update completed)  
EventIDMeaning – A friendly description of the event type (e.g., "Setup started", "Feature Update Completed", or "Unknown")  
KB – The KB (Knowledge Base) identifier extracted from the event message, if available  
Level – The severity or level of the event (e.g., Information, Warning, Error)  
Message – The event log message text (condensed for readability)  
Section – Static identifier labeling the data as `"SetupEventLog"`

---

## **Purpose & Usefulness:**  
This function retrieves and summarizes recent entries from the Windows Setup Event Log.

TimeCreated and Level help build a timeline of setup, update, and restoration events, supporting troubleshooting and historical analysis.  
EventID and EventIDMeaning provide quick insight into the type and status of each setup or update event.  
KB identifies specific Microsoft updates, patches, or rollups, supporting patch management, vulnerability tracking, and compliance verification.  
Message supplies detailed context for installation and update events, aiding in root cause analysis for setup or update failures.  
Collecting and interpreting Setup event logs is crucial for identifying upgrade history, troubleshooting failed installations, verifying system updates, and supporting digital forensics on Windows systems.

</div>
