export type ExportChannel = "pdf" | "spreadsheet" | "email";
export type ExportRole = "admin" | "authorized_viewer" | "tracked_user";
export type ExportActivityStatus = "success" | "blocked" | "pending_approval";

export interface ExportChannelSettings {
  channel: ExportChannel;
  /** Master switch — "Allowed" vs "Restricted". */
  enabled: boolean;
  requireApproval: boolean;
  auditAll: boolean;
  maxRecords: number;
  allowedRoles: ExportRole[];
}

export interface ExportActivity {
  id: string;
  channel: ExportChannel;
  user: string;
  /** null when the export never produced records (e.g. blocked). */
  records: number | null;
  time: string;
  status: ExportActivityStatus;
}

export interface ExportSettingsOverview {
  activeAssignments: number;
  channels: ExportChannelSettings[];
}

export const EXPORT_CHANNEL_META: Record<ExportChannel, { title: string; short: string; description: string }> = {
  pdf: { title: "PDF Export", short: "PDF", description: "Export tracking logs and reports as PDF documents" },
  spreadsheet: { title: "Spreadsheet Export", short: "Spreadsheet", description: "Export data as CSV or Excel spreadsheets" },
  email: { title: "Email Export", short: "Email", description: "Send export links or attachments via email" },
};

export const EXPORT_ROLE_LABELS: Record<ExportRole, string> = {
  admin: "Admin",
  authorized_viewer: "Authorized Viewer",
  tracked_user: "Tracked User",
};

export const EXPORT_STATUS_LABELS: Record<ExportActivityStatus, string> = {
  success: "Success",
  blocked: "Blocked",
  pending_approval: "Pending Approval",
};
