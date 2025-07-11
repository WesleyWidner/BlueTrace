<div align="center">

# 🕑 Volume Shadow Copies (Snapshots)

## **Information Pulled:**  
ID – The unique identifier for each volume shadow copy (snapshot)  
VolumeName – The original volume name or drive letter associated with the shadow copy  
InstallDate – The creation timestamp of each shadow copy (InstallDate or Creation Time)  
Section – Static identifier labeling the data as `"VolumeShadowCopies"`

---

## **Purpose & Usefulness:**  
This function enumerates all Volume Shadow Copies (snapshots) present on the system, using both WMI and a command-line fallback for completeness.

ID provides a unique handle for each shadow copy, useful for referencing or managing specific snapshots.  
VolumeName shows which disk volume or partition the shadow copy belongs to, supporting targeted restoration or analysis.  
InstallDate establishes when each shadow copy was created, which helps in constructing backup, recovery, or compromise timelines.  
Collecting this information is important for data recovery planning, forensic investigations (since deleted or modified data may be recoverable from snapshots),  
and for identifying unauthorized or suspicious shadow copy creation that may indicate ransomware or attacker activity.

</div>
