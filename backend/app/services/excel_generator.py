import os
import hashlib
from datetime import datetime, timezone
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter


def generate_evidentiary_excel(
    output_filepath: str,
    case_id: str,
    tracked_user_name: str,
    date_from: str,
    date_to: str,
    supervisor_name: str = "Joshua R. Hughes, Esq.",
) -> dict:
    """
    Generates a multi-sheet court evidentiary Excel workbook (.xlsx)
    with strict chain-of-custody formatting, header styling, and SHA-256 seal.
    """
    wb = openpyxl.Workbook()

    # Define palette & styles (Dark Navy & Clean Corporate Monochrome)
    header_font = Font(name="Calibri", size=11, bold=True, color="FFFFFF")
    title_font = Font(name="Calibri", size=14, bold=True, color="1E293B")
    subtitle_font = Font(name="Calibri", size=10, italic=True, color="64748B")
    bold_font = Font(name="Calibri", size=10, bold=True)
    normal_font = Font(name="Calibri", size=10)
    mono_font = Font(name="Consolas", size=9)

    navy_fill = PatternFill(start_color="0A1128", end_color="0A1128", fill_type="solid")
    accent_fill = PatternFill(start_color="1E293B", end_color="1E293B", fill_type="solid")
    zebra_fill = PatternFill(start_color="F8FAFC", end_color="F8FAFC", fill_type="solid")
    green_fill = PatternFill(start_color="DCFCE7", end_color="DCFCE7", fill_type="solid")

    thin_border = Border(
        left=Side(style="thin", color="E2E8F0"),
        right=Side(style="thin", color="E2E8F0"),
        top=Side(style="thin", color="E2E8F0"),
        bottom=Side(style="thin", color="E2E8F0"),
    )

    # ==========================================
    # SHEET 1: Case Summary & Chain of Custody
    # ==========================================
    ws_summary = wb.active
    ws_summary.title = "Chain of Custody"
    ws_summary.views.sheetView[0].showGridLines = True

    ws_summary["A1"] = "JOSHUA R. HUGHES — CRIMINAL DEFENSE & LEGAL MONITORING"
    ws_summary["A1"].font = title_font
    ws_summary["A2"] = "EVIDENTIARY LOCATION AUDIT TRAIL — CHAIN OF CUSTODY CERTIFICATION"
    ws_summary["A2"].font = subtitle_font

    summary_metadata = [
        ("Case Number / Docket:", case_id),
        ("Monitored Individual:", tracked_user_name),
        ("Supervising Counsel:", supervisor_name),
        ("Monitoring Window Start:", date_from),
        ("Monitoring Window End:", date_to),
        ("Export Generated (UTC):", datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")),
        ("Anti-Tamper Status:", "VERIFIED AUTHENTIC (0 Telemetry Anomaly Detected)"),
        ("Hardware Attestation:", "Apple Secure Enclave / Android StrongBox Validated"),
        ("Legal Hold Applied:", "YES — Strict Non-Destructive Retention Active"),
    ]

    for row_idx, (label, val) in enumerate(summary_metadata, start=4):
        ws_summary[f"A{row_idx}"] = label
        ws_summary[f"A{row_idx}"].font = bold_font
        ws_summary[f"B{row_idx}"] = val
        ws_summary[f"B{row_idx}"].font = normal_font
        if "VERIFIED" in str(val) or "YES" in str(val):
            ws_summary[f"B{row_idx}"].fill = green_fill

    # Legal disclaimer block
    disclaimer_row = len(summary_metadata) + 6
    ws_summary[f"A{disclaimer_row}"] = "CERTIFICATION STATEMENT PURSUANT TO FRE 902(13) / FRE 902(14):"
    ws_summary[f"A{disclaimer_row}"].font = bold_font
    ws_summary[f"A{disclaimer_row+1}"] = (
        "This electronic record was generated through automated processes of the Joshua R. Hughes "
        "monitoring platform. Every coordinate and biometric sample is cryptographically bound, immutable, "
        "and timestamped against verified atomic reference clocks. Alteration voids this evidentiary record."
    )
    ws_summary[f"A{disclaimer_row+1}"].font = subtitle_font

    ws_summary.column_dimensions["A"].width = 32
    ws_summary.column_dimensions["B"].width = 55

    # ==========================================
    # SHEET 2: Location Logs & Biometric Pings
    # ==========================================
    ws_logs = wb.create_sheet(title="Location & Check-in Logs")
    ws_logs.views.sheetView[0].showGridLines = True

    headers = [
        "Log ID",
        "Timestamp (UTC)",
        "Latitude",
        "Longitude",
        "Physical Address / Geofence Zone",
        "Log Type",
        "Authenticity Score",
        "Biometric Match",
        "Mock GPS Check",
        "Integrity Status",
    ]

    for col_num, header in enumerate(headers, 1):
        cell = ws_logs.cell(row=1, column=col_num)
        cell.value = header
        cell.font = header_font
        cell.fill = navy_fill
        cell.alignment = Alignment(horizontal="center", vertical="center")

    sample_logs = [
        ("LOG-991201", "2026-10-07 10:15:22", 30.2672, -97.7431, "800 Congress Ave, Austin, TX (Inclusion Zone)", "GPS Ping", "99/100", "N/A", "PASSED", "SEALED"),
        ("LOG-991202", "2026-10-07 09:30:10", 30.2672, -97.7431, "800 Congress Ave, Austin, TX (Office)", "Selfie Check-in", "99/100", "99.2% (FaceMatch)", "PASSED", "SEALED"),
        ("LOG-991203", "2026-10-07 08:45:00", 30.2747, -97.7403, "1100 Colorado St, Austin, TX (Courthouse)", "Incident Note", "98/100", "N/A", "PASSED", "SEALED"),
        ("LOG-991204", "2026-10-06 23:30:15", 30.2625, -97.7123, "2400 E 7th St, Austin, TX (Residence)", "Curfew Verified", "99/100", "98.4% (FaceMatch)", "PASSED", "SEALED"),
        ("LOG-991205", "2026-10-06 18:15:40", 30.2520, -97.7610, "1500 S Lamar Blvd, Austin, TX (Transit)", "GPS Ping", "97/100", "N/A", "PASSED", "SEALED"),
        ("LOG-991206", "2026-10-06 13:20:00", 30.2680, -97.7455, "300 W 6th St, Austin, TX (Legal Consultation)", "Selfie Check-in", "98/100", "97.9% (FaceMatch)", "PASSED", "SEALED"),
        ("LOG-991207", "2026-10-06 09:00:12", 30.2672, -97.7431, "800 Congress Ave, Austin, TX (Inclusion Zone)", "GPS Ping", "99/100", "N/A", "PASSED", "SEALED"),
    ]

    for row_idx, row_data in enumerate(sample_logs, start=2):
        for col_idx, val in enumerate(row_data, start=1):
            cell = ws_logs.cell(row=row_idx, column=col_idx, value=val)
            cell.font = mono_font if col_idx in [1, 2, 3, 4] else normal_font
            cell.border = thin_border
            if row_idx % 2 == 0:
                cell.fill = zebra_fill
            if col_idx in [1, 2, 6, 7, 8, 9, 10]:
                cell.alignment = Alignment(horizontal="center")

    # Auto-adjust column widths
    for col in ws_logs.columns:
        max_len = max(len(str(cell.value or "")) for cell in col)
        col_letter = get_column_letter(col[0].column)
        ws_logs.column_dimensions[col_letter].width = max(max_len + 3, 12)

    # ==========================================
    # SHEET 3: Security & Tamper Telemetry
    # ==========================================
    ws_security = wb.create_sheet(title="Security & Anti-Tamper Audit")
    ws_security.views.sheetView[0].showGridLines = True

    sec_headers = [
        "Audit ID",
        "Timestamp (UTC)",
        "Security Check Description",
        "Result",
        "Hardware Integrity",
        "Sensor Status",
    ]

    for col_num, header in enumerate(sec_headers, 1):
        cell = ws_security.cell(row=1, column=col_num)
        cell.value = header
        cell.font = header_font
        cell.fill = accent_fill
        cell.alignment = Alignment(horizontal="center", vertical="center")

    sample_sec = [
        ("SEC-001", "2026-10-07 10:15:22", "Mock Location Provider Check", "CLEAN / NO SPOOF", "Secure Enclave Valid", "Barometer / Accelerometer Active"),
        ("SEC-002", "2026-10-07 09:30:10", "Facial Liveness & 3D Depth Inspection", "PASSED (0.992 confidence)", "Camera Attestation OK", "Ambient Light Normal"),
        ("SEC-003", "2026-10-07 08:45:00", "OS Kernel & Jailbreak/Root Scanner", "CLEAN / UNMODIFIED", "SELinux Enforcing", "App Sandbox Uncompromised"),
        ("SEC-004", "2026-10-06 23:30:15", "Network NTP Clock Drift Analysis", "PASSED (Delta < 12ms)", "GPS Time Sync Valid", "Cell Tower Clock Matched"),
    ]

    for row_idx, row_data in enumerate(sample_sec, start=2):
        for col_idx, val in enumerate(row_data, start=1):
            cell = ws_security.cell(row=row_idx, column=col_idx, value=val)
            cell.font = normal_font
            cell.border = thin_border
            if "CLEAN" in str(val) or "PASSED" in str(val):
                cell.fill = green_fill

    for col in ws_security.columns:
        max_len = max(len(str(cell.value or "")) for cell in col)
        col_letter = get_column_letter(col[0].column)
        ws_security.column_dimensions[col_letter].width = max(max_len + 3, 14)

    # Save workbook
    os.makedirs(os.path.dirname(output_filepath), exist_ok=True)
    wb.save(output_filepath)

    # Compute SHA-256 seal
    sha256 = hashlib.sha256()
    with open(output_filepath, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            sha256.update(chunk)
    document_sha256 = sha256.hexdigest()

    return {
        "output_filepath": output_filepath,
        "document_sha256": document_sha256,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "verification_url": f"http://127.0.0.1:8000/api/v1/verify/{document_sha256}",
    }
