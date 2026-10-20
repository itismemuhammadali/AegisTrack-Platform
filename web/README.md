# Joshua R Hughes — Web Admin Portal

> **Role:** Enterprise Legal Administration & Regulatory Compliance Web Suite  
> **Framework:** Next.js 16.3.6 (Turbopack, App Router) + React 19.2.8 + Tailwind CSS v4 + TypeScript 5  
> **Port:** `http://localhost:3000`  
> **Specification Reference:** [`documentation/08_WEB_ADMIN_SPEC.md`](../documentation/08_WEB_ADMIN_SPEC.md)

---

## 1. Overview & Capabilities

The **Web Admin Portal** provides centralized supervisory oversight, court docket tracking, regulatory compliance enforcement, and device telemetry diagnostics for system administrators, legal defense attorneys, and court-appointed supervisors.

### Core Modules
* **Executive Dashboard (`/dashboard`):** Real-time KPI cards, weekly tracking trends, certified export volume, live activity audit feed, and system health status.
* **Managed Users (`/users`):** Comprehensive user registry across Tracked Defendants, Authorized Viewers, and Administrators.
* **Viewer Access Assignments (`/access-assignments`):** Matrix assigning authorized viewers/attorneys to tracked defendants with granular read/write permissions.
* **Case Docket Management (`/cases`):** Legal case listings, case numbers, primary attorney assignments, court jurisdictions, and direct legal hold flags.
* **Check-In Scheduling (`/check-ins`):** Facial biometrics and camera selfie verification schedules with recurrence patterns, compliance tracking, and manual push reminders.
* **Live Telemetry & Diagnostics (`/tracking-activity`):** Real-time GPS stream, signal strength, sync status, battery levels, accuracy radius, and device details.
* **Geofence Boundary Manager (`/zones`):** Interactive allowed safe zones, exclusion zones, and check-in zones with radius controls and breach logging.
* **Anti-Tamper & Security Oversight (`/security-alerts`):** VPN detection, mock location/fake GPS detection, flight mode violations, and abnormal velocity jumps.
* **High-Priority Escalations (`/escalations`):** Real-time incident escalation queue with priority tiers, assignment controls, and resolution workflows.
* **Immutable Audit Trail (`/audit-logs`):** Regulatory audit logs capturing all logins, exports, permission alterations, and tamper events.
* **Certified Reports & Analytics (`/reports`):** Evidentiary court-certified PDF generation and multi-sheet Excel exports.
* **Export Policies & Watermarks (`/export-settings`):** Mandatory PDF watermarking rules, AES-256 encryption, and export role guardrails.
* **Legal Hold Record Preservation (`/legal-hold`):** Court-mandated record preservation policies under FRCP discovery rules, freezing records from deletion.
* **Statutory Retention Rules (`/retention-rules`):** Configurable automated data purging and archival tiers (7-day to 7-year statutory cycles) with compliance lock protection.
* **Sync Failure Diagnostics (`/sync-failures`):** Diagnostic console for recovering failed offline sync events and preventing telemetry data loss.
* **Admin Management (`/admin-management`):** Provisioning, profile management, and role-based permissions delegation for administrators.
* **System Settings & Health (`/settings`):** Global feature flags, database backups, cache controls, and maintenance switches.
* **Administrator Dispatch Support (`/support`):** Real-time communication and support dispatch channel for operational personnel.

---

## 2. Dual-Mode Architecture

The web application supports seamless switching between offline prototyping and production REST API execution:

### A. Zero-Config Mock Mode (`USE_MOCK = true`)
When `NEXT_PUBLIC_API_BASE_URL` is omitted or empty, the entire portal operates using high-fidelity in-memory mock data services located in `services/`.
* Instant offline demonstration with pre-seeded legal cases, GPS breadcrumbs, and alerts.
* Realistic network delay simulations (200ms–400ms).
* Full stateful mutation simulation (create, update, toggle legal holds, assign viewers).

### B. Production REST API Mode (`USE_MOCK = false`)
When `NEXT_PUBLIC_API_BASE_URL` is configured (e.g. `http://localhost:8000/api/v1`), the centralized `apiRequest` client communicates directly with the Python FastAPI backend (`backend/app`).

---

## 3. Getting Started

### Prerequisites
* Node.js 18+ or 20+
* npm or pnpm

### Installation
```bash
cd web
npm install
```

### Local Development Server
Start the Turbopack dev server on port 3000:
```bash
npm run dev
```

Visit [`http://localhost:3000`](http://localhost:3000) in your browser.

### Production Build
```bash
npm run build
npm run start
```

### Linting
```bash
npm run lint
```

---

## 4. Environment Variables

Create a `.env.local` file in `web/` if connecting to a live backend:

```env
# Leave blank for zero-config offline mock mode
# Set to FastAPI backend URL for live API mode
NEXT_PUBLIC_API_BASE_URL=http://localhost:8000/api/v1
```

---

## 5. Technology Stack

* **Framework:** Next.js 16.3.6 (Turbopack Engine, App Router)
* **Runtime:** React 19.2.8 & React-DOM 19.2.8
* **Styling:** Tailwind CSS v4 (`@tailwindcss/postcss`)
* **Icons:** Lucide React (`lucide-react`)
* **Charts & Telemetry:** Recharts (`recharts`)
* **Language:** TypeScript 5.0 (Strict mode enabled)
