export type SecuritySeverity = "critical" | "high" | "medium" | "low";
export type SecurityEventStatus = "active" | "investigating" | "flagged" | "resolved";
export type SecurityEventType =
  | "vpn"
  | "failed_login"
  | "unusual_location"
  | "airplane_mode"
  | "proxy"
  | "unauthorized_access"
  | "power_cycling";

export interface SecurityEvent {
  id: string;
  type: SecurityEventType;
  title: string;
  userEmail: string; // "unknown" when unattributed
  userId?: string;
  location: string;
  time: string;
  severity: SecuritySeverity;
  status: SecurityEventStatus;
  ipAddress?: string;
}

export interface SecurityStats {
  critical: number;
  high: number;
  active: number;
  open: number;
  syncFailures: number;
}

export interface SecurityEventQuery {
  search?: string;
  severity?: SecuritySeverity | "all";
  status?: SecurityEventStatus | "all";
  type?: SecurityEventType | "all";
}

export const SEVERITY_LABELS: Record<SecuritySeverity, string> = { critical: "Critical", high: "High", medium: "Medium", low: "Low" };
export const EVENT_STATUS_LABELS: Record<SecurityEventStatus, string> = {
  active: "Active",
  investigating: "Investigating",
  flagged: "Flagged",
  resolved: "Resolved",
};
export const EVENT_TYPE_LABELS: Record<SecurityEventType, string> = {
  vpn: "VPN Usage",
  failed_login: "Failed Login",
  unusual_location: "Unusual Location",
  airplane_mode: "Airplane Mode",
  proxy: "Proxy Network",
  unauthorized_access: "Unauthorized Access",
  power_cycling: "Power Cycling",
};
