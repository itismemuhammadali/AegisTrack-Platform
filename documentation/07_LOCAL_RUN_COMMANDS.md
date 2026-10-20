# 07. Local Execution & Commands Reference Guide

> **Project:** Joshua R Hughes — Secure Location Logging & Legal Monitoring Platform  
> **Target:** Local Development, Testing, and Multi-Tier Orchestration  
> **Status:** Active Command Reference  

---

## 1. System Architecture Overview for Local Testing

```
┌────────────────────────────────────────────────────────────────────────┐
│                        LOCAL DEVELOPMENT PORTS                         │
├─────────────────────────┬──────────────┬───────────────────────────────┤
│ Service                 │ Port         │ URL / Endpoint                │
├─────────────────────────┼──────────────┼───────────────────────────────┤
│ Web Admin Portal (Next) │ 3000         │ http://localhost:3000         │
│ Firebase Emulator UI    │ 4000         │ http://localhost:4000         │
│ Firestore Emulator      │ 8080         │ localhost:8080 (10.0.2.2:8080)│
│ Auth Emulator           │ 9099         │ localhost:9099                │
│ Storage Emulator        │ 9199         │ localhost:9199                │
│ Python Backend (FastAPI)│ 8000         │ http://localhost:8000         │
│ Swagger API Docs        │ 8000         │ http://localhost:8000/docs    │
│ Flutter Mobile App      │ Native       │ iOS Simulator / Android AVD   │
└─────────────────────────┴──────────────┴───────────────────────────────┘
```

---

## 2. Terminal 1: Starting the Firebase Local Emulator Suite

### A. Launching the Emulators
From the `firebase/` directory:
```bash
cd firebase
firebase emulators:start
```
*With persistent emulator state export:*
```bash
firebase emulators:start --import=./emulator_data --export-on-exit
```

*Open your browser and navigate to:*  
👉 **`http://localhost:4000`** to view real-time Firestore collections, Auth users, and Storage buckets.

---

## 3. Terminal 2: Starting the Local Python Backend (FastAPI)

### A. Environment Initialization
Navigate to the `backend/` directory:
```bash
cd backend
source .venv/bin/activate
```

*(If setting up `.venv` fresh:)*
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### B. Running the FastAPI Server
```bash
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

### C. Automated Test Suite
```bash
python test_backend.py
```
*Tests all 13 REST API endpoints (PDF, Excel, Biometrics, Offline Sync, SOS, Court Verification).*

*Explore Interactive Swagger Docs:*  
👉 **`http://localhost:8000/docs`**

---

## 4. Terminal 3: Running the Next.js Web Admin Portal

### A. Environment Initialization
Navigate to the `web/` directory:
```bash
cd web
npm install
```

### B. Launching the Web Admin Portal
```bash
npm run dev
```

*Open your browser and navigate to:*  
👉 **`http://localhost:3000`**

*(To test production build:)*
```bash
npm run build && npm run start
```

---

## 5. Terminal 4: Running the Flutter Mobile App

### A. Fetch Dependencies
Navigate to the `app/` directory:
```bash
cd app
flutter pub get
```

### B. Static Analysis & Unit Tests
```bash
flutter analyze lib/
flutter test
```

### C. Launching on Devices

#### Option 1: iOS Simulator
```bash
flutter run -d iPhone
```

#### Option 2: Android Emulator
```bash
flutter run -d emulator-5554
```
*(Note: Android emulators map your Mac's `localhost` to `10.0.2.2`)*

---

## 6. Development Shortcuts & Useful Commands

| Task | Location | Command |
|:---|:---|:---|
| **Flutter Analyze** | `app/` | `flutter analyze lib/` |
| **Flutter Tests** | `app/` | `flutter test` |
| **Backend API Tests** | `backend/` | `python test_backend.py` |
| **Web Admin Dev** | `web/` | `npm run dev` |
| **Web Admin Build** | `web/` | `npm run build` |
| **Check Active Ports** | Root | `lsof -i :3000 -i :4000 -i :8000 -i :8080` |
| **Kill Port if Stuck** | Root | `kill -9 $(lsof -t -i :3000)` |
