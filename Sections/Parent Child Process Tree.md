<div align="center">

# 🌲 Parent-Child Process Tree Analysis

## **Information Pulled:**  
ProcessName – The name of each process  
ProcessId – The unique process ID (PID) for each process  
ParentProcessId – The process ID of the parent (which process launched this one)  
ExecutablePath – The file system path to the process's executable (if available)  
CommandLine – The command line string used to launch the process (if available)  
CreationDate – The timestamp when the process was started (formatted as yyyy-MM-dd HH:mm:ss or "Unavailable")  
Section – Static identifier labeling the data as `"ParentChildProcessTree"`

---

## **Purpose & Usefulness:**  
This function enumerates all processes and reconstructs their parent-child relationships, providing a detailed process tree for the system.

ProcessName, ProcessId, and ParentProcessId reveal how processes are spawned and linked, which is critical for identifying suspicious or malicious process chains.  
ExecutablePath and CommandLine provide insight into how and from where each process was launched, aiding in security investigations and incident response.  
CreationDate helps build a timeline of process activity, supporting event correlation and anomaly detection.  
Collecting parent-child process data is essential for digital forensics, security monitoring, and troubleshooting,  
as it exposes potentially unwanted or attacker-controlled process hierarchies and execution paths.

</div>
