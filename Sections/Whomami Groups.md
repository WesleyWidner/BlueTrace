<div align="center">

# 👥 Whoami Group Memberships

## **Information Pulled:**  
GroupName – The name of each group the current user is a member of  
SID – The Security Identifier associated with each group  
Attributes – Group membership attributes (e.g., Enabled, Mandatory, Default Owner) or "None" if not present  
Section – Static identifier labeling the data as `"WhoamiGroups"`

---

## **Purpose & Usefulness:**  
This function runs `whoami /groups` and parses its output to enumerate all security groups the current user is a member of, including group SIDs and any relevant attributes.

GroupName and SID provide a comprehensive mapping of the user's group memberships, which is vital for privilege and access reviews.  
Attributes indicate special group properties that may affect security context or privileges (such as Enabled or Default Owner).  
Collecting this data is important for digital forensics, incident response, and privilege escalation investigations,  
as it helps determine the effective permissions and roles assigned to the current user context.

</div>
