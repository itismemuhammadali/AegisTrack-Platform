# 08. Web Admin Portal Specification & Architecture

> **Platform:** Joshua R Hughes Legal Administration & Compliance Web Portal  
> **Repository:** `joshua_r_hughes_admin` (Cloned into `/web`)  
> **Framework:** Next.js 16.3.6 (Turbopack, App Router) + React 19.2.8 + Tailwind CSS v4 + TypeScript 5  
> **Status:** Fully Integrated, Built, and Documented  

---

## 1. Executive Summary & Purpose

The **Web Admin Portal** is the centralized, compliance-grade operational dashboard for system administrators, supervisory probation officers, and legal compliance officers. It provides system-wide visibility, multi-case oversight, legal hold management, statutory retention enforcement, and diagnostic controls over all tracked defendants and authorized viewers.

The codebase features a **Dual-Mode Architecture**:
1. **Zero-Config Offline Mock Mode (`USE_MOCK = true`):** When `NEXT_PUBLIC_API_BASE_URL` is omitted, the entire suite operates interactively with stateful in-memory mock data, instant feedback, and realistic delay simulations.
2. **Production REST API Mode (`USE_MOCK = false`):** When `NEXT_PUBLIC_API_BASE_URL` is defined, the centralized `apiRequest` client communicates directly with the Python FastAPI backend (`backend/app`).

---

## 2. Technical Stack & Dependencies

```
┌────────────────────────────────────────────────────────────────────────┐
│                        WEB ADMIN TECHNOLOGY STACK                      │
├───────────────────────┬──────────────────┬─────────────────────────────┤
│ Layer                 │ Technology       │ Version / Notes             │
├───────────────────────┼──────────────────┼─────────────────────────────┤
│ Core Framework        │ Next.js          │ 16.3.6 (Turbopack Engine)   │
│ UI Runtime            │ React / React-DOM│ 19.2.8 (Server/Client Comps)│
│ Styling Engine        │ Tailwind CSS     │ v4 (@tailwindcss/postcss)   │
│ Iconography           │ Lucide React     │ ^1.47.0                     │
│ Data Visualizations   │ Recharts         │ ^3.10.1                     │
│ Language              │ TypeScript       │ ^5.0 (Strict Typing)        │
│ HTTP Client           │ Native Fetch     │ apiRequest with Credentials │
└───────────────────────┴──────────────────┴─────────────────────────────┘
```

---

## 3. Directory & Route Architecture

```
web/
├── app/
│   ├── (auth)/                     # Administrator Authentication & MFA
│   │   ├── login/                  # Credentials & Remember Me
│   │   ├── verify-code/            # 6-Digit Email Challenge
│   │   ├── two-factor/             # TOTP Authenticator Challenge
│   │   ├── device-verification/    # New Device / IP Authorization
│   │   ├── forgot-password/        # Password Reset Request
│   │   ├── forgot-password/verify/ # Reset Code Validation
│   │   └── reset-password/         # New Password Creation
│   ├── (dashboard)/                # Authenticated Operations Suite
│   │   ├── dashboard/              # Executive Overview & Activity Feed
│   │   ├── users/                  # Managed Users (Tracked, Viewers, Admins)
│   │   ├── access-assignments/     # Viewer-to-Tracked Assignment Matrix
│   │   ├── cases/                  # Legal Docket & Case Management
│   │   ├── check-ins/              # Scheduled Biometric & Selfie Check-ins
│   │   ├── tracking-activity/      # Live Telemetry & Device Diagnostics
│   │   ├── zones/                  # Geofences (Allowed, Restricted, Check-in)
│   │   ├── security-alerts/        # Tamper, VPN & Anomaly Monitoring
│   │   ├── escalations/            # High-Priority Legal/Security Tickets
│   │   ├── audit-logs/             # Immutable Regulatory Audit Trails
│   │   ├── reports/                # Compliance Analytics & Certified Export
│   │   ├── export-settings/        # Watermark, AES Encryption & Caps
│   │   ├── legal-hold/             # Court-Ordered Record Preservation
│   │   ├── retention-rules/        # Statutory Purge & Archival Policies
│   │   ├── sync-failures/          # Offline Sync Failure Recovery
│   │   ├── admin-management/       # Admin Accounts & Role Delegations
│   │   │   ├── new/                # Provision Admin Account
│   │   │   └── [id]/               # Admin Profile & Permissions Detail
│   │   ├── settings/               # System Health, Backups & Global Flags
│   │   └── support/                # In-App Administrator Dispatch Chat
│   └── page.tsx                    # Root Redirect to /login or /dashboard
├── components/                     # Modular UI & Feature Components
├── hooks/                          # Reusable Custom React Hooks
├── lib/                            # Formatting, Time, Utility Helpers
├── services/                       # Data Services (Mock + API Clients)
└── types/                          # Domain TypeScript Definitions
```

---

## 4. Module Deep-Dive & Functional Breakdown

### A. Authentication & Multi-Factor Security (`web/app/(auth)`)
* **Multi-Step Challenge:** Validates email and password, then issues a time-sensitive 6-digit challenge code or TOTP verification.
* **Device Authorization:** If a login attempt occurs from an unrecognized user agent or geographic IP, triggers `/device-verification`.
* **Stateful Flow:** Managed via `usePendingVerification` and `usePendingReset` hooks using sessionStorage to ensure secure handoffs without credential leaks.

### B. Executive Dashboard (`/dashboard`)
* **KPI Metrics:**
  - Total Tracked Users (e.g., 1,247)
  - Authorized Viewers (e.g., 342)
  - Active Sessions (e.g., 89)
  - Failed Syncs with Data Loss Risk (e.g., 12)
