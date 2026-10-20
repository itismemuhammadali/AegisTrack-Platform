"use client";

import { type FormEvent, useState } from "react";
import { Check, ChevronDown, CircleCheck, Loader2, Lock } from "lucide-react";
import { DetailTile, HistoryRow, Modal } from "@/components/ui/Modal";
import { useAsync } from "@/hooks/useAsync";
import { caseService } from "@/services/caseService";
import type { ApplyLegalHoldInput, LegalHold } from "@/types/legalHold";

const FIELD = "w-full rounded-[18px] border border-white/10 bg-white/10 text-[#e5e7eb] outline-none transition-colors placeholder:text-[#9ca3af] focus:border-white/30";

/** Figma 622:5405. Submit stays disabled until a case, reason, reference and confirmation are given. */
export function ApplyLegalHoldModal({ onClose, onSubmit }: { onClose: () => void; onSubmit: (input: ApplyLegalHoldInput) => Promise<void> }) {
  const cases = useAsync(() => caseService.list(), []);
  const [caseId, setCaseId] = useState("");
  const [reason, setReason] = useState("");
  const [authorization, setAuthorization] = useState("");
  const [confirmed, setConfirmed] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const available = (cases.data ?? []).filter((c) => !c.legalHold && c.status !== "closed");
  const canSubmit = Boolean(caseId && reason.trim() && authorization.trim() && confirmed && !saving);

  async function submit(e: FormEvent) {
    e.preventDefault();
    if (!canSubmit) return;
    setSaving(true);
    setError(null);
    try {
      await onSubmit({ caseId, reason, authorization });
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't apply legal hold");
      setSaving(false);
    }
  }

  return (
    <Modal title="Apply Legal Hold" subtitle="Protect case records from archiving or deletion" onClose={onClose}>
      <form onSubmit={submit} className="flex flex-col gap-4">
        <p className="flex items-start gap-2 rounded-[18px] border border-[#fb2c36]/30 bg-[#fb2c36]/10 p-4 text-sm leading-5 font-medium text-[#ffa2a2]">
          <Lock className="mt-0.5 size-4 shrink-0 text-[#ff6467]" />
          Legal Hold prevents protected records from being archived or removed while the hold is active.
        </p>

        <label className="flex flex-col gap-2.5">
          <span className="text-sm leading-5 font-medium text-[#e5e7eb]">Case</span>
          <span className="relative">
            <select value={caseId} onChange={(e) => setCaseId(e.target.value)} required className={`${FIELD} h-[42px] cursor-pointer appearance-none px-2.5 pr-9 text-base`}>
              <option value="" className="bg-[#0c0e1a]">
                {cases.loading ? "Loading cases…" : "Select case..."}
              </option>
              {available.map((c) => (
                <option key={c.id} value={c.id} className="bg-[#0c0e1a]">
                  {c.number} — {c.title}
                </option>
              ))}
            </select>
            <ChevronDown className="pointer-events-none absolute top-1/2 right-3 size-4 -translate-y-1/2 text-[#e5e7eb]" />
          </span>
        </label>

        <label className="flex flex-col gap-2.5">
          <span className="text-sm leading-5 font-medium text-[#e5e7eb]">Reason</span>
          <textarea value={reason} onChange={(e) => setReason(e.target.value)} rows={3} placeholder="Explain the legal basis for this hold..." className={`${FIELD} min-h-[82px] resize-y px-4 py-2.5 text-sm leading-5`} />
        </label>

        <label className="flex flex-col gap-2.5">
          <span className="text-sm leading-5 font-medium text-[#e5e7eb]">Court Order / Authorization Reference</span>
          <input value={authorization} onChange={(e) => setAuthorization(e.target.value)} placeholder="e.g. CO-2025-XXXX" className={`${FIELD} h-[46px] px-4 text-base`} />
        </label>

        <label className="flex cursor-pointer items-start gap-3 rounded-[18px] border border-white/10 bg-white/10 p-3">
          <input type="checkbox" checked={confirmed} onChange={(e) => setConfirmed(e.target.checked)} className="peer sr-only" />
          <span aria-hidden className={`mt-0.5 flex size-4 shrink-0 items-center justify-center rounded-[2px] border peer-focus-visible:ring-2 peer-focus-visible:ring-white/40 ${confirmed ? "border-[#e7000b] bg-[#e7000b]" : "border-white"}`}>
            {confirmed && <Check className="size-3.5 text-white" strokeWidth={3} />}
          </span>
          <span className="text-sm leading-5 font-medium text-[#e5e7eb]">
            I confirm I am authorized to apply this legal hold and understand that protected records cannot be deleted or archived until this hold is lifted.
          </span>
        </label>

        {error && (
          <p role="alert" className="text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex gap-3">
          <button type="button" onClick={onClose} className="flex-1 cursor-pointer rounded-[18px] bg-white/10 px-4 py-2.5 text-base leading-6 font-medium text-[#e5e7eb] transition hover:bg-white/15">
            Cancel
          </button>
          <button
            type="submit"
            disabled={!canSubmit}
            className="flex flex-1 cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#e7000b] px-4 py-2.5 text-base leading-6 font-medium text-white transition hover:bg-[#c8000a] disabled:cursor-not-allowed disabled:opacity-40"
          >
            {saving && <Loader2 className="size-4 animate-spin" />}
            Apply Legal Hold
          </button>
        </div>
      </form>
    </Modal>
  );
}

/** Figma 622:6005. */
export function LegalHoldDetailsModal({ hold, onClose }: { hold: LegalHold; onClose: () => void }) {
  const active = hold.status === "active";
  return (
    <Modal title="Legal Hold Details" onClose={onClose}>
      <div className={`rounded-[18px] border p-4 ${active ? "border-[#fb2c36]/30 bg-[#fb2c36]/10" : "border-white/10 bg-white/10"}`}>
        <p className={`flex items-center gap-2 text-sm leading-5 font-semibold ${active ? "text-[#ffa2a2]" : "text-[#99a1af]"}`}>
          <Lock className={`size-4 ${active ? "text-[#ff6467]" : ""}`} />
          {active ? "Hold Active" : "Hold Lifted"}
        </p>
        <p className="pt-1 text-sm leading-5 text-[#9ca3af]">{hold.title}</p>
      </div>

      <div className="grid grid-cols-2 gap-3">
        <DetailTile label="Applied By">{hold.appliedBy}</DetailTile>
        <DetailTile label="Applied Date">{hold.appliedAt}</DetailTile>
        <DetailTile label="Authorization" className="col-span-2">
          {hold.authorization}
        </DetailTile>
        <DetailTile label="Reason" className="col-span-2">
          <span className="font-normal">{hold.reason}</span>
        </DetailTile>
      </div>

      <div>
        <h3 className="text-sm leading-5 font-semibold text-[#e5e7eb]">Hold History</h3>
        <ul className="flex flex-col gap-2 pt-3">
          {hold.history.map((h, i) => (
            <HistoryRow key={i} icon={<CircleCheck className="size-4 text-[#05df72]" />} action={h.action} actor={h.actor} date={h.date} />
          ))}
        </ul>
      </div>

      <button type="button" onClick={onClose} className="h-11 cursor-pointer rounded-[18px] border border-white/10 text-base leading-6 font-medium text-[#e5e7eb] transition hover:bg-white/5">
        Close
      </button>
    </Modal>
  );
}
