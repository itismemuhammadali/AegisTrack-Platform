export type SyncStatus = "success" | "failed";
export type SignalStrength = "strong" | "medium" | "weak";

export interface TrackingSync {
  id: string;
  user: { id: string; name: string; avatarUrl?: string };
  location: string;
  syncTime: string;
  status: SyncStatus;
  device: string;
  signal: SignalStrength;
}

/** Full record behind the "Activity Details" dialog. */
export interface TrackingSyncDetail extends TrackingSync {
  /** e.g. "37.7749° N, 122.4194° W" */
  coordinates: string;
  /** Absolute timestamp, e.g. "May 18, 2026 2:30 PM" */
  syncedAt: string;
  os: string;
  batteryLevel: number;
  /** Metres */
  gpsAccuracy: number;
  /** km/h */
  speed: number;
  /** Metres */
  altitude: number;
}

export interface TrackingStats {
  total: number;
  successful: number;
  failed: number;
  onlineUsers: number;
}

export const SYNC_STATUS_LABELS: Record<SyncStatus, string> = { success: "Success", failed: "Failed" };
export const SIGNAL_LABELS: Record<SignalStrength, string> = { strong: "Strong", medium: "Medium", weak: "Weak" };
