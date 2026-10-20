"use client";

import { useState } from "react";
import { Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import type { CheckInSchedule } from "@/types/checkIn";

/** "Delete Check-in" (Figma 622:8556) — opened from the row menu's Delete. */
export function DeleteCheckInModal({ schedule, onClose, onDelete }: { schedule: CheckInSchedule; onClose: () => void; onDelete: () => Promise<void> }) {
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function confirm() {
    setDeleting(true);
    setError(null);
    try {
      await onDelete();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't delete check-in");
      setDeleting(false);
    }
  }

  return (
    <Modal title="Delete Check-in" onClose={onClose} width="max-w-[448px]" hideClose>
      <div className="-mt-3 flex flex-col gap-4">
        <p className="text-sm leading-5 text-[#9ca3af]">
          Are you sure you want to delete <span className="font-semibold break-words text-white">{schedule.name}?</span> This action cannot be undone.
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
            Delete Check-in
          </button>
        </div>
      </div>
    </Modal>
  );
}
