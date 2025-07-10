<div align="center">

# 🖥️ System & User Session Information

## **Information Pulled:**  
Hostname – The computer’s network name (`$env:COMPUTERNAME`)  
UserDomain – The domain name of the logged-in user (`$env:USERDOMAIN`)  
Username – The current username (`$env:USERNAME`)  
SID – The Security Identifier for the current user  
IsAdmin – Whether the script is running with administrator privileges  
SystemTimeLocal – The local system date and time  
SystemTimeUTC – The system date and time in UTC  
TimeZone – The current system time zone ID  
BootTime – The timestamp of the last system boot  

---

## **Purpose & Usefulness:**  
This function gathers fundamental system and user session details necessary for incident response, auditing, or troubleshooting.

Hostname, UserDomain, and Username uniquely identify the machine and current user context—useful for correlating logs or tracking user activity.  
SID is critical for uniquely identifying users, especially in environments with identical usernames across domains.  
IsAdmin reveals whether the script has elevated privileges, affecting the ability to perform certain actions or access protected data.  
SystemTimeLocal and SystemTimeUTC provide precise timing for events, supporting log correlation and forensic timelines.  
TimeZone helps interpret timestamps in the context of the machine’s location.  
BootTime establishes how long the system has been running, which can help detect recent reboots (possibly related to incidents or updates).

</div>
