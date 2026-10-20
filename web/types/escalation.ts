export type EscalationCategory = "security" | "legal" | "compliance" | "permission" | "technical";
export type EscalationSeverity = "medium" | "high" | "critical";
export type EscalationStatus = "open" | "under_review" | "resolved";
export type EscalationAction = "flag" | "escalate" | "resolve";

export interface EscalationEvent {
  action: string;
  actor: string;
  date: string; // YYYY-MM-DD
}

export interface Escalation {
  id: string;
  category: EscalationCategory;
  severity: EscalationSeverity;
  status: EscalationStatus;
  description: string;
  /** User email, case number or system component. */
  related: string;
  createdAt: string; // YYYY-MM-DD
  assignedTo: string;
  history: EscalationEvent[];
}

export interface EscalationStats {
  open: number;
  underReview: number;
  resolved: number;
  critical: number;
}

export interface EscalationListQuery {
  search?: string;
  status?: EscalationStatus | "all";
}

export const ESCALATION_CATEGORY_LABELS: Record<EscalationCategory, string> = {
  security: "Security",
  legal: "Legal",
  compliance: "Compliance",
  permission: "Permission",
  technical: "Technical",
};

export const ESCALATION_SEVERITY_LABELS: Record<EscalationSeverity, string> = {
  medium: "Medium",
  high: "High",
  critical: "Critical",
};

export const ESCALATION_STATUS_LABELS: Record<EscalationStatus, string> = {
  open: "Open",
  under_review: "Under Review",
  resolved: "Resolved",
};
