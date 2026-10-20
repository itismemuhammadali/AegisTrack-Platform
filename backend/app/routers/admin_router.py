"""
Admin Web Portal REST API Router
Provides endpoints for all 18 Web Admin modules, authentication, and supervisory controls.
"""

import uuid
from datetime import datetime, timezone
from typing import Optional, List, Dict, Any
from fastapi import APIRouter, HTTPException, status, Query, Body
from pydantic import BaseModel, Field

admin_router = APIRouter(tags=["Web Admin Portal"])

# --- In-Memory Stores for Admin State ---

MOCK_ADMINS = {
    "superadmin@securetrack.io": {
        "id": "sa-1",
        "name": "Super Admin",
        "email": "superadmin@securetrack.io",
        "role": "SUPER_ADMIN",
        "permissions": ["*"],
        "password": "SuperAdmin@123",
    },
    "admin@securetrack.io": {
        "id": "ad-1",
        "name": "Admin User",
        "email": "admin@securetrack.io",
        "role": "ADMIN",
        "permissions": ["cases.create", "access.assign", "exports.manage"],
        "password": "Admin@123",
    },
}

USERS_DB = [
    {"id": "u1", "name": "John Smith", "email": "john.smith@company.com", "role": "tracked_user", "status": "active", "lastActive": "2 mins ago", "phone": "+1 (555) 012-3456", "location": "New York, US"},
    {"id": "u2", "name": "Sarah Johnson", "email": "sarah.j@lawfirm.com", "role": "authorized_viewer", "status": "active", "lastActive": "5 mins ago", "phone": "+1 (555) 012-7890", "location": "Los Angeles, US"},
    {"id": "u3", "name": "Mike Wilson", "email": "mike.w@company.com", "role": "tracked_user", "status": "active", "lastActive": "15 mins ago", "phone": "+1 (555) 012-4567", "location": "Chicago, US"},
    {"id": "u4", "name": "Emma Davis", "email": "emma.d@defensecounsel.org", "role": "authorized_viewer", "status": "active", "lastActive": "1 hour ago", "phone": "+1 (555) 012-8901", "location": "Houston, US"},
    {"id": "u5", "name": "Robert Brown", "email": "robert.b@company.com", "role": "tracked_user", "status": "disabled", "lastActive": "3 days ago", "phone": "+1 (555) 012-5678", "location": "Phoenix, US"},
    {"id": "u6", "name": "Lisa Anderson", "email": "lisa.a@securetrack.io", "role": "admin", "status": "active", "lastActive": "Just now", "phone": "+1 (555) 012-9012", "location": "Philadelphia, US"},
]

ZONES_DB = [
    {"id": "z1", "name": "Downtown Safe Zone", "type": "allowed", "radius": 500, "lat": 37.7749, "lng": -122.4194, "assignedUsersCount": 14, "status": "active", "createdAt": "2025-01-10"},
    {"id": "z2", "name": "Victim Residence Perimeter", "type": "restricted", "radius": 1000, "lat": 37.7833, "lng": -122.4167, "assignedUsersCount": 3, "status": "active", "createdAt": "2025-02-14"},
    {"id": "z3", "name": "County Courthouse Reporting", "type": "check-in", "radius": 250, "lat": 37.7752, "lng": -122.4175, "assignedUsersCount": 28, "status": "active", "createdAt": "2025-03-01"},
]

SCHEDULES_DB = [
    {"id": "s1", "user": {"id": "u1", "name": "John Smith", "avatarUrl": "/images/avatars/john.png"}, "name": "Daily Morning Check-in", "methods": ["biometric", "selfie"], "time": "09:00 AM", "frequency": "daily", "status": "active", "lastCheckIn": "Today 09:02 AM", "missedCount": 0, "nextCheckIn": "Tomorrow 09:00 AM"},
    {"id": "s2", "user": {"id": "u3", "name": "Mike Wilson", "avatarUrl": "/images/avatars/mike.png"}, "name": "Field Site Check-in", "methods": ["selfie"], "time": "08:00 AM", "frequency": "daily", "status": "active", "lastCheckIn": "Yesterday 08:15 AM", "missedCount": 1, "nextCheckIn": "Today 08:00 AM"},
    {"id": "s3", "user": {"id": "u5", "name": "Robert Brown", "avatarUrl": "/images/avatars/robert.png"}, "name": "Weekly Status Check", "methods": ["biometric"], "time": "10:00 AM", "frequency": "weekly", "status": "active", "lastCheckIn": "3 days ago", "missedCount": 0, "nextCheckIn": "In 4 days"},
]

