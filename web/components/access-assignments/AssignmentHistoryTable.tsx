import { Clock } from "lucide-react";
import { Badge } from "@/components/ui/Badge";
import type { AssignmentHistoryEntry } from "@/types/accessAssignment";

const ACTION = {
  assigned: { label: "Viewer assigned", tone: "green" },
  removed: { label: "Viewer removed", tone: "red" },
} as const;

const HEADERS = ["Action", "Tracked User", "Viewer", "Admin", "Time"];

function Time({ value }: { value: string }) {
  return (
    <span className="flex items-center gap-1 text-xs leading-4 whitespace-nowrap text-[#9ca3af]">
      <Clock className="size-3" />
      {value}
    </span>
  );
}

export function AssignmentHistoryTable({ entries, loading }: { entries: AssignmentHistoryEntry[]; loading: boolean }) {
  const empty = !loading && entries.length === 0;
  return (
    <section className="overflow-hidden rounded-[18px] border border-white/10 bg-black/60" aria-busy={loading}>
      {/* md+: table */}
      <table className="hidden w-full text-left md:table">
        <thead>
          <tr className="border-b border-white/10">
            {HEADERS.map((h) => (
              <th key={h} className="px-4 py-4 text-xs leading-4 font-medium text-[#9ca3af]">
                {h}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {entries.map((e) => (
            <tr key={e.id} className="border-b border-white/10 last:border-0">
              <td className="px-4 py-3">
                <Badge tone={ACTION[e.action].tone}>{ACTION[e.action].label}</Badge>
              </td>
              <td className="px-4 py-3 text-sm leading-5 text-[#e5e7eb]">{e.trackedUser}</td>
              <td className="px-4 py-3 text-sm leading-5 text-[#e5e7eb]">{e.viewer}</td>
              <td className="px-4 py-3 text-xs leading-4 text-[#9ca3af]">{e.admin}</td>
              <td className="px-4 py-3">
                <Time value={e.time} />
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* < md: stacked cards */}
      <ul className="divide-y divide-white/10 md:hidden">
        {entries.map((e) => (
          <li key={e.id} className="flex flex-col gap-2 p-4">
            <div className="flex items-center justify-between gap-2">
              <Badge tone={ACTION[e.action].tone}>{ACTION[e.action].label}</Badge>
              <Time value={e.time} />
            </div>
            <p className="text-sm leading-5 text-[#e5e7eb]">
              {e.viewer} <span className="text-[#9ca3af]">→</span> {e.trackedUser}
            </p>
            <p className="text-xs leading-4 text-[#9ca3af]">{e.admin}</p>
          </li>
        ))}
      </ul>

      {empty && <p className="p-6 text-center text-sm text-[#9ca3af]">No assignment history yet.</p>}
    </section>
  );
}
