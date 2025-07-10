<div align="center">

# 🧩 Installed Programs Inventory

## **Information Pulled:**  
DisplayName – The name of each installed program  
DisplayVersion – The version number of each installed program  
Publisher – The software publisher or vendor  
InstallDate – The date when the program was installed (formatted as yyyy-MM-dd if possible)  
Section – Static identifier labeling the data as `"InstalledPrograms"`

---

## **Purpose & Usefulness:**  
This function collects details about all programs installed on the system by querying relevant registry paths for both 32-bit and 64-bit applications, as well as per-user installations.

DisplayName and DisplayVersion help identify exactly what software is present and which versions are in use, which is essential for vulnerability management, software inventory, compliance audits, or incident response.  
Publisher provides information about the vendor, which can help distinguish legitimate software from potentially unwanted or suspicious programs.  
InstallDate is useful for tracking recent software installations that could be linked to security incidents or unauthorized changes.  
Aggregating this information gives a clear picture of the system's software footprint, supporting system health assessments and security investigations.

</div>
