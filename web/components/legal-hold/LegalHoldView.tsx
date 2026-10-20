"use client";

import { useState } from "react";
import { Clock, Eye, Lock, Plus, Shield } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { StatTile } from "@/components/ui/StatTile";
import { useAsync } from "@/hooks/useAsync";
import { legalHoldService } from "@/services/legalHoldService";
import type { ApplyLegalHoldInput, LegalHold } from "@/types/legalHold";
import { ApplyLegalHoldModal, LegalHoldDetailsModal } from "./LegalHoldModals";

/** Super Admin only (Figma 610:22020, modals 622:5405 / 622:6005). */
export function LegalHoldView() {
  const { user } = useAuth();
  const actor = user?.email ?? "admin";
  const [version, setVersion] = useState(0);
  const holds = useAsync(() => legalHoldService.list(), [version]);
  const stats = useAsync(() => legalHoldService.stats(), [version]);
  const [applying, setApplying] = useState(false);
  const [viewing, setViewing] = useState<LegalHold | null>(null);
  const [actionError, setActionError] = useState<string | null>(null);

  async function apply(input: ApplyLegalHoldInput) {
    await legalHoldService.apply(input, actor);
    setApplying(false);
    setVersion((v) => v + 1);
  }

  async function lift(hold: LegalHold) {
    if (!window.confirm(`Lift the legal hold on "${hold.title}"? Records will again be subject to retention rules.`)) return;
    setActionError(null);
    try {
      await legalHoldService.lift(hold.id, actor);
      setVersion((v) => v + 1);
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Couldn't lift legal hold");
    }
  }

  const s = stats.data;
  const dash = "–";

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Legal Hold</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Manage legal holds to protect records from archiving or deletion</p>
        </div>
        <button
          type="button"
          onClick={() => setApplying(true)}
          className="flex cursor-pointer items-center gap-2 rounded-[18px] bg-[#34206c] px-4 py-2.5 text-base leading-6 font-medium whitespace-nowrap text-white shadow-[0_10px_15px_rgba(52,32,108,0.2),0_4px_6px_rgba(52,32,108,0.2)] transition hover:bg-[#3f2785]"
        >
          <Plus className="size-4" />
          Apply Legal Hold
        </button>
      </div>

      <div className="flex items-start gap-3 rounded-[18px] border border-[#fb2c36]/30 bg-[#fb2c36]/10 p-4">
        <Shield className="mt-0.5 size-5 shrink-0 text-[#ff6467]" />
        <div className="text-sm leading-5">
          <p className="font-semibold text-[#ffa2a2]">Legal Hold Protection</p>
          <p className="text-[#9ca3af]">
            Legal Hold prevents protected records from being archived or removed while the hold is active. This includes all associated location logs, check-ins, zone events, and security
            flags.
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
        <StatTile icon={Lock} tone="red" value={s?.active ?? dash} label="Active Holds" />
        <StatTile icon={Lock} tone="green" value={s?.lifted ?? dash} label="Lifted Holds" />
        <StatTile icon={Lock} tone="blue" value={s ? s.totalRecords.toLocaleString("en-US") : dash} label="Total Records" />
      </div>

      <section className="flex flex-col gap-4 rounded-2xl border border-white/10 bg-[#0c0e1a] p-4 sm:p-6">
        <h2 className="text-sm leading-5 font-semibold text-[#e5e7eb]">Legal Hold Records</h2>

        {actionError && (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            {actionError}
          </p>
        )}

        {holds.error ? (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            Couldn&apos;t load legal holds. {holds.error.message}
          </p>
        ) : !holds.data ? (
          [0, 1, 2].map((i) => <div key={i} className="h-[112px] animate-pulse rounded-[18px] border border-white/10 bg-white/5" />)
        ) : holds.data.length === 0 ? (
          <p className="py-8 text-center text-sm text-[#9ca3af]">No legal holds yet.</p>
        ) : (
          holds.data.map((h) => <HoldCard key={h.id} hold={h} onView={() => setViewing(h)} onLift={() => lift(h)} />)
        )}
      </section>

      {applying && <ApplyLegalHoldModal onClose={() => setApplying(false)} onSubmit={apply} />}
      {viewing && <LegalHoldDetailsModal hold={viewing} onClose={() => setViewing(null)} />}
    </div>
  );
}

function HoldCard({ hold: h, onView, onLift }: { hold: LegalHold; onView: () => void; onLift: () => void }) {
  const active = h.status === "active";
  return (
    <article className={`rounded-[18px] border p-4 ${active ? "border-[#fb2c36]/20 bg-[#fb2c36]/5" : "border-white/10 bg-[#1e3a4a]/20"}`}>
      <div className="flex items-start justify-between gap-3">
        <div className="flex min-w-0 items-start gap-3">
          <span className={`flex size-9 shrink-0 items-center justify-center rounded-[18px] ${active ? "bg-[#ff6467]/10 text-[#ff6467]" : "bg-[#99a1af]/10 text-[#99a1af]"}`}>
            <Lock className="size-4" />
          </span>
          <div className="min-w-0">
            <div className="flex flex-wrap items-center gap-2">
              <p className="text-sm leading-5 font-semibold text-[#e5e7eb]">{h.title}</p>
              <span
                className={`rounded-[10px] border px-1.5 py-0.5 text-[10px] leading-[15px] font-bold ${
                  active ? "border-[#fb2c36]/30 bg-[#fb2c36]/20 text-[#ff6467]" : "border-[#6a7282]/30 bg-[#6a7282]/20 text-[#99a1af]"
                }`}
              >
                {active ? "● ACTIVE" : "○ LIFTED"}
              </span>
            </div>
            <p className="pt-0.5 text-xs leading-4 text-[#9ca3af]">
              {h.caseNumber} · Auth: {h.authorization}
            </p>
            <p className="pt-1 text-xs leading-4 text-[#9ca3af]">{h.reason}</p>
          </div>
        </div>
        <div className="flex shrink-0 items-center gap-2">
          <button type="button" onClick={onView} aria-label={`View ${h.title}`} className="cursor-pointer rounded-[14px] p-1.5 text-[#9ca3af] transition hover:bg-white/10 hover:text-white">
            <Eye className="size-4" />
          </button>
          {active && (
            <button
              type="button"
              onClick={onLift}
              className="cursor-pointer rounded-[14px] border border-white/10 bg-white/10 px-3 py-1.5 text-xs leading-4 font-medium whitespace-nowrap text-[#e5e7eb] transition hover:bg-white/15"
            >
              Lift Hold
            </button>
          )}
        </div>
      </div>
      <div className="mt-3 flex flex-wrap items-center gap-x-4 gap-y-1 border-t border-white/10 pt-3 text-xs leading-4 text-[#9ca3af]">
        <span className="flex items-center gap-1">
          <Clock className="size-3" />
          Applied {h.appliedAt}
        </span>
        <span>By {h.appliedBy}</span>
      </div>
    </article>
  );
}
