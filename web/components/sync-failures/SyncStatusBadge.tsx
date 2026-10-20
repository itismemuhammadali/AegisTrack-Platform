import { CircleCheck, CircleX, Clock, Loader, type LucideIcon } from "lucide-react";
import { SYNC_STATUS_LABELS, type SyncFailureStatus } from "@/types/syncFailure";

export const SYNC_STATUS_STYLE: Record<SyncFailureStatus, { Icon: LucideIcon; pill: string; tile: string }> = {
  failed: { Icon: CircleX, pill: "border-[#fb2c36]/30 bg-[#fb2c36]/20 text-[#ff6467]", tile: "bg-[#fb2c36]/20 text-[#ff6467]" },
  pending: { Icon: Clock, pill: "border-[#f0b100]/30 bg-[#f0b100]/20 text-[#fdc700]", tile: "bg-[#f0b100]/20 text-[#fdc700]" },
  retrying: { Icon: Loader, pill: "border-[#2b7fff]/30 bg-[#2b7fff]/20 text-[#51a2ff]", tile: "bg-[#2b7fff]/20 text-[#51a2ff]" },
  resolved: { Icon: CircleCheck, pill: "border-[#00c950]/30 bg-[#00c950]/20 text-[#05df72]", tile: "bg-[#00c950]/20 text-[#05df72]" },
};

export function SyncStatusBadge({ status }: { status: SyncFailureStatus }) {
  const { Icon, pill } = SYNC_STATUS_STYLE[status];
  return (
    <span className={`inline-flex items-center gap-1.5 rounded-full border px-2 py-0.5 text-xs leading-5 whitespace-nowrap ${pill}`}>
      <Icon className="size-3" />
      {SYNC_STATUS_LABELS[status]}
    </span>
  );
}
