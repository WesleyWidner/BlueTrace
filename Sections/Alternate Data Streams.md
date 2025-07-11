<div align="center">

# 🧪 Alternate Data Streams (ADS)

## **Information Pulled:**  
File – The full file system path to each file found on the Desktop (and subfolders)  
Stream – The name of the alternate data stream (ADS) associated with each file (excluding the default data stream)  
Length – The size (in bytes) of each alternate data stream  
SHA256 – The SHA-256 cryptographic hash of the main file's contents  
Section – Static identifier labeling the data as `"AlternateDataStreams"`

---

## **Purpose & Usefulness:**  
This function scans all files on the Desktop (including subfolders) for alternate data streams (ADS), which are hidden streams of data that can be attached to files on NTFS file systems.

File and Stream allow for identification of where non-standard data is stored, which is significant because ADS are often used to hide malicious code, scripts, or data from standard file listings.  
Length provides the size of each ADS, helping assess their potential impact or contents.  
SHA256 serves as a unique identifier for the main file, supporting further integrity or threat analysis.  
Collecting ADS information is important for security auditing, incident response, and digital forensics,  
as attackers and malware commonly leverage ADS for stealthy persistence or data concealment.

</div>
