import {
  ESCALATION_CATEGORY_LABELS,
  ESCALATION_SEVERITY_LABELS,
  ESCALATION_STATUS_LABELS,
  type EscalationCategory,
  type EscalationSeverity,
  type EscalationStatus,
} from "@/types/escalation";

/** Category tint — also used for the row's icon circle. */
export const CATEGORY_TONE: Record<EscalationCategory, string> = {
  security: "bg-[#ff6467]/10 text-[#ff6467]",
  legal: "bg-[#c27aff]/10 text-[#c27aff]",
  compliance: "bg-[#ff8904]/10 text-[#ff8904]",
  permission: "bg-[#fdc700]/10 text-[#fdc700]",
  technical: "bg-[#51a2ff]/10 text-[#51a2ff]",
};

const SEVERITY_TONE: Record<EscalationSeverity, string> = {
  critical: "border-[#fb2c36]/30 bg-[#ff6467]/20 text-[#ff6467]",
  high: "border-[#ff6900]/30 bg-[#ff8904]/20 text-[#ff8904]",
  medium: "border-[#f0b100]/30 bg-[#fdc700]/20 text-[#fdc700]",
};

const STATUS_TONE: Record<EscalationStatus, string> = {
  open: "border-[#2b7fff]/20 bg-[#51a2ff]/10 text-[#51a2ff]",
  under_review: "border-[#f0b100]/20 bg-[#fdc700]/10 text-[#fdc700]",
  resolved: "border-[#00c950]/20 bg-[#05df72]/10 text-[#05df72]",
};

const PILL = "inline-block rounded-full px-2 py-0.5 text-xs leading-4 whitespace-nowrap";

export function CategoryBadge({ category }: { category: EscalationCategory }) {
  return <span className={`${PILL} font-medium ${CATEGORY_TONE[category]}`}>{ESCALATION_CATEGORY_LABELS[category]}</span>;
}

export function SeverityBadge({ severity }: { severity: EscalationSeverity }) {
  return <span className={`${PILL} border font-bold ${SEVERITY_TONE[severity]}`}>{ESCALATION_SEVERITY_LABELS[severity]}</span>;
}

export function EscalationStatusBadge({ status }: { status: EscalationStatus }) {
  return <span className={`${PILL} border ${STATUS_TONE[status]}`}>{ESCALATION_STATUS_LABELS[status]}</span>;
}
