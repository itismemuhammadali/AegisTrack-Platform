import os
import hashlib
import uuid
from datetime import datetime, timezone
from typing import Optional, List, Dict, Any
from fastapi import FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from pydantic import BaseModel, Field

from app.services.pdf_generator import generate_evidentiary_pdf
from app.services.excel_generator import generate_evidentiary_excel
from app.services.rekognition_service import verify_face_biometrics
from app.routers.admin_router import admin_router

app = FastAPI(
    title="Joshua R Hughes — Legal Tech Monitoring API",
    description="Backend service for evidentiary PDF generation, Excel raw audit logs, court verification, legal cases, telemetry, and biometrics.",
    version="1.0.0",
)

# Include Admin Portal & Supervisory Router
app.include_router(admin_router, prefix="/api/v1")

# Enable CORS for local Flutter mobile / simulator / web testing
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REPORTS_DIR = os.path.join(BASE_DIR, "generated_reports")
os.makedirs(REPORTS_DIR, exist_ok=True)


# --- Data Models ---

class HealthResponse(BaseModel):
    status: str
    timestamp: str
    service: str
    version: str


class PDFReportRequest(BaseModel):
    case_id: str = Field(..., example="case_10482")
    tracked_user_id: str = Field(..., example="usr_98234")
    tracked_user_name: Optional[str] = Field("Johnathan Vance", example="Johnathan Vance")
    date_from: str = Field(..., example="2026-10-01")
    date_to: str = Field(..., example="2026-10-07")
    include_selfie_photos: bool = True
    include_map_snapshots: bool = True
    requestor_user_id: Optional[str] = "Joshua R. Hughes, Esq."


class PDFReportResponse(BaseModel):
    status: str
    report_id: str
    document_sha256: str
    download_url: str
    page_count: int
    generated_at: str


class ExcelReportRequest(BaseModel):
    case_id: str = Field(..., example="case_10482")
    tracked_user_name: Optional[str] = Field("Johnathan Vance", example="Johnathan Vance")
    date_from: str = Field(..., example="2026-10-01")
    date_to: str = Field(..., example="2026-10-07")
    supervisor_name: Optional[str] = "Joshua R. Hughes, Esq."


class ExcelReportResponse(BaseModel):
    status: str
    report_id: str
    document_sha256: str
    download_url: str
    sheets_count: int
    generated_at: str


class BiometricVerificationRequest(BaseModel):
    tracked_user_id: str
    reference_image_url: Optional[str] = None
    checkin_image_url: Optional[str] = None


class BiometricVerificationResponse(BaseModel):
    is_match: bool
    similarity_score: float
    confidence_level: float
    liveness_confirmed: bool


class LegalCase(BaseModel):
    case_id: str
    case_number: str
    court: str
    client_name: str
    attorney_name: str
    status: str
    compliance_score: int
    curfew_hours: str
    geofence_count: int
    assigned_at: str


class TelemetryLog(BaseModel):
    log_id: str
    case_id: str
    user_id: str
    latitude: float
    longitude: float
    accuracy_meters: float
    speed_mps: float
    is_mock_provider: bool
    battery_level: int
    timestamp: str


class BatchSyncRequest(BaseModel):
    user_id: str
    case_id: str
    device_id: str
    items: List[Dict[str, Any]]


class BatchSyncResponse(BaseModel):
    status: str
    synced_count: int
    failed_count: int
    batch_receipt_id: str
    synced_at: str


class SosAlertRequest(BaseModel):
    user_id: str
    case_id: str
    latitude: float
    longitude: float
    battery_level: int
    note: Optional[str] = "Emergency SOS button triggered"


class SosAlertResponse(BaseModel):
    status: str
    alert_id: str
    dispatched_to: List[str]
    timestamp: str


class UserProfile(BaseModel):
    user_id: str
    role: str
    full_name: str
    email: str
    phone: str
    bio: Optional[str] = ""
    firm_name: Optional[str] = ""
    bar_number: Optional[str] = ""
    location: Optional[str] = "San Francisco, CA"
    two_factor_enabled: bool = True
    biometrics_enabled: bool = True


class ComplianceCheckRequest(BaseModel):
    case_id: str
    telemetry_points: List[Dict[str, Any]]
    curfew_start_hour: int = 22
    curfew_end_hour: int = 6


class ComplianceCheckResponse(BaseModel):
    case_id: str
    overall_status: str
    compliance_score: float
    violations: List[Dict[str, Any]]
    inspected_at: str


