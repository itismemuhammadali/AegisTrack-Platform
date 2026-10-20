import type { AdminAccountRole } from "@/types/adminAccount";

/** Admin Management uses a tighter 8px-radius control style (Figma 632:2 / 634:717 / 634:1792). */
export const BTN_PRIMARY =
  "flex cursor-pointer items-center justify-center gap-2 rounded-lg bg-[linear-gradient(90deg,#2f1d63_0%,#4a2d8f_100%)] px-[18px] py-2.5 text-sm font-semibold whitespace-nowrap text-[#f3f4f6] transition hover:brightness-125 disabled:cursor-not-allowed disabled:opacity-50";

export const BTN_SECONDARY =
  "flex cursor-pointer items-center justify-center rounded-lg border border-white/[0.08] bg-white/[0.02] px-[18px] py-2.5 text-sm font-semibold whitespace-nowrap text-[#f3f4f6] transition hover:bg-white/[0.06] disabled:cursor-not-allowed disabled:opacity-50";

export const INPUT =
  "w-full rounded-lg border border-white/[0.08] bg-white/[0.06] p-3 text-sm text-[#f3f4f6] outline-none transition-colors placeholder:text-[#6b7280] focus:border-white/25 aria-invalid:border-red-400/60";

export const ROLE_BADGE: Record<AdminAccountRole, string> = {
  super_admin: "border-[#f59e0b]/20 bg-[#f59e0b]/10 text-[#f59e0b]",
  admin: "border-[#6366f1]/20 bg-[#6366f1]/10 text-[#c27aff]",
  moderator: "border-[#3b82f6]/20 bg-[#3b82f6]/10 text-[#60a5fa]",
};
