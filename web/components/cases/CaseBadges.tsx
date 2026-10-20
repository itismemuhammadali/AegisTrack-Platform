import { Lock } from "lucide-react";
import { CASE_STATUS_LABELS, type CaseStatus } from "@/types/case";

const PILL = "inline-flex items-center gap-1.5 rounded-[14px] border px-2.5 py-1 text-xs leading-4 font-medium whitespace-nowrap";

const STATUS: Record<CaseStatus, { cls: string; dot: string }> = {
  active: { cls: "border-[#00c950]/20 bg-[#00c950]/10 text-[#05df72]", dot: "bg-[#05df72]" },
  open: { cls: "border-[#2b7fff]/20 bg-[#2b7fff]/10 text-[#51a2ff]", dot: "bg-[#51a2ff]" },
  pending: { cls: "border-[#f0b100]/20 bg-[#f0b100]/10 text-[#fdc700]", dot: "bg-[#fdc700]" },
  closed: { cls: "border-white/20 bg-white/10 text-[#9ca3af]", dot: "bg-[#9ca3af]" },
};

export function CaseStatusBadge({ status }: { status: CaseStatus }) {
  const s = STATUS[status];
  return (
    <span className={`${PILL} ${s.cls}`}>
      <span className={`size-1.5 rounded-full ${s.dot}`} />
      {CASE_STATUS_LABELS[status]}
    </span>
  );
}

export function LegalHoldBadge({ active }: { active: boolean }) {
  if (!active) return <span className="text-xs leading-4 text-[#9ca3af]">None</span>;
  return (
    <span className={`${PILL} border-[#fb2c36]/40 bg-[#fb2c36]/20 font-semibold text-[#ff6467]`}>
      <Lock className="size-3" />
      Legal Hold
    </span>
  );
}

export function AssignedUserChips({ users }: { users: string[] }) {
  return (
    <div className="flex flex-wrap gap-1">
      {users.map((u) => (
        <span key={u} className="rounded-md bg-white/10 px-2 py-0.5 text-xs leading-4 whitespace-nowrap text-[#9ca3af]">
          {u}
        </span>
      ))}
    </div>
  );
}