# --- In-Memory Stores ---

VERIFIED_DOCUMENTS: Dict[str, Dict[str, Any]] = {}

CASES_DB: Dict[str, LegalCase] = {
    "case_10482": LegalCase(
        case_id="case_10482",
        case_number="CR-2026-0842",
        court="San Francisco Superior Court, Dept. 12",
        client_name="Johnathan Vance",
        attorney_name="Joshua R. Hughes, Esq.",
        status="Active",
        compliance_score=98,
        curfew_hours="22:00 - 06:00 Daily",
        geofence_count=2,
        assigned_at="2026-09-15T08:00:00Z",
    ),
    "case_10483": LegalCase(
        case_id="case_10483",
        case_number="CR-2026-0911",
        court="Oakland Municipal Court, Dept. 4",
        client_name="Marcus Sterling",
        attorney_name="Joshua R. Hughes, Esq.",
        status="Legal Hold",
        compliance_score=87,
        curfew_hours="20:00 - 05:00 Daily",
        geofence_count=3,
        assigned_at="2026-09-20T10:30:00Z",
    ),
    "case_10484": LegalCase(
        case_id="case_10484",
        case_number="CR-2026-1002",
        court="San Jose Federal District Court",
        client_name="Elena Rostova",
        attorney_name="Joshua R. Hughes, Esq.",
        status="Active",
        compliance_score=99,
        curfew_hours="21:00 - 06:00 Daily",
        geofence_count=1,
        assigned_at="2026-10-01T14:15:00Z",
    ),
}

TELEMETRY_LOGS_DB: List[TelemetryLog] = [
    TelemetryLog(
        log_id="tel_001",
        case_id="case_10482",
        user_id="usr_98234",
        latitude=37.7749,
        longitude=-122.4194,
        accuracy_meters=4.2,
        speed_mps=0.0,
        is_mock_provider=False,
        battery_level=88,
        timestamp="2026-10-07T03:30:00Z",
    ),
    TelemetryLog(
        log_id="tel_002",
        case_id="case_10482",
        user_id="usr_98234",
        latitude=37.7750,
        longitude=-122.4195,
        accuracy_meters=3.8,
        speed_mps=1.2,
        is_mock_provider=False,
        battery_level=87,
        timestamp="2026-10-07T03:35:00Z",
    ),
]

PROFILES_DB: Dict[str, UserProfile] = {
    "usr_98234": UserProfile(
        user_id="usr_98234",
        role="tracked",
        full_name="Johnathan Vance",
        email="j.vance@example.com",
        phone="+1 (555) 019-2834",
        bio="Tracked individual under pretrial electronic monitoring.",
        location="San Francisco, CA",
        two_factor_enabled=True,
        biometrics_enabled=True,
    ),
    "counsel_001": UserProfile(
        user_id="counsel_001",
        role="tracker",
        full_name="Joshua R. Hughes",
        email="alex.viewer@example.com",
        phone="+1 (555) 482-1920",
        bio="Defense Counsel & Legal Monitoring Supervisor",
        firm_name="Hughes Legal Defense, APC",
        bar_number="CA Bar #302918",
        location="San Francisco, CA",
        two_factor_enabled=True,
        biometrics_enabled=True,
    ),
}


# --- REST API Endpoints ---

@app.get("/", tags=["General"])
async def root():
    return {
        "service": "Joshua R Hughes Legal Monitoring API",
        "status": "online",
        "docs_url": "/docs",
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }


@app.get("/api/health", response_model=HealthResponse, tags=["General"])
async def health_check():
    return HealthResponse(
        status="healthy",
        timestamp=datetime.now(timezone.utc).isoformat(),
        service="backend-api",
        version="1.0.0",
    )


# --- Reports & Exporters ---

