import Link from "next/link";
import { Briefcase, CircleArrowUp, Lock, TriangleAlert } from "lucide-react";
import { Badge } from "@/components/ui/Badge";
import { Panel } from "@/components/ui/Panel";
import type { CaseStatus, CaseSummary, EscalationPriority, EscalationStatus, EscalationSummary, Tone } from "@/types/dashboard";

const CASE_STATUS: Record<CaseStatus, { label: string; tone: Tone }> = {
  active: { label: "Active", tone: "green" },
  open: { label: "Open", tone: "blue" },
  pending: { label: "Pending", tone: "yellow" },
  closed: { label: "Closed", tone: "neutral" },
};

const PRIORITY: Record<EscalationPriority, { label: string; tone: Tone }> = {
  critical: { label: "Critical", tone: "red" },
  high: { label: "High", tone: "orange" },
  medium: { label: "Medium", tone: "yellow" },
};

const ESC_STATUS: Record<EscalationStatus, { label: string; tone: Tone }> = {
  "under-review": { label: "Under Review", tone: "yellow" },
  open: { label: "Open", tone: "blue" },
  resolved: { label: "Resolved", tone: "green" },
};

const ROW = "flex gap-3 rounded-[18px] bg-white/10 p-3 transition-colors hover:bg-white/[0.14]";

export function OpenCases({ cases }: { cases: CaseSummary[] }) {
  return (
    <Panel title="Open Cases" action={<Briefcase className="size-4 text-[#e5e7eb]" />} className="gap-4">
      <ul className="flex flex-col gap-2">
        {cases.map((c) => {
          const st = CASE_STATUS[c.status];
          return (
            <li key={c.id}>
              <Link href={`/cases/${c.id}`} className={`${ROW} items-center`}>
                <span className="flex size-8 shrink-0 items-center justify-center rounded-[14px] bg-white/10">
                  <Briefcase className="size-4 text-[#e5e7eb]" />
                </span>
                <div className="min-w-0 flex-1">
                  <p className="truncate text-xs leading-4 font-medium text-[#e5e7eb]">{c.title}</p>
                  <p className="truncate text-xs leading-4 text-white">{c.caseNumber}</p>
                </div>
                <div className="flex shrink-0 items-center gap-1.5">
                  {c.onHold && (
                    <span className="flex items-center gap-0.5 rounded-[10px] border border-[#fb2c36]/30 bg-[#fb2c36]/20 px-1.5 py-0.5 text-[10px] leading-[15px] font-bold text-[#ff6467]">
                      <Lock className="size-2.5" />
                      HOLD
                    </span>
                  )}
                  <Badge tone={st.tone}>{st.label}</Badge>
                </div>
              </Link>
            </li>
          );
        })}
      </ul>
    </Panel>
  );
}

export function Escalations({ items }: { items: EscalationSummary[] }) {
  return (
    <Panel title="Escalations" action={<CircleArrowUp className="size-4 text-[#ff6467]" />} className="gap-4">
      <ul className="flex flex-col gap-2">
        {items.map((e) => {
          const pr = PRIORITY[e.priority];
          const st = ESC_STATUS[e.status];
          return (
            <li key={e.id}>
              <Link href={`/escalations/${e.id}`} className={`${ROW} items-start`}>
                <span className="flex size-8 shrink-0 items-center justify-center rounded-[14px] bg-[#ff6467]/10">
                  <TriangleAlert className="size-4 text-[#ff6467]" />
                </span>
                <div className="min-w-0 flex-1">
                  <p className="truncate text-xs leading-4 font-medium text-[#e5e7eb]">{e.title}</p>
                  <div className="pt-0.5">
                    <Badge tone={pr.tone} size="sm">
                      {pr.label}
                    </Badge>
                  </div>
                </div>
                <Badge tone={st.tone} className="shrink-0">
                  {st.label}
                </Badge>
              </Link>
            </li>
          );
        })}
      </ul>
    </Panel>
  );
}
