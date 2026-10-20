import os
import sys
from fastapi.testclient import TestClient

# Ensure backend root is on sys.path
backend_dir = os.path.dirname(os.path.abspath(__file__))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from app.main import app

client = TestClient(app)

def test_health():
    res = client.get("/api/health")
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "healthy"
    print("✓ Health endpoint OK")

def test_generate_pdf():
    payload = {
        "case_id": "case_test_99",
        "tracked_user_id": "usr_vance",
        "tracked_user_name": "Johnathan Vance",
        "date_from": "2026-10-01",
        "date_to": "2026-10-07",
    }
    res = client.post("/api/v1/reports/pdf", json=payload)
    assert res.status_code == 200, res.text
    data = res.json()
    assert data["status"] == "success"
    assert "document_sha256" in data
    assert len(data["document_sha256"]) == 64
    print(f"✓ PDF generation OK: {data['report_id']} | Hash: {data['document_sha256'][:16]}...")
    return data["document_sha256"], data["download_url"]

def test_generate_excel():
    payload = {
        "case_id": "case_test_99",
        "tracked_user_name": "Johnathan Vance",
        "date_from": "2026-10-01",
        "date_to": "2026-10-07",
        "supervisor_name": "Joshua R. Hughes, Esq.",
    }
    res = client.post("/api/v1/reports/excel", json=payload)
    assert res.status_code == 200, res.text
    data = res.json()
    assert data["status"] == "success"
    assert "document_sha256" in data
    assert data["sheets_count"] == 3
    print(f"✓ Excel generation OK: {data['report_id']} | Hash: {data['document_sha256'][:16]}...")
    return data["document_sha256"], data["download_url"]

def test_verify_document(doc_hash):
    res = client.get(f"/api/v1/verify/{doc_hash}")
    assert res.status_code == 200, res.text
    data = res.json()
    assert data["status"] == "VERIFIED_VALID"
    assert "certification" in data
    print(f"✓ Court Verification endpoint OK for hash: {doc_hash[:16]}...")

def test_download(download_url):
    res = client.get(download_url)
    assert res.status_code == 200
    assert len(res.content) > 1000
    print(f"✓ Download OK for {download_url} ({len(res.content)} bytes)")

def test_biometrics():
    payload = {
        "tracked_user_id": "usr_vance",
    }
    res = client.post("/api/v1/biometrics/verify-face", json=payload)
    assert res.status_code == 200
    data = res.json()
    assert data["is_match"] is True
    assert data["similarity_score"] >= 98.0
    print(f"✓ Biometrics endpoint OK: score={data['similarity_score']}%")

def test_cases_crud():
    # List cases
    res = client.get("/api/v1/cases")
    assert res.status_code == 200
    cases = res.json()
    assert len(cases) >= 3
    assert any(c["case_id"] == "case_10482" for c in cases)

    # Get single case
    res = client.get("/api/v1/cases/case_10482")
    assert res.status_code == 200
    single = res.json()
    assert single["client_name"] == "Johnathan Vance"

    # Create new case
    new_case = {
        "case_id": "case_test_new",
        "case_number": "CR-2026-9999",
        "court": "Federal District Court",
        "client_name": "Test Client",
        "attorney_name": "Joshua R. Hughes, Esq.",
        "status": "Active",
        "compliance_score": 100,
        "curfew_hours": "21:00 - 06:00 Daily",
        "geofence_count": 2,
        "assigned_at": "2026-10-07T00:00:00Z",
    }
    res = client.post("/api/v1/cases", json=new_case)
    assert res.status_code == 201
    assert res.json()["case_id"] == "case_test_new"
    print("✓ Cases CRUD endpoints OK (list, get, create)")

