import { FileSpreadsheet, LogIn, type LucideIcon, RefreshCw, ShieldAlert, TriangleAlert, UserPlus } from "lucide-react";
import { Badge } from "@/components/ui/Badge";
import { Panel } from "@/components/ui/Panel";
import type { ActivityEvent, ActivityType } from "@/types/dashboard";

const TYPE_STYLES: Record<ActivityType, { icon: LucideIcon; tile: string; color: string }> = {
  export: { icon: FileSpreadsheet, tile: "bg-[#51a2ff]/10", color: "text-[#51a2ff]" },
  security: { icon: ShieldAlert, tile: "bg-[#ff6467]/10", color: "text-[#ff6467]" },
  sync: { icon: RefreshCw, tile: "bg-[#fdc700]/10", color: "text-[#fdc700]" },
  login: { icon: LogIn, tile: "bg-[#05df72]/10", color: "text-[#05df72]" },
  access: { icon: UserPlus, tile: "bg-[#c27aff]/10", color: "text-[#c27aff]" },
  "failed-login": { icon: TriangleAlert, tile: "bg-[#ff8904]/10", color: "text-[#ff8904]" },
};

export function ActivityFeed({ events }: { events: ActivityEvent[] }) {
  return (
    <Panel
      title="Real-Time Activity Feed"
      subtitle="Live security and system events"
      action={
        <span className="flex items-center gap-1.5 text-xs leading-4 text-[#05df72]">
          <span className="size-2 animate-pulse rounded-full bg-[#05df72] opacity-70" />
          Live
        </span>
      }
    >
      <ul className="mt-4 flex max-h-[288px] flex-col gap-2.5 overflow-y-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden" aria-live="polite">
        {events.map((e) => {
          const { icon: Icon, tile, color } = TYPE_STYLES[e.type];
          return (
            <li key={e.id} className="flex items-start gap-3 rounded-[18px] bg-white/10 p-3">
              <span className={`flex size-8 shrink-0 items-center justify-center rounded-[14px] ${tile}`}>
                <Icon className={`size-4 ${color}`} />
              </span>
              <div className="min-w-0 flex-1">
                <p className="truncate text-xs leading-4 font-medium text-[#e5e7eb]">{e.title}</p>
                <p className="truncate pt-0.5 text-xs leading-4 text-[#9ca3af]">{e.actor}</p>
              </div>
              <div className="flex shrink-0 items-center gap-1.5">
                {e.severity && (
                  <Badge tone={e.severity === "critical" ? "red" : "yellow"} className={e.severity === "warning" ? "!bg-[#f0b100]/20" : ""}>
                    {e.severity === "critical" ? "Critical" : "Warning"}
                  </Badge>
                )}
                <span className="text-xs leading-4 whitespace-nowrap text-[#9ca3af]">{e.time}</span>
              </div>
            </li>
          );
        })}
      </ul>
    </Panel>
  );
}
