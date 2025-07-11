<div align="center">

# 🌐 Environment Variables

## **Information Pulled:**  
Name – The name of each environment variable  
Value – The value assigned to each environment variable  
Scope – Specifies whether the variable is set at the `"User"` (current user only) or `"System"` (all users on the machine) level  
Section – Static identifier labeling the data as `"EnvironmentVariables"`

---

## **Purpose & Usefulness:**  
This function gathers all environment variables defined for both the user and the system.

Name and Value provide details about the runtime configuration, paths, and settings that can influence how applications behave on the system.  
Scope indicates whether each variable affects just the current user or all users, which is important for understanding the variable’s impact and for troubleshooting.  
Collecting environment variables is valuable for incident response, troubleshooting software issues, detecting malicious persistence methods, and auditing system configurations.  
Unusual or suspicious variables may indicate compromise or misconfiguration.

</div>
