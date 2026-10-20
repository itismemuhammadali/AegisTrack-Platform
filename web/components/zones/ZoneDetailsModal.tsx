"use client";

import { DetailTile, Modal } from "@/components/ui/Modal";
import { BTN_SUBMIT } from "@/components/users/EditUserModal";
import { useAsync } from "@/hooks/useAsync";
import { zoneService } from "@/services/zoneService";
import { formatCoordinates, type Zone, type ZoneActivityKind } from "@/types/zone";
import { ZONE_TYPE_STYLE, ZoneStatusBadge, ZoneTypeBadge } from "./ZoneBadges";
import { MapPin } from "lucide-react";

const DOT: Record<ZoneActivityKind, string> = { entry: "bg-[#05df72]", exit: "bg-[#ff6467]", "check-in": "bg-[#51a2ff]" };
const BTN_OUTLINE = "h-11 flex-1 cursor-pointer rounded-[18px] border border-white/10 text-base font-medium text-[#e5e7eb] transition hover:bg-white/5";

/** "Zone Details" (Figma 618:1461) — opened from the row menu's View Details. */
export function ZoneDetailsModal({ zone, onClose, onEdit }: { zone: Zone; onClose: () => void; onEdit: () => void }) {
  const { data, loading, error } = useAsync(() => zoneService.get(zone.id), [zone.id]);
  const z = data ?? zone;

  return (
    <Modal title="Zone Details" onClose={onClose} width="max-w-[672px]">
      <div className="flex flex-col pt-1">
        <div className="flex gap-4 border-b border-white/10 pb-5">
          <span className={`flex size-12 shrink-0 items-center justify-center rounded-[18px] ${ZONE_TYPE_STYLE[z.type].iconBg}`}>
            <MapPin className="size-6" />
          </span>
          <div className="flex min-w-0 flex-1 flex-col">
            <h3 className="text-lg leading-7 font-semibold break-words text-[#e5e7eb]">{z.name}</h3>
            {z.description && <p className="text-sm leading-5 text-[#9ca3af]">{z.description}</p>}
            <div className="flex flex-wrap items-center gap-2 pt-2">
              <ZoneTypeBadge type={z.type} />
              <ZoneStatusBadge status={z.status} />
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 gap-4 pt-5 sm:grid-cols-3">
          <DetailTile label="Coordinates">{formatCoordinates(z.latitude, z.longitude)}</DetailTile>
          <DetailTile label="Assigned Users">{`${z.assignedUsers} ${z.assignedUsers === 1 ? "user" : "users"}`}</DetailTile>
          <DetailTile label="Last Activity">{z.lastActivity}</DetailTile>
        </div>

        <div className="flex flex-col gap-3 pt-5">
          <h4 className="text-sm leading-5 font-semibold text-[#e5e7eb]">Entry / Exit Activity</h4>
          {error ? (
            <p role="alert" className="text-sm text-red-300">
              Couldn&apos;t load activity. {error.message}
            </p>
          ) : loading || !data ? (
            [0, 1, 2].map((i) => <div key={i} className="h-10 animate-pulse rounded-[18px] bg-white/5" />)
          ) : data.activity.length === 0 ? (
            <p className="rounded-[18px] bg-white/10 px-4 py-6 text-center text-sm text-[#9ca3af]">No entry or exit activity yet.</p>
          ) : (
            <ul className="flex max-h-[196px] flex-col gap-2 overflow-y-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
              {data.activity.map((a) => (
                <li key={a.id} className="flex items-center gap-3 rounded-[18px] bg-white/10 p-3">
                  <span className={`size-2 shrink-0 rounded-full ${DOT[a.kind]}`} />
                  <p className="min-w-0 flex-1 text-xs leading-4 font-medium text-[#e5e7eb]">{a.label}</p>
                  <span className="shrink-0 text-xs leading-4 text-[#9ca3af]">{a.time}</span>
                </li>
              ))}
            </ul>
          )}
        </div>

        <div className="flex gap-3 pt-6">
          <button type="button" onClick={onClose} className={BTN_OUTLINE}>
            Close
          </button>
          <button type="button" onClick={onEdit} className={BTN_SUBMIT}>
            Edit Zone
          </button>
        </div>
      </div>
    </Modal>
  );
}