@app.post("/api/v1/reports/pdf", response_model=PDFReportResponse, tags=["Reports"])
async def generate_pdf_report_endpoint(request: PDFReportRequest):
    report_id = f"rep_{uuid.uuid4().hex[:10]}"
    output_filename = f"{report_id}.pdf"
    output_filepath = os.path.join(REPORTS_DIR, output_filename)

    try:
        pdf_meta = generate_evidentiary_pdf(
            output_filepath=output_filepath,
            case_id=request.case_id,
            tracked_user_name=request.tracked_user_name or "Johnathan Vance",
            date_from=request.date_from,
            date_to=request.date_to,
            requestor_name=request.requestor_user_id or "Joshua R. Hughes, Esq.",
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to generate evidentiary PDF: {str(e)}",
        )

    document_hash = pdf_meta["document_sha256"]

    VERIFIED_DOCUMENTS[document_hash] = {
        "report_id": report_id,
        "case_id": request.case_id,
        "tracked_user_name": request.tracked_user_name or "Johnathan Vance",
        "date_from": request.date_from,
        "date_to": request.date_to,
        "format": "PDF_SEALED",
        "generated_at": pdf_meta["generated_at"],
        "tamper_status": "AUTHENTIC_UNMODIFIED",
        "verification_url": pdf_meta["verification_url"],
    }

    return PDFReportResponse(
        status="success",
        report_id=report_id,
        document_sha256=document_hash,
        download_url=f"/api/v1/reports/download/{output_filename}",
        page_count=2,
        generated_at=pdf_meta["generated_at"],
    )


@app.post("/api/v1/reports/excel", response_model=ExcelReportResponse, tags=["Reports"])
async def generate_excel_report_endpoint(request: ExcelReportRequest):
    report_id = f"audit_{uuid.uuid4().hex[:10]}"
    output_filename = f"{report_id}.xlsx"
    output_filepath = os.path.join(REPORTS_DIR, output_filename)

    try:
        excel_meta = generate_evidentiary_excel(
            output_filepath=output_filepath,
            case_id=request.case_id,
            tracked_user_name=request.tracked_user_name or "Johnathan Vance",
            date_from=request.date_from,
            date_to=request.date_to,
            supervisor_name=request.supervisor_name or "Joshua R. Hughes, Esq.",
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to generate evidentiary Excel: {str(e)}",
        )

    document_hash = excel_meta["document_sha256"]

    VERIFIED_DOCUMENTS[document_hash] = {
        "report_id": report_id,
        "case_id": request.case_id,
        "tracked_user_name": request.tracked_user_name or "Johnathan Vance",
        "date_from": request.date_from,
        "date_to": request.date_to,
        "format": "EXCEL_XLSX",
        "generated_at": excel_meta["generated_at"],
        "tamper_status": "AUTHENTIC_UNMODIFIED",
        "verification_url": excel_meta["verification_url"],
    }

    return ExcelReportResponse(
        status="success",
        report_id=report_id,
        document_sha256=document_hash,
        download_url=f"/api/v1/reports/download/{output_filename}",
        sheets_count=3,
        generated_at=excel_meta["generated_at"],
    )


@app.get("/api/v1/reports/download/{filename}", tags=["Reports"])
async def download_report(filename: str):
    filepath = os.path.join(REPORTS_DIR, filename)
    if not os.path.exists(filepath):
        if os.path.exists(f"{filepath}.pdf"):
            filepath = f"{filepath}.pdf"
            filename = f"{filename}.pdf"
        elif os.path.exists(f"{filepath}.xlsx"):
            filepath = f"{filepath}.xlsx"
            filename = f"{filename}.xlsx"
        else:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Report file not found.",
            )

    media_type = (
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        if filename.endswith(".xlsx")
        else "application/pdf"
    )
    return FileResponse(filepath, media_type=media_type, filename=filename)


@app.get("/api/v1/verify/{document_sha256}", tags=["Verification"])
async def verify_document_integrity(document_sha256: str):
    record = VERIFIED_DOCUMENTS.get(document_sha256)
    if not record:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Document hash not found. The document may be fraudulent or modified.",
        )
    return {
        "status": "VERIFIED_VALID",
        "certification": "This record matches the immutable court-certified log generated by Slicon Systems for Joshua R Hughes.",
        "record": record,
    }


# --- Biometrics ---

@app.post("/api/v1/biometrics/verify-face", response_model=BiometricVerificationResponse, tags=["Biometrics"])
async def verify_face(request: BiometricVerificationRequest):
    result = verify_face_biometrics(
        tracked_user_id=request.tracked_user_id,
        reference_image_url=request.reference_image_url,
        checkin_image_url=request.checkin_image_url,
    )
    return BiometricVerificationResponse(
        is_match=result["is_match"],
        similarity_score=result["similarity_score"],
        confidence_level=result["confidence_level"],
        liveness_confirmed=result["liveness_confirmed"],
    )


# --- Legal Cases ---

@app.get("/api/v1/cases", response_model=List[LegalCase], tags=["Cases"])
async def list_cases():
    return list(CASES_DB.values())


