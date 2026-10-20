"use client";

import { useState } from "react";
import { Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import type { Zone } from "@/types/zone";

/** "Delete Zone" (Figma 618:2271) — opened from the row menu's Delete Zone. */
export function DeleteZoneModal({ zone, onClose, onDelete }: { zone: Zone; onClose: () => void; onDelete: () => Promise<void> }) {
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function confirm() {
    setDeleting(true);
    setError(null);
    try {
      await onDelete();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't delete zone");
      setDeleting(false);
    }
  }

  return (
    <Modal title="Delete Zone" onClose={onClose} width="max-w-[448px]" hideClose>
      <div className="-mt-3 flex flex-col gap-4">
        <p className="text-sm leading-5 text-[#9ca3af]">
          Are you sure you want to delete <span className="font-medium break-words text-[#e5e7eb]">{zone.name}</span>? This action cannot be undone.
        </p>
        <p className="rounded-[18px] border border-[#fb2c36]/20 bg-[#fb2c36]/10 p-3 text-xs leading-4 text-[#ff6467]">
          All geofence rules and user assignments for this zone will be removed.
        </p>

        {error && (
          <p role="alert" className="text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex gap-3">
          <button type="button" onClick={onClose} className="h-11 flex-1 cursor-pointer rounded-[18px] border border-white/10 text-base font-medium text-[#e5e7eb] transition hover:bg-white/5">
            Cancel
          </button>
          <button
            type="button"
            onClick={confirm}
            disabled={deleting}
            className="flex h-11 flex-1 cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#ef4444] text-base font-medium whitespace-nowrap text-white transition hover:bg-[#dc2626] disabled:cursor-not-allowed disabled:opacity-60"
          >
            {deleting && <Loader2 className="size-4 animate-spin" />}
            Delete Zone
          </button>
        </div>
      </div>
    </Modal>
  );
}