* **Visual Trends:** Weekly tracking volume chart and monthly certified export volume chart (Recharts).
* **Live Activity Stream:** Real-time stream of export completions, security flags, sync alerts, and authentication events.
* **System Health Monitor:** Live status badges for GPS Tracking Service, Sync Engine, Export Service, Auth API, and Audit Logger.

### C. Case Management & Docket Oversight (`/cases`)
* **Case Records:** Tracks case numbers (e.g. `CASE-2025-001: State v. Johnson`), primary attorney, court jurisdiction, and case status (`active`, `open`, `pending`, `closed`).
* **Direct Legal Hold Flagging:** Instant toggle for court-ordered litigation preservation, safeguarding case records from automated retention purges.

### D. Check-In Schedule Engine (`/check-ins`)
* **Multi-Modal Verification:** Configures check-in schedules requiring **Biometric Facial Recognition**, **In-App Camera Selfie**, or dual verification.
* **Recurrence Patterns:** Supports Daily, Weekly, and Custom interval schedules.
* **Compliance Tracking:** Tracks consecutive missed check-ins, calculates `dueToday` counters, and allows administrators to issue immediate manual push reminders.

### E. Live Telemetry & Device Diagnostics (`/tracking-activity`)
* **Real-Time Telemetry:** Displays sync timestamp, geographic location, signal strength (`strong`, `medium`, `weak`), and sync status (`success`, `failed`).
* **Device Inspection Dialog:** Reveals latitude/longitude coordinates (up to 4 decimal precision), device OS, battery level percentage, GPS accuracy radius (meters), and recorded speed (km/h).

### F. Geofencing & Zone Boundary Manager (`/zones`)
* **Zone Typology:**
  1. **Allowed Zones:** Permitted residences, workplaces, counseling centers, or courtrooms.
  2. **Restricted / Exclusion Zones:** Prohibited victim residences, school perimeters, or state borders.
  3. **Check-in Zones:** Designated physical reporting locations.
* **Zone Parameters:** Center coordinates (latitude/longitude), radius threshold, assigned user count, and real-time entry/exit logs.

### G. Security Alerts & Anti-Tamper Oversight (`/security-alerts`)
* **Detection Engine:**
  - VPN & Proxy detection
  - Fake GPS / Mock Location mock provider flags
  - Airplane mode toggles during scheduled tracking windows
  - Device power-cycling / forced shutdowns
  - Unusual geographic velocity jumps (e.g., 500 mph teleports)
* **Incident Lifecycle:** Status workflow: `Active` → `Investigating` → `Flagged` → `Resolved`.

### H. Compliance Audit Logs (`/audit-logs`)
* **Regulatory Immutability:** Logs all export actions, logins, login failures, screenshot capture attempts, security incidents, sync events, and permission adjustments.
* **Diagnostic Filtering:** Filterable by date range (`from`/`to`), severity level (`info`, `warning`, `critical`), and event category. Captures user identity, IP address, and client device.

### I. Legal Hold Management (`/legal-hold`)
* **Litigation Preservation:** Implements Federal Rules of Civil Procedure (FRCP) and criminal discovery compliance.
* **Audit Trail:** Records court order authorization, presiding judge/prosecutor authority, justification reason, application date, and full chronological hold history.

### J. Statutory Data Retention & Archival (`/retention-rules`)
* **Configurable Retention Windows:** 7 Days, 30 Days, 90 Days, 180 Days, 365 Days, or Statutory 7 Years.
* **Compliance Lock:** High-security policies marked with `complianceMode: true` are locked from being lowered below the court-mandated minimum retention window.
* **Auto-Archive Pipeline:** Automatically stages cold records to encrypted cold storage before permanent purging.

### K. Sync Failure Diagnostics & Recovery (`/sync-failures`)
* **Resilience Tracking:** Tracks offline sync errors (GPS signal lost, network socket timeout, device power loss, storage limit reached).
* **Automated & Manual Retries:** Allows administrators to trigger remote sync retries or flag records with critical data loss risk.

### L. Export Policy & Certified Watermarking (`/export-settings`)
* **Export Guardrails:** Sets role-based export permissions, mandatory supervisory approvals for bulk exports, and maximum records export thresholds.
* **Forensic Protection:** Configures mandatory PDF watermarking (case number, requesting attorney, timestamp) and AES-256 PDF encryption.

---

## 5. Integration Alignment with Backend & Mobile App

```
┌────────────────────────────────────────────────────────────────────────┐
│               THREE-TIER SYNCHRONIZATION DATA CONTRACT                 │
├────────────────────────┬───────────────────────┬───────────────────────┤
│ Web Admin Domain       │ FastAPI Backend API   │ Mobile App Mirror     │
├────────────────────────┼───────────────────────┼───────────────────────┤
│ `/cases`               │ `/api/v1/cases`       │ Attorney Cases Tab    │
│ `/check-ins`           │ `/api/v1/biometrics`  │ Defendant Selfie Flow │
│ `/tracking-activity`   │ `/api/v1/telemetry`   │ Background GPS Stream │
│ `/security-alerts`     │ `/api/v1/compliance`  │ Tamper Detection Loop │
│ `/reports`             │ `/api/v1/reports`     │ Court PDF & Excel Gen │
│ `/sync-failures`       │ `/api/v1/sync/batch`  │ SQLite Offline Queue  │
│ `/escalations`         │ `/api/v1/sos`         │ Emergency SOS Action  │
└────────────────────────┴───────────────────────┴───────────────────────┘
```
