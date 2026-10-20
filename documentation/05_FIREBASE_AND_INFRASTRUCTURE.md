# 05. Firebase Architecture & Local Emulator Suite Specification

> **Project:** Joshua R Hughes — Secure Location Logging & Legal Monitoring Platform  
> **Service:** Firebase Real-Time Data Layer & Cloud Functions  
> **Status:** Specification & Technical Implementation Blueprint

---

## 1. Overview & Architectural Role

Firebase serves as the real-time operational database, authentication provider, file storage repository, and lightweight event-driven trigger system for the mobile applications.

By running the **Firebase Local Emulator Suite**, the entire application stack can be developed, tested, and validated completely offline with zero dependency on cloud credentials or billing accounts.

---

## 2. Firestore Database Schema

```
firestore/
├── users/
│   └── {user_id}/
│       ├── role: "tracked" | "tracker" | "admin"
│       ├── email: string
│       ├── phone_number: string
│       ├── display_name: string
│       ├── reference_face_url: string (baseline photo for biometrics)
│       ├── assigned_tracker_ids: array<string>
│       ├── active_case_ids: array<string>
│       └── created_at: timestamp
│
├── cases/
│   └── {case_id}/
│       ├── case_number: "#CR-2026-9912"
│       ├── court_jurisdiction: string
│       ├── client_name: string
│       ├── assigned_tracked_user_id: string
│       ├── assigned_tracker_ids: array<string>
│       ├── status: "active" | "completed" | "flagged"
│       ├── curfew_start_time: "22:00"
│       ├── curfew_end_time: "06:00"
│       │
│       └── geofences/ (subcollection)
│           └── {geofence_id}/
│               ├── name: "Home Residence"
│               ├── type: "inclusion" | "exclusion"
│               ├── latitude: number
│               ├── longitude: number
│               ├── radius_meters: number
│               ├── is_active: boolean
│               └── schedule_days: array<string> ["MON", "TUE", ...]
│
├── tracked_logs/
│   └── {user_id}/
│       ├── locations/ (subcollection - high frequency)
│       │   └── {log_id}/
│       │       ├── latitude: number
│       │       ├── longitude: number
│       │       ├── accuracy: number
│       │       ├── timestamp: timestamp
│       │       ├── battery_level: number
│       │       ├── is_mock: boolean
│       │       ├── speed: number
│       │       └── sync_state: "synced"
│       │
│       ├── check_ins/ (subcollection - periodic verification)
│       │   └── {checkin_id}/
│       │       ├── selfie_url: string
│       │       ├── timestamp: timestamp
│       │       ├── liveness_passed: boolean
│       │       ├── similarity_score: number (e.g. 98.4)
│       │       ├── latitude: number
│       │       ├── longitude: number
│       │       └── verified_by: "aws_rekognition" | "local_ml"
│       │
│       └── incidents/ (subcollection - alerts & notes)
│           └── {incident_id}/
│               ├── type: "SOS" | "NOTE" | "GEOFENCE_BREACH" | "TAMPER_MOCK_GPS"
│               ├── note_text: string
│               ├── timestamp: timestamp
│               └── acknowledged_by_tracker: boolean
│
└── export_requests/
    └── {request_id}/
        ├── case_id: string
        ├── requestor_id: string
        ├── date_from: timestamp
        ├── date_to: timestamp
        ├── format: "pdf" | "excel"
        ├── status: "pending" | "processing" | "completed" | "failed"
        ├── document_url: string
        ├── document_sha256: string
        └── created_at: timestamp
```

---

## 3. Strict Security Rules (RBAC & Immutability)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper Functions
    function isAuthenticated() {
      return request.auth != null;
    }
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    function isTrackerForUser(userId) {
      return isAuthenticated() && 
        request.auth.uid in get(/databases/$(database)/documents/users/$(userId)).data.assigned_tracker_ids;
    }
    
    // Users Collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
    }
    
    // Cases Collection: Trackers read and manage assigned cases
    match /cases/{caseId} {
      allow read: if isAuthenticated() && request.auth.uid in resource.data.assigned_tracker_ids;
      allow write: if isAuthenticated() && request.auth.uid in resource.data.assigned_tracker_ids;
      
      match /geofences/{geofenceId} {
        allow read, write: if isAuthenticated() && 
          request.auth.uid in get(/databases/$(database)/documents/cases/$(caseId)).data.assigned_tracker_ids;
      }
    }
    
    // Tracked Logs: Append-only for Tracked user; read-only for assigned Tracker
    match /tracked_logs/{userId} {
      
      match /locations/{logId} {
        // Tracked user can ONLY create, NEVER update or delete (Immutability guarantee)
        allow create: if isOwner(userId);
        allow update, delete: if false; 
        allow read: if isOwner(userId) || isTrackerForUser(userId);
      }
      
      match /check_ins/{checkinId} {
        allow create: if isOwner(userId);
        allow update, delete: if false;
        allow read: if isOwner(userId) || isTrackerForUser(userId);
      }
      
      match /incidents/{incidentId} {
        allow create: if isOwner(userId);
        allow update: if isTrackerForUser(userId); // Tracker can mark as acknowledged
        allow delete: if false;
        allow read: if isOwner(userId) || isTrackerForUser(userId);
      }
    }
  }
}
```

---

## 4. Local Emulator Suite Setup

### Step 1: Initialize Emulators Configuration (`firebase.json`)
```json
{
  "emulators": {
    "auth": {
      "port": 9099
    },
    "firestore": {
      "port": 8080
    },
    "storage": {
      "port": 9199
    },
    "functions": {
      "port": 5001
    },
    "ui": {
      "enabled": true,
      "port": 4000
    }
  }
}
```

### Step 2: Running the Emulators Locally
```bash
firebase emulators:start --import=./emulator_data --export-on-exit
```
The **Firebase Emulator Web UI** opens at `http://localhost:4000`, providing a full interactive visual dashboard for Auth, Firestore, and Storage.

### Step 3: Flutter Client Connection (Local Mode)
Inside Flutter's `main.dart` or configuration initialization:
```dart
const bool kUseLocalEmulators = bool.fromEnvironment('USE_EMULATORS', defaultValue: true);

if (kUseLocalEmulators) {
  final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  await FirebaseStorage.instance.useStorageEmulator(host, 9199);
}
```
When moving to production, setting `USE_EMULATORS=false` automatically points the apps to the live cloud instances without altering any code.
