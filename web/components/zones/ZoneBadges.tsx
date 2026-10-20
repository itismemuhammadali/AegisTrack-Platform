import { CircleCheck, CircleX, MapPin } from "lucide-react";
import { ZONE_STATUS_LABELS, ZONE_TYPE_LABELS, type ZoneStatus, type ZoneType } from "@/types/zone";

const PILL = "inline-flex items-center gap-1.5 rounded-[14px] border px-2.5 py-1 text-xs leading-4 font-medium whitespace-nowrap";

export const ZONE_TYPE_STYLE: Record<ZoneType, { pill: string; iconBg: string; Icon: typeof MapPin }> = {
  allowed: { pill: "border-[#00c950]/30 bg-[#00c950]/10 text-[#05df72]", iconBg: "bg-[#00c950]/10 text-[#05df72]", Icon: CircleCheck },
  restricted: { pill: "border-[#fb2c36]/30 bg-[#fb2c36]/10 text-[#ff6467]", iconBg: "bg-[#fb2c36]/10 text-[#ff6467]", Icon: CircleX },
  checkin: { pill: "border-[#2b7fff]/30 bg-[#2b7fff]/10 text-[#51a2ff]", iconBg: "bg-[#2b7fff]/10 text-[#51a2ff]", Icon: MapPin },
};

export function ZoneTypeBadge({ type }: { type: ZoneType }) {
  const { pill, Icon } = ZONE_TYPE_STYLE[type];
  return (
    <span className={`${PILL} ${pill}`}>
      <Icon className="size-3" />
      {ZONE_TYPE_LABELS[type]}
    </span>
  );
}

const STATUS: Record<ZoneStatus, { cls: string; dot: string }> = {
  active: { cls: "border-[#00c950]/20 bg-[#00c950]/10 text-[#05df72]", dot: "bg-[#05df72]" },
  inactive: { cls: "border-white/20 bg-white/10 text-[#9ca3af]", dot: "bg-[#9ca3af]" },
};

export function ZoneStatusBadge({ status }: { status: ZoneStatus }) {
  const s = STATUS[status];
  return (
    <span className={`${PILL} ${s.cls}`}>
      <span className={`size-1.5 rounded-full ${s.dot}`} />
      {ZONE_STATUS_LABELS[status]}
    </span>
  );
}