SECURITY_EVENTS_DB = [
    {"id": "e1", "type": "vpn", "title": "VPN usage detected during active tracking session", "userEmail": "john.smith@company.com", "userId": "u1", "location": "New York, US", "time": "2 mins ago", "severity": "high", "status": "active", "ipAddress": "10.0.0.1"},
    {"id": "e2", "type": "failed_login", "title": "8 consecutive failed login attempts", "userEmail": "unknown@attacker.com", "location": "Moscow, RU", "time": "5 mins ago", "severity": "critical", "status": "active", "ipAddress": "185.220.101.4"},
    {"id": "e3", "type": "unusual_location", "title": "Login from unusual location — 3,500 miles from last location", "userEmail": "mike.wilson@company.com", "userId": "u3", "location": "Tokyo, JP", "time": "12 mins ago", "severity": "high", "status": "investigating", "ipAddress": "126.45.12.8"},
]

SYNC_FAILURES_DB = [
    {"id": "f1", "user": {"id": "u1", "name": "John Smith", "email": "john@company.com"}, "device": "iPhone 15 Pro", "reason": "Connection timeout after 30s", "errorCode": "ERR_CONN_TIMEOUT", "retries": 3, "time": "2 mins ago", "status": "failed", "dataLossRisk": False},
    {"id": "f2", "user": {"id": "u3", "name": "Mike Wilson", "email": "mike@company.com"}, "device": "Samsung Galaxy S24", "reason": "GPS signal lost during sync", "errorCode": "ERR_GPS_SIGNAL", "retries": 1, "time": "5 mins ago", "status": "pending", "dataLossRisk": False},
    {"id": "f3", "user": {"id": "u5", "name": "Robert Brown", "email": "robert@company.com"}, "device": "iPhone 14", "reason": "Server rejected sync — data format mismatch", "errorCode": "ERR_DATA_FORMAT", "retries": 5, "time": "8 mins ago", "status": "failed", "dataLossRisk": True},
]

AUDIT_LOGS_DB = [
    {"id": "l1", "event": "User login", "user": "john.smith@company.com", "category": "Authentication", "time": "2 mins ago", "status": "success", "ip": "192.168.1.100"},
    {"id": "l2", "event": "PDF Export", "user": "emma.davis@company.com", "category": "Export", "time": "5 mins ago", "status": "success", "ip": "192.168.1.102"},
    {"id": "l3", "event": "Failed login", "user": "unknown@external.com", "category": "Security", "time": "8 mins ago", "status": "failed", "ip": "185.220.101.4"},
    {"id": "l4", "event": "Legal hold applied", "user": "admin@securetrack.io", "category": "Compliance", "time": "15 mins ago", "status": "success", "ip": "10.0.0.1"},
]

LEGAL_HOLDS_DB = [
    {
        "id": "h1",
        "caseId": "c1",
        "caseNumber": "CASE-2025-001",
        "title": "State v. Johnson — Location Verification",
        "authorization": "CO-2025-4521",
        "reason": "Court-ordered preservation of location records for active criminal proceedings.",
        "status": "active",
        "appliedAt": "2025-06-01",
        "appliedBy": "admin@securetrack.io",
        "history": [
            {"action": "Legal hold applied", "actor": "admin@securetrack.io", "date": "2025-06-01"},
            {"action": "Hold verified by supervisor", "actor": "supervisor@securetrack.io", "date": "2025-06-01"}
        ]
    }
]

ESCALATIONS_DB = [
    {"id": "e1", "title": "GPS manipulation flags — John Smith", "priority": "critical", "status": "under-review", "assignedTo": "Supervisor Team", "createdAt": "2026-10-06T14:00:00Z"},
    {"id": "e2", "title": "Court order — immediate export required", "priority": "high", "status": "open", "assignedTo": "Legal Dispatch", "createdAt": "2026-10-07T09:30:00Z"},
]

