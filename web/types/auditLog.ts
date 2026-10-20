export type AuditEventType = "export" | "login" | "login_fail" | "screenshot" | "security" | "sync" | "account" | "permission" | "admin";
export type AuditSeverity = "info" | "warning" | "critical";

export interface AuditLogEntry {
  id: string;
  timestamp: string; // "YYYY-MM-DD HH:mm:ss"
  user: { name: string; role: string };
  event: string;
  type: AuditEventType;
  severity: AuditSeverity;
  device: string;
  ip: string;
}

export interface AuditLogQuery {
  search?: string;
  type?: AuditEventType | "all";
  severity?: AuditSeverity | "all";
  from?: string; // YYYY-MM-DD
  to?: string;
}

/** Summary tiles in Figma order; `login_fail` rolls up into Security, `account` has no tile. */
export type AuditStatKey = "export" | "login" | "screenshot" | "security" | "sync" | "permission" | "admin";
export type AuditStats = Record<AuditStatKey, number>;

export const AUDIT_TYPE_LABELS: Record<AuditEventType, string> = {
  export: "Export",
  login: "Login",
  login_fail: "Login Fail",
  screenshot: "Screenshot",
  security: "Security",
  sync: "Sync",
  account: "Account",
  permission: "Permission",
  admin: "Admin",
};

export const AUDIT_SEVERITY_LABELS: Record<AuditSeverity, string> = { info: "Info", warning: "Warning", critical: "Critical" };
