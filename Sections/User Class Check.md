<div align="center">

# 📁 USRCLASS.DAT Registry Hive

## **Information Pulled:**  
File – The name of the file checked ("UsrClass.dat")  
Path – The full path to the UsrClass.dat file for the current user  
Exists – Indicates whether the file was found ("Yes" or "No")  
Note – Description noting that this file contains ShellBag and Jump List data, and should be parsed with Registry Explorer or a ShellBag parser  
Section – Static identifier labeling the data as `"USRCLASS.DAT"`

---

## **Purpose & Usefulness:**  
This function checks for the presence of the UsrClass.dat registry hive, which stores user-specific Windows Explorer settings, ShellBag information (folder view history), and Jump List data (recent app/file activity).

Path and Exists help forensic analysts confirm whether this key user registry hive is available for further analysis.  
Note offers guidance for deeper investigation using common forensic tools.  
UsrClass.dat is a critical artifact for digital forensics, incident response, and user activity reconstruction,  
as it can reveal historical folder access, desktop layout, and recent file/app usage even when other evidence has been cleared.

</div>
