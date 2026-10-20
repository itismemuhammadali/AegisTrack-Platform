export type CaseStatus = "active" | "open" | "pending" | "closed";
export type CaseStatusFilter = CaseStatus | "all";

export interface CaseRecord {
  id: string;
  title: string;
  number: string;
  assignedUsers: string[];
  status: CaseStatus;
  createdAt: string; // ISO date (YYYY-MM-DD)
  legalHold: boolean;
}

export interface CaseStats {
  open: number;
  legalHolds: number;
  pendingReview: number;
  total: number;
}

export const CASE_STATUS_LABELS: Record<CaseStatus, string> = {
  active: "Active",
  open: "Open",
  pending: "Pending",
  closed: "Closed",
};

export type CaseTimelineKind = "zone" | "check-in" | "location-log" | "flag";

export interface CaseTimelineEvent {
  id: string;
  kind: CaseTimelineKind;
  label: string;
  time: string;
}

export interface CaseMember {
  name: string;
  role: string; // display label, e.g. "Tracked User"
  status: "active" | "inactive";
}

export interface CaseDetail extends CaseRecord {
  members: CaseMember[];
  courtOrder?: string;
  description: string;
  supportingInfo?: string;
  timeline: CaseTimelineEvent[];
}

export interface CreateCaseInput {
  title: string;
  number: string;
  description: string;
  assignedUsers: string[];
  courtOrder?: string;
  supportingInfo?: string;
}
