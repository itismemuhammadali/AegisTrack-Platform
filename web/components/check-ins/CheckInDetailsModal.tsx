"use client";

import { Camera, CircleCheck, Fingerprint, TriangleAlert } from "lucide-react";
import { DetailTile, Modal } from "@/components/ui/Modal";
import { BTN_SUBMIT } from "@/components/users/EditUserModal";
import { useAsync } from "@/hooks/useAsync";
import { checkInService } from "@/services/checkInService";
import type { CheckInSchedule } from "@/types/checkIn";
import { CheckInStatusBadge, FrequencyBadge } from "./CheckInBadges";
import { initials } from "./CheckInTable";

const BTN_OUTLINE = "h-11 flex-1 cursor-pointer rounded-[18px] border border-white/10 text-base font-medium text-[#e5e7eb] transition hover:bg-white/5";

/** "Check-in Details" (Figma 622:4742) — opened from the row menu's View Details. */
export function CheckInDetailsModal({ schedule, onClose, onEdit }: { schedule: CheckInSchedule; onClose: () => void; onEdit: () => void }) {
  const { data, loading, error } = useAsync(() => checkInService.get(schedule.id), [schedule.id]);
  const s = data ?? schedule;

  return (
    <Modal title="Check-in Details" onClose={onClose} width="max-w-[672px]">
      <div className="flex flex-col gap-4">
        <div className="flex items-center gap-4 border-b border-white/10 pb-4">
          <span aria-hidden className="flex size-12 shrink-0 items-center justify-center rounded-full bg-[linear-gradient(135deg,#ad46ff_0%,#4f39f6_100%)] text-base font-semibold text-white">
            {initials(s.user.name)}
          </span>
          <div className="flex min-w-0 flex-1 flex-col">
            <p className="text-base leading-6 font-semibold text-[#e5e7eb]">{s.user.name}</p>
            <p className="text-sm leading-5 break-words text-[#9ca3af]">{s.name}</p>
            <div className="flex flex-wrap items-center gap-2 pt-1.5">
              <CheckInStatusBadge status={s.status} />
              <FrequencyBadge frequency={s.frequency} />
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 gap-3 pt-1 sm:grid-cols-3">
          <DetailTile label="Check-in Time">{s.time}</DetailTile>
          <DetailTile label="Last Check-in">{s.lastCheckIn}</DetailTile>
          <DetailTile label="Next Check-in">{s.nextCheckIn}</DetailTile>
        </div>

        {s.methods.length > 0 && (
          <div className="flex flex-wrap gap-2">
            {s.methods.includes("biometric") && (
              <span className="inline-flex items-center gap-1.5 rounded-[18px] border border-[#ad46ff]/20 bg-[#c27aff]/10 px-3 py-1.5 text-xs leading-4 text-[#dab2ff]">
                <Fingerprint className="size-3.5" /> Biometric Required
              </span>
            )}
            {s.methods.includes("selfie") && (
              <span className="inline-flex items-center gap-1.5 rounded-[18px] border border-[#2b7fff]/20 bg-[#51a2ff]/10 px-3 py-1.5 text-xs leading-4 text-[#8ec5ff]">
                <Camera className="size-3.5" /> Selfie Required
              </span>
            )}
          </div>
        )}

        <div className="flex flex-col gap-3">
          <h4 className="text-sm leading-5 font-semibold text-[#e5e7eb]">Completed Check-ins</h4>
          {error ? (
            <p role="alert" className="text-sm text-red-300">
              Couldn&apos;t load check-ins. {error.message}
            </p>
          ) : loading || !data ? (
            [0, 1, 2].map((i) => <div key={i} className="h-14 animate-pulse rounded-[18px] bg-white/5" />)
          ) : data.history.length === 0 ? (
            <p className="rounded-[18px] bg-white/10 px-4 py-6 text-center text-sm text-[#9ca3af]">No check-ins completed yet.</p>
          ) : (
            <ul className="flex max-h-[196px] flex-col gap-2 overflow-y-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
              {data.history.map((h) => (
                <li key={h.id} className="flex items-center gap-3 rounded-[18px] bg-white/10 p-3">
                  {h.verified ? <CircleCheck className="size-4 shrink-0 text-[#05df72]" /> : <TriangleAlert className="size-4 shrink-0 text-[#ff6467]" />}
                  <div className="min-w-0 flex-1">
                    <p className="text-xs leading-4 font-medium text-[#e5e7eb]">{h.time}</p>
                    <p className="text-xs leading-4 break-words text-[#9ca3af]">{h.detail}</p>
                  </div>
                  <span className={`shrink-0 text-xs leading-4 ${h.verified ? "text-[#05df72]" : "text-[#ff6467]"}`}>{h.verified ? "Verified" : "Not verified"}</span>
                </li>
              ))}
            </ul>
          )}
        </div>

        <div className="flex gap-3 pt-2">
          <button type="button" onClick={onClose} className={BTN_OUTLINE}>
            Close
          </button>
          <button type="button" onClick={onEdit} className={BTN_SUBMIT}>
            Edit Schedule
          </button>
        </div>
      </div>
    </Modal>
  );
}
