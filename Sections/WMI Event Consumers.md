<div align="center">

# 🔔 WMI Event Consumers

## **Information Pulled:**  
Name – The name of the WMI event consumer  
ConsumerType – The class/type of the WMI event consumer (e.g., CommandLineEventConsumer, ActiveScriptEventConsumer)  
CommandLine – The command line to be executed by the consumer (if available)  
Executable – The extracted path to the executable file (if available)  
Suspicious – Boolean flag indicating if the command line is potentially suspicious (e.g., involves scripts, PowerShell, or runs from risky folders)  
Section – Static identifier labeling the data as `"WMIEventConsumers"`

---

## **Purpose & Usefulness:**  
This function enumerates all WMI event consumers in the system's `root\subscription` namespace and collects metadata about each one.

Name and ConsumerType help identify the type and purpose of each event consumer, which are used by the WMI system to execute actions in response to certain triggers or events.  
CommandLine and Executable indicate what action or file will be executed when the event consumer is triggered, which is vital for detecting persistence mechanisms or potential abuse by attackers.  
Suspicious flags highlight consumers that run from non-standard or high-risk locations, or that use interpreters or scripts commonly abused by malware.  
Collecting this data is essential for security monitoring, digital forensics, and incident response, as malicious actors often use WMI event consumers for stealthy, persistent code execution.

</div>