RETENTION_RULES_DB = [
    {"id": "r1", "name": "Pretrial GPS Logs", "periodDays": "90", "complianceMode": True, "target": "gps_telemetry", "lastPurge": "2026-10-01"},
    {"id": "r2", "name": "Check-In Selfies & Biometrics", "periodDays": "180", "complianceMode": True, "target": "biometrics", "lastPurge": "2026-09-15"},
    {"id": "r3", "name": "Non-Evidentiary Audit Logs", "periodDays": "365", "complianceMode": False, "target": "audit_logs", "lastPurge": "2026-08-01"},
]

SYSTEM_SETTINGS_STATE = {
    "security": {"twoFactor": True, "sessionTimeout": True, "ipWhitelist": False},
    "notifications": {"failedSync": True, "newUser": True, "securityAlerts": True, "exportCompletion": True},
    "retention": {"logRetentionDays": "90", "autoDeleteExportsDays": "30", "automaticBackup": True},
    "exports": {"encryptedPdf": True, "watermark": True, "defaultFormat": "pdf"},
}

EXPORT_SETTINGS_STATE = {
    "activeAssignments": 24,
    "channels": [
        {"channel": "pdf", "enabled": True, "requireApproval": False, "auditAll": True, "maxRecords": 5000, "allowedRoles": ["admin", "authorized_viewer"]},
        {"channel": "spreadsheet", "enabled": True, "requireApproval": True, "auditAll": True, "maxRecords": 10000, "allowedRoles": ["admin"]},
        {"channel": "email", "enabled": True, "requireApproval": True, "auditAll": True, "maxRecords": 1000, "allowedRoles": ["admin"]},
    ]
}

NOTIFICATIONS_DB = [
    {"id": "n1", "title": "New High Priority Escalation", "body": "GPS manipulation flag active for John Smith", "time": "5m ago", "read": False, "type": "escalation"},
    {"id": "n2", "title": "Export Completed", "body": "Certified PDF export ready for Case #CASE-2025-001", "time": "20m ago", "read": False, "type": "export"},
    {"id": "n3", "title": "Sync Failure Detected", "body": "Connection timeout for Mike Wilson", "time": "1h ago", "read": True, "type": "sync"},
]


# =========================================================================
# 1. AUTHENTICATION ENDPOINTS
# =========================================================================

class LoginRequest(BaseModel):
    email: str
    password: str
    rememberMe: bool = False

@admin_router.post("/auth/login")
async def admin_login(creds: LoginRequest):
    email = creds.email.lower().strip()
    account = MOCK_ADMINS.get(email)
    if not account or account["password"] != creds.password:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid email or password")
    challenge_id = f"chal_{uuid.uuid4().hex[:12]}_{email}"
    return {"challengeId": challenge_id, "email": email, "resendAfter": 60}

@admin_router.post("/auth/verify-email-code")
async def verify_email_code(payload: Dict[str, Any] = Body(...)):
    challenge_id = payload.get("challengeId", "")
    code = payload.get("code", "")
    if code == "000000":
        raise HTTPException(status_code=400, detail="Invalid verification code")
    return {"challengeId": challenge_id}

@admin_router.post("/auth/resend-email-code")
async def resend_email_code(payload: Dict[str, Any] = Body(...)):
    return {"resendAfter": 60}

@admin_router.post("/auth/verify-totp")
async def verify_totp(payload: Dict[str, Any] = Body(...)):
    challenge_id = payload.get("challengeId", "")
    code = payload.get("code", "")
    if code == "000000":
        raise HTTPException(status_code=400, detail="Invalid verification code")
    email = challenge_id.split("_")[-1] if "_" in challenge_id else "superadmin@securetrack.io"
    account = MOCK_ADMINS.get(email, MOCK_ADMINS["superadmin@securetrack.io"])
    return {
        "user": {
            "id": account["id"],
            "name": account["name"],
            "email": account["email"],
            "role": account["role"],
            "permissions": account["permissions"],
        },
        "accessToken": f"bearer_{uuid.uuid4().hex}",
        "device": {"name": "Chrome on macOS", "ip": "127.0.0.1", "location": "Local Developer Workspace"},
        "deviceTrusted": True,
    }

@admin_router.post("/auth/device-trust")
async def set_device_trust(payload: Dict[str, Any] = Body(...)):
    return {"status": "success", "trusted": payload.get("trusted", True)}


# =========================================================================
# 2. DASHBOARD OVERVIEW
# =========================================================================

