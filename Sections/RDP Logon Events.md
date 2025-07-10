<div align="center">

# 🖥️ Remote Desktop Protocol (RDP) Logon Events (Event ID 1149)

## **Information Pulled:**  
TimeCreated – The timestamp when each RDP logon event occurred (formatted as yyyy-MM-dd HH:mm:ss)  
EventID – The event ID (should be 1149 for successful Remote Desktop connection attempts)  
Message – The full event log message text (condensed for readability)  
Section – Static identifier labeling the data as `"RDP Logon Events"`

---

## **Purpose & Usefulness:**  
This function retrieves and summarizes recent Remote Desktop Protocol (RDP) logon events (Event ID 1149) from the Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational event log.

TimeCreated and EventID provide a timeline of RDP connection attempts to the system, helping to identify both legitimate and potentially unauthorized access.  
Message contains details such as user, source IP, and session information, which are crucial for forensic investigations, incident response, and security monitoring.  
Collecting RDP logon event data is essential for tracking remote access activity, detecting brute-force or lateral movement attempts,  
and maintaining audit trails for compliance or review.

</div>
