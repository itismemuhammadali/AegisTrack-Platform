import type { CaseDetail, CaseRecord, CaseStats, CaseStatusFilter, CreateCaseInput } from "@/types/case";
import { apiRequest } from "./apiClient";
import { dbList, dbGet, dbSet, INITIAL_CASES } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const mockExtras: Record<string, any> = {
  c1: {
    courtOrder: "CO-2026-0842",
    description: "Court-ordered 24/7 GPS location logging for parole compliance verification.",
    timeline: [
      { id: "t1", kind: "zone", label: "Zone entry — Downtown Safe Zone", time: "Today 14:23" },
      { id: "t2", kind: "check-in", label: "Check-in verified — Morning", time: "Today 11:04" },
      { id: "t3", kind: "location-log", label: "Location log — 247 records synced", time: "Yesterday 18:30" },
      { id: "t4", kind: "check-in", label: "Check-in verified — Morning", time: "Yesterday 09:00" },
      { id: "t5", kind: "flag", label: "Security flag — VPN detected", time: "3 days ago" },
    ],
  },
};

const MOCK_ASSIGNABLE = ["Johnathan Vance", "Marcus Sterling", "Elena Rostova", "Sarah Johnson", "Emma Davis"];

export interface CaseListQuery {
  search?: string;
  status?: CaseStatusFilter;
}

export const caseService = {
  async list({ search = "", status = "all" }: CaseListQuery = {}): Promise<CaseRecord[]> {
    if (!USE_MOCK) {
      const p = new URLSearchParams();
      if (search.trim()) p.set("search", search.trim());
      if (status !== "all") p.set("status", status);
      const qs = p.toString();
      return apiRequest(`/cases${qs ? `?${qs}` : ""}`);
    }
    const all = await dbList<CaseRecord>("cases", INITIAL_CASES as unknown as CaseRecord[]);
    const s = search.trim().toLowerCase();
    return all.filter(
      (c) =>
        (status === "all" || c.status === status) &&
        (!s || c.title.toLowerCase().includes(s) || c.number.toLowerCase().includes(s)),
    );
  },

  async stats(): Promise<CaseStats> {
    if (!USE_MOCK) return apiRequest("/cases/stats");
    const all = await dbList<CaseRecord>("cases", INITIAL_CASES as unknown as CaseRecord[]);
    return {
      open: all.filter((c) => c.status === "active" || c.status === "open").length,
      legalHolds: all.filter((c) => c.legalHold).length,
      pendingReview: all.filter((c) => c.status === "pending").length,
      total: all.length,
    };
  },

  async close(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/cases/${id}/close`, { method: "POST" });
      return;
    }
    await dbSet("cases", id, { status: "closed" });
  },

  async get(id: string): Promise<CaseDetail> {
    if (!USE_MOCK) return apiRequest(`/cases/${id}`);
    const record = await dbGet<CaseRecord>("cases", id);
    if (!record) throw new Error("Case not found");
    const members = (record.assignedUsers || []).map((name) => ({ name, role: "Tracked User", status: "active" as const }));
    return { ...record, members, ...(mockExtras[id] ?? { description: "", timeline: [] }) };
  },

  async assignableUsers(): Promise<string[]> {
    if (!USE_MOCK) return apiRequest("/cases/assignable-users");
    return MOCK_ASSIGNABLE;
  },

  async create(input: CreateCaseInput): Promise<CaseRecord> {
    if (!USE_MOCK) return apiRequest("/cases", { method: "POST", body: JSON.stringify(input) });
    const number = input.number.trim();
    const all = await dbList<CaseRecord>("cases", INITIAL_CASES as unknown as CaseRecord[]);
    if (all.some((c) => c.number.toLowerCase() === number.toLowerCase())) throw new Error(`${number} already exists`);
    const record: CaseRecord = {
      id: `c${Date.now()}`,
      title: input.title.trim(),
      number,
      assignedUsers: input.assignedUsers,
      status: "active",
      createdAt: new Date().toISOString().slice(0, 10),
      legalHold: false,
    };
    await dbSet("cases", record.id, record);
    return record;
  },

  async setLegalHold(id: string, legalHold: boolean): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/cases/${id}/legal-hold`, { method: "POST", body: JSON.stringify({ legalHold }) });
      return;
    }
    await dbSet("cases", id, { legalHold });
  },
};
