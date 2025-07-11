<div align="center">

# 🌐 DNS Resolver Cache

## **Information Pulled:**  
RecordName – The domain name queried and cached by the system DNS resolver  
RecordType – The DNS record type (e.g., "A (Host Address)", "CNAME (Canonical Name)", "AAAA (IPv6 Address)", or "Other")  
TTL – The remaining Time To Live (in seconds) for the cache entry  
Data – The record data (such as IP address for an A record, or target hostname for a CNAME)  
Section – Static identifier labeling the data as `"DNSCache"`

---

## **Purpose & Usefulness:**  
This function parses the system's DNS resolver cache, displaying all cached DNS records with their type, data, and expiry.

RecordName, RecordType, and Data provide visibility into recent and current domain resolutions by the system, supporting investigation of user and process network activity.  
TTL helps analysts understand when the cached entry is set to expire, useful for timeline analysis.  
Collecting DNS cache information is valuable for digital forensics, incident response, and network monitoring,  
as it can reveal evidence of connections to suspicious, malicious, or noteworthy domains—even if browser or application history has been cleared.

</div>
