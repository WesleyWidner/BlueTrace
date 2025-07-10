<div align="center">

# 🔥 Windows Firewall Rules

## **Information Pulled:**  
Name – The display name of each Windows Firewall rule  
Enabled – Whether the rule is enabled ("True") or disabled ("False")  
Direction – The rule's direction ("Inbound", "Outbound", or "Unknown")  
Action – The rule's action ("Allow", "Block", or "Unknown")  
Profile – The firewall profile(s) the rule applies to ("Domain", "Private", "Public", "All", or combinations)  
Section – Static identifier labeling the data as `"FirewallRules"`

---

## **Purpose & Usefulness:**  
This function enumerates all configured Windows Firewall rules on the system and collects their key properties.

Name, Direction, and Action give a clear description of what traffic is being allowed or blocked and in which direction.  
Enabled indicates which rules are actively enforced, assisting with compliance and security validation.  
Profile reveals the network environment (Domain, Private, Public) where each rule applies, allowing targeted policy analysis.  
Collecting firewall rule information is essential for security auditing, troubleshooting network issues,  
verifying compliance, and identifying misconfigurations or unauthorized changes that may impact system security.

</div>
