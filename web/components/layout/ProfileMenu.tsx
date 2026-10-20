"use client";

import Image from "next/image";
import { LogOut, Shield, User } from "lucide-react";
import type { AdminUser } from "@/types/auth";

const ROLE_LABEL: Record<AdminUser["role"], string> = {
  SUPER_ADMIN: "Super Administrator",
  ADMIN: "Administrator",
};

/** Header account dropdown (Figma 610:26962) — shared by Admin and Super Admin. */
export function ProfileMenu({
  user,
  onViewProfile,
  onSignOut,
}: {
  user: AdminUser;
  onViewProfile: () => void;
  onSignOut: () => void;
}) {
  return (
    <div
      role="menu"
      aria-label="Account"
      className="absolute top-[calc(100%+8px)] right-0 z-50 flex w-[min(240px,calc(100vw-32px))] flex-col gap-2.5 rounded-[18px] border border-white/10 bg-[linear-gradient(138.5deg,rgba(12,18,39,0.4)_0%,rgba(12,18,39,0.9)_50%,rgba(12,18,39,0.4)_100%),linear-gradient(#0c0e1a,#0c0e1a)] p-[9px] drop-shadow-[0_25px_25px_rgba(0,0,0,0.25)]"
    >
      <div className="flex flex-col gap-2 border-b border-white/10 pb-[15px]">
        <div className="flex items-center gap-2.5">
          <Image
            src={user.avatarUrl ?? "/images/avatar.png"}
            alt=""
            width={48}
            height={48}
            unoptimized={user.avatarUrl?.startsWith("blob:")}
            className="size-12 shrink-0 rounded-full bg-[linear-gradient(135deg,#ad46ff_0%,#4f39f6_100%)] object-cover"
          />
          <div className="min-w-0 flex-1">
            <p className="truncate text-sm leading-5 font-medium text-[#e5e7eb]">
              {user.name}
            </p>
            <p className="truncate text-xs leading-4 text-[#9ca3af]">
              {user.email}
            </p>
          </div>
        </div>
        <div className="flex items-center gap-2 rounded-[14px] border border-white/20 bg-white/10 px-[9px] py-[11px]">
          <Shield className="size-3 text-white" />
          <span className="text-xs leading-4 font-medium text-white">
            {ROLE_LABEL[user.role]}
          </span>
        </div>
      </div>

      <button
        type="button"
        role="menuitem"
        onClick={onViewProfile}
        className="flex cursor-pointer items-center gap-4 rounded-[14px] px-3 py-2 text-sm leading-5 font-medium text-[#e5e7eb] transition hover:bg-white/5"
      >
        <User className="size-4" />
        View Profile
      </button>

      <div className="border-t border-white/10" />

      <button
        type="button"
        role="menuitem"
        onClick={onSignOut}
        className="flex cursor-pointer items-center gap-3 rounded-[14px] px-3 py-2 text-sm leading-5 font-medium text-[#ef4444] transition hover:bg-[#ef4444]/10"
      >
        <LogOut className="size-4" />
        Sign Out
      </button>
    </div>
  );
}
