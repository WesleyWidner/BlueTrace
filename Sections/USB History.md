<div align="center">

# 💾 USB Storage Device History

## **Information Pulled:**  
Device – The registry subkey name for each detected USB storage device  
FriendlyName – The user-friendly name of the device (if available)  
Service – The driver/service used by the device (if available)  
ContainerID – The unique container ID assigned to the device (if available)  
PSPath – The full registry path to the device entry  
Section – Static identifier labeling the data as `"USBHistory"`

---

## **Purpose & Usefulness:**  
This function enumerates the USBSTOR registry key, collecting information about all USB storage devices (such as flash drives and external hard drives) ever connected to the system.

Device, FriendlyName, Service, and ContainerID provide device-specific details useful for tracking usage, identifying devices, and correlating with user or incident activity.  
PSPath offers precise registry location for reference or deeper manual analysis.  
Collecting USB history is essential in digital forensics, insider threat investigations, and data exfiltration cases,  
as it helps identify removable devices that may have been used to copy or transfer sensitive data.

</div>
