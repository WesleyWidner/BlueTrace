<div align="center">

# 📡 WMI Activity Logs

## **Information Pulled:**  
TimeCreated – The timestamp when each WMI event was generated (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The event ID associated with each WMI activity event  
EventType – A descriptive label for the type of WMI activity (e.g., Query Execution Started, Query Execution Completed, Error, etc.)  
ProcessID – The process ID that initiated the WMI operation (if available)  
User – The user account that performed the WMI operation (if available)  
Operation – The specific operation being performed (e.g., WMI query, method call)  
Namespace – The WMI namespace in which the operation occurred  
Query – The actual WMI query or operation details (if available)  
Section – Static identifier labeling the data as `"WmiActivityLogs"`

---

## **Purpose & Usefulness:**  
This function collects recent events from the Windows WMI Activity Operational log, which records detailed activity for all WMI (Windows Management Instrumentation) operations.

TimeCreated, EventID, and EventType provide essential timeline and classification data for each event.  
ProcessID and User identify who initiated the activity, supporting attribution and investigation of potentially malicious or unauthorized activity.  
Operation, Namespace, and Query provide context on exactly what was being accessed or executed, helping in threat hunting, security auditing, and troubleshooting.  
Collecting and analyzing WMI activity is critical for incident response and digital forensics, as attackers often abuse WMI for persistence, lateral movement, and execution of malicious code.

</div>