def test_telemetry_flow():
    # Ingest point
    point = {
        "log_id": "tel_test_100",
        "case_id": "case_10482",
        "user_id": "usr_98234",
        "latitude": 37.7760,
        "longitude": -122.4180,
        "accuracy_meters": 3.5,
        "speed_mps": 0.5,
        "is_mock_provider": False,
        "battery_level": 95,
        "timestamp": "2026-10-07T04:00:00Z",
    }
    res = client.post("/api/v1/telemetry/log", json=point)
    assert res.status_code == 201
    assert res.json()["log_id"] == "tel_test_100"

    # Get history
    res = client.get("/api/v1/telemetry/history?case_id=case_10482")
    assert res.status_code == 200
    logs = res.json()
    assert len(logs) >= 1
    assert logs[0]["log_id"] == "tel_test_100"
    print("✓ Telemetry ingestion and history query OK")

def test_offline_batch_sync():
    batch = {
        "user_id": "usr_98234",
        "case_id": "case_10482",
        "device_id": "iPhone_14_Pro_UUID_101",
        "items": [
            {"coords": "37.7749,-122.4194", "ts": "2026-10-07T03:00:00Z"},
            {"coords": "37.7750,-122.4195", "ts": "2026-10-07T03:15:00Z"},
            {"coords": "37.7752,-122.4197", "ts": "2026-10-07T03:30:00Z"},
        ],
    }
    res = client.post("/api/v1/sync/batch", json=batch)
    assert res.status_code == 200
    data = res.json()
    assert data["status"] == "success"
    assert data["synced_count"] == 3
    assert "batch_receipt_id" in data
    print(f"✓ Offline batch sync OK: {data['synced_count']} items synced (Receipt: {data['batch_receipt_id']})")

def test_sos_alert():
    sos = {
        "user_id": "usr_98234",
        "case_id": "case_10482",
        "latitude": 37.7749,
        "longitude": -122.4194,
        "battery_level": 78,
        "note": "Immediate panic trigger by client",
    }
    res = client.post("/api/v1/sos/alert", json=sos)
    assert res.status_code == 201
    data = res.json()
    assert data["status"] == "dispatched"
    assert len(data["dispatched_to"]) >= 3
    print(f"✓ Emergency SOS dispatch OK: {data['alert_id']} broadcast to counsel")

def test_user_profiles():
    # Get profile
    res = client.get("/api/v1/profile?user_id=usr_98234")
    assert res.status_code == 200
    p = res.json()
    assert p["full_name"] == "Johnathan Vance"

    # Update profile
    p["phone"] = "+1 (555) 999-8888"
    res = client.put("/api/v1/profile", json=p)
    assert res.status_code == 200
    assert res.json()["phone"] == "+1 (555) 999-8888"
    print("✓ User profile GET & PUT OK")

def test_ai_compliance():
    # Compliant points
    check_req = {
        "case_id": "case_10482",
        "telemetry_points": [
            {"latitude": 37.7749, "longitude": -122.4194, "is_mock_provider": False, "accuracy_meters": 4.0},
            {"latitude": 37.7750, "longitude": -122.4195, "is_mock_provider": False, "accuracy_meters": 3.8},
        ],
    }
    res = client.post("/api/v1/ai/compliance-check", json=check_req)
    assert res.status_code == 200
    data = res.json()
    assert data["overall_status"] == "COMPLIANT"
    assert data["compliance_score"] == 100.0

    # With mock location violation
    violation_req = {
        "case_id": "case_10482",
        "telemetry_points": [
            {"latitude": 37.7749, "longitude": -122.4194, "is_mock_provider": True, "accuracy_meters": 12.0},
        ],
    }
    res2 = client.post("/api/v1/ai/compliance-check", json=violation_req)
    assert res2.status_code == 200
    data2 = res2.json()
    assert data2["overall_status"] in ["WARNING", "VIOLATION_DETECTED"]
    assert len(data2["violations"]) == 1
    assert data2["violations"][0]["type"] == "MOCK_LOCATION_DETECTED"
    print("✓ AI automated legal compliance check endpoint OK")

