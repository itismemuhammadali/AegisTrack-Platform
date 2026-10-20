# 01. System Architecture Overview

> **Project:** Joshua R Hughes — Secure Location Logging & Legal Monitoring Platform  
> **Prepared by:** Slicon Systems LLC  
> **Status:** Local-First Development Architecture Blueprint

---

## 1. High-Level Ecosystem

The platform is designed as a **tamper-evident, 4-tier legal compliance ecosystem**:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           1. CLIENT APPS LAYER                              │
│                                                                             │
│   ┌───────────────────────────────┐       ┌─────────────────────────────┐   │
│   │   TRACKED MOBILE APP (app/)   │       │  TRACKER MOBILE APP (app/)  │   │
│   │    (Defendant / Participant)  │       │    (Attorney / Supervisor)  │   │
│   │  • Background GPS Engine      │       │  • Real-time Live Tracking  │   │
│   │  • Facial Liveness Check-in   │       │  • Route History Playback   │   │
│   │  • Offline SQLite Queue       │       │  • Geofence Breach Alerts   │   │
│   │  • SOS & Note Logging         │       │  • Certified Export Request │   │
│   └──────────────┬────────────────┘       └──────────────▲──────────────┘   │
│                  │                                       │                  │
│                  │        ┌──────────────────────────────┴──────────────┐   │
│                  │        │        WEB ADMIN PORTAL (web/)              │   │
│                  │        │    (Compliance & System Administrators)     │   │
│                  │        │  • Next.js 16 (Turbopack) + React 19        │   │
│                  │        │  • 18 Modules: Legal Hold, Audits, Cases,   │   │
│                  │        │    Retention Rules, Sync Failure Diagnosis  │   │
│                  │        └──────────────────────┬──────────────────────┘   │
└──────────────────┼───────────────────────────────┼──────────────────────────┘
                   │                               │
                   ▼                               ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                 2. FIREBASE & INFRASTRUCTURE LAYER (firebase/)              │
│                                                                             │
│   ┌────────────────────┐    ┌───────────────────┐    ┌──────────────────┐   │
│   │     FIRESTORE      │    │  CLOUD FUNCTIONS  │    │ FIREBASE STORAGE │   │
│   │ Real-time Stream & │    │ Event Triggers &  │    │ Check-in Selfies │   │
│   │ Security Rules     │    │ Geofence Calc     │    │ & Signatures     │   │
│   └─────────┬──────────┘    └─────────┬─────────┘    └──────────────────┘   │
└─────────────┼─────────────────────────┼─────────────────────────────────────┘
              │                         │
              ▼                         ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                 3. PYTHON BACKEND & REPORT ENGINE (backend/)                │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ FASTAPI REST SERVICE (Port 8000)                                    │   │
│   │  • Evidentiary PDF Engine (SHA-256 Tamper Seals, QR, Watermarks)    │   │
│   │  • Excel / CSV Multi-table Exporter (.xlsx)                         │   │
│   │  • Face Comparison API Integration (AWS Rekognition Relay)          │   │
│   │  • Web Portal API & Regulatory Audit Logs                           │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Core Entities & Roles

| Role | Interface | Primary Responsibilities | Data Access Scope |
|:---|:---|:---|:---|
| **Tracked User** | Mobile (`app/` Tracked Mode) | • Periodic background location pinging<br>• Selfie check-ins with liveness<br>• Incident / Note submission<br>• Emergency SOS broadcasts | Write own logs; read-only own summary profile. Cannot modify past logs. |
| **Tracker / Viewer** | Mobile (`app/` Tracker Mode) | • Multi-case oversight<br>• Live map tracking & history playback<br>• Geofence boundary setup (Safe/Exclusion)<br>• Tamper alert monitoring<br>• Requesting certified PDF/Excel exports | Read assigned cases; write geofences, notes, and export requests. |
| **System Admin** | Web Portal (`web/` Next.js) | • User & access assignment management<br>• Legal hold imposition & statutory retention<br>• Sync failure diagnostics & system health<br>• Immutable regulatory audit log oversight | Full system visibility; immutable audit log oversight. |

---

## 3. Communication & Data Flow

### A. Location & Check-In Logging Flow
1. **Tracked App** captures GPS (lat, lng, accuracy, altitude, speed, battery, mock-provider check).
2. If online: writes directly to Firestore `/tracked_users/{id}/location_logs`.
3. If offline: stores in local SQLite/Isar database; automatically drains queue on network reconnection.
4. **Cloud Function** listens to new entries, evaluates against active geofences, and sends FCM push notifications to the assigned **Tracker** upon boundary breach.

### B. Evidentiary PDF Export Flow
1. **Tracker** requests an export for a date range (e.g., Nov 1 to Nov 15).
2. Request is created in Firestore `/export_requests`.
3. **Python Backend** picks up the request, pulls validated location and check-in logs.
4. Generates a court-certified PDF:
   - Includes map snapshots, check-in selfies, GPS coordinates, timestamps.
   - Computes SHA-256 digital signature of the document content.
   - Watermarks each page with legal disclaimer and verification QR code.
5. Saves generated PDF in Firebase Storage and writes download link back to Firestore.

---

## 4. Local-First Development Strategy

Because production credentials (Apple, Google Play, AWS, Twilio) are pending client delivery, development runs locally with zero external dependencies:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     LOCAL ISOLATED DEV ENVIRONMENT                      │
│                                                                         │
│  Flutter Mobile App  ──►  Firebase Emulator Suite  ◄──  Local Python    │
│  (iOS/Android Dev)        • Firestore (Port 8080)       Backend         │
│                           • Auth (Port 9099)            • FastAPI       │
│                           • Storage (Port 9199)         • Port 8000     │
│                           • Functions (Port 5001)       • Uvicorn       │
└─────────────────────────────────────────────────────────────────────────┘
```

When client credentials arrive, transitioning to production requires only updating `.env` configuration keys.
