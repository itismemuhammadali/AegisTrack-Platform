"use client";

import { useState } from "react";
import { CircleArrowUp, CircleCheck, Loader2, Shield } from "lucide-react";
import { DetailTile, HistoryRow, Modal } from "@/components/ui/Modal";
import type { Escalation, EscalationAction } from "@/types/escalation";
import { CategoryBadge, EscalationStatusBadge, SeverityBadge } from "./EscalationBadges";

/** Figma 622:6740. Actions are disabled when they would be a no-op. */
export function EscalationDetailsModal({ escalation: e, onClose, onAction }: { escalation: Escalation; onClose: () => void; onAction: (action: EscalationAction) => Promise<void> }) {
  const [busy, setBusy] = useState<EscalationAction | null>(null);
  const [error, setError] = useState<string | null>(null);
  const resolved = e.status === "resolved";

  async function run(action: EscalationAction) {
    setBusy(action);
    setError(null);
    try {
      await onAction(action);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Action failed");
    } finally {
      setBusy(null);
    }
  }

  const spin = (a: EscalationAction) => busy === a && <Loader2 className="size-4 animate-spin" />;

  return (
    <Modal title="Escalation Details" titleAside={<SeverityBadge severity={e.severity} />} onClose={onClose} width="max-w-[700px]">
      <div className="flex flex-col gap-2.5">
        <div className="flex flex-col gap-2.5 rounded-[18px] border border-white/10 bg-white/10 p-4">
          <div className="flex flex-wrap items-center gap-2">
            <CategoryBadge category={e.category} />
            <EscalationStatusBadge status={e.status} />
          </div>
          <p className="text-sm leading-5 text-[#e5e7eb]">{e.description}</p>
        </div>

        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
          <DetailTile label="Related User / Case">{e.related}</DetailTile>
          <DetailTile label="Created Date">{e.createdAt}</DetailTile>
          <DetailTile label="Assigned To">{e.assignedTo}</DetailTile>
        </div>

        <div className="flex flex-col gap-2.5">
          <h3 className="text-sm leading-5 font-semibold text-[#e5e7eb]">Investigation History</h3>
          <ul className="flex flex-col gap-2.5">
            {e.history.map((h, i) => (
              <HistoryRow key={i} icon={<Shield className="size-4 text-[#e5e7eb]" />} action={h.action} actor={h.actor} date={h.date} />
            ))}
          </ul>
        </div>
      </div>

      {error && (
        <p role="alert" className="text-sm text-red-300">
          {error}
        </p>
      )}

      <div className="flex flex-wrap gap-3">
        <button type="button" onClick={onClose} className="min-w-[120px] flex-1 cursor-pointer rounded-[18px] bg-white/10 px-4 py-2.5 text-base leading-6 font-medium text-[#e5e7eb] transition hover:bg-white/15">
          Close
        </button>
        <button
          type="button"
          onClick={() => run("flag")}
          disabled={busy !== null || resolved || e.status === "under_review"}
          className="flex cursor-pointer items-center gap-1.5 rounded-[18px] border border-[#f0b100]/30 bg-[#f0b100]/20 px-4 py-2.5 text-sm leading-5 font-medium text-[#ffdf20] transition hover:bg-[#f0b100]/30 disabled:cursor-not-allowed disabled:opacity-40"
        >
          {spin("flag")}
          Flag
        </button>
        <button
          type="button"
          onClick={() => run("escalate")}
          disabled={busy !== null || resolved || e.severity === "critical"}
          className="flex cursor-pointer items-center gap-1.5 rounded-[18px] border border-[#ff6900]/30 bg-[#ff6900]/20 px-4 py-2.5 text-sm leading-5 font-medium text-[#ffb86a] transition hover:bg-[#ff6900]/30 disabled:cursor-not-allowed disabled:opacity-40"
        >
          {spin("escalate") || <CircleArrowUp className="size-4" />}
          Escalate
        </button>
        <button
          type="button"
          onClick={() => run("resolve")}
          disabled={busy !== null || resolved}
          className="flex cursor-pointer items-center gap-1.5 rounded-[18px] bg-[#00a63e] px-4 py-2.5 text-sm leading-5 font-medium text-white transition hover:bg-[#00913a] disabled:cursor-not-allowed disabled:opacity-40"
        >
          {spin("resolve") || <CircleCheck className="size-4" />}
          Resolve
        </button>
      </div>
    </Modal>
  );
}
