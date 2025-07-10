<div align="center">

# 🧍‍♂️ BAM/DAM Executable Activity

## **Information Pulled:**  
UserSID – The Security Identifier (SID) of the user profile associated with each activity entry  
Executable – The name (usually path) of the executable that was monitored  
LastUsed – The timestamp when the executable was last used, formatted as yyyy-MM-dd HH:mm:ss (or `"Unreadable Timestamp"` if conversion fails)  
Section – Static identifier labeling the data as `"BamDamActivity"`

---

## **Purpose & Usefulness:**  
This function parses the Background Activity Moderator (BAM) registry data, which tracks per-user executable usage and last access times.

UserSID and Executable provide a mapping of which user ran which executables, and when.  
LastUsed supplies precise timing of process execution, which is useful for building user activity timelines and identifying potentially suspicious or rare executable launches.  
Collecting BAM/DAM activity is valuable for digital forensics, incident response, and security auditing,  
as it may reveal hidden or short-lived process executions that are not captured by normal logging mechanisms.

</div>
