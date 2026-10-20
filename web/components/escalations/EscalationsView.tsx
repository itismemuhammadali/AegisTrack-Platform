"use client";

import { useEffect, useState } from "react";
import { Clock, Eye, Search, TriangleAlert } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { FilterSelect } from "@/components/ui/FilterSelect";
import { StatTile } from "@/components/ui/StatTile";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { escalationService } from "@/services/escalationService";
import { ESCALATION_STATUS_LABELS, type Escalation, type EscalationAction, type EscalationStatus } from "@/types/escalation";
import { CATEGORY_TONE, CategoryBadge, EscalationStatusBadge, SeverityBadge } from "./EscalationBadges";
import { EscalationDetailsModal } from "./EscalationDetailsModal";

/** Super Admin only (Figma 610:22336, modal 622:6740). */
export function EscalationsView() {
  const { user } = useAuth();
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<EscalationStatus | "all">("all");
  const debouncedSearch = useDebouncedValue(search, 250);
  const [version, setVersion] = useState(0);
  const [reviewing, setReviewing] = useState<Escalation | null>(null);

  const { data, loading, error } = useAsync(() => escalationService.list({ search: debouncedSearch, status }), [debouncedSearch, status, version]);
  const stats = useAsync(() => escalationService.stats(), [version]);

  const [rows, setRows] = useState<Escalation[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  async function handleAction(action: EscalationAction) {
    if (!reviewing) return;
    const updated = await escalationService.act(reviewing.id, action, user?.email ?? "admin");
    setReviewing(updated);
    setVersion((v) => v + 1);
  }

  const s = stats.data;
  const dash = "–";
  const openCount = s ? s.open + s.underReview : null;

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Escalations</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Review, investigate, and resolve escalated security and compliance issues</p>
        </div>
        <span className="flex items-center gap-2 rounded-[18px] border border-[#fb2c36]/20 bg-[#fb2c36]/10 px-4 py-2.5 text-sm leading-5 font-medium whitespace-nowrap text-[#ffa2a2]">
          <TriangleAlert className="size-4 text-[#ff6467]" />
          {openCount === null ? dash : `${openCount} open escalation${openCount === 1 ? "" : "s"}`}
        </span>
      </div>

      <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        <StatTile icon={TriangleAlert} tone="blue" value={s?.open ?? dash} label="Open" />
        <StatTile icon={TriangleAlert} tone="yellow" value={s?.underReview ?? dash} label="Under Review" />
        <StatTile icon={TriangleAlert} tone="green" value={s?.resolved ?? dash} label="Resolved" />
        <StatTile icon={TriangleAlert} tone="red" value={s?.critical ?? dash} label="Critical" />
      </div>

      <section className="flex flex-col gap-4 rounded-2xl border border-white/10 bg-[#0c0e1a] p-4 sm:p-6">
        <div className="flex flex-col gap-3 md:flex-row md:gap-6">
          <label className="flex min-w-0 flex-1 items-center gap-4 rounded-[18px] border border-white/10 p-4 transition-colors focus-within:border-white/30">
            <Search className="size-5 shrink-0 text-white" strokeWidth={1.75} />
            <input
              type="search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search escalations..."
              aria-label="Search escalations"
              className="w-full min-w-0 bg-transparent text-base text-white outline-none placeholder:text-white"
            />
          </label>
          <FilterSelect label="Filter by status" allLabel="All Status" value={status} onChange={setStatus} options={ESCALATION_STATUS_LABELS} />
        </div>

        {error ? (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            Couldn&apos;t load escalations. {error.message}
          </p>
        ) : loading && rows.length === 0 ? (
          [0, 1, 2].map((i) => <div key={i} className="h-[76px] animate-pulse rounded-[18px] border border-white/10 bg-white/5" />)
        ) : rows.length === 0 ? (
          <p className="py-8 text-center text-sm text-[#9ca3af]">No escalations match your filters.</p>
        ) : (
          <ul className="flex flex-col gap-3">
            {rows.map((e) => (
              <li key={e.id} className={`flex flex-col gap-3 rounded-[18px] border p-4 sm:flex-row sm:items-start sm:justify-between ${e.severity === "critical" ? "border-[#fb2c36]/20" : "border-white/10"}`}>
                <div className="flex min-w-0 items-start gap-3">
                  <span className={`flex size-9 shrink-0 items-center justify-center rounded-[18px] ${CATEGORY_TONE[e.category]}`}>
                    <TriangleAlert className="size-4" />
                  </span>
                  <div className="min-w-0">
                    <div className="flex flex-wrap items-center gap-2">
                      <CategoryBadge category={e.category} />
                      <SeverityBadge severity={e.severity} />
                      <EscalationStatusBadge status={e.status} />
                    </div>
                    <p className="pt-1.5 text-sm leading-5 text-[#e5e7eb]">{e.description}</p>
                    <p className="flex flex-wrap items-center gap-x-3 gap-y-1 pt-1.5 text-xs leading-4 text-[#9ca3af]">
                      <span>Related: {e.related}</span>
                      <span className="flex items-center gap-1">
                        <Clock className="size-3" />
                        {e.createdAt}
                      </span>
                    </p>
                  </div>
                </div>
                <button
                  type="button"
                  onClick={() => setReviewing(e)}
                  className="flex shrink-0 cursor-pointer items-center gap-1.5 self-start rounded-[14px] border border-white/10 bg-white/10 px-3 py-1.5 text-xs leading-4 font-medium text-[#e5e7eb] transition hover:bg-white/15 max-sm:ml-12"
                >
                  <Eye className="size-3.5" />
                  Review
                </button>
              </li>
            ))}
          </ul>
        )}
      </section>

      {reviewing && <EscalationDetailsModal escalation={reviewing} onClose={() => setReviewing(null)} onAction={handleAction} />}
    </div>
  );
}
