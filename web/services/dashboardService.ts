import type { DashboardOverview } from "@/types/dashboard";
import { apiRequest } from "./apiClient";
import { dbList, INITIAL_USERS, INITIAL_CASES, INITIAL_FAILURES, INITIAL_AUDIT } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

export const dashboardService = {
  async getOverview(): Promise<DashboardOverview> {
    if (!USE_MOCK) return apiRequest<DashboardOverview>("/dashboard/overview");

    const users = await dbList<any>("users", INITIAL_USERS);
    const cases = await dbList<any>("cases", INITIAL_CASES);
    const failures = await dbList<any>("sync_failures", INITIAL_FAILURES);
    const audit = await dbList<any>("audit_logs", INITIAL_AUDIT);

    const trackedUsersCount = users.filter((u: any) => u.role === "tracked_user" || !u.role).length;
    const authorizedViewersCount = users.filter((u: any) => u.role === "authorized_viewer").length;
    const activeSessionsCount = users.filter((u: any) => u.status === "active").length;
    const failedSyncsCount = failures.filter((f: any) => f.status === "failed").length;

    return {
      stats: [
        { id: "trackedUsers", label: "Total Tracked Users", value: trackedUsersCount || 1247, change: "+12.5%", trend: "positive", direction: "up" },
        { id: "authorizedViewers", label: "Authorized Viewers", value: authorizedViewersCount || 342, change: "+8.2%", trend: "positive", direction: "up" },
        { id: "activeSessions", label: "Active Sessions", value: activeSessionsCount || 89, change: "-3.1%", trend: "negative", direction: "down" },
        { id: "failedSyncs", label: "Failed Syncs", value: failedSyncsCount || 12, change: "+2", trend: "negative", direction: "down" },
      ],
      trackingActivity: [
        { label: "Mon", value: 46 },
        { label: "Tue", value: 53 },
        { label: "Wed", value: 38 },
        { label: "Thu", value: 62 },
        { label: "Fri", value: 52 },
        { label: "Sat", value: 29 },
        { label: "Sun", value: 33 },
      ],
      exportActivity: [
        { label: "Jan", value: 24 },
        { label: "Feb", value: 31 },
        { label: "Mar", value: 45 },
        { label: "Apr", value: 38 },
        { label: "May", value: 52 },
      ],
      activityFeed: [
        { id: "a1", type: "export", title: "Spreadsheet export completed", actor: "lisa.anderson@company.com", time: "Just now" },
        { id: "a2", type: "security", title: "VPN detected for tracked user session", actor: "unknown", severity: "critical", time: "Just now" },
        { id: "a3", type: "sync", title: "Sync failure: GPS signal lost", actor: "tom.harris@company.com", severity: "warning", time: "Just now" },
        { id: "a4", type: "login", title: "Successful login from San Francisco, CA", actor: "admin@securetrack.io", time: "Just now" },
      ],
      systemHealth: [
        { name: "GPS Tracking Service", status: "operational" },
        { name: "Sync Engine", status: failedSyncsCount > 5 ? "degraded" : "operational", detail: `${failedSyncsCount} failures` },
        { name: "Export Service", status: "operational" },
        { name: "Authentication API", status: "operational" },
        { name: "Audit Logger", status: "operational" },
        { name: "Alert System", status: "operational" },
      ],
      openCases: cases.slice(0, 4).map((c: any) => ({
        id: c.id,
        title: c.title,
        caseNumber: c.number || c.caseNumber || "CASE-2026",
        status: c.status || "active",
        onHold: !!c.legalHold,
      })),
      escalations: [
        { id: "e1", title: "GPS manipulation flags — Johnathan Vance", priority: "critical", status: "under-review" },
        { id: "e2", title: "Court order CO-2026-0842 — statutory preservation active", priority: "high", status: "open" },
        { id: "e3", title: "Curfew compliance monitoring — Marcus Sterling", priority: "high", status: "open" },
      ],
      recentAudit: audit.slice(0, 5).map((l: any, i: number) => ({
        id: l.id || `l${i + 1}`,
        event: l.event || "Audit Log Event",
        user: typeof l.user === "string" ? l.user : l.user?.name || "admin@securetrack.io",
        category: l.category || "Security",
        time: l.time || "Recently",
        status: l.status || "success",
      })),
    };
  },
};

