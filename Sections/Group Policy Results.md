<div align="center">

# 🛡️ Group Policy Results (GPResult)

## **Information Pulled:**  
Section – Distinguishes between `"GroupPolicyResults_Computer"` and `"GroupPolicyResults_User"`  
Scope – Indicates if the output is for Computer or User scope  
Output – Full raw text output from `gpresult /scope computer /r` and `gpresult /scope user /r`, showing applied Group Policy Objects (GPOs), settings, and policy inheritance details

---

## **Purpose & Usefulness:**  
This function gathers the results of applied Group Policy Objects (GPOs) for both the computer and the current user.

The Output includes security policies, login scripts, software restrictions, auditing configurations, and other enforced settings.  
Provides visibility into which policies are in effect, their sources, and any potential conflicts or overrides.  
Useful for auditing, security reviews, troubleshooting group policy issues, and verifying compliance with organizational baselines.

</div>
