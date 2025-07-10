<div align="center">

# 📝 Windows PowerShell Event Log

## **Information Pulled:**  
TimeCreated – The timestamp when each Windows PowerShell event log entry was generated (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The numeric ID of the event (e.g., 400 for engine lifecycle, 403 for command started)  
EventIDMeaning – A friendly description of the event type (e.g., "Engine Lifecycle State Changed", "Command Started", or "Other/Unknown")  
Level – The severity or level of the event (e.g., Information, Warning, Error)  
Message – The event log message text (condensed for readability)  
Section – Static identifier labeling the data as `"WindowsPowerShellLog"`

---

## **Purpose & Usefulness:**  
This function retrieves and summarizes recent entries from the Windows PowerShell event log.

TimeCreated and Level help build a timeline and filter events based on severity for efficient analysis.  
EventID and EventIDMeaning provide quick context about the nature of each PowerShell event, supporting triage and incident response.  
Message offers detailed information about PowerShell execution, module loads, and errors, which is essential for digital forensics, monitoring for unauthorized PowerShell activity, and troubleshooting script or automation issues.  
Collecting and reviewing Windows PowerShell event logs is vital for detecting potential abuse of PowerShell by attackers, understanding automation activity, and maintaining security on Windows systems.

</div>