def test_web_admin_auth():
    # Login with valid superadmin
    res = client.post("/api/v1/auth/login", json={"email": "superadmin@securetrack.io", "password": "SuperAdmin@123"})
    assert res.status_code == 200, res.text
    data = res.json()
    assert "challengeId" in data
    chal_id = data["challengeId"]

    # Verify email code
    res_code = client.post("/api/v1/auth/verify-email-code", json={"challengeId": chal_id, "code": "123456"})
    assert res_code.status_code == 200

    # Verify TOTP
    res_totp = client.post("/api/v1/auth/verify-totp", json={"challengeId": chal_id, "code": "123456"})
    assert res_totp.status_code == 200
    user_data = res_totp.json()
    assert user_data["user"]["role"] == "SUPER_ADMIN"
    assert "accessToken" in user_data
    print("✓ Web Admin Authentication endpoints OK (Login, Code, 2FA)")

def test_web_admin_dashboard():
    res = client.get("/api/v1/dashboard/overview")
    assert res.status_code == 200
    data = res.json()
    assert "stats" in data
    assert len(data["stats"]) == 4
    assert "trackingActivity" in data
    assert "systemHealth" in data
    print("✓ Web Admin Dashboard Overview endpoint OK")

def test_web_admin_users_and_zones():
    # Users
    res_u = client.get("/api/v1/users")
    assert res_u.status_code == 200
    users = res_u.json()
    assert len(users) >= 5

    res_stats = client.get("/api/v1/users/stats")
    assert res_stats.status_code == 200
    assert res_stats.json()["total"] >= 5

    # Zones
    res_z = client.get("/api/v1/zones")
    assert res_z.status_code == 200
    assert len(res_z.json()) >= 3

    res_zstats = client.get("/api/v1/zones/stats")
    assert res_zstats.status_code == 200
    assert res_zstats.json()["total"] >= 3
    print("✓ Web Admin Users and Geofence Zones endpoints OK")

def test_web_admin_checkins_and_security():
    # Check-in Schedules
    res_s = client.get("/api/v1/check-ins/schedules")
    assert res_s.status_code == 200
    assert len(res_s.json()) >= 3

    res_sstats = client.get("/api/v1/check-ins/stats")
    assert res_sstats.status_code == 200

    # Security Alerts
    res_sec = client.get("/api/v1/security/events")
    assert res_sec.status_code == 200
    assert len(res_sec.json()) >= 3

    # Sync Failures
    res_sync = client.get("/api/v1/sync-failures")
    assert res_sync.status_code == 200
    assert len(res_sync.json()) >= 3

    res_retry = client.post("/api/v1/sync-failures/retry-all")
    assert res_retry.status_code == 200
    print("✓ Web Admin Check-Ins, Security Alerts, and Sync Failures endpoints OK")

def test_web_admin_legal_and_settings():
    # Legal Holds
    res_lh = client.get("/api/v1/legal-holds")
    assert res_lh.status_code == 200
    assert len(res_lh.json()) >= 1

    # Retention Rules
    res_rr = client.get("/api/v1/retention-rules")
    assert res_rr.status_code == 200
    assert len(res_rr.json()) >= 3

    # Audit Logs
    res_al = client.get("/api/v1/audit-logs")
    assert res_al.status_code == 200
    assert len(res_al.json()) >= 4

    # System Settings
    res_sett = client.get("/api/v1/settings/system")
    assert res_sett.status_code == 200
    assert "settings" in res_sett.json()

    # Notifications
    res_notif = client.get("/api/v1/notifications")
    assert res_notif.status_code == 200
    assert len(res_notif.json()) >= 3
    print("✓ Web Admin Legal Hold, Retention Rules, Audits, Settings & Notifications OK")

if __name__ == "__main__":
    test_health()
    pdf_hash, pdf_url = test_generate_pdf()
    excel_hash, excel_url = test_generate_excel()
    test_verify_document(pdf_hash)
    test_verify_document(excel_hash)
    test_download(pdf_url)
    test_download(excel_url)
    test_biometrics()
    test_cases_crud()
    test_telemetry_flow()
    test_offline_batch_sync()
    test_sos_alert()
    test_user_profiles()
    test_ai_compliance()
    test_web_admin_auth()
    test_web_admin_dashboard()
    test_web_admin_users_and_zones()
    test_web_admin_checkins_and_security()
    test_web_admin_legal_and_settings()
    print("\n=======================================================")
    print("ALL 18+ BACKEND & WEB ADMIN REST API SUITES PASSED 100%!")
    print("=======================================================")
