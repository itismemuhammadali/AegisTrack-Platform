"use client";

import { useState } from "react";
import { Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import type { ManagedUser } from "@/types/user";
import { BTN_CANCEL } from "./EditUserModal";

/** "Delete User" (Figma 610:27138) — opened from the row menu's Delete User. */
export function DeleteUserModal({
  user,
  onClose,
  onDelete,
}: {
  user: ManagedUser;
  onClose: () => void;
  onDelete: () => Promise<void>;
}) {
  const [deleting, setDeleting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function confirm() {
    setDeleting(true);
    setError(null);
    try {
      await onDelete();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't delete user");
      setDeleting(false);
    }
  }

  return (
    <Modal
      title="Delete User"
      subtitle="Are you sure you want to delete this user? This action cannot be undone."
      onClose={onClose}
      width="max-w-[448px]"
      hideClose
    >
      <div className="flex flex-col gap-6 pt-2">
        <p className="rounded-[18px] border border-[#ef4444]/20 bg-[#ef4444]/10 p-4 text-sm leading-5 font-medium text-[#ef4444]">
          Warning: Deleting {user.name} will remove all associated data and
          tracking history.
        </p>

        {error && (
          <p role="alert" className="text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex gap-3">
          <button type="button" onClick={onClose} className={BTN_CANCEL}>
            Cancel
          </button>
          <button
            type="button"
            onClick={confirm}
            disabled={deleting}
            className="flex h-11 flex-1 cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#ef4444] text-base font-medium whitespace-nowrap text-white transition hover:bg-[#dc2626] disabled:cursor-not-allowed disabled:opacity-60"
          >
            {deleting && <Loader2 className="size-4 animate-spin" />}
            Delete User
          </button>
        </div>
      </div>
    </Modal>
  );
}
