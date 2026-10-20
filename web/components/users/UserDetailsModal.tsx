"use client";

import { Avatar } from "@/components/ui/Avatar";
import { DetailTile, Modal } from "@/components/ui/Modal";
import type { ManagedUser } from "@/types/user";
import { RoleBadge, StatusBadge } from "./UserBadges";

/** "User Details" (Figma 610:27027) — opened from the row menu's View Details. */
export function UserDetailsModal({
  user,
  onClose,
}: {
  user: ManagedUser;
  onClose: () => void;
}) {
  return (
    <Modal title="User Details" onClose={onClose} width="max-w-[672px]">
      <div className="flex flex-col gap-6 pt-2">
        <div className="flex items-center gap-4 border-b border-white/10 pb-6">
          <Avatar src={user.avatarUrl} name={user.name} size={64} />
          <div className="flex min-w-0 flex-col">
            <h3 className="truncate text-lg leading-7 font-semibold text-[#e5e7eb]">
              {user.name}
            </h3>
            <p className="truncate text-sm leading-5 text-[#9ca3af]">
              {user.email}
            </p>
            <div className="mt-2 flex flex-wrap gap-2">
              <RoleBadge role={user.role} />
              <StatusBadge status={user.status} dot={false} />
            </div>
          </div>
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          <DetailTile label="Email" className="p-4">
            {user.email}
          </DetailTile>
          <DetailTile label="Phone" className="p-4">
            {user.phone ?? "—"}
          </DetailTile>
          <DetailTile label="Last Active" className="p-4">
            {user.lastActive}
          </DetailTile>
          <DetailTile label="Location" className="p-4">
            {user.location ?? "—"}
          </DetailTile>
        </div>
      </div>

      <button
        type="button"
        onClick={onClose}
        className="mt-2 h-11 w-full cursor-pointer rounded-[18px] bg-[#3c2579] text-base font-medium text-[#e5e7eb] transition hover:bg-[#4a2f94]"
      >
        Close
      </button>
    </Modal>
  );
}
