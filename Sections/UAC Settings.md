<div align="center">

# 🛡️ User Account Control (UAC) Settings

## **Information Pulled:**  
ConsentPromptBehaviorAdmin – How User Account Control (UAC) prompts administrators (various prompt levels or silent elevation)  
ConsentPromptBehaviorUser – How UAC prompts standard users when elevation is requested  
EnableLUA – Whether UAC is enabled or disabled on the system  
PromptOnSecureDesktop – Whether UAC prompts are shown on a secure desktop (protects against spoofing)  
EnableVirtualization – Whether UAC file and registry virtualization is enabled (helps with legacy applications)  
ValidateAdminCodeSignatures – Whether admin code signatures are validated before running  
FilterAdministratorToken – Whether administrator accounts use a split or full security token  
Section – Static identifier labeling the data as `"UACSettings"`

---

## **Purpose & Usefulness:**  
This function collects the key UAC (User Account Control) configuration settings from the system registry.

These settings determine how Windows manages privilege elevation and how users are prompted for administrative actions.  
Reviewing these values is crucial for understanding the system's security posture, since relaxed UAC settings can increase the risk of privilege escalation and malware execution.  
Secure desktop and code signature validation help mitigate spoofing and ensure only trusted code is run with elevated permissions.  
Virtualization settings impact compatibility and containment of legacy applications.  
This data supports security audits, incident response, and compliance by showing how strictly Windows enforces elevation and admin actions.

</div>
