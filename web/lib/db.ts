/**
 * Central Database Service for Web Admin Portal
 * Reads and writes directly to Firestore (Local Emulator on port 8080 or Cloud Firestore)
 * with transparent in-memory fallback if the Firestore emulator is not currently running.
 */

import {
  db,
  collection,
  doc,
  getDocs,
  getDoc,
  setDoc,
  addDoc,
  updateDoc,
  deleteDoc,
  initFirebaseEmulators,
} from "./firebase";
import type { ManagedUser } from "@/types/user";
import type { SecurityEvent } from "@/types/security";
import type { LegalHold } from "@/types/legalHold";
import type { SyncFailure } from "@/types/syncFailure";
import type { CheckInSchedule } from "@/types/checkIn";

// Initialize emulators on load
initFirebaseEmulators();


// --- Initial Seed Data (Legal Monitoring & Compliance Suite) ---

export const INITIAL_USERS: ManagedUser[] = [
  { id: "u1", name: "Johnathan Vance", email: "j.vance@example.com", role: "tracked_user", status: "active", lastActive: "Just now", phone: "+1 (555) 019-2834", location: "San Francisco, CA" },
  { id: "u2", name: "Sarah Johnson, Esq.", email: "sarah.j@lawfirm.com", role: "authorized_viewer", status: "active", lastActive: "5 mins ago", phone: "+1 (555) 012-7890", location: "Los Angeles, CA" },
  { id: "u3", name: "Marcus Sterling", email: "m.sterling@example.com", role: "tracked_user", status: "active", lastActive: "15 mins ago", phone: "+1 (555) 012-4567", location: "Oakland, CA" },
  { id: "u4", name: "Emma Davis, Esq.", email: "emma.d@defensecounsel.org", role: "authorized_viewer", status: "active", lastActive: "1 hour ago", phone: "+1 (555) 012-8901", location: "San Francisco, CA" },
  { id: "u5", name: "Elena Rostova", email: "e.rostova@example.com", role: "tracked_user", status: "active", lastActive: "35 mins ago", phone: "+1 (555) 012-5678", location: "San Jose, CA" },
  { id: "u6", name: "Joshua R. Hughes, Esq.", email: "admin@securetrack.io", role: "admin", status: "active", lastActive: "Just now", phone: "+1 (555) 482-1920", location: "San Francisco, CA" },
];

export const INITIAL_CASES = [
  { id: "c1", title: "State v. Vance — Pretrial Monitoring", number: "CASE-2025-001", assignedUsers: ["Johnathan Vance"], status: "active", createdAt: "2026-09-15", legalHold: true, courtOrder: "CO-2026-0842", description: "Court-ordered 24/7 GPS location logging." },
  { id: "c2", title: "People v. Sterling — Bail Supervision", number: "CASE-2025-002", assignedUsers: ["Marcus Sterling"], status: "active", createdAt: "2026-09-20", legalHold: true, courtOrder: "CO-2026-0911", description: "Curfew & exclusion perimeter compliance monitoring." },
  { id: "c3", title: "State v. Rostova — Diversion Program", number: "CASE-2025-003", assignedUsers: ["Elena Rostova"], status: "open", createdAt: "2026-10-01", legalHold: false, courtOrder: "CO-2026-1002", description: "Scheduled biometric check-ins and curfew verification." },
];

export const INITIAL_ZONES = [
  { id: "z1", name: "Downtown San Francisco Safe Zone", type: "allowed", radius: 500, lat: 37.7749, lng: -122.4194, assignedUsersCount: 14, status: "active", createdAt: "2026-01-10" },
  { id: "z2", name: "Oakland Victim Exclusion Perimeter", type: "restricted", radius: 1000, lat: 37.7833, lng: -122.4167, assignedUsersCount: 3, status: "active", createdAt: "2026-02-14" },
  { id: "z3", name: "SF Superior Court Dept. 12 Reporting", type: "check-in", radius: 250, lat: 37.7752, lng: -122.4175, assignedUsersCount: 28, status: "active", createdAt: "2026-03-01" },
];

export const INITIAL_SCHEDULES: CheckInSchedule[] = [
  { id: "s1", user: { id: "u1", name: "Johnathan Vance", avatarUrl: "/images/avatars/john.png" }, name: "Daily Morning Check-in", methods: ["biometric", "selfie"], time: "09:00 AM", frequency: "daily", status: "active", lastCheckIn: "Today 09:02 AM", missedCount: 0, nextCheckIn: "Tomorrow 09:00 AM" },
  { id: "s2", user: { id: "u3", name: "Marcus Sterling", avatarUrl: "/images/avatars/mike.png" }, name: "Evening Curfew Check-in", methods: ["selfie"], time: "08:00 PM", frequency: "daily", status: "active", lastCheckIn: "Yesterday 08:00 PM", missedCount: 0, nextCheckIn: "Today 08:00 PM" },
  { id: "s3", user: { id: "u5", name: "Elena Rostova", avatarUrl: "/images/avatars/emma.png" }, name: "Weekly Court Check-in", methods: ["biometric"], time: "10:00 AM", frequency: "weekly", status: "active", lastCheckIn: "3 days ago", missedCount: 0, nextCheckIn: "In 4 days" },
];

export const INITIAL_SECURITY: SecurityEvent[] = [
  { id: "e1", type: "vpn", title: "VPN usage detected during active tracking session", userEmail: "j.vance@example.com", userId: "u1", location: "San Francisco, US", time: "2 mins ago", severity: "high", status: "active", ipAddress: "10.0.0.1" },
  { id: "e2", type: "failed_login", title: "3 consecutive failed admin login attempts", userEmail: "unknown@attacker.com", location: "Remote IP", time: "5 mins ago", severity: "critical", status: "active", ipAddress: "185.220.101.4" },
  { id: "e3", type: "airplane_mode", title: "Airplane mode enabled during curfew window", userEmail: "m.sterling@example.com", userId: "u3", location: "Oakland, US", time: "18 mins ago", severity: "medium", status: "investigating" },
];

