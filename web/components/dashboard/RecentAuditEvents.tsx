import { Clock, Shield } from "lucide-react";
import { Badge } from "@/components/ui/Badge";
import { Panel } from "@/components/ui/Panel";
import type { AuditEvent } from "@/types/dashboard";

export function RecentAuditEvents({ events }: { events: AuditEvent[] }) {
  return (
    <Panel
      title="Recent Audit Events"
      subtitle="Latest security and access changes"
      action={<Shield className="size-5 text-[#e5e7eb]" strokeWidth={1.75} />}
    >
      {/* Horizontal scroll keeps the 5-column layout readable below ~760px */}
      <div className="-mx-4 mt-4 overflow-x-auto px-4 sm:-mx-6 sm:px-6">
        <table className="w-full min-w-[720px] border-collapse text-left">
          <thead>
            <tr className="border-b border-white/10 text-xs leading-4 font-medium text-[#9ca3af]">
              <th className="w-[24%] pb-3 font-medium">Event</th>
              <th className="w-[27%] pb-3 font-medium">User</th>
              <th className="w-[20%] pb-3 font-medium">Category</th>
              <th className="w-[14%] pb-3 font-medium">Time</th>
              <th className="pb-3 font-medium">Status</th>
            </tr>
          </thead>
          <tbody>
            {events.map((e) => (
              <tr key={e.id} className="h-[49px] border-b border-white/10 last:border-0">
                <td className="text-sm leading-5 text-[#e5e7eb]">{e.event}</td>
                <td className="max-w-0 truncate pr-4 text-xs leading-4 text-[#9ca3af]">{e.user}</td>
                <td>
                  <Badge>{e.category}</Badge>
                </td>
                <td>
                  <span className="flex items-center gap-1 text-xs leading-4 text-[#9ca3af]">
                    <Clock className="size-3" />
                    {e.time}
                  </span>
                </td>
                <td>
                  {e.status === "success" ? (
                    <Badge className="!bg-white/20 !text-[#05df72]">Success</Badge>
                  ) : (
                    <Badge tone="red">Failed</Badge>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </Panel>
  );
}
