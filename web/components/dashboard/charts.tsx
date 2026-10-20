"use client";

import { Area, AreaChart, Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import { Panel } from "@/components/ui/Panel";
import type { ChartPoint } from "@/types/dashboard";

const AXIS = {
  stroke: "rgba(255,255,255,0.3)",
  tick: { fill: "#9ca3af", fontSize: 12 },
  tickLine: true,
} as const;

const TOOLTIP = {
  contentStyle: {
    background: "#0c1227",
    border: "1px solid rgba(255,255,255,0.1)",
    borderRadius: 12,
    color: "#e5e7eb",
    fontSize: 12,
  },
  labelStyle: { color: "#9ca3af" },
  itemStyle: { color: "#e5e7eb" },
} as const;

function ChartFrame({ children }: { children: React.ReactElement }) {
  return (
    <div className="mt-6 h-[240px] w-full sm:h-[260px]">
      <ResponsiveContainer width="100%" height="100%">
        {children}
      </ResponsiveContainer>
    </div>
  );
}

export function TrackingActivityChart({ data }: { data: ChartPoint[] }) {
  return (
    <Panel title="Tracking Activity" subtitle="Daily sessions and sync events">
      <ChartFrame>
        <AreaChart data={data} margin={{ top: 8, right: 8, left: -16, bottom: 0 }}>
          <defs>
            <linearGradient id="trackingFill" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="#8e51ff" stopOpacity={0.45} />
              <stop offset="100%" stopColor="#8e51ff" stopOpacity={0} />
            </linearGradient>
          </defs>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.08)" />
          <XAxis dataKey="label" {...AXIS} />
          <YAxis domain={[0, 80]} ticks={[0, 20, 40, 60, 80]} {...AXIS} />
          <Tooltip {...TOOLTIP} cursor={{ stroke: "rgba(255,255,255,0.2)" }} />
          <Area type="monotone" dataKey="value" name="Events" stroke="#a684ff" strokeWidth={2} fill="url(#trackingFill)" />
        </AreaChart>
      </ChartFrame>
    </Panel>
  );
}

export function ExportActivityChart({ data }: { data: ChartPoint[] }) {
  return (
    <Panel title="Export Activity" subtitle="Monthly export trends">
      <ChartFrame>
        <BarChart data={data} margin={{ top: 8, right: 8, left: -16, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.08)" />
          <XAxis dataKey="label" {...AXIS} />
          <YAxis domain={[0, 60]} ticks={[0, 15, 30, 45, 60]} allowDataOverflow={false} {...AXIS} />
          <Tooltip {...TOOLTIP} cursor={{ fill: "rgba(255,255,255,0.05)" }} />
          <Bar dataKey="value" name="Exports" fill="#00b8db" radius={[4, 4, 0, 0]} maxBarSize={64} />
        </BarChart>
      </ChartFrame>
    </Panel>
  );
}
