import { EVENT_STATUS_LABELS, SEVERITY_LABELS, type SecurityEventStatus, type SecuritySeverity } from "@/types/security";

const TAG = "inline-flex items-center rounded-full px-2 py-0.5 text-xs leading-4 whitespace-nowrap";

const RED = "bg-[#fb2c36]/20 text-[#ff6467]";
const ORANGE = "bg-[#ff6900]/20 text-[#ff8904]";
const YELLOW = "bg-[#f0b100]/20 text-[#fdc700]";
const BLUE = "bg-[#2b7fff]/20 text-[#51a2ff]";
const GREEN = "bg-[#00c950]/20 text-[#05df72]";

const SEVERITY: Record<SecuritySeverity, string> = { critical: RED, high: ORANGE, medium: YELLOW, low: BLUE };
const STATUS: Record<SecurityEventStatus, string> = { active: RED, investigating: YELLOW, flagged: ORANGE, resolved: GREEN };

export function SeverityTag({ severity }: { severity: SecuritySeverity }) {
  return <span className={`${TAG} ${SEVERITY[severity]}`}>{SEVERITY_LABELS[severity]}</span>;
}

export function EventStatusTag({ status }: { status: SecurityEventStatus }) {
  return <span className={`${TAG} ${STATUS[status]}`}>{EVENT_STATUS_LABELS[status]}</span>;
}
