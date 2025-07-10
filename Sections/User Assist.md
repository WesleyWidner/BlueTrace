<div align="center">

# 📊 UserAssist Registry Data

## **Information Pulled:**  
SubKey – The registry subkey under UserAssist (typically a GUID, often associated with application usage tracking)  
ValueName – The name of the registry value (often an encoded or application-specific identifier)  
ValueType – The data type of the value (e.g., String, Int, DateTime)  
RawValue – The raw data stored for the UserAssist entry (may require decoding for full analysis)  
Section – Static identifier labeling the data as `"UserAssist"`

---

## **Purpose & Usefulness:**  
This function retrieves and parses data from the UserAssist registry keys, which Windows uses to track programs and files recently executed or accessed by the user.

SubKey, ValueName, and RawValue reveal detailed information about user activity, application usage, and file execution on the system, supporting timeline and behavior analysis.  
ValueType informs analysts of how the data is stored, which may be helpful for decoding or deeper investigation.  
Collecting this data is vital for digital forensics, user activity monitoring, and incident response,  
as it provides insights into what applications and files have been used, regardless of whether shortcuts remain or standard logs are cleared.

</div>
