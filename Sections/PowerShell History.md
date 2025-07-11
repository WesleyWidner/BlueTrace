<div align="center">

# 🧾 PowerShell Command History

## **Information Pulled:**  
Timestamp – The last modified time of the PowerShell history file containing the command  
LineNumber – The line number of the command in the history file  
Command – The exact PowerShell command or line that was entered  
Section – Static identifier labeling the data as `"PowerShellHistory"`

---

## **Purpose & Usefulness:**  
This function collects and parses PowerShell command history from standard transcript and history files found in the user's profile.

Timestamp shows when the history file was last updated, helping establish timelines for script or command execution.  
LineNumber helps reference and review specific commands within the context of their sequence.  
Command provides full visibility into user and script activity within the PowerShell environment,  
which is invaluable for incident response, security auditing, and troubleshooting.  
Collecting PowerShell command history can reveal attempted or successful privilege escalation, persistence,  
data exfiltration, or misconfiguration efforts performed via PowerShell.

</div>