@admin_router.get("/dashboard/overview")
async def get_dashboard_overview():
    return {
        "stats": [
            {"id": "trackedUsers", "label": "Total Tracked Users", "value": len(USERS_DB), "change": "+12.5%", "trend": "positive", "direction": "up"},
            {"id": "authorizedViewers", "label": "Authorized Viewers", "value": 342, "change": "+8.2%", "trend": "positive", "direction": "up"},
            {"id": "activeSessions", "label": "Active Sessions", "value": 89, "change": "-3.1%", "trend": "negative", "direction": "down"},
            {"id": "failedSyncs", "label": "Failed Syncs", "value": len(SYNC_FAILURES_DB), "change": "+2", "trend": "negative", "direction": "down"},
        ],
        "trackingActivity": [
            {"label": "Mon", "value": 46},
            {"label": "Tue", "value": 53},
            {"label": "Wed", "value": 38},
            {"label": "Thu", "value": 62},
            {"label": "Fri", "value": 52},
            {"label": "Sat", "value": 29},
            {"label": "Sun", "value": 33},
        ],
        "exportActivity": [
            {"label": "Jan", "value": 24},
            {"label": "Feb", "value": 31},
            {"label": "Mar", "value": 45},
            {"label": "Apr", "value": 38},
            {"label": "May", "value": 52},
        ],
        "activityFeed": [
            {"id": "a1", "type": "export", "title": "Spreadsheet export completed", "actor": "lisa.anderson@company.com", "time": "Just now"},
            {"id": "a2", "type": "security", "title": "VPN detected for tracked user session", "actor": "unknown", "severity": "critical", "time": "Just now"},
            {"id": "a3", "type": "sync", "title": "Sync failure: GPS signal lost", "actor": "tom.harris@company.com", "severity": "warning", "time": "Just now"},
            {"id": "a4", "type": "login", "title": "Successful login from San Francisco, US", "actor": "superadmin@securetrack.io", "time": "Just now"},
        ],
        "systemHealth": [
            {"name": "GPS Tracking Service", "status": "operational"},
            {"name": "Sync Engine", "status": "operational"},
            {"name": "Export Service", "status": "operational"},
            {"name": "Authentication API", "status": "operational"},
            {"name": "Audit Logger", "status": "operational"},
        ],
        "openCases": [
            {"id": "c1", "title": "State v. Johnson", "caseNumber": "CASE-2025-001", "status": "active", "onHold": True},
            {"id": "c2", "title": "Civil Dispute — Asset Tracking", "caseNumber": "CASE-2025-002", "status": "open", "onHold": False},
        ],
        "escalations": ESCALATIONS_DB,
        "recentAudit": AUDIT_LOGS_DB,
    }


# =========================================================================
# 3. USERS MANAGEMENT
# =========================================================================

@admin_router.get("/users")
async def list_users(search: str = "", status: str = "all", role: str = "all"):
    results = USERS_DB
    if status != "all":
        results = [u for u in results if u.get("status") == status]
    if role != "all":
        results = [u for u in results if u.get("role") == role]
    if search.strip():
        s = search.strip().lower()
        results = [u for u in results if s in u["name"].lower() or s in u["email"].lower()]
    return results

@admin_router.get("/users/stats")
async def users_stats():
    tracked = sum(1 for u in USERS_DB if u["role"] == "tracked_user")
    viewers = sum(1 for u in USERS_DB if u["role"] == "authorized_viewer")
    admins = sum(1 for u in USERS_DB if u["role"] == "admin")
    return {"total": len(USERS_DB), "tracked": tracked, "viewers": viewers, "admins": admins}

@admin_router.post("/users", status_code=201)
async def create_user(payload: Dict[str, Any] = Body(...)):
    new_user = {
        "id": f"u_{uuid.uuid4().hex[:8]}",
        "name": payload.get("name", "New User"),
        "email": payload.get("email", ""),
        "role": payload.get("role", "tracked_user"),
        "status": "active",
        "lastActive": "Just now",
        "phone": payload.get("phone", ""),
        "location": payload.get("location", "United States"),
    }
    USERS_DB.append(new_user)
    return new_user

@admin_router.patch("/users/{user_id}")
async def update_user(user_id: str, payload: Dict[str, Any] = Body(...)):
    for u in USERS_DB:
        if u["id"] == user_id:
            u.update(payload)
            return u
    raise HTTPException(status_code=404, detail="User not found")

