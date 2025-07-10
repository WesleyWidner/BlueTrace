<div align="center">

# 👥 Local Group Enumeration

## **Information Pulled:**  
GroupName – The name of each local group found on the system  
Collected – The date and time the group name was collected (formatted as yyyy-MM-dd HH:mm:ss)  
Section – Static identifier labeling the data as `"NetLocalGroup"`

---

## **Purpose & Usefulness:**  
This function runs the `net localgroup` command and parses its output to enumerate all local groups on the Windows system.

GroupName provides a list of local groups, supporting group inventory, privilege review, and potential misuse investigation.  
Collected supplies a timestamp for when the group enumeration occurred, aiding in audit trails and repeatability.  
Collecting local group information is important for digital forensics, security auditing, and incident response,  
as it helps identify unauthorized, overly privileged, or suspicious groups that may affect the system’s security posture.

</div>
