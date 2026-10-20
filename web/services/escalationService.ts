import type { Escalation, EscalationAction, EscalationListQuery, EscalationSeverity, EscalationStats } from "@/types/escalation";
import { apiRequest } from "./apiClient";
import { dbList, dbGet, dbSet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const initialEscalations: Escalation[] = [
  {
    id: "esc1",
    category: "security",
    severity: "critical",
    status: "under_review",
    description: "Multiple anti-spoofing flags detected within 48-hour window. Possible GPS manipulation.",
    related: "j.vance@example.com",
    createdAt: "2026-10-05",
    assignedTo: "admin@securetrack.io",
    history: [
      { action: "Initial flag raised by security system", actor: "System", date: "2026-10-05" },
      { action: "Escalation created by administrator", actor: "admin@securetrack.io", date: "2026-10-05" },
      { action: "Under investigation", actor: "admin@securetrack.io", date: "2026-10-06" },
    ],
  },
  {
    id: "esc2",
    category: "legal",
    severity: "high",
    status: "open",
    description: "Court order received requiring immediate location data export for ongoing proceedings.",
    related: "CASE-2025-001",
    createdAt: "2026-10-04",
    assignedTo: "admin@securetrack.io",
    history: [{ action: "Escalation created by administrator", actor: "admin@securetrack.io", date: "2026-10-04" }],
  },
  {
    id: "esc3",
    category: "compliance",
    severity: "high",
    status: "open",
    description: "3 consecutive missed check-ins. Compliance violation per monitoring agreement.",
    related: "m.sterling@example.com",
    createdAt: "2026-10-03",
    assignedTo: "admin@securetrack.io",
    history: [{ action: "Initial flag raised by check-in monitor", actor: "System", date: "2026-10-03" }],
  },
  {
    id: "esc4",
    category: "permission",
    severity: "medium",
    status: "resolved",
    description: "Unauthorized export attempt by Authorized Viewer — access reviewed and corrected.",
    related: "CASE-2025-003",
    createdAt: "2026-09-28",
    assignedTo: "admin@securetrack.io",
    history: [
      { action: "Export blocked by policy", actor: "System", date: "2026-09-28" },
      { action: "Access reviewed and corrected", actor: "admin@securetrack.io", date: "2026-09-29" },
    ],
  },
  {
    id: "esc5",
    category: "technical",
    severity: "medium",
    status: "resolved",
    description: "Persistent sync failures affecting 12 devices. Root cause: certificate expiration.",
    related: "Sync Engine",
    createdAt: "2026-09-25",
    assignedTo: "admin@securetrack.io",
    history: [
      { action: "Sync failure threshold exceeded", actor: "System", date: "2026-09-25" },
      { action: "Certificate renewed, devices re-synced", actor: "admin@securetrack.io", date: "2026-09-26" },
    ],
  },
];

const today = () => new Date().toISOString().slice(0, 10);
const RAISE: Record<EscalationSeverity, EscalationSeverity> = { medium: "high", high: "critical", critical: "critical" };

export const escalationService = {
  async list({ search = "", status = "all" }: EscalationListQuery = {}): Promise<Escalation[]> {
    if (!USE_MOCK) {
      const p = new URLSearchParams();
      if (search.trim()) p.set("search", search.trim());
      if (status !== "all") p.set("status", status);
      const qs = p.toString();
      return apiRequest(`/escalations${qs ? `?${qs}` : ""}`);
    }
    const s = search.trim().toLowerCase();
    const escalations = await dbList<Escalation>("escalations", initialEscalations);
    return escalations.filter(
      (e) => (status === "all" || e.status === status) && (!s || `${e.description} ${e.related} ${e.category}`.toLowerCase().includes(s)),
    );
  },

  async stats(): Promise<EscalationStats> {
    if (!USE_MOCK) return apiRequest("/escalations/stats");
    const escalations = await dbList<Escalation>("escalations", initialEscalations);
    const count = (f: (e: Escalation) => boolean) => escalations.filter(f).length;
    return {
      open: count((e) => e.status === "open"),
      underReview: count((e) => e.status === "under_review"),
      resolved: count((e) => e.status === "resolved"),
      critical: count((e) => e.severity === "critical" && e.status !== "resolved"),
    };
  },

  /** Flag → moves to Under Review; Escalate → raises severity one level; Resolve → closes it. */
  async act(id: string, action: EscalationAction, actor: string): Promise<Escalation> {
    if (!USE_MOCK) return apiRequest(`/escalations/${id}/${action}`, { method: "POST" });
    const e = await dbGet<Escalation>("escalations", id);
    if (!e) throw new Error("Escalation not found");
    const next: Escalation =
      action === "flag"
        ? { ...e, status: "under_review", history: [...e.history, { action: "Flagged for review", actor, date: today() }] }
        : action === "escalate"
          ? { ...e, severity: RAISE[e.severity], history: [...e.history, { action: `Escalated to ${RAISE[e.severity]} severity`, actor, date: today() }] }
          : { ...e, status: "resolved", history: [...e.history, { action: "Resolved", actor, date: today() }] };
    await dbSet<Escalation>("escalations", id, next);
    return next;
  },
};

