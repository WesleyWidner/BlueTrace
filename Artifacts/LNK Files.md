### 🧭 LNK File Artifacts in Forensics

**Windows shortcut files (.lnk)** are small metadata-rich artifacts that record **user activity**—specifically, which files or programs were opened and how. These files are automatically created when a user accesses content via Windows Explorer or pinned locations (e.g., desktop, Start menu, recent files).

📍 **Typical locations:**

* `%AppData%\Microsoft\Windows\Recent\`
* `%UserProfile%\Recent\`
* On the Desktop or inside custom folders

---

### 🧪 Why LNK Files Matter in Forensics

LNK files provide a **wealth of evidence**, even if the original file is deleted or moved:

| Artifact                                      | Description                                                          |
| --------------------------------------------- | -------------------------------------------------------------------- |
| **Target Path**                               | Original location of the opened file or program                      |
| **Access, Creation, Modification Timestamps** | Detailed MAC times of both the LNK and the target file               |
| **Volume Serial Number**                      | Uniquely identifies the disk where the file resided                  |
| **MAC Address & NetBIOS name**                | (sometimes) captured from network shares                             |
| **File Size & Attributes**                    | Of the original target file                                          |
| **Working Directory**                         | Context of execution (useful for malware analysis)                   |
| **Arguments**                                 | Shows if files were opened with command-line options (e.g., scripts) |

---

### 🔍 How BlueTrace Handles LNK Artifacts

While BlueTrace doesn’t explicitly label LNK files in the modules, it **does capture related shortcut and usage data** in several ways:

#### ✅ Relevant Modules in BlueTrace:

* **Jump Lists**: Track recent documents and app destinations—often referencing `.lnk` files.
* **Shellbags**: Reveal folders navigated to, which may have contained or used LNKs.
* **UserAssist / RunMRU**: Registry entries showing programs run by GUI or via Run dialog.
* **Desktop File Timestamps**: LNK files on the Desktop are logged along with hashes and modified times.
* **Recent Docs**: Registry-based indicators of recently accessed documents, often referring to files opened via LNKs.

You can cross-reference these modules to infer LNK file interactions without needing full LNK parsing.

---

### 🛠 For Deep LNK Analysis (External Tools)

To directly parse `.lnk` files for forensic metadata, use tools like:

* **Eric Zimmerman's [LECmd](https://ericzimmerman.github.io/#!index.md)** – Extracts all internal fields from .lnk files
* **ShellBags Explorer** – For link and folder traversal info
* **Windows Shortcut Parser (e.g., lnk-parser.py)** – Python-based forensic parser

---

### 📘 Summary

> LNK files are powerful forensic artifacts that expose historical file usage, even after deletion. While BlueTrace focuses on shortcut-related registry and metadata entries, analysts can supplement it with external tools for full .lnk file parsing.
