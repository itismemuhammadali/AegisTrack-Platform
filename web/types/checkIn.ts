export type CheckInFrequency = "daily" | "weekly" | "custom";
export type CheckInStatus = "active" | "paused";
export type VerificationMethod = "biometric" | "selfie";

export interface CheckInSchedule {
  id: string;
  user: { id: string; name: string; avatarUrl?: string };
  name: string;
  methods: VerificationMethod[];
  time: string; // display, e.g. "09:00 AM"
  frequency: CheckInFrequency;
  status: CheckInStatus;
  lastCheckIn: string;
  missedCount: number;
  nextCheckIn: string;
}

export interface CheckInStats {
  activeSchedules: number;
  missedCheckIns: number;
  dueToday: number;
  paused: number;
}

export const CHECKIN_FREQUENCY_LABELS: Record<CheckInFrequency, string> = { daily: "Daily", weekly: "Weekly", custom: "Custom" };
export const CHECKIN_STATUS_LABELS: Record<CheckInStatus, string> = { active: "Active", paused: "Paused" };

export interface CheckInHistoryEntry {
  id: string;
  time: string; // display, e.g. "Today 09:02 AM"
  detail: string; // e.g. "Biometric + Selfie · New York, NY"
  verified: boolean;
}

export const REMINDER_OPTIONS = [
  { minutes: 0, label: "No reminder" },
  { minutes: 15, label: "15 minutes before" },
  { minutes: 30, label: "30 minutes before" },
  { minutes: 60, label: "1 hour before" },
  { minutes: 120, label: "2 hours before" },
] as const;

export interface CheckInScheduleDetail extends CheckInSchedule {
  startsAt: string; // local date-time, "YYYY-MM-DDTHH:mm"
  reminderMinutes: number;
  history: CheckInHistoryEntry[];
}

export interface CheckInScheduleInput {
  userId: string;
  name: string;
  startsAt: string;
  frequency: CheckInFrequency;
  methods: VerificationMethod[];
  reminderMinutes: number;
}

export interface TrackedUserOption {
  id: string;
  name: string;
  avatarUrl?: string;
}