@admin_router.delete("/users/{user_id}")
async def delete_user(user_id: str):
    global USERS_DB
    USERS_DB = [u for u in USERS_DB if u["id"] != user_id]
    return {"status": "deleted", "id": user_id}


# =========================================================================
# 4. GEOFENCE ZONES
# =========================================================================

@admin_router.get("/zones")
async def list_zones(search: str = "", type: str = "all"):
    results = ZONES_DB
    if type != "all":
        results = [z for z in results if z["type"] == type]
    if search.strip():
        s = search.strip().lower()
        results = [z for z in results if s in z["name"].lower()]
    return results

@admin_router.get("/zones/stats")
async def zones_stats():
    return {
        "total": len(ZONES_DB),
        "allowed": sum(1 for z in ZONES_DB if z["type"] == "allowed"),
        "restricted": sum(1 for z in ZONES_DB if z["type"] == "restricted"),
        "checkIn": sum(1 for z in ZONES_DB if z["type"] == "check-in"),
    }

@admin_router.post("/zones", status_code=201)
async def create_zone(payload: Dict[str, Any] = Body(...)):
    new_zone = {
        "id": f"z_{uuid.uuid4().hex[:8]}",
        "name": payload.get("name", "New Zone"),
        "type": payload.get("type", "allowed"),
        "radius": payload.get("radius", 500),
        "lat": payload.get("lat", 37.7749),
        "lng": payload.get("lng", -122.4194),
        "assignedUsersCount": 0,
        "status": "active",
        "createdAt": datetime.now(timezone.utc).strftime("%Y-%m-%d"),
    }
    ZONES_DB.append(new_zone)
    return new_zone

@admin_router.patch("/zones/{zone_id}")
async def update_zone(zone_id: str, payload: Dict[str, Any] = Body(...)):
    for z in ZONES_DB:
        if z["id"] == zone_id:
            z.update(payload)
            return z
    raise HTTPException(status_code=404, detail="Zone not found")

@admin_router.delete("/zones/{zone_id}")
async def delete_zone(zone_id: str):
    global ZONES_DB
    ZONES_DB = [z for z in ZONES_DB if z["id"] != zone_id]
    return {"status": "deleted"}


# =========================================================================
# 5. CHECK-IN SCHEDULES
# =========================================================================

@admin_router.get("/check-ins/schedules")
async def list_schedules():
    return SCHEDULES_DB

@admin_router.get("/check-ins/stats")
async def checkins_stats():
    active = sum(1 for s in SCHEDULES_DB if s["status"] == "active")
    missed = sum(s.get("missedCount", 0) for s in SCHEDULES_DB)
    return {"active": active, "dueToday": len(SCHEDULES_DB), "missed": missed, "compliance": 96.4}

@admin_router.post("/check-ins/schedules", status_code=201)
async def create_schedule(payload: Dict[str, Any] = Body(...)):
    new_sched = {
        "id": f"s_{uuid.uuid4().hex[:8]}",
        "name": payload.get("name", "New Scheduled Check-In"),
        "methods": payload.get("methods", ["biometric", "selfie"]),
        "time": payload.get("time", "09:00 AM"),
        "frequency": payload.get("frequency", "daily"),
        "status": "active",
        "lastCheckIn": "None yet",
        "missedCount": 0,
        "nextCheckIn": "Today",
        "user": payload.get("user", {"id": "u1", "name": "John Smith"}),
    }
    SCHEDULES_DB.append(new_sched)
    return new_sched

@admin_router.post("/check-ins/schedules/{schedule_id}/pause")
async def pause_schedule(schedule_id: str):
    for s in SCHEDULES_DB:
        if s["id"] == schedule_id:
            s["status"] = "paused"
            return s
    raise HTTPException(status_code=404, detail="Schedule not found")

@admin_router.post("/check-ins/schedules/{schedule_id}/resume")
async def resume_schedule(schedule_id: str):
    for s in SCHEDULES_DB:
        if s["id"] == schedule_id:
            s["status"] = "active"
            return s
    raise HTTPException(status_code=404, detail="Schedule not found")

