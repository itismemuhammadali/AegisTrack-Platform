import { Briefcase } from "lucide-react";
import type { CaseRecord } from "@/types/case";
import { AssignedUserChips, CaseStatusBadge, LegalHoldBadge } from "./CaseBadges";
import { CaseRowActions } from "./CaseRowActions";

const HEADERS = ["Case", "Assigned Users", "Status", "Created", "Legal Hold", ""];

function CaseTitle({ record }: { record: CaseRecord }) {
  return (
    <div className="flex min-w-0 items-center gap-3">
      <span className="flex size-9 shrink-0 items-center justify-center rounded-full bg-white/10 text-white">
        <Briefcase className="size-4" />
      </span>
      <div className="min-w-0">
        <p className="text-sm leading-5 font-medium text-white">{record.title}</p>
        <p className="text-xs leading-4 text-[#9ca3af]">{record.number}</p>
      </div>
    </div>
  );
}

interface CaseTableProps {
  cases: CaseRecord[];
  loading: boolean;
  onOpen: (record: CaseRecord) => void;
}

export function CaseTable({ cases, loading, onOpen }: CaseTableProps) {
  if (loading) return <p className="py-8 text-center text-sm text-[#9ca3af]">Loading cases…</p>;
  if (cases.length === 0) return <p className="py-8 text-center text-sm text-[#9ca3af]">No cases found.</p>;

  return (
    <>
      {/* lg+: table */}
      <div className="hidden lg:block">
        <table className="w-full table-fixed text-left">
          <colgroup>
            <col className="w-[35%]" />
            <col className="w-[20%]" />
            <col className="w-[11%]" />
            <col className="w-[11%]" />
            <col className="w-[15%]" />
            <col className="w-[8%]" />
          </colgroup>
          <thead>
            <tr className="border-b border-white/10">
              {HEADERS.map((h, i) => (
                <th key={i} className="px-4 pt-2 pb-3 text-xs leading-4 font-medium tracking-[0.6px] text-[#9ca3af] uppercase">
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {cases.map((c) => (
              <tr key={c.id} className="border-b border-white/10 last:border-0">
                <td className="px-4 py-4">
                  <CaseTitle record={c} />
                </td>
                <td className="px-4 py-4">
                  <AssignedUserChips users={c.assignedUsers} />
                </td>
                <td className="px-4 py-4">
                  <CaseStatusBadge status={c.status} />
                </td>
                <td className="px-4 py-4 text-sm leading-5 text-[#9ca3af]">{c.createdAt}</td>
                <td className="px-4 py-4">
                  <LegalHoldBadge active={c.legalHold} />
                </td>
                <td className="px-4 py-4 text-center">
                  <CaseRowActions record={c} onOpen={onOpen} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* < lg: cards */}
      <ul className="flex flex-col gap-3 lg:hidden">
        {cases.map((c) => (
          <li key={c.id} className="flex flex-col gap-3 rounded-[18px] border border-white/10 p-4">
            <div className="flex items-start justify-between gap-2">
              <CaseTitle record={c} />
              <CaseRowActions record={c} onOpen={onOpen} />
            </div>
            <AssignedUserChips users={c.assignedUsers} />
            <div className="flex flex-wrap items-center gap-2">
              <CaseStatusBadge status={c.status} />
              <LegalHoldBadge active={c.legalHold} />
              <span className="ml-auto text-xs leading-4 text-[#9ca3af]">{c.createdAt}</span>
            </div>
          </li>
        ))}
      </ul>
    </>
  );
}
