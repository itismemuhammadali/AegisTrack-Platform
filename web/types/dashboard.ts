export type Tone = "purple" | "cyan" | "green" | "red" | "yellow" | "orange" | "blue" | "neutral";

export interface StatMetric {
  id: "trackedUsers" | "authorizedViewers" | "activeSessions" | "failedSyncs";
  label: string;
  value: number;
  /** Display string, e.g. "+12.5%" or "+2". */
  change: string;
  /** Whether the change is good news (green) or bad news (red) — not simply its sign. */
  trend: "positive" | "negative";
  direction: "up" | "down";
}

export interface ChartPoint {
  label: string;
  value: number;
}

export type ActivityType = "export" | "security" | "sync" | "login" | "access" | "failed-login";
export type Severity = "critical" | "warning";

export interface ActivityEvent {
  id: string;
  type: ActivityType;
  title: string;
  actor: string;
  severity?: Severity;
  time: string;
}

export type ServiceStatus = "operational" | "degraded" | "down";

export interface ServiceHealth {
  name: string;
  status: ServiceStatus;
  /** Optional detail shown before the status, e.g. "12 failures". */
  detail?: string;
}

export type CaseStatus = "active" | "open" | "pending" | "closed";

export interface CaseSummary {
  id: string;
  title: string;
  caseNumber: string;
  status: CaseStatus;
  onHold: boolean;
}

export type EscalationPriority = "critical" | "high" | "medium";
export type EscalationStatus = "under-review" | "open" | "resolved";

export interface EscalationSummary {
  id: string;
  title: string;
  priority: EscalationPriority;
  status: EscalationStatus;
}

export interface AuditEvent {
  id: string;
  event: string;
  user: string;
  category: string;
  time: string;
  status: "success" | "failed";
}

export interface DashboardOverview {
  stats: StatMetric[];
  trackingActivity: ChartPoint[];
  exportActivity: ChartPoint[];
  activityFeed: ActivityEvent[];
  systemHealth: ServiceHealth[];
  openCases: CaseSummary[];
  escalations: EscalationSummary[];
  recentAudit: AuditEvent[];
}
