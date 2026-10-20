import type { ApplyLegalHoldInput, LegalHold, LegalHoldStats } from "@/types/legalHold";
import { apiRequest } from "./apiClient";
import { caseService } from "./caseService";
import { dbList, dbGet, dbSet, INITIAL_LEGAL_HOLDS } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;
const today = () => new Date().toISOString().slice(0, 10);

export const legalHoldService = {
  async list(): Promise<LegalHold[]> {
    if (!USE_MOCK) return apiRequest<LegalHold[]>("/legal-holds");
    return dbList<LegalHold>("legal_holds", INITIAL_LEGAL_HOLDS);
  },

  async stats(): Promise<LegalHoldStats> {
    if (!USE_MOCK) return apiRequest<LegalHoldStats>("/legal-holds/stats");
    const holds = await dbList<LegalHold>("legal_holds", INITIAL_LEGAL_HOLDS as LegalHold[]);
    return {
      active: holds.filter((h) => h.status === "active").length,
      lifted: holds.filter((h) => h.status === "lifted").length,
      totalRecords: holds.length,
    };
  },


  async apply(input: ApplyLegalHoldInput, actor = "admin@securetrack.io"): Promise<LegalHold> {
    if (!USE_MOCK) return apiRequest<LegalHold>("/legal-holds", { method: "POST", body: JSON.stringify({ ...input, actor }) });
    const c = await caseService.get(input.caseId);
    const hold: LegalHold = {
      id: `h${Date.now()}`,
      caseId: input.caseId,
      caseNumber: c.number,
      title: c.title,
      authorization: input.authorization.trim(),
      reason: input.reason.trim(),
      status: "active",
      appliedAt: today(),
      appliedBy: actor,
      history: [
        { action: "Legal hold applied", actor, date: today() },
        { action: "Audit log entry created", actor: "system", date: today() },
      ],
    };
    await dbSet("legal_holds", hold.id, hold);
    await caseService.setLegalHold(input.caseId, true);
    return hold;
  },

  async lift(id: string, reason?: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/legal-holds/${id}/lift`, { method: "POST", body: JSON.stringify({ reason }) });
      return;
    }
    const hold = await dbGet<LegalHold>("legal_holds", id);
    if (!hold) return;
    const history = [...hold.history, { action: reason ? `Legal hold lifted: ${reason}` : "Legal hold lifted", actor: "admin@securetrack.io", date: today() }];
    await dbSet("legal_holds", id, { status: "lifted", history });
    await caseService.setLegalHold(hold.caseId, false);
  },
};
