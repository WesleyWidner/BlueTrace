<div align="center">

# ⚙️ PowerShell Operational Event Log

## **Information Pulled:**  
TimeCreated – The timestamp when each PowerShell Operational event log entry was generated (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The numeric ID of the event (e.g., 4100 for engine lifecycle error, 4104 for scriptblock logging)  
EventIDMeaning – A friendly description of the event type (e.g., "PowerShell Engine Lifecycle Error", "ScriptBlock Logging (Executed Code)", or "Other/Unknown")  
Level – The severity or level of the event (e.g., Information, Warning, Error)  
Message – The event log message text (condensed for readability)  
Section – Static identifier labeling the data as `"PowerShellOperationalLog"`

---

## **Purpose & Usefulness:**  
This function retrieves and summarizes recent entries from the Microsoft-Windows-PowerShell/Operational event log.

TimeCreated and Level support timeline analysis and prioritization of notable PowerShell events.  
EventID and EventIDMeaning help quickly identify significant PowerShell activity, such as executed scripts, errors, or pipeline execution.  
Message provides detailed context on what PowerShell code was run or what issues occurred,  
aiding in digital forensics, incident response, and troubleshooting.  
Collecting and reviewing PowerShell Operational event logs is critical for detecting malicious PowerShell usage,  
script execution, and monitoring automation activities for security and compliance on Windows systems.

</div>
