"use client";

import { useState } from "react";
import { TriangleAlert } from "lucide-react";

export function SyncFailureBanner({ count, onRetryAll }: { count: number; onRetryAll: () => Promise<void> }) {
  const [busy, setBusy] = useState(false);
  if (count <= 0) return null;

  async function retry() {
    setBusy(true);
    try {
      await onRetryAll();
    } finally {
      setBusy(false);
    }
  }

  return (
    <div className="flex flex-wrap items-center gap-4 rounded-[18px] border border-[#fb2c36]/30 bg-[#fb2c36]/10 px-4 py-[17px]">
      <TriangleAlert className="size-5 shrink-0 text-[#ff6467]" />
      <div className="min-w-0 flex-1">
        <p className="text-sm leading-5 font-medium text-[#ff6467]">
          {count} sync failure{count === 1 ? "" : "s"} require{count === 1 ? "s" : ""} attention
        </p>
        <p className="pt-1 text-xs leading-4 text-[#d1d5dc]">Users may have incomplete location data. Review and retry or investigate each failure.</p>
      </div>
      <button
        type="button"
        onClick={retry}
        disabled={busy}
        className="cursor-pointer rounded-[14px] bg-[#fb2c36]/20 px-3 py-1.5 text-xs leading-4 font-medium whitespace-nowrap text-[#ff6467] transition hover:bg-[#fb2c36]/30 disabled:cursor-wait disabled:opacity-60"
      >
        {busy ? "Retrying…" : "Retry All"}
      </button>
    </div>
  );
}
