<div align="center">

# 👤 Local User Account Enumeration

## **Information Pulled:**  
Username – The name of each local user account found on the system  
Collected – The date and time the username was collected (formatted as yyyy-MM-dd HH:mm:ss)  
Section – Static identifier labeling the data as `"NetUser"`

---

## **Purpose & Usefulness:**  
This function runs the `net user` command and parses its output to enumerate all local user accounts on the Windows system.

Username provides a list of accounts that exist locally, supporting account inventory, privilege review, and potential misuse investigation.  
Collected supplies a timestamp for when the enumeration occurred, aiding in audit trails and repeatability.  
Collecting local user account information is crucial for digital forensics, security auditing, and incident response,  
as it helps identify unauthorized, dormant, or suspicious user accounts that may present security risks.

</div>