export const INITIAL_LEGAL_HOLDS: LegalHold[] = [
  {
    id: "h1",
    caseId: "c1",
    caseNumber: "CASE-2025-001",
    title: "State v. Vance — Pretrial Monitoring",
    authorization: "CO-2026-0842",
    reason: "Court-ordered statutory preservation under Federal Rules of Civil Procedure / Discovery.",
    status: "active",
    appliedAt: "2026-09-15",
    appliedBy: "admin@securetrack.io",
    history: [
      { action: "Legal hold applied", actor: "admin@securetrack.io", date: "2026-09-15" },
      { action: "Evidentiary preservation seal verified", actor: "system", date: "2026-09-15" }
    ]
  }
];

export const INITIAL_RETENTION = [
  { id: "r1", name: "Court Pretrial GPS Logs", periodDays: "90", complianceMode: true, target: "gps_telemetry", lastPurge: "2026-10-01" },
  { id: "r2", name: "Selfie Check-Ins & Facial Imagery", periodDays: "180", complianceMode: true, target: "biometrics", lastPurge: "2026-09-15" },
  { id: "r3", name: "Regulatory Administrative Audit Trail", periodDays: "365", complianceMode: true, target: "audit_logs", lastPurge: "2026-08-01" },
];

export const INITIAL_FAILURES: SyncFailure[] = [
  { id: "f1", user: { id: "u1", name: "Johnathan Vance", email: "j.vance@example.com" }, device: "iPhone 15 Pro", reason: "Connection timeout after 30s", errorCode: "ERR_CONN_TIMEOUT", retries: 3, time: "2 mins ago", status: "failed", dataLossRisk: false },
  { id: "f2", user: { id: "u3", name: "Marcus Sterling", email: "m.sterling@example.com" }, device: "Samsung Galaxy S24", reason: "GPS signal degraded during tunnel transit", errorCode: "ERR_GPS_SIGNAL", retries: 1, time: "5 mins ago", status: "pending", dataLossRisk: false },
];

export const INITIAL_AUDIT = [
  { id: "l1", timestamp: "2026-10-07 14:23:15", user: { name: "Admin User", role: "Admin" }, event: "Admin Sign In", type: "login", severity: "info", device: "Chrome - MacOS", ip: "127.0.0.1" },
  { id: "l2", timestamp: "2026-10-07 14:15:42", user: { name: "Admin User", role: "Admin" }, event: "Court PDF Export Generated", type: "export", severity: "info", device: "Chrome - MacOS", ip: "127.0.0.1" },
  { id: "l3", timestamp: "2026-10-07 14:10:30", user: { name: "Johnathan Vance", role: "Tracked User" }, event: "Legal Hold Verified", type: "permission", severity: "info", device: "Mobile App - iOS", ip: "192.168.1.78" },
];

// In-Memory store for offline fallback
const memoryStore: Record<string, any[]> = {
  users: [...INITIAL_USERS],
  cases: [...INITIAL_CASES],
  zones: [...INITIAL_ZONES],
  schedules: [...INITIAL_SCHEDULES],
  security: [...INITIAL_SECURITY],
  legal_holds: [...INITIAL_LEGAL_HOLDS],
  retention: [...INITIAL_RETENTION],
  sync_failures: [...INITIAL_FAILURES],
  audit_logs: [...INITIAL_AUDIT],
};

// --- Generic Database Service Methods ---

export async function dbList<T = any>(collName: string, initialData: T[] = []): Promise<T[]> {
  try {
    const colRef = collection(db, collName);
    const snap = await getDocs(colRef);
    if (!snap.empty) {
      return snap.docs.map((d) => ({ id: d.id, ...d.data() } as T));
    }
    // If empty in Firestore, populate initial seed
    if (initialData.length > 0) {
      for (const item of initialData) {
        const id = (item as any)?.id || `${collName}_${Date.now()}`;
        await setDoc(doc(db, collName, id), item as any);
      }
      return initialData;
    }
  } catch {
    // Firestore not reachable (e.g. emulator not started) — use memory store
  }

  if (!memoryStore[collName]) {
    memoryStore[collName] = [...initialData];
  }
  return memoryStore[collName] as T[];
}

export async function dbGet<T = any>(collName: string, id: string): Promise<T | null> {
  try {
    const docRef = doc(db, collName, id);
    const snap = await getDoc(docRef);
    if (snap.exists()) {
      return { id: snap.id, ...snap.data() } as T;
    }
  } catch {}

  const list = memoryStore[collName] || [];
  return (list.find((item: any) => item.id === id) as T) || null;
}

export async function dbSet<T = any>(collName: string, id: string, data: Partial<T>): Promise<T> {
  try {
    const docRef = doc(db, collName, id);
    await setDoc(docRef, data, { merge: true });
  } catch {}

  if (!memoryStore[collName]) memoryStore[collName] = [];
  const idx = memoryStore[collName].findIndex((i: any) => i.id === id);
  if (idx >= 0) {
    memoryStore[collName][idx] = { ...memoryStore[collName][idx], ...data };
    return memoryStore[collName][idx];
  } else {
    const created = { id, ...data } as T;
    memoryStore[collName].push(created);
    return created;
  }
}

export async function dbDelete(collName: string, id: string): Promise<void> {
  try {
    const docRef = doc(db, collName, id);
    await deleteDoc(docRef);
  } catch {}

  if (memoryStore[collName]) {
    memoryStore[collName] = memoryStore[collName].filter((i: any) => i.id !== id);
  }
}

