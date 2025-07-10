<div align="center">

# ⚙️ Importance of **Prefetch Files** in Forensics

**Prefetch files** (`.pf`) are created by Windows to **speed up application launch times**.  
But in forensics, they’re a goldmine for discovering:

**Which executables were run**  
**How many times they were executed**  
**When they were last executed**  
**What files were loaded during execution**

📁 **Location:**



```
C:\Windows\Prefetch\
```

Each `.pf` file is named like this:

```
<ExecutableName>-<Hash>.pf
e.g., CHROME.EXE-AB12CD34.pf
```


---

## 🕵️‍♂️ What Prefetch Files Reveal

| Artifact                     | Description                                                                  |
| ---------------------------- | ---------------------------------------------------------------------------- |
| **Executable name**          | The name of the program that was run                                         |
| **Run count**                | How many times it has executed                                               |
| **Last execution timestamp** | When it was last run (sometimes includes the 8 most recent)                  |
| **Loaded DLLs and files**    | A list of files loaded during execution—used for malware detection           |
| **Device and volume ID**     | Unique identifiers for source drives (useful in USB or shadow copy analysis) |

This makes Prefetch one of the most **effective sources of execution history**, even if an app has since been deleted.

---

## 🔍 How BlueTrace Handles Prefetch Files

BlueTrace includes a **Prefetch Files** module that collects key metadata:

1. Scans for `.pf` files in the standard Prefetch directory  
2. Extracts the following data for each:

`Name`: Filename of the prefetch file  
`Path`: Full file system location  
`SizeKB`: Size in kilobytes  
`Modified`: Last modified time (i.e., *last execution timestamp*)  
`Section`: `"PrefetchFiles"` for filtering/export

> 🔸 **Note:** BlueTrace does **not parse internal binary contents** like run counts or DLL load lists directly—it flags presence and metadata for further analysis.

---

## 🛠 For Deep Dive Analysis (External Tools)

To fully parse Prefetch contents, use specialized forensic tools such as:

**Eric Zimmerman's [PECmd](https://ericzimmerman.github.io/#!index.md)** – Full prefetch parser (run counts, timestamps, loaded modules)  
**WinPrefetchView (NirSoft)** – GUI-based viewer of `.pf` contents  
**Prefetch Parser scripts** – e.g., PowerShell or Python-based

These tools can extract additional timestamps and DLL paths not shown in BlueTrace.

---

## ✅ Use Cases in Investigations

**Malware Execution Traces** – Prefetch survives even after malware is deleted  
**User Activity Timeline** – Shows what ran and when  
**Persistence Detection** – Repeated launches from temp/AppData  
**Script/Tool Usage** – Tracks investigator or attacker tools run locally

---

## 📘 Summary

> Prefetch files are a powerful forensic artifact for discovering what programs ran and when.  
> BlueTrace collects essential metadata for timeline correlation and flags them for offline deep parsing using tools like PECmd.

</div>
