import type { SecurityEvent, SecurityEventQuery, SecurityEventStatus, SecurityStats } from "@/types/security";
import { apiRequest } from "./apiClient";
import { syncFailureService } from "./syncFailureService";
import { dbList, dbSet, INITIAL_SECURITY } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

export const securityService = {
  async list({ search = "", severity = "all", status = "all", type = "all" }: SecurityEventQuery = {}): Promise<SecurityEvent[]> {
    if (!USE_MOCK) {
      const p = new URLSearchParams();
      if (search.trim()) p.set("search", search.trim());
      if (severity !== "all") p.set("severity", severity);
      if (status !== "all") p.set("status", status);
      if (type !== "all") p.set("type", type);
      const qs = p.toString();
      return apiRequest(`/security/events${qs ? `?${qs}` : ""}`);
    }
    const all = await dbList<SecurityEvent>("security", INITIAL_SECURITY);
    const s = search.trim().toLowerCase();
    return all.filter(
      (e) =>
        (severity === "all" || e.severity === severity) &&
        (status === "all" || e.status === status) &&
        (type === "all" || e.type === type) &&
        (!s || e.userEmail.toLowerCase().includes(s) || e.title.toLowerCase().includes(s)),
    );
  },

  async stats(): Promise<SecurityStats> {
    if (!USE_MOCK) return apiRequest("/security/stats");
    const all = await dbList<SecurityEvent>("security", INITIAL_SECURITY);
    const open = all.filter((e) => e.status !== "resolved");
    return {
      critical: open.filter((e) => e.severity === "critical").length,
      high: all.filter((e) => e.severity === "high").length,
      active: all.filter((e) => e.status === "active").length,
      open: open.length,
      syncFailures: (await syncFailureService.stats()).failed,
    };
  },

  async setStatus(id: string, status: SecurityEventStatus): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/security/events/${id}`, { method: "PATCH", body: JSON.stringify({ status }) });
      return;
    }
    await dbSet("security", id, { status });
  },

  async retryAllSyncFailures(): Promise<void> {
    await syncFailureService.retryAll();
  },
};
