<div align="center">

# 🧠 Cached DNS Entries from `ipconfig /displaydns`

## **Information Pulled:**  
RecordName – The domain name associated with each DNS cache entry  
RecordType – The type of DNS record (e.g., 1 for A record, 5 for CNAME, 28 for AAAA)  
TTL – The remaining Time To Live for each cache entry (in seconds)  
Data – The record data (e.g., IP address, canonical name)  
Section – Static identifier labeling the data as `"Ipconfig/displaydns"`

---

## **Purpose & Usefulness:**  
This function parses the output of `ipconfig /displaydns`, collecting all currently cached DNS records from the Windows DNS resolver.

RecordName, RecordType, and Data provide visibility into what domains and addresses have been recently resolved and accessed by the system.  
TTL shows how long each record will remain in cache, aiding in timeline analysis.  
Collecting DNS cache entries is important for digital forensics, incident response, and network security monitoring,  
as it reveals recent domain lookups even if browser or application history has been deleted, supporting investigations into suspicious network activity.

</div>
