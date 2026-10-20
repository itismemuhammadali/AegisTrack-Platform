export type ReportTab = "user_activity" | "authentication" | "export_activity" | "security" | "sync_performance";
export type ReportFormat = "pdf" | "sheet" | "email";
export type ReportKind = ReportTab | "platform_usage";

export interface ReportKpi {
  key: "total" | "avg_export_time" | "this_month" | "success_rate";
  label: string;
  value: string;
  change: number; // percent, signed
}

export interface WeeklyActivityPoint { day: string; activeUsers: number; exports: number }
export interface AuthPoint { day: string; successful: number; failed: number }
export interface ExportPoint { day: string; exports: number }
export interface SecurityPoint { day: string; events: number }
export interface SyncPoint { day: string; success: number; failed: number; pending: number }
export interface RoleSlice { role: string; count: number }

export interface ReportsOverview {
  kpis: ReportKpi[];
  weeklyActivity: WeeklyActivityPoint[];
  roleDistribution: RoleSlice[];
  authentication: AuthPoint[];
  exportActivity: ExportPoint[];
  security: SecurityPoint[];
  syncPerformance: SyncPoint[];
}

export interface AvailableReport {
  kind: ReportKind;
  title: string;
  description: string;
  range: string;
}

export const REPORT_TAB_LABELS: Record<ReportTab, string> = {
  user_activity: "User Activity Report",
  authentication: "Authentication Report",
  export_activity: "Export Activity Report",
  security: "Security Report",
  sync_performance: "Sync Performance Report",
};

export const REPORT_FORMAT_LABELS: Record<ReportFormat, string> = { pdf: "PDF", sheet: "Sheet", email: "Email" };
