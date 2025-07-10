# 📄 Reports.md

## Blue Trace Report Generation

Blue Trace enables you to generate detailed PDF reports from your scan results. To ensure successful report creation, please review the following requirements and workflow.

---

## Report Creation Requirements

* **Reports can only be generated from scan results saved in the `JSON` format.**
* The relevant JSON files **must be located in a folder named `BlueTraceReports`**.

---

### Preconfigured Scans

* For **preconfigured scans** (e.g., Incident Response, Networking, System Health, Compliance):

  * The `BlueTraceReports` folder is **created automatically**.
  * All scan results are saved in the correct location, allowing you to generate reports directly from the dashboard.

---

### User-Created (Custom) Scans

* For **custom scans or user-created scan profiles**:

  * **You must manually create a folder named `BlueTraceReports`** in your chosen output location.
  * Save your custom scan results as `.json` files **within this folder**.
  * Only JSON files in `BlueTraceReports` will be available for PDF report generation.

---

## How to Generate a Report

1. **Save your scan as JSON** (select the JSON export option after completing your scan).
2. **Ensure the JSON file is in the `BlueTraceReports` folder**.

   * For preconfigured scans: This is done automatically.
   * For custom scans: You must create the folder and place the JSON file there.
3. **Go to the Reports section** in Blue Trace.
4. **Select the scan you wish to report on** from the available list.
5. **Click “Generate Report”** to create a detailed PDF report.

---

## Folder Example

```
Documents\
  BlueTraceReports\
    IncidentResponse_2024-07-05.json
    MyCustomScan_2024-07-05.json
    SystemHealth_2024-07-05.json
```

---

## Important Notes

* Only `.json` scan files in `BlueTraceReports` will appear in the report generation list.
* Reports generated from other formats (XLSX, TXT, CSV) are **not supported**.
* For best results, do **not** rename or move the `BlueTraceReports` folder after scan creation.

---

<img width="819" height="1058" alt="image" src="https://github.com/user-attachments/assets/2b30aa25-3d85-4bf3-927c-9897269b63e8" />

<img width="819" height="1063" alt="image" src="https://github.com/user-attachments/assets/ac10457b-8f73-41ea-a470-ff11e767c0fa" />

<img width="818" height="1054" alt="image" src="https://github.com/user-attachments/assets/82368529-b5da-4da0-94a8-230fa70cdbfd" />

<img width="819" height="1056" alt="image" src="https://github.com/user-attachments/assets/f5b6a9dd-3bc9-4eab-b129-6e53353ee464" />

---

If you have questions or encounter issues, please contact [Info@whitehatwes.com](mailto:Info@whitehatwes.com).
