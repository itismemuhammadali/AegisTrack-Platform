import type { AuditLogEntry, AuditLogQuery, AuditStats } from "@/types/auditLog";
import { apiRequest } from "./apiClient";
import { dbList } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

type Row = [string, string, string, string, AuditLogEntry["type"], AuditLogEntry["severity"], string, string];
const rows: Row[] = [
  ["14:23:15", "Admin User", "Admin", "PDF Export Generated", "export", "info", "Chrome - MacOS", "192.168.1.100"],
  ["14:15:42", "Sarah Johnson", "Viewer", "Login Successful", "login", "info", "Safari - iOS", "192.168.1.45"],
  ["14:12:10", "Unknown", "N/A", "Failed Login Attempt", "login_fail", "warning", "Chrome - Linux", "203.0.113.45"],
  ["14:10:30", "John Smith", "Tracked User", "Screenshot Captured", "screenshot", "info", "Mobile App - iOS", "192.168.1.78"],
  ["14:08:00", "Unknown", "N/A", "Unauthorized Access Attempt", "security", "critical", "Firefox - Linux", "185.234.12.5"],
  ["14:05:18", "Mike Wilson", "Tracked User", "Location Sync Failed", "sync", "warning", "Mobile App - Android", "192.168.1.92"],
  ["13:58:00", "Admin User", "Admin", "User Account Disabled", "account", "info", "Chrome - MacOS", "192.168.1.100"],
  ["13:50:22", "Admin User", "Admin", "Permission Changed", "permission", "info", "Chrome - MacOS", "192.168.1.100"],
  ["13:45:10", "Admin User", "Admin", "User Created", "admin", "info", "Chrome - MacOS", "192.168.1.100"],
  ["13:40:00", "Emma Davis", "Admin", "Spreadsheet Export", "export", "info", "Chrome - Windows", "192.168.1.55"],
  ["13:35:00", "Unknown", "N/A", "Failed Login Attempt", "login_fail", "critical", "Tor Browser", "10.0.0.1"],
  ["13:20:00", "Robert Brown", "Tracked User", "Airplane Mode Detected", "security", "warning", "Mobile App - iOS", "192.168.1.34"],
  ["13:10:00", "Admin User", "Admin", "User Password Reset", "admin", "info", "Chrome - MacOS", "192.168.1.100"],
  ["12:55:00", "Lisa Anderson", "Viewer", "Login Successful", "login", "info", "Chrome - Windows", "192.168.1.22"],
  ["12:40:00", "Admin User", "Admin", "Viewer Access Revoked", "permission", "info", "Chrome - MacOS", "192.168.1.100"],
];

const mockLogs: AuditLogEntry[] = rows.map(([time, name, role, event, type, severity, device, ip], i) => ({
  id: `a${i + 1}`,
  timestamp: `2026-10-07 ${time}`,
  user: { name, role },
  event,
  type,
  severity,
  device,
  ip,
}));

function toQueryString(q: AuditLogQuery) {
  const p = new URLSearchParams();
  if (q.search?.trim()) p.set("search", q.search.trim());
  if (q.type && q.type !== "all") p.set("type", q.type);
  if (q.severity && q.severity !== "all") p.set("severity", q.severity);
  if (q.from) p.set("from", q.from);
  if (q.to) p.set("to", q.to);
  const s = p.toString();
  return s ? `?${s}` : "";
}

export const auditLogService = {
  async list(q: AuditLogQuery = {}): Promise<AuditLogEntry[]> {
    if (!USE_MOCK) return apiRequest(`/audit-logs${toQueryString(q)}`);
    const logs = await dbList<AuditLogEntry>("audit_logs", mockLogs);
    const s = q.search?.trim().toLowerCase();
    return logs.filter((l) => {
      const day = (l.timestamp || "2026-10-07").slice(0, 10);
      const userName = typeof l.user === "object" ? l.user?.name || "" : String(l.user || "");
      return (
        (!q.type || q.type === "all" || l.type === q.type) &&
        (!q.severity || q.severity === "all" || l.severity === q.severity) &&
        (!q.from || day >= q.from) &&
        (!q.to || day <= q.to) &&
        (!s || [userName, l.event || "", l.ip || ""].some((v) => v.toLowerCase().includes(s)))
      );
    });
  },

  async stats(): Promise<AuditStats> {
    if (!USE_MOCK) return apiRequest("/audit-logs/stats");
    const logs = await dbList<AuditLogEntry>("audit_logs", mockLogs);
    const n = (...types: AuditLogEntry["type"][]) => logs.filter((l) => types.includes(l.type)).length;
    return {
      export: n("export"),
      login: n("login"),
      screenshot: n("screenshot"),
      security: n("security", "login_fail"),
      sync: n("sync"),
      permission: n("permission"),
      admin: n("admin"),
    };
  },
};

