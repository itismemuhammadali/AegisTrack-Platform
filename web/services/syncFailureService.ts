import type { SyncFailure, SyncFailureStats, SyncFailureStatus } from "@/types/syncFailure";
import { apiRequest } from "./apiClient";
import { dbList, dbSet, INITIAL_FAILURES } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

export const syncFailureService = {
  async list({ search = "", status = "all" }: { search?: string; status?: SyncFailureStatus | "all" } = {}): Promise<SyncFailure[]> {
    if (!USE_MOCK) {
      const p = new URLSearchParams();
      if (search.trim()) p.set("search", search.trim());
      if (status !== "all") p.set("status", status);
      const qs = p.toString();
      return apiRequest(`/sync-failures${qs ? `?${qs}` : ""}`);
    }
    const all = await dbList<SyncFailure>("sync_failures", INITIAL_FAILURES);
    const s = search.trim().toLowerCase();
    return all.filter(
      (f) =>
        (status === "all" || f.status === status) &&
        (!s || [f.user.name, f.user.email, f.reason, f.errorCode].some((v) => v.toLowerCase().includes(s))),
    );
  },

  async stats(): Promise<SyncFailureStats> {
    if (!USE_MOCK) return apiRequest("/sync-failures/stats");
    const all = await dbList<SyncFailure>("sync_failures", INITIAL_FAILURES);
    const count = (s: SyncFailureStatus) => all.filter((f) => f.status === s).length;
    return { failed: count("failed"), pending: count("pending"), retrying: count("retrying"), resolved: count("resolved") };
  },

  async retry(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/sync-failures/${id}/retry`, { method: "POST" });
      return;
    }
    await dbSet("sync_failures", id, { status: "retrying", time: "Just now" });
  },

  async resolve(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/sync-failures/${id}/resolve`, { method: "POST" });
      return;
    }
    await dbSet("sync_failures", id, { status: "resolved", time: "Just now" });
  },

  async retryAll(): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest("/sync-failures/retry-all", { method: "POST" });
      return;
    }
    const all = await dbList<SyncFailure>("sync_failures", INITIAL_FAILURES);
    for (const f of all) {
      if (f.status === "failed" || f.status === "pending") {
        await dbSet("sync_failures", f.id, { status: "retrying", retries: f.retries + 1 });
      }
    }
  },
};
