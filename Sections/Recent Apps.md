<div align="center">

# 🕑 Recent Applications Usage

## **Information Pulled:**  
AppID – The unique identifier for each recently used application, as stored in the registry  
Executable – The path or name of the application's executable file  
LastAccessTime – The last time the application was accessed or used (raw registry value, may need conversion)  
Section – Static identifier labeling the data as `"RecentApps"`

---

## **Purpose & Usefulness:**  
This function parses the RecentApps registry key, which tracks applications that have been recently accessed or launched by the user through Windows Search.

AppID and Executable provide a mapping of recent program usage, allowing investigators to identify what apps were recently run.  
LastAccessTime can help build a timeline of user activity, which is critical for digital forensics, incident response, and behavioral analysis.  
Collecting recent application usage data supports detection of suspicious or rare activity,  
reconstruction of user actions, and validation of incident timelines.

</div>
