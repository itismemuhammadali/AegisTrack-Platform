export type SyncFailureStatus = "failed" | "pending" | "retrying" | "resolved";

export interface SyncFailure {
  id: string;
  user: { id: string; name: string; email: string };
  device: string;
  reason: string;
  errorCode: string;
  retries: number;
  time: string;
  status: SyncFailureStatus;
  dataLossRisk: boolean;
}

export type SyncFailureStats = Record<SyncFailureStatus, number>;

export const SYNC_STATUS_LABELS: Record<SyncFailureStatus, string> = {
  failed: "Failed",
  pending: "Pending",
  retrying: "Retrying",
  resolved: "Resolved",
};