@admin_router.post("/check-ins/schedules/{schedule_id}/remind")
async def send_checkin_reminder(schedule_id: str):
    return {"status": "reminded", "scheduleId": schedule_id, "dispatchedAt": datetime.now(timezone.utc).isoformat()}


# =========================================================================
# 6. SECURITY ALERTS & ANTI-TAMPER
# =========================================================================

@admin_router.get("/security/events")
async def list_security_events(search: str = "", severity: str = "all", status: str = "all"):
    results = SECURITY_EVENTS_DB
    if severity != "all":
        results = [e for e in results if e["severity"] == severity]
    if status != "all":
        results = [e for e in results if e["status"] == status]
    return results

@admin_router.get("/security/stats")
async def security_stats():
    return {
        "critical": sum(1 for e in SECURITY_EVENTS_DB if e["severity"] == "critical"),
        "high": sum(1 for e in SECURITY_EVENTS_DB if e["severity"] == "high"),
        "active": sum(1 for e in SECURITY_EVENTS_DB if e["status"] == "active"),
        "open": sum(1 for e in SECURITY_EVENTS_DB if e["status"] != "resolved"),
        "syncFailures": len(SYNC_FAILURES_DB),
    }

@admin_router.patch("/security/events/{event_id}")
async def update_security_event_status(event_id: str, payload: Dict[str, Any] = Body(...)):
    for e in SECURITY_EVENTS_DB:
        if e["id"] == event_id:
            e["status"] = payload.get("status", e["status"])
            return e
    raise HTTPException(status_code=404, detail="Event not found")


# =========================================================================
# 7. SYNC FAILURES
# =========================================================================

@admin_router.get("/sync-failures")
async def list_sync_failures():
    return SYNC_FAILURES_DB

@admin_router.get("/sync-failures/stats")
async def sync_failures_stats():
    return {
        "failed": sum(1 for f in SYNC_FAILURES_DB if f["status"] == "failed"),
        "pending": sum(1 for f in SYNC_FAILURES_DB if f["status"] == "pending"),
        "retrying": sum(1 for f in SYNC_FAILURES_DB if f["status"] == "retrying"),
        "resolved": sum(1 for f in SYNC_FAILURES_DB if f["status"] == "resolved"),
    }

@admin_router.post("/sync-failures/{failure_id}/retry")
async def retry_single_sync(failure_id: str):
    for f in SYNC_FAILURES_DB:
        if f["id"] == failure_id:
            f["status"] = "retrying"
            f["retries"] += 1
            return f
    raise HTTPException(status_code=404, detail="Sync failure record not found")

@admin_router.post("/sync-failures/retry-all")
async def retry_all_syncs():
    for f in SYNC_FAILURES_DB:
        if f["status"] in ("failed", "pending"):
            f["status"] = "retrying"
            f["retries"] += 1
    return {"status": "retrying_all", "count": len(SYNC_FAILURES_DB)}


# =========================================================================
# 8. AUDIT LOGS
# =========================================================================

@admin_router.get("/audit-logs")
async def list_audit_logs():
    return AUDIT_LOGS_DB

@admin_router.get("/audit-logs/stats")
async def audit_logs_stats():
    return {
        "total": len(AUDIT_LOGS_DB),
        "logins": sum(1 for a in AUDIT_LOGS_DB if a["category"] == "Authentication"),
        "exports": sum(1 for a in AUDIT_LOGS_DB if a["category"] == "Export"),
        "security": sum(1 for a in AUDIT_LOGS_DB if a["category"] == "Security"),
    }


# =========================================================================
# 9. LEGAL HOLDS & RETENTION RULES
# =========================================================================

@admin_router.get("/legal-holds")
async def list_legal_holds():
    return LEGAL_HOLDS_DB

@admin_router.get("/legal-holds/stats")
async def legal_holds_stats():
    active = sum(1 for h in LEGAL_HOLDS_DB if h["status"] == "active")
    return {"active": active, "total": len(LEGAL_HOLDS_DB), "audited": True}