@app.get("/api/v1/cases/{case_id}", response_model=LegalCase, tags=["Cases"])
async def get_case(case_id: str):
    case = CASES_DB.get(case_id)
    if not case:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Case {case_id} not found",
        )
    return case


@app.post("/api/v1/cases", response_model=LegalCase, status_code=status.HTTP_201_CREATED, tags=["Cases"])
async def create_case(case: LegalCase):
    if case.case_id in CASES_DB:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Case ID already exists",
        )
    CASES_DB[case.case_id] = case
    return case


# --- Telemetry & Tracking ---

@app.post("/api/v1/telemetry/log", response_model=TelemetryLog, status_code=status.HTTP_201_CREATED, tags=["Telemetry"])
async def ingest_telemetry_point(log: TelemetryLog):
    TELEMETRY_LOGS_DB.insert(0, log)
    return log


@app.get("/api/v1/telemetry/history", response_model=List[TelemetryLog], tags=["Telemetry"])
async def get_telemetry_history(case_id: Optional[str] = None, limit: int = 50):
    if case_id:
        return [l for l in TELEMETRY_LOGS_DB if l.case_id == case_id][:limit]
    return TELEMETRY_LOGS_DB[:limit]


# --- Offline Batch Sync ---

@app.post("/api/v1/sync/batch", response_model=BatchSyncResponse, tags=["Sync"])
async def batch_sync_telemetry(payload: BatchSyncRequest):
    receipt_id = f"sync_{uuid.uuid4().hex[:10]}"
    synced_count = len(payload.items)
    return BatchSyncResponse(
        status="success",
        synced_count=synced_count,
        failed_count=0,
        batch_receipt_id=receipt_id,
        synced_at=datetime.now(timezone.utc).isoformat(),
    )


# --- Emergency SOS ---

@app.post("/api/v1/sos/alert", response_model=SosAlertResponse, status_code=status.HTTP_201_CREATED, tags=["SOS"])
async def dispatch_sos_alert(alert: SosAlertRequest):
    alert_id = f"sos_{uuid.uuid4().hex[:8]}"
    return SosAlertResponse(
        status="dispatched",
        alert_id=alert_id,
        dispatched_to=[
            "Joshua R. Hughes, Esq. (Defense Counsel)",
            "Pretrial Services Dispatch",
            "Emergency Contact (Primary)",
        ],
        timestamp=datetime.now(timezone.utc).isoformat(),
    )


# --- User Profiles ---

@app.get("/api/v1/profile", response_model=UserProfile, tags=["Profile"])
async def get_profile(user_id: Optional[str] = "usr_98234"):
    profile = PROFILES_DB.get(user_id or "usr_98234")
    if not profile:
        profile = PROFILES_DB["usr_98234"]
    return profile


@app.put("/api/v1/profile", response_model=UserProfile, tags=["Profile"])
async def update_profile(profile_data: UserProfile):
    PROFILES_DB[profile_data.user_id] = profile_data
    return profile_data


# --- AI Compliance Check ---

@app.post("/api/v1/ai/compliance-check", response_model=ComplianceCheckResponse, tags=["AI Compliance"])
async def check_compliance(request: ComplianceCheckRequest):
    violations = []
    points = request.telemetry_points
    score = 100.0

    for idx, pt in enumerate(points):
        # Inspect for mock location
        if pt.get("is_mock_provider", False):
            violations.append({
                "type": "MOCK_LOCATION_DETECTED",
                "index": idx,
                "timestamp": pt.get("timestamp", datetime.now(timezone.utc).isoformat()),
                "severity": "CRITICAL",
                "details": "Mock GPS provider flag active on device telemetry.",
            })
            score = max(0.0, score - 25.0)

        # Inspect for low accuracy / potential GPS jamming
        if pt.get("accuracy_meters", 5.0) > 65.0:
            violations.append({
                "type": "GPS_DEGRADATION",
                "index": idx,
                "timestamp": pt.get("timestamp", datetime.now(timezone.utc).isoformat()),
                "severity": "WARNING",
                "details": f"GPS accuracy degraded to {pt.get('accuracy_meters')}m (exceeds 65m threshold).",
            })
            score = max(0.0, score - 5.0)

    overall_status = "COMPLIANT" if not violations else ("WARNING" if score >= 85.0 else "VIOLATION_DETECTED")

    return ComplianceCheckResponse(
        case_id=request.case_id,
        overall_status=overall_status,
        compliance_score=score,
        violations=violations,
        inspected_at=datetime.now(timezone.utc).isoformat(),
    )
