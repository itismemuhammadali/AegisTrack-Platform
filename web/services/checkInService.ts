import type { CheckInSchedule, CheckInScheduleDetail, CheckInScheduleInput, CheckInStats, CheckInStatus, TrackedUserOption } from "@/types/checkIn";
import { apiRequest } from "./apiClient";
import { dbList, dbGet, dbSet, dbDelete, INITIAL_SCHEDULES } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const u = (id: string, name: string, avatar: string) => ({ id, name, avatarUrl: `/images/avatars/${avatar}.png` });

const MOCK_TRACKED_USERS: TrackedUserOption[] = [
  u("u1", "Johnathan Vance", "john"),
  u("u3", "Marcus Sterling", "mike"),
  u("u5", "Elena Rostova", "emma"),
];

const mockExtras: Record<string, any> = {
  s1: {
    startsAt: "2026-06-01T09:00",
    reminderMinutes: 30,
    history: [
      { id: "h1", time: "Today 09:02 AM", detail: "Biometric + Selfie · San Francisco, CA", verified: true },
      { id: "h2", time: "Yesterday 09:05 AM", detail: "Biometric + Selfie · San Francisco, CA", verified: true },
    ],
  },
};

function displayTime(hhmm: string) {
  const [h, m] = hhmm.split(":").map(Number);
  return `${String(h % 12 || 12).padStart(2, "0")}:${String(m).padStart(2, "0")} ${h < 12 ? "AM" : "PM"}`;
}

function fromInput(input: CheckInScheduleInput) {
  const user = MOCK_TRACKED_USERS.find((t) => t.id === input.userId) || { id: input.userId, name: "Tracked Client" };
  return { user, name: input.name.trim(), methods: input.methods, frequency: input.frequency, time: displayTime(input.startsAt.slice(11, 16)) };
}

export const checkInService = {
  async list({ search = "", status = "all" }: { search?: string; status?: CheckInStatus | "all" } = {}): Promise<CheckInSchedule[]> {
    if (!USE_MOCK) {
      const p = new URLSearchParams();
      if (search.trim()) p.set("search", search.trim());
      if (status !== "all") p.set("status", status);
      const qs = p.toString();
      return apiRequest(`/check-ins${qs ? `?${qs}` : ""}`);
    }
    const all = await dbList<CheckInSchedule>("schedules", INITIAL_SCHEDULES);
    const s = search.trim().toLowerCase();
    return all.filter(
      (c) => (status === "all" || c.status === status) && (!s || c.user.name.toLowerCase().includes(s) || c.name.toLowerCase().includes(s)),
    );
  },

  async stats(): Promise<CheckInStats> {
    if (!USE_MOCK) return apiRequest("/check-ins/stats");
    const all = await dbList<CheckInSchedule>("schedules", INITIAL_SCHEDULES);
    return {
      activeSchedules: all.filter((c) => c.status === "active").length,
      missedCheckIns: all.reduce((n, c) => n + c.missedCount, 0),
      dueToday: all.length,
      paused: all.filter((c) => c.status === "paused").length,
    };
  },

  async setStatus(id: string, status: CheckInStatus): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/check-ins/${id}`, { method: "PATCH", body: JSON.stringify({ status }) });
      return;
    }
    await dbSet("schedules", id, { status });
  },

  async get(id: string): Promise<CheckInScheduleDetail> {
    if (!USE_MOCK) return apiRequest(`/check-ins/${id}`);
    const sched = await dbGet<CheckInSchedule>("schedules", id);
    if (!sched) throw new Error("Schedule not found");
    const extra = mockExtras[id] ?? {
      startsAt: "2026-06-01T09:00",
      reminderMinutes: 30,
      history: [{ id: "h1", time: "Today", detail: "Verified Check-in", verified: true }],
    };
    return { ...sched, ...extra };
  },

  async trackedUsers(): Promise<TrackedUserOption[]> {
    if (!USE_MOCK) return apiRequest("/check-ins/tracked-users");
    return MOCK_TRACKED_USERS;
  },

  async create(input: CheckInScheduleInput): Promise<CheckInSchedule> {
    if (!USE_MOCK) return apiRequest("/check-ins", { method: "POST", body: JSON.stringify(input) });
    const parsed = fromInput(input);
    const newRecord: CheckInSchedule = {
      id: `s${Date.now()}`,
      ...parsed,
      status: "active",
      lastCheckIn: "Not yet checked in",
      missedCount: 0,
      nextCheckIn: parsed.time,
    };
    await dbSet("schedules", newRecord.id, newRecord);
    return newRecord;
  },

  async update(id: string, input: CheckInScheduleInput): Promise<CheckInSchedule> {
    if (!USE_MOCK) return apiRequest(`/check-ins/${id}`, { method: "PATCH", body: JSON.stringify(input) });
    const parsed = fromInput(input);
    const updated = await dbSet<CheckInSchedule>("schedules", id, parsed);
    return updated;
  },

  async sendPushReminder(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/check-ins/${id}/remind`, { method: "POST" });
      return;
    }
  },

  async sendReminder(id: string): Promise<void> {
    return this.sendPushReminder(id);
  },

  async remove(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/check-ins/${id}`, { method: "DELETE" });
      return;
    }
    await dbDelete("schedules", id);
  },
};
