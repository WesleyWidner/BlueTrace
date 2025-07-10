<div align="center">

# 🌐 Hosts File Mapping & Integrity Check

## **Information Pulled:**  
IPAddress – The IP address specified in each non-comment line of the hosts file  
Hostname – The hostname mapped to each IP address entry  
SHA256 – The SHA-256 hash of the entire hosts file (or error status)  
Section – Static identifier labeling the data as `"HostsFile"`

---

## **Purpose & Usefulness:**  
This function parses the Windows hosts file and collects a mapping of static hostname-to-IP assignments along with a hash of the entire file.

IPAddress and Hostname reveal custom DNS overrides or redirects, which are critical for identifying potential malware, adware, or manual configuration that could affect network behavior or security.  
SHA256 enables integrity checking, ensuring the hosts file has not been tampered with or altered unexpectedly.  
Collecting hosts file information is important for digital forensics, security auditing, troubleshooting DNS issues,  
and detecting unauthorized or malicious changes to system name resolution.

</div>
