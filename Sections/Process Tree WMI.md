<div align="center">

# 🧩 WMI-Based Process Tree (ProcessTreeWMI)

## **Information Pulled:**  
Name – The name of each process  
PID – The process ID (unique identifier) for each process  
ParentPID – The parent process ID (which process launched this process)  
CommandLine – The command line string used to launch the process (if available)  
StartTime – The process creation time (if available and convertible)  
User – The user account under which the process is running (in DOMAIN\User format if available)  
Section – Static identifier labeling the data as `"ProcessTreeWMI"`

---

## **Purpose & Usefulness:**  
This function builds a process tree using WMI, providing detailed relationships and context for every process on the system.

Name, PID, and ParentPID reveal process hierarchies, which is essential for detecting suspicious process spawning,  
understanding parent-child relationships, and correlating process activity in incident response.  
CommandLine shows the exact execution string, aiding in the identification of malicious scripts, hidden arguments, or command-line-based attacks.  
StartTime and User help establish process activity timelines and attribute actions to specific users or accounts.  
Collecting this information is crucial for digital forensics, threat hunting, security monitoring, and troubleshooting,  
as it allows investigators to reconstruct how programs and scripts were launched and under what security context.

</div>
