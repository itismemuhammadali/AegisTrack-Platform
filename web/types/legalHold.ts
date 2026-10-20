export type LegalHoldStatus = "active" | "lifted";

export interface LegalHoldEvent {
  action: string;
  actor: string;
  date: string; // YYYY-MM-DD
}

export interface LegalHold {
  id: string;
  caseId: string;
  caseNumber: string;
  title: string;
  authorization: string;
  reason: string;
  status: LegalHoldStatus;
  appliedAt: string; // YYYY-MM-DD
  appliedBy: string;
  history: LegalHoldEvent[];
}

export interface LegalHoldStats {
  active: number;
  lifted: number;
  totalRecords: number;
}

export interface ApplyLegalHoldInput {
  caseId: string;
  reason: string;
  authorization: string;
}
