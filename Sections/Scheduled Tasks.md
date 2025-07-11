<div align="center">

# ⏰ Scheduled Tasks Metadata

## **Information Pulled:**  
TaskName – The name of each scheduled task  
TaskPath – The path of each scheduled task in Task Scheduler  
State – The current status of the task (e.g., Ready, Running, Disabled)  
LastRunTime – The last time the task was run (formatted as yyyy-MM-dd HH:mm:ss or "Never")  
NextRunTime – The next scheduled run time for the task (if available)  
LastResult – The last result or exit code of the task's last run  
Hidden – Boolean indicating if the task is hidden from standard Task Scheduler views  
Principal – The user account under which the task runs  
Action – The command(s) or executable(s) the task runs  
Trigger – The trigger(s) for the task (e.g., schedule, at logon)  
SHA256 – The SHA-256 hash of the executable/action for the task (if resolvable)  
SuspiciousPath – Boolean flag indicating if the task's action points to suspicious locations (e.g., AppData, Temp, Downloads, or user profile directories)  
SuspiciousTrigger – Boolean flag indicating if the task uses suspicious or high-risk triggers (e.g., running late at night, at logon, or with repetition)  
Section – Static identifier labeling the data as `"ScheduledTasks"`

---

## **Purpose & Usefulness:**  
This function enumerates all scheduled tasks on the system and gathers detailed metadata about each one.

TaskName, TaskPath, State, Action, and Trigger allow for identification and review of what each scheduled task does and when it executes.  
Principal identifies the user context, which is crucial for assessing privilege levels and risk.  
LastRunTime, NextRunTime, and LastResult provide execution history for auditing, troubleshooting, and incident investigation.  
Hidden and SuspiciousPath/SuspiciousTrigger flags help quickly spot stealthy or potentially malicious tasks that could be used for persistence, privilege escalation, or lateral movement.  
SHA256 supports file integrity checks and threat hunting by providing a unique hash for each executable or script run by a task.  
Collecting this information is essential for security monitoring, compliance auditing, digital forensics,  
and detecting unauthorized or malicious persistence mechanisms.

</div>
