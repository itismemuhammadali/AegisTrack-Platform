# 02. Tracked User Mobile App Specification

> **Project:** Joshua R Hughes — Secure Location Logging & Legal Monitoring Platform  
> **Target Module:** `lib/src/modules/tracked/`  
> **Status:** Specification & Technical Implementation Blueprint

---

## 1. Overview & Persona

The **Tracked User** is the individual subject to legal monitoring, bail conditions, probation check-ins, or supervised travel.

### Core Philosophy
* **Simplicity & Compliance:** High-clarity UI designed for ease of compliance; zero ambiguity about whether the device is currently logging.
* **Tamper-Evident:** The app operates under the assumption that the user or environment may attempt GPS spoofing, clock skewing, or network disabling.
* **Non-Repudiation:** Once a log or check-in is recorded, it is cryptographically signed and immutable.

---

## 2. Core Functional Modules

### A. Continuous Background Location Engine
* **Interval:** Configurable heartbeat (default: every 5 to 15 minutes, or on significant displacement > 100 meters).
* **Payload Structure:**
  ```json
  {
    "log_id": "uuid-v4",
    "tracked_user_id": "usr_98234",
    "timestamp_device": "2026-10-07T03:30:00Z",
    "timestamp_server": "2026-10-07T03:30:01Z",
    "latitude": 37.774929,
    "longitude": -122.419416,
    "accuracy_meters": 4.2,
    "altitude_meters": 15.0,
    "speed_mps": 0.0,
    "battery_level": 82,
    "is_charging": true,
    "is_mock_location": false,
    "network_type": "wifi",
    "sync_status": "synced"
  }
  ```
* **Battery Optimization:**
  * Uses motion activity recognition (`still` vs. `in_vehicle` vs. `walking`) to adjust GPS ping frequency dynamically.
  * Employs Android Foreground Service with a persistent, non-dismissible notification (*"Compliance Monitoring Active"*).
  * Employs iOS Background Location Updates with `pausesLocationUpdatesAutomatically = false`.

---

### B. Facial Verification & Liveness Check-in
1. **Trigger:** Can be on-demand (user voluntary check-in) or scheduled / push-notified by the Tracker ("Check-in required within 15 minutes").
2. **Step 1: Passive Liveness:**
   * Front camera stream captures facial landmarks.
   * Prompts user for a random action (e.g., *"Blink naturally"* or *"Turn head slightly left"*).
   * Verifies 3D depth / reflection to prevent static photo or screen playback spoofing.
3. **Step 2: Selfie Capture & Metadata Stamp:**
   * High-resolution frame captured.
   * Watermarked internally with timestamp, latitude, longitude, and device hash.
4. **Step 3: Upload & Verification:**
   * Image uploaded to Firebase Storage under `/check_ins/{user_id}/{log_id}.jpg`.
   * Cloud Function or Python Backend triggers AWS Rekognition `CompareFaces` against the user's baseline reference photo.
   * Match confidence score recorded (e.g., `similarity: 98.4%`).

---

### C. Tamper & Anti-Spoofing Defenses

| Threat Vector | Detection Mechanism | App Reaction |
|:---|:---|:---|
| **Mock GPS Apps** | `location.isMocked` flag inspection on Android; `LocationManager.isMockProvider` check. | Flags log as `TAMPER_DETECTED_MOCK_GPS`. Immediate push notification sent to Tracker. |
| **Root / Jailbreak** | `flutter_jailbreak_detection` / Rootbeer library verifying su binaries and Cydia substrate. | Logs root status; increases audit logging frequency. |
| **Clock Skewing** | Compares device system clock against NTP true network time (`kronos` or TrueTime library). | If drift > 60 seconds, logs `TAMPER_CLOCK_SKEW` and uses NTP timestamp. |
| **Airplane Mode / GPS Off** | System connectivity & location service listener. | Stores offline shutdown event; uploads event immediately when reconnected. |

---

### D. Offline Queue & Resilient Sync
* **Local Database:** SQLite / Isar table `offline_pending_logs`.
* **Sync States:**
  * **Green (Synced):** All local records confirmed on Firestore.
  * **Amber (Pending):** X records queued locally awaiting connection.
  * **Red (Offline):** No network connectivity detected; background logging continues uninterrupted locally.
* **Sync Engine:** Automatic exponential backoff queue worker + manual *"Sync Now"* button in Settings.

---

### E. Emergency SOS & Incident Notes
* **SOS Trigger:** Dedicated hold-for-3-seconds emergency button.
  * Instantly records GPS fix with high precision.
  * Automatically uploads an `EMERGENCY_ALERT` event to Firestore.
  * Triggers priority push notification / SMS alert to assigned Tracker.
* **Incident / Note Logging:**
  * Allows the user to attach context (e.g., *"Car broke down on Highway 101, waiting for tow truck"*).
  * Category tagging: *Traffic*, *Work*, *Medical*, *Court Hearing*, *General*.
  * Optional supporting photo attachment.

---

## 3. UI Screen Architecture (`lib/src/modules/tracked/`)

```
lib/src/modules/tracked/
├── dashboard/
│   ├── tracked_dashboard_view.dart       # Main compliance status & quick actions
│   └── components/
│       ├── compliance_card.dart          # Status chip (Active, Alert, Curfew)
│       ├── sync_status_indicator.dart    # Real-time sync badge
│       └── quick_checkin_button.dart     # Primary selfie check-in CTA
├── home/
│   ├── tracked_home_view.dart            # Live map of current location & safe zone
│   └── components/
│       └── active_geofence_card.dart     # Displays current zone details
├── logs/
│   ├── tracked_logs_view.dart            # History of check-ins and locations
│   ├── tracked_log_detail_view.dart      # Detailed view with map & timestamp
│   └── tracked_add_note_view.dart        # Incident note & explanation submission
├── ai/
│   └── tracked_ai_view.dart              # In-app Gemini assistant for user queries
└── settings/
    ├── tracked_settings_view.dart        # Battery settings, permissions audit
    └── tracked_offline_sync_view.dart    # Manual sync queue manager
```
