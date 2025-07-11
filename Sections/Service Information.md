<div align="center">

# ⚙️ Windows Service Information

## **Information Pulled:**  
Name – The service's short (system) name  
DisplayName – The display name of the service  
State – The current state of the service (e.g., Running, Stopped)  
StartMode – The startup type for the service (e.g., Auto, Manual, Disabled)  
PathName – The full command line or path used to launch the service  
Executable – The extracted executable file path for the service (if available)  
SHA256 – The SHA-256 hash of the service's executable (if available)  
IsSigned – Boolean indicating if the service's executable is digitally signed and valid  
SignatureStatus – The status of the executable's digital signature (e.g., Valid, NotSigned, CheckFailed)  
Publisher – The publisher or subject of the signing certificate (if available)  
Suspicious – Boolean indicating if the service is suspicious (e.g., unsigned, script-based, or running from risky folders)  
Description – The service description, if available  
Section – Static identifier labeling the data as `"ServiceInformation"`

---

## **Purpose & Usefulness:**  
This function enumerates all Windows services and collects detailed metadata about each one.

Name, DisplayName, State, and StartMode provide an overview of all services and their operational status, which is essential for system monitoring and auditing.  
PathName and Executable identify what is actually run when the service starts, supporting detection of potentially unwanted or malicious services.  
SHA256 and digital signature fields (IsSigned, SignatureStatus, Publisher) enable integrity checks, threat hunting, and identification of trusted vs. untrusted code.  
Suspicious flags help focus attention on services that are unsigned, use scripts, or reside in non-standard or high-risk locations.  
Description supplies additional context to aid in the identification and validation of each service's purpose.  
Collecting this information is crucial for digital forensics, security auditing, incident response, and system hardening,  
as malicious actors often use services for persistence or privilege escalation.

</div>
