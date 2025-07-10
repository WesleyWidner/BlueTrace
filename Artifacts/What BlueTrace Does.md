<div align="center">

# ✅ What BlueTrace *Can* Do (Collection)

BlueTrace is fully capable of **locating, verifying, and staging** the following high-value forensic artifacts for **offline analysis**, even if it doesn't parse their binary contents directly:

| Artifact           | Action by BlueTrace                                                | Location Example                                               |
| ------------------ | ------------------------------------------------------------------ | -------------------------------------------------------------- |
| **SOFTWARE Hive**  | Detects & logs full path                                           | `C:\Windows\System32\config\SOFTWARE`                          |
| **SYSTEM Hive**    | Detects & logs full path                                           | `C:\Windows\System32\config\SYSTEM`                            |
| **SAM Hive**       | Detects & logs full path                                           | `C:\Windows\System32\config\SAM`                               |
| **SECURITY Hive**  | Detects & logs full path                                           | `C:\Windows\System32\config\SECURITY`                          |
| **LNK Files**      | Captures metadata indirectly (via JumpLists, Desktop, Recent Docs) | `%AppData%\Microsoft\Windows\Recent\`                          |
| **Prefetch Files** | Logs presence, timestamps, metadata                                | `C:\Windows\Prefetch\`                                         |

For each artifact, BlueTrace:

Checks if the file exists  
Logs its file path and timestamp  
Flags it in exported JSON for analyst reference  
Provides guidance on which **external tool** to use for parsing

---

## ❌ What BlueTrace *Does Not* Do (Parsing)

BlueTrace **does not attempt to parse**:

Binary hives (SYSTEM, SAM, SECURITY, SOFTWARE)  
`.lnk` file structures (e.g., run counts, target path, timestamps)  
Prefetch internal contents (e.g., run count, loaded files)

These require:

Tools like **Eric Zimmerman's Registry Explorer, PECmd, LECmd**  
Parsers like `secretsdump.py`, `lnk-parser.py`, or `ShimCacheParser`  
Manual review in forensic suites (e.g., X-Ways, Autopsy)

---

## Summary

> BlueTrace **collects but does not parse** core Windows forensic artifacts such as registry hives, shortcut files, and prefetch data.  
> These items are securely staged for offline analysis using external tools.  
> This design ensures forensic integrity and modular workflows while preserving full analyst control.

</div>
