<div align="center">

# 🔑 Windows Credential Manager Entries

## **Information Pulled:**  
Target – The identifier or resource name for the credential (e.g., server, share, or application name)  
Username – The username associated with the saved credential  
Retrieved – The date and time the credential entry was retrieved (formatted as yyyy-MM-dd HH:mm:ss)  
Section – Static identifier labeling the data as `"CredentialManager"`

---

## **Purpose & Usefulness:**  
This function retrieves entries from the Windows Credential Manager using the `cmdkey` command, collecting relevant details about saved credentials.

Target and Username reveal what resources (network shares, remote systems, applications) the user has stored credentials for,  
which is useful for mapping access relationships and potential attack paths.  
Retrieved provides a timestamp for when the data was collected, supporting timeline and audit requirements.  
Collecting Credential Manager entries is important for digital forensics, security assessments, and incident response,  
as saved credentials can reveal persistence mechanisms, third-party access, or targets for lateral movement.

</div>
