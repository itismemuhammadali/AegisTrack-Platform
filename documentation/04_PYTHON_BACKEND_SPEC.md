# 04. Python Backend & Evidentiary Reporting Engine Specification

> **Project:** Joshua R Hughes — Secure Location Logging & Legal Monitoring Platform  
> **Service:** Python REST Backend & Court-Admissible Document Engine  
> **Framework:** FastAPI (Python 3.10+)  
> **Status:** Specification & Technical Implementation Blueprint

---

## 1. Overview & Architectural Role

While Firebase handles real-time data ingestion, presence, and live synchronization, the **Python Backend** is responsible for CPU-intensive, security-critical, and data-processing tasks:

1. **Evidentiary PDF Report Engine:** Compiling tamper-evident, court-admissible PDF reports featuring cryptographic checksums (SHA-256), QR validation codes, and high-resolution route map snapshots.
2. **Spreadsheet Compilation Engine:** Generating multi-tab Excel (`.xlsx`) and CSV reports containing full raw audit trails.
3. **AWS Rekognition Integration Relay:** Secure server-side biometric face comparison and liveness verification scoring.
4. **Independent Document Verification:** Publicly or restrictedly verifiable endpoint validating that a printed/PDF report has not been altered since generation.

---

## 2. Technology Stack

* **Web Framework:** `FastAPI` (Asynchronous, high-performance REST API with automated OpenAPI / Swagger documentation).
* **ASGI Server:** `Uvicorn` with hot-reloading in development.
* **Data Validation:** `Pydantic v2`.
* **PDF Compilation:** `ReportLab` / `WeasyPrint` + `PyPDF2` (for digital signatures, page numbering, and watermarking).
* **Map Image Rendering:** Static Maps API generator (OpenStreetMap / Google Static Maps) embedded directly into report pages.
* **Spreadsheet Generation:** `pandas` and `openpyxl`.
* **Cloud & Storage SDKs:** `firebase-admin` (Firestore & Storage connectivity) and `boto3` (AWS Rekognition).

---

## 3. Core REST API Endpoints

### A. Report Generation Endpoints

#### 1. Generate Court-Certified PDF
* **Route:** `POST /api/v1/reports/pdf`
* **Request Payload:**
  ```json
  {
    "case_id": "case_10482",
    "tracked_user_id": "usr_98234",
    "date_from": "2026-10-01T00:00:00Z",
    "date_to": "2026-10-07T23:59:59Z",
    "include_selfie_photos": true,
    "include_map_snapshots": true,
    "requestor_user_id": "atty_4492"
  }
  ```
* **Response Payload:**
  ```json
  {
    "status": "success",
    "report_id": "rep_991823",
    "document_sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
    "download_url": "http://localhost:8000/api/v1/reports/download/rep_991823.pdf",
    "page_count": 8,
    "generated_at": "2026-10-07T03:35:00Z"
  }
  ```

#### 2. Generate Multi-Tab Excel Audit Log
* **Route:** `POST /api/v1/reports/excel`
* **Output:** `.xlsx` document containing 4 formatted sheets:
  1. `Summary`: Case details, compliance score %, total distance traveled, total hours in safe zone.
  2. `GPS_Logs`: Full timestamped GPS coordinates, accuracy, battery, and mock-location flags.
  3. `Check_Ins`: Selfie check-in events, facial match scores, and liveness audit results.
  4. `Breach_Events`: Geofence exit/entry incidents and curfew violations with duration metrics.

---

### B. Biometric Verification Endpoint
* **Route:** `POST /api/v1/biometrics/verify-face`
* **Function:** Compares incoming check-in selfie with baseline reference image using AWS Rekognition.
* **Payload:** Base64 or Storage URL of reference photo + Base64 or Storage URL of check-in selfie.
* **Response:**
  ```json
  {
    "is_match": true,
    "similarity_score": 98.6,
    "confidence_level": 99.9,
    "face_detected": true,
    "liveness_confirmed": true
  }
  ```

---

### C. Independent Document Verification Endpoint
* **Route:** `GET /api/v1/verify/{document_sha256}`
* **Purpose:** Any judge, prosecutor, or defense attorney can scan the QR code printed on the PDF or enter the hash to verify the exact report metadata stored in the immutable audit log.

---

## 4. Anatomy of the Evidentiary PDF Report

```
┌────────────────────────────────────────────────────────────────────────┐
│ [LOGO] JOSHUA R HUGHES — LEGAL DEFENSE & COMPLIANCE REPORT             │
│                                                                        │
│ CASE REF: #CR-2026-9912          SUBJECT: Johnathan Doe                │
│ MONITORING WINDOW: Oct 01, 2026 — Oct 07, 2026                         │
│                                                                        │
│ ┌─────────────────────────── COMPLIANCE OVERVIEW ────────────────────┐ │
│ │ Total GPS Pings: 2,016           Overall Compliance: 99.4%         │ │
│ │ Geofence Breaches: 0             Tamper Incidents: 0               │ │
│ │ Scheduled Check-ins: 14/14       Avg Face Match: 98.7%             │ │
│ └────────────────────────────────────────────────────────────────────┘ │
│                                                                        │
│ [MAP SNAPSHOT: Day 1 Route with Waypoints and Geofence Boundaries]    │
│                                                                        │
│ [CHECK-IN GALLERY: Side-by-Side Reference Photo vs Live Check-in]      │
│                                                                        │
│ ────────────────────────────────────────────────────────────────────── │
│ CERTIFICATION OF INTEGRITY:                                            │
│ I hereby certify that the records herein were generated automatically   │
│ from cryptographically validated, tamper-resistant location logs.      │
│ SHA-256 HASH: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca49599  │
│ [QR CODE FOR REAL-TIME INDEPENDENT VERIFICATION]                       │
│ Page 1 of 8 | TAMPER SEALED LEGAL RECORD                               │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Local Setup & Execution Guide

1. **Virtual Environment Setup:**
   ```bash
   cd backend
   python3 -m venv .venv
   source .venv/bin/activate
   pip install fastapi uvicorn pydantic reportlab openpyxl pandas boto3 firebase-admin
   ```
2. **Running the Local Server:**
   ```bash
   uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
   ```
3. **Interactive Documentation:**
   * Swagger UI available at: `http://localhost:8000/docs`
   * Redoc available at: `http://localhost:8000/redoc`
