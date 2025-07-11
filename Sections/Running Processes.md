<div align="center">

# 🏃‍♂️ Running Processes

## **Information Pulled:**  
Name – The name of each running process  
Id – The process ID (PID) of each running process  
Path – The file system path to the executable for each process (if accessible; otherwise "ACCESS_DENIED" or "N/A")  
StartTime – The timestamp when each process was started (if accessible; otherwise "ACCESS_DENIED")  
Section – Static identifier labeling the data as `"RunningProcesses"`

---

## **Purpose & Usefulness:**  
This function collects information about all currently running processes on the system.

Name and Id uniquely identify each process, which is useful for system monitoring, troubleshooting, and correlation with security events.  
Path shows the location of the executable file for each process, helping identify legitimate versus suspicious or potentially malicious processes.  
StartTime indicates when the process began, which aids in timeline reconstruction for incident response and in identifying long-running or recently started processes.  
Collecting this data supports system health checks, digital forensics, security monitoring, and can help detect unauthorized or anomalous processes running on the system.

</div>
