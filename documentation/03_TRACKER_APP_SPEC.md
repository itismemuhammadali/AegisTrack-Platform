# 03. Tracker (Authorized Viewer) Mobile App Specification

> **Project:** Joshua R Hughes — Secure Location Logging & Legal Monitoring Platform  
> **Target Module:** `lib/src/modules/tracker/`  
> **Status:** Specification & Technical Implementation Blueprint

---

## 1. Overview & Persona

The **Tracker (Authorized Viewer)** is the legal professional, bail bondsman, probation officer, or appointed case supervisor responsible for monitoring one or more Tracked individuals.

### Core Philosophy
* **Actionable Situational Awareness:** Immediate visual clarity on who is compliant, who is approaching a boundary, and who has triggered an alert.
* **Audit-Grade Integrity:** Read-only access to historical logs; the Tracker cannot alter, delete, or falsify recorded data.
* **Rapid Evidentiary Generation:** Ability to generate court-admissible reports and data exports with a single tap.

---

## 2. Core Functional Modules

### A. Case Portfolio Dashboard
* **Overview Metrics:** Total Active Cases, Within Safe Zone, In Breach, Offline/Low Battery.
* **Case List Card:**
  * Client name, photo, and case number.
  * Real-time compliance badge: `COMPLIANT (Green)`, `IN_TRANSIT (Blue)`, `GEOFENCE_BREACH (Red)`, `OFFLINE (Amber)`.
  * Last ping timestamp and device battery percentage.
  * Quick action triggers: *Call*, *View Live Map*, *Request Check-in*, *Generate Report*.

---

### B. Live Map Tracking & Breadcrumbs
* **Real-time Map:** Shows the latest known GPS location of selected Tracked users.
* **Visual Identifiers:**
  * Distinct markers with battery level indicators.
  * Visual radius of GPS accuracy (circle overlay).
  * Color-coded active Geofences (Green = Safe Zone, Red = Exclusion Zone).
* **Direct Actions on Map:**
  * Ping Device / Request Immediate Selfie Check-in.
  * Navigate to location (external Google Maps / Apple Maps deep link).

---

### C. Route History & Timeline Playback
* **Date Range Filter:** Today, Yesterday, Last 7 Days, Custom Date Range.
* **Interactive Timeline Player:**
  * Play / Pause / Scrubber slider.
  * Playback speed multiplier (1x, 2x, 5x, 10x).
  * Animated path polyline tracing the exact route taken throughout the day.
  * Stopover indicators: Highlights locations where the user remained stationary for > 15 minutes with duration metrics.

---

### D. Geofencing & Curfew Management
* **Boundary Types:**
  1. **Inclusion / Safe Zone:** Home, Workplace, Counseling Center, Legal Office.
  2. **Exclusion / Danger Zone:** Victim residence, alcohol dispensaries, county/state borders.
* **Geofence Parameters:**
  * Center Coordinate (lat, lng), Radius (meters), or Custom Polygon.
  * Active Schedule: Days of week, start time, end time (e.g., Curfew: Mon-Sun 10:00 PM – 06:00 AM).
* **Alert Logic:**
  * Cloud Function computes point-in-polygon / distance formula upon each location write.
  * Generates immediate FCM push notification and in-app high-priority alert banner upon breach.

---

### E. Security Detail & Tampering Audit
* **Device Health Inspection:**
  * Mock Location status: `NORMAL` vs `MOCK_PROVIDER_ACTIVE`.
  * Battery health history & sudden drop alerts.
  * Airplane mode / offline gap visualization.
* **Facial Check-in Review:**
  * Side-by-side inspection of registered profile photo vs. check-in selfie.
  * AWS Rekognition Match Score percentage.
  * Passive liveness verification confirmation.

---

### F. Reports & Certified Data Sharing
* **Report Request:**
  * Select Case + Date Range + Report Type (*Full Evidentiary PDF*, *Summary PDF*, *Raw CSV Logs*).
  * Submits request to Python backend.
  * Download link rendered with in-app PDF viewer upon generation.
* **Secure Share Flow:**
  * Generates temporary password-protected or expiring link for co-counsel, prosecutors, or judges.

---

## 3. UI Screen Architecture (`lib/src/modules/tracker/`)

```
lib/src/modules/tracker/
├── dashboard/
│   ├── tracker_dashboard_view.dart       # High-level metrics & recent alerts
│   └── components/
│       ├── case_summary_carousel.dart    # Quick-switch case cards
│       └── active_breach_banner.dart     # Priority alert notification
├── cases/
│   ├── tracker_case_list_view.dart       # Searchable list of all cases
│   └── tracker_case_detail_view.dart     # Individual case overview & stats
├── users/
│   ├── tracker_user_details_view.dart    # Client profile, contact, conditions
│   ├── tracker_live_tracking_view.dart   # Real-time full-screen map
│   ├── tracker_map_playback_view.dart    # Historical route player & scrubber
│   ├── tracker_check_ins_view.dart       # Gallery of selfie check-ins & scores
│   ├── tracker_security_details_view.dart# Anti-tamper & device audit logs
│   └── tracker_ai_insights_view.dart     # AI behavioral pattern summaries
├── reports/
│   ├── tracker_reports_view.dart         # List of generated PDFs & exports
│   └── tracker_request_report_view.dart  # Date range & export options modal
├── share/
│   └── tracker_secure_share_view.dart    # Encrypted link & export sharing
└── notifications/
    └── tracker_notifications_view.dart   # Geofence & tamper notification feed
```
