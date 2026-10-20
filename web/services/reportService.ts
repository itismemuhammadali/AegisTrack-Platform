import type { AvailableReport, ReportFormat, ReportKind, ReportsOverview } from "@/types/report";
import { apiRequest } from "./apiClient";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;
const DAYS = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
const zip = <T,>(f: (day: string, i: number) => T) => DAYS.map(f);

const MOCK_OVERVIEW: ReportsOverview = {
  kpis: [
    { key: "total", label: "Total Reports", value: "1,247", change: 15.3 },
    { key: "avg_export_time", label: "Avg Export Time", value: "2.4s", change: -8.2 },
    { key: "this_month", label: "This Month", value: "342", change: 22.1 },
    { key: "success_rate", label: "Success Rate", value: "98.4%", change: 1.2 },
  ],
  weeklyActivity: zip((day, i) => ({ day, activeUsers: [120, 155, 98, 178, 142, 65, 88][i], exports: [15, 22, 12, 28, 19, 8, 11][i] })),
  roleDistribution: [
    { role: "Tracked Users", count: 842 },
    { role: "Viewers", count: 342 },
    { role: "Admins", count: 63 },
  ],
  authentication: zip((day, i) => ({ day, successful: [118, 135, 98, 158, 134, 77, 89][i], failed: [3, 7, 2, 11, 6, 1, 3][i] })),
  exportActivity: zip((day, i) => ({ day, exports: [15, 22, 12, 28, 19, 8, 11][i] })),
  security: zip((day, i) => ({ day, events: [15, 22, 12, 28, 19, 8, 11][i] })),
  syncPerformance: zip((day, i) => ({ day, success: [318, 378, 268, 418, 356, 178, 218][i], failed: [22, 16, 30, 12, 20, 8, 10][i], pending: [12, 8, 14, 5, 9, 3, 6][i] })),
};

const AVAILABLE: AvailableReport[] = [
  { kind: "user_activity", title: "User Activity Report", description: "Complete user engagement summary", range: "Last 30 days" },
  { kind: "export_activity", title: "Export Activity Report", description: "All data exports with user and volume", range: "Last 7 days" },
  { kind: "authentication", title: "Authentication Report", description: "Login events, MFA, failed attempts", range: "Last 30 days" },
  { kind: "security", title: "Security Threat Report", description: "Suspicious activity and security events", range: "Last 30 days" },
  { kind: "sync_performance", title: "Sync Performance Report", description: "GPS sync success rates and failures", range: "Last 14 days" },
  { kind: "platform_usage", title: "Platform Usage Statistics", description: "Comprehensive platform analytics", range: "Last 90 days" },
];

const delay = (ms: number) => new Promise((r) => setTimeout(r, ms));

export const reportService = {
  async overview(): Promise<ReportsOverview> {
    if (!USE_MOCK) return apiRequest("/reports/overview");
    await delay(250);
    return MOCK_OVERVIEW;
  },

  async available(): Promise<AvailableReport[]> {
    if (!USE_MOCK) return apiRequest("/reports/available");
    return AVAILABLE;
  },

  /** Queues a report export; resolves with a download URL (pdf/sheet) or nothing (email). */
  async generate(kind: ReportKind, format: ReportFormat): Promise<{ downloadUrl?: string }> {
    if (!USE_MOCK) return apiRequest("/reports/generate", { method: "POST", body: JSON.stringify({ kind, format }) });
    await delay(900);
    return {};
  },
};
