<div align="center">

# 🌐 Active Network Connections (`netstat -ano`)

## **Information Pulled:**  
Protocol – The network protocol (TCP or UDP) for the connection  
LocalAddress – The local address and port number used by the connection  
ForeignAddress – The remote (foreign) address and port number to which the connection is established or listening  
State – The state of the connection (e.g., LISTENING, ESTABLISHED, TIME_WAIT), or "N/A" for UDP  
PID – The Process ID associated with the network connection  
Section – Static identifier labeling the data as `"NetstatOutput"`

---

## **Purpose & Usefulness:**  
This function collects and parses the output of the `netstat -ano` command, which provides a snapshot of all current TCP and UDP network connections and listening ports, along with their associated process IDs.

Protocol, LocalAddress, and ForeignAddress provide a full view of current network activity and communication endpoints.  
State helps determine the status of each connection, which is crucial for identifying active, listening, or terminated sessions.  
PID links each network connection to a specific process on the system, supporting further investigation of potentially suspicious or unauthorized network activity.  
Collecting this data is important for network forensics, security auditing, threat hunting, and incident response,  
as it helps detect malware communications, lateral movement, unauthorized listeners, and exfiltration channels.

</div>
