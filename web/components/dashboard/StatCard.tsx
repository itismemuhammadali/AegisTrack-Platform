import { Activity, Eye, type LucideIcon, TrendingDown, TrendingUp, TriangleAlert, Users } from "lucide-react";
import type { StatMetric } from "@/types/dashboard";

const STYLES: Record<StatMetric["id"], { icon: LucideIcon; card: string; iconColor: string }> = {
  trackedUsers: {
    icon: Users,
    card: "border-[#ad46ff]/20 bg-[linear-gradient(149deg,rgba(173,70,255,0.2)_0%,rgba(152,16,250,0.05)_100%)]",
    iconColor: "text-[#c27aff]",
  },
  authorizedViewers: {
    icon: Eye,
    card: "border-[#00b8db]/20 bg-[linear-gradient(149deg,rgba(0,184,219,0.2)_0%,rgba(0,146,184,0.05)_100%)]",
    iconColor: "text-[#00d3f2]",
  },
  activeSessions: {
    icon: Activity,
    card: "border-[#00c950]/20 bg-[linear-gradient(149deg,rgba(0,201,80,0.2)_0%,rgba(0,166,62,0.05)_100%)]",
    iconColor: "text-[#05df72]",
  },
  failedSyncs: {
    icon: TriangleAlert,
    card: "border-[#fb2c36]/20 bg-[linear-gradient(149deg,rgba(251,44,54,0.2)_0%,rgba(231,0,11,0.05)_100%)]",
    iconColor: "text-[#ff6467]",
  },
};

export function StatCard({ metric }: { metric: StatMetric }) {
  const { icon: Icon, card, iconColor } = STYLES[metric.id];
  const TrendIcon = metric.direction === "up" ? TrendingUp : TrendingDown;
  const trendColor = metric.trend === "positive" ? "text-[#05df72]" : "text-[#ff6467]";

  return (
    <div className={`flex min-w-0 flex-col gap-4 rounded-2xl border p-6 ${card}`}>
      <div className="flex items-start justify-between">
        <div className="flex size-11 items-center justify-center rounded-[18px] bg-[#001a27]/50">
          <Icon className={`size-5 ${iconColor}`} strokeWidth={1.75} />
        </div>
        <span className={`flex items-center gap-1 text-xs leading-4 font-medium ${trendColor}`}>
          <TrendIcon className="size-3" />
          {metric.change}
        </span>
      </div>
      <div className="flex flex-col gap-1">
        <p className="text-2xl leading-8 font-semibold text-[#e5e7eb]">{metric.value.toLocaleString("en-US")}</p>
        <p className="text-xs leading-4 text-[#9ca3af]">{metric.label}</p>
      </div>
    </div>
  );
}
