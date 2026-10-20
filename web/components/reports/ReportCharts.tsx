"use client";

import type { ReactElement, ReactNode } from "react";
import { Bar, BarChart, CartesianGrid, Cell, Legend, Line, LineChart, Pie, PieChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";
import type { AuthPoint, ExportPoint, RoleSlice, SecurityPoint, SyncPoint, WeeklyActivityPoint } from "@/types/report";

const AXIS = { stroke: "rgba(255,255,255,0.6)", tick: { fill: "#9ca3af", fontSize: 11 }, tickLine: true } as const;
const GRID = <CartesianGrid strokeDasharray="3 3" stroke="rgba(0,201,80,0.15)" />;
const TOOLTIP = {
  contentStyle: { background: "#0c1227", border: "1px solid rgba(255,255,255,0.1)", borderRadius: 12, color: "#e5e7eb", fontSize: 12 },
  labelStyle: { color: "#9ca3af" },
  itemStyle: { color: "#e5e7eb" },
} as const;
const LEGEND = { wrapperStyle: { paddingTop: 12 }, formatter: (v: string, e: { color?: string }) => <span style={{ color: e.color }}>{v}</span> };
const MARGIN = { top: 8, right: 8, left: -12, bottom: 0 };

export const COLORS = { purple: "#8e51ff", cyan: "#00b8db", green: "#10b981", red: "#ef4444", orange: "#f59e0b", yellow: "#fdc700" };

export function ChartCard({ title, subtitle, children, className = "" }: { title: string; subtitle: string; children: ReactNode; className?: string }) {
  return (
    <section className={`flex min-w-0 flex-col rounded-[18px] border border-white/20 bg-black p-4 sm:p-6 ${className}`}>
      <h3 className="text-base leading-6 font-semibold text-white">{title}</h3>
      <p className="text-xs leading-4 text-[#9ca3af]">{subtitle}</p>
      {children}
    </section>
  );
}

function Frame({ children, height = 280 }: { children: ReactElement; height?: number }) {
  return (
    <div className="mt-5 w-full" style={{ height }}>
      <ResponsiveContainer width="100%" height="100%">
        {children}
      </ResponsiveContainer>
    </div>
  );
}

export function WeeklyActivityChart({ data }: { data: WeeklyActivityPoint[] }) {
  return (
    <Frame height={250}>
      <LineChart data={data} margin={MARGIN}>
        {GRID}
        <XAxis dataKey="day" {...AXIS} />
        <YAxis ticks={[0, 45, 90, 135, 180]} domain={[0, 180]} {...AXIS} />
        <Tooltip {...TOOLTIP} />
        <Legend {...LEGEND} itemSorter={null} />
        <Line type="monotone" dataKey="activeUsers" name="Active Users" stroke={COLORS.purple} strokeWidth={2} dot={{ r: 3, fill: "#fff", stroke: COLORS.purple }} />
        <Line type="monotone" dataKey="exports" name="Exports" stroke={COLORS.cyan} strokeWidth={2} dot={{ r: 3, fill: "#fff", stroke: COLORS.cyan }} />
      </LineChart>
    </Frame>
  );
}

const ROLE_COLORS = [COLORS.purple, COLORS.cyan, COLORS.green];

export function RoleDistributionChart({ data }: { data: RoleSlice[] }) {
  return (
    <>
      <Frame height={210}>
        <PieChart>
          <Tooltip {...TOOLTIP} />
          <Pie data={data} dataKey="count" nameKey="role" innerRadius="58%" outerRadius="95%" stroke="#fff" strokeWidth={1} startAngle={90} endAngle={-270}>
            {data.map((d, i) => (
              <Cell key={d.role} fill={ROLE_COLORS[i % ROLE_COLORS.length]} />
            ))}
          </Pie>
        </PieChart>
      </Frame>
      <ul className="mt-4 flex flex-wrap justify-center gap-x-4 gap-y-1">
        {data.map((d, i) => (
          <li key={d.role} className="flex items-center gap-1.5 text-xs leading-4 text-[#9ca3af]">
            <span className="size-2 rounded-full" style={{ background: ROLE_COLORS[i % ROLE_COLORS.length] }} />
            {d.role}: {d.count}
          </li>
        ))}
      </ul>
    </>
  );
}

function Bars<T extends { day: string }>({ data, series, ticks }: { data: T[]; series: { key: keyof T & string; name: string; color: string }[]; ticks: number[] }) {
  return (
    <Frame>
      <BarChart data={data} margin={MARGIN} barGap={4}>
        {GRID}
        <XAxis dataKey="day" {...AXIS} />
        <YAxis ticks={ticks} domain={[0, ticks[ticks.length - 1]]} {...AXIS} />
        <Tooltip {...TOOLTIP} cursor={{ fill: "rgba(255,255,255,0.05)" }} />
        <Legend {...LEGEND} iconType="square" itemSorter={null} />
        {series.map((s) => (
          <Bar key={s.key} dataKey={s.key as string} name={s.name} fill={s.color} radius={[4, 4, 0, 0]} />
        ))}
      </BarChart>
    </Frame>
  );
}

export const AuthenticationChart = ({ data }: { data: AuthPoint[] }) => (
  <Bars data={data} ticks={[0, 40, 80, 120, 160]} series={[{ key: "successful", name: "Successful", color: COLORS.green }, { key: "failed", name: "Failed", color: COLORS.red }]} />
);

export const ExportVolumeChart = ({ data }: { data: ExportPoint[] }) => (
  <Bars data={data} ticks={[0, 7, 14, 21, 28]} series={[{ key: "exports", name: "Exports", color: COLORS.purple }]} />
);

export const SecurityEventsChart = ({ data }: { data: SecurityPoint[] }) => (
  <Bars data={data} ticks={[0, 7, 14, 21, 28]} series={[{ key: "events", name: "Security Events", color: COLORS.red }]} />
);

export const SyncPerformanceChart = ({ data }: { data: SyncPoint[] }) => (
  <Bars
    data={data}
    ticks={[0, 150, 300, 450, 600]}
    series={[
      { key: "success", name: "Success", color: COLORS.green },
      { key: "failed", name: "Failed", color: COLORS.red },
      { key: "pending", name: "Pending", color: COLORS.orange },
    ]}
  />
);
