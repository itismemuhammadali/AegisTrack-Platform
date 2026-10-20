"use client";

import type { Ref } from "react";
import { CircleCheck, FileText, RotateCcw } from "lucide-react";
import { SYNC_STATUS_LABELS, type SyncFailure } from "@/types/syncFailure";

const BTN = "inline-flex cursor-pointer items-center gap-2 rounded-xl px-3 py-2 text-sm leading-5 font-medium transition hover:brightness-125 disabled:cursor-not-allowed disabled:opacity-50";

interface Props {
  ref?: Ref<HTMLElement>;
  failure: SyncFailure;
  onClose: () => void;
  onRetry: () => void;
  onResolve: () => void;
}

export function SyncFailureDetails({ ref, failure: f, onClose, onRetry, onResolve }: Props) {
  const resolved = f.status === "resolved";
  const fields: [string, string][] = [
    ["User", f.user.name],
    ["Email", f.user.email],
    ["Device", f.device],
    ["Error Code", f.errorCode],
    ["Failure Reason", f.reason],
    ["Retry Count", String(f.retries)],
    ["Data Loss Risk", f.dataLossRisk ? "Yes" : "No"],
    ["Timestamp", f.time],
    ["Status", SYNC_STATUS_LABELS[f.status]],
  ];

  return (
    <section ref={ref} aria-label={`Event details for ${f.user.name}`} className="scroll-mt-6 rounded-[18px] border border-white/10 bg-black/60 p-4 sm:p-6">
      <header className="flex items-start justify-between gap-3">
        <h2 className="text-base leading-6 font-semibold text-white">Event Details — {f.user.name}</h2>
        <button type="button" onClick={onClose} className="cursor-pointer text-xs leading-4 text-[#9ca3af] transition hover:text-white">
          Close
        </button>
      </header>

      <dl className="grid grid-cols-1 gap-x-6 gap-y-4 pt-5 sm:grid-cols-2 lg:grid-cols-3">
        {fields.map(([label, value]) => (
          <div key={label} className="min-w-0">
            <dt className="text-xs leading-4 text-[#9ca3af]">{label}</dt>
            <dd className={`pt-1 text-sm leading-5 break-words text-white ${label === "Data Loss Risk" && f.dataLossRisk ? "text-[#ff6467]" : ""}`}>{value}</dd>
          </div>
        ))}
      </dl>

      <div className="mt-5 flex flex-wrap gap-2 border-t border-white/10 pt-4">
        <button type="button" className={`${BTN} bg-[#2b7fff]/20 text-[#51a2ff]`} onClick={onRetry} disabled={resolved}>
          <RotateCcw className="size-4" /> Force Retry
        </button>
        <button type="button" className={`${BTN} bg-[#00c950]/20 text-[#05df72]`} onClick={onResolve} disabled={resolved}>
          <CircleCheck className="size-4" /> Mark Resolved
        </button>
        <button type="button" className={`${BTN} bg-white/10 text-white`} onClick={() => window.alert("Full log viewer is not designed yet.")}>
          <FileText className="size-4" /> View Full Log
        </button>
      </div>
    </section>
  );
}