@admin_router.post("/legal-holds", status_code=201)
async def create_legal_hold(payload: Dict[str, Any] = Body(...)):
    new_hold = {
        "id": f"h_{uuid.uuid4().hex[:8]}",
        "caseId": payload.get("caseId", ""),
        "caseNumber": payload.get("caseNumber", "CASE-NEW"),
        "title": payload.get("title", "Court Ordered Preservation"),
        "authorization": payload.get("authorization", "CO-2026-001"),
        "reason": payload.get("reason", "Evidentiary preservation"),
        "status": "active",
        "appliedAt": datetime.now(timezone.utc).strftime("%Y-%m-%d"),
        "appliedBy": "admin@securetrack.io",
        "history": [{"action": "Legal hold applied", "actor": "admin@securetrack.io", "date": datetime.now(timezone.utc).strftime("%Y-%m-%d")}]
    }
    LEGAL_HOLDS_DB.append(new_hold)
    return new_hold

@admin_router.post("/legal-holds/{hold_id}/lift")
async def lift_legal_hold(hold_id: str):
    for h in LEGAL_HOLDS_DB:
        if h["id"] == hold_id:
            h["status"] = "lifted"
            h["history"].append({"action": "Legal hold lifted", "actor": "admin@securetrack.io", "date": datetime.now(timezone.utc).strftime("%Y-%m-%d")})
            return h
    raise HTTPException(status_code=404, detail="Hold not found")

@admin_router.get("/retention-rules")
async def list_retention_rules():
    return RETENTION_RULES_DB

@admin_router.patch("/retention-rules/{rule_id}")
async def update_retention_rule(rule_id: str, payload: Dict[str, Any] = Body(...)):
    for r in RETENTION_RULES_DB:
        if r["id"] == rule_id:
            r.update(payload)
            return r
    raise HTTPException(status_code=404, detail="Retention rule not found")

@admin_router.post("/retention-rules/trigger-purge")
async def trigger_retention_purge():
    return {
        "status": "purge_executed",
        "recordsPurged": 142,
        "purgedAt": datetime.now(timezone.utc).isoformat(),
        "vaultArchived": True
    }


# =========================================================================
# 10. ESCALATIONS & SYSTEM SETTINGS
# =========================================================================

@admin_router.get("/escalations")
async def list_escalations():
    return ESCALATIONS_DB

@admin_router.get("/escalations/stats")
async def escalations_stats():
    return {
        "critical": sum(1 for e in ESCALATIONS_DB if e["priority"] == "critical"),
        "high": sum(1 for e in ESCALATIONS_DB if e["priority"] == "high"),
        "open": sum(1 for e in ESCALATIONS_DB if e["status"] == "open"),
    }

@admin_router.post("/escalations/{escalation_id}/resolve")
async def resolve_escalation(escalation_id: str):
    for e in ESCALATIONS_DB:
        if e["id"] == escalation_id:
            e["status"] = "resolved"
            return e
    raise HTTPException(status_code=404, detail="Escalation not found")

@admin_router.get("/settings/system")
async def get_system_settings():
    return {
        "settings": SYSTEM_SETTINGS_STATE,
        "info": {
            "platformVersion": "2.4.0 (Enterprise Legal Edition)",
            "databaseStatus": "Operational (Encrypted at Rest)",
            "lastBackup": "Today, 03:00 AM UTC",
            "storageUsed": "42.8 GB / 500 GB",
            "activeSessions": 89,
            "uptime": "99.98%",
        }
    }

@admin_router.put("/settings/system")
async def update_system_settings(payload: Dict[str, Any] = Body(...)):
    SYSTEM_SETTINGS_STATE.update(payload)
    return SYSTEM_SETTINGS_STATE

@admin_router.get("/export-settings")
async def get_export_settings():
    return EXPORT_SETTINGS_STATE

@admin_router.put("/export-settings")
async def update_export_settings(payload: Dict[str, Any] = Body(...)):
    EXPORT_SETTINGS_STATE.update(payload)
    return EXPORT_SETTINGS_STATE


# =========================================================================
# 11. NOTIFICATIONS & SUPPORT
# =========================================================================

@admin_router.get("/notifications")
async def get_notifications():
    return NOTIFICATIONS_DB

@admin_router.post("/notifications/read-all")
async def mark_all_notifications_read():
    for n in NOTIFICATIONS_DB:
        n["read"] = True
    return {"status": "all_marked_read"}

@admin_router.post("/notifications/{notification_id}/read")
async def mark_single_notification_read(notification_id: str):
    for n in NOTIFICATIONS_DB:
        if n["id"] == notification_id:
            n["read"] = True
            return n
    raise HTTPException(status_code=404, detail="Notification not found")
