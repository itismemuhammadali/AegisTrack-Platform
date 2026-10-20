"use client";

import {
  CircleAlert,
  Eye,
  Flag,
  Lock,
  MapPin,
  Power,
  ShieldCheck,
  UserX,
  Wifi,
  WifiOff,
  type LucideIcon,
} from "lucide-react";
import type { SecurityEvent, SecurityEventStatus, SecurityEventType } from "@/types/security";
import { EventStatusTag, SeverityTag } from "./SecurityBadges";

const TYPE_ICON: Record<SecurityEventType, { Icon: LucideIcon; cls: string }> = {
  vpn: { Icon: WifiOff, cls: "bg-[#ff6900]/10 text-[#ff8904]" },
  failed_login: { Icon: Lock, cls: "bg-[#fb2c36]/10 text-[#ff6467]" },
  unusual_location: { Icon: MapPin, cls: "bg-[#fb2c36]/10 text-[#ff6467]" },
  airplane_mode: { Icon: Wifi, cls: "bg-[#f0b100]/10 text-[#fdc700]" },
  proxy: { Icon: CircleAlert, cls: "bg-[#fb2c36]/10 text-[#ff6467]" },
  unauthorized_access: { Icon: UserX, cls: "bg-[#fb2c36]/10 text-[#ff6467]" },
  power_cycling: { Icon: Power, cls: "bg-[#2b7fff]/10 text-[#51a2ff]" },
};

const ACTION = "inline-flex cursor-pointer items-center gap-1.5 rounded-full px-3 py-1 text-xs leading-4 font-medium whitespace-nowrap transition hover:brightness-125 disabled:cursor-not-allowed disabled:opacity-50";

interface SecurityEventCardProps {
  event: SecurityEvent;
  expanded: boolean;
  onToggle: () => void;
  onSetStatus: (status: SecurityEventStatus) => void;
  onDisableUser: () => void;
}

export function SecurityEventCard({ event, expanded, onToggle, onSetStatus, onDisableUser }: SecurityEventCardProps) {
  const { Icon, cls } = TYPE_ICON[event.type];
  const critical = event.severity === "critical" && event.status !== "resolved";
  const resolved = event.status === "resolved";

  return (
    <article className={`rounded-[18px] border bg-black/60 p-4 transition-colors ${critical ? "border-[#fb2c36]/40" : "border-white/10"}`}>
      <button type="button" onClick={onToggle} aria-expanded={expanded} className="flex w-full cursor-pointer items-start gap-3 text-left">
        <span className={`flex size-9 shrink-0 items-center justify-center rounded-full ${cls}`}>
          <Icon className="size-4" />
        </span>
        <div className="flex min-w-0 flex-1 flex-wrap items-start justify-between gap-2">
          <div className="min-w-0">
            <p className="text-sm leading-5 font-medium text-white">{event.title}</p>
            <p className="flex flex-wrap items-center gap-x-1.5 pt-0.5 text-xs leading-4 text-[#9ca3af]">
              <span>{event.userEmail}</span>
              <span aria-hidden>·</span>
              <span className="inline-flex items-center gap-1">
                <MapPin className="size-3" />
                {event.location}
              </span>
              <span aria-hidden>·</span>
              <span>{event.time}</span>
            </p>
          </div>
          <div className="flex shrink-0 gap-1.5">
            <SeverityTag severity={event.severity} />
            <EventStatusTag status={event.status} />
          </div>
        </div>
      </button>

      {expanded && (
        <div className="mt-4 flex flex-col gap-3 border-t border-white/10 pt-4 md:mr-[44px]">
          {event.ipAddress && (
            <p className="rounded-xl bg-white/10 px-3 py-2.5 text-xs leading-4 text-[#9ca3af]">
              IP Address: <span className="font-mono text-white">{event.ipAddress}</span>
            </p>
          )}
          <div className="flex flex-wrap gap-1.5">
            <button type="button" className={`${ACTION} bg-[#f0b100]/20 text-[#fdc700]`} disabled={resolved} onClick={() => onSetStatus("investigating")}>
              <Eye className="size-3.5" /> Investigate
            </button>
            <button type="button" className={`${ACTION} bg-[#fb2c36]/20 text-[#ff6467]`} disabled={!event.userId} onClick={onDisableUser}>
              <UserX className="size-3.5" /> Disable User
            </button>
            <button type="button" className={`${ACTION} bg-[#ff6900]/20 text-[#ff8904]`} disabled={resolved} onClick={() => onSetStatus("flagged")}>
              <Flag className="size-3.5" /> Flag for Review
            </button>
            <button type="button" className={`${ACTION} bg-[#00c950]/20 text-[#05df72]`} disabled={resolved} onClick={() => onSetStatus("resolved")}>
              <ShieldCheck className="size-3.5" /> Mark Resolved
            </button>
          </div>
        </div>
      )}
    </article>
  );
}
