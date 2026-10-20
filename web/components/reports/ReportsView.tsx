"use client";

import { useState } from "react";
import {
  Calendar,
  Download,
  FileText,
  LogIn,
  Mail,
  RefreshCw,
  Shield,
  Sheet,
  TrendingUp,
  type LucideIcon,
} from "lucide-react";
import { useAsync } from "@/hooks/useAsync";
import { reportService } from "@/services/reportService";
import { REPORT_FORMAT_LABELS, REPORT_TAB_LABELS, type ReportFormat, type ReportKind, type ReportKpi, type ReportTab } from "@/types/report";
import {
  AuthenticationChart,
  ChartCard,
  ExportVolumeChart,
  RoleDistributionChart,
  SecurityEventsChart,
  SyncPerformanceChart,
  WeeklyActivityChart,
} from "./ReportCharts";

const KIND_ICON: Record<ReportKind, LucideIcon> = {
  user_activity: TrendingUp,
  authentication: LogIn,
  export_activity: Download,
  security: Shield,
  sync_performance: RefreshCw,
  platform_usage: Calendar,
};

const KPI_ICON: Record<ReportKpi["key"], LucideIcon> = { total: FileText, avg_export_time: TrendingUp, this_month: Calendar, success_rate: TrendingUp };
const FORMAT_ICON: Record<ReportFormat, LucideIcon> = { pdf: FileText, sheet: Sheet, email: Mail };
const TABS = Object.keys(REPORT_TAB_LABELS) as ReportTab[];

function KpiCard({ kpi }: { kpi: ReportKpi }) {
  const Icon = KPI_ICON[kpi.key];
  // Lower export time is better, but Figma colours by sign: +green / −red.
  const up = kpi.change >= 0;
  return (
    <div className="flex flex-col rounded-[18px] border border-white/10 bg-black p-4">
      <div className="flex items-start justify-between">
        <Icon className="size-5 text-white" />
        <span className={`text-xs leading-4 ${up ? "text-[#05df72]" : "text-[#ff6467]"}`}>
          {up ? "+" : ""}
          {kpi.change}%
        </span>
      </div>
      <p className="pt-3 text-2xl leading-8 font-semibold text-white">{kpi.value}</p>
      <p className="pt-1 text-xs leading-4 text-white">{kpi.label}</p>
    </div>
  );
}

/** Reports & Analytics — Figma 987:2 / 987:485 / 987:953 / 987:1847 (same for Admin & Super Admin). */
export function ReportsView() {
  const [tab, setTab] = useState<ReportTab>("user_activity");
  const [format, setFormat] = useState<ReportFormat>("pdf");
  const [busy, setBusy] = useState<ReportKind | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const { data, loading, error } = useAsync(() => reportService.overview(), []);
  const available = useAsync(() => reportService.available(), []);

  async function generate(kind: ReportKind, title: string) {
    setBusy(kind);
    setNotice(null);
    try {
      const { downloadUrl } = await reportService.generate(kind, format);
      if (downloadUrl) window.open(downloadUrl, "_blank", "noopener");
      setNotice(format === "email" ? `${title} will be emailed to you shortly.` : `${title} (${REPORT_FORMAT_LABELS[format]}) is ready.`);
    } catch (e) {
      setNotice(`Couldn't generate ${title}: ${e instanceof Error ? e.message : "unknown error"}`);
    } finally {
      setBusy(null);
    }
  }

  const exportLabel = format === "email" ? "Email Report" : `Export ${REPORT_FORMAT_LABELS[format]}`;
  const ExportIcon = format === "email" ? Mail : Download;

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-white">Reports &amp; Analytics</h1>
          <p className="pt-1 text-sm leading-5 text-white">Platform usage and performance insights</p>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <div role="radiogroup" aria-label="Export format" className="flex gap-1 rounded-[14px] border border-white/10 bg-black p-1">
            {(Object.keys(REPORT_FORMAT_LABELS) as ReportFormat[]).map((f) => {
              const Icon = FORMAT_ICON[f];
              const active = f === format;
              return (
                <button
                  key={f}
                  type="button"
                  role="radio"
                  aria-checked={active}
                  onClick={() => setFormat(f)}
                  className={`flex cursor-pointer items-center gap-1 rounded-[10px] px-3 py-1.5 text-xs leading-4 transition ${active ? "bg-[#34206c] text-white" : "text-[#9ca3af] hover:text-white"}`}
                >
                  <Icon className="size-3" /> {REPORT_FORMAT_LABELS[f]}
                </button>
              );
            })}
          </div>
          <button
            type="button"
            onClick={() => generate(tab, REPORT_TAB_LABELS[tab])}
            disabled={busy !== null}
            className="flex cursor-pointer items-center gap-2 rounded-[14px] bg-[#34206c] px-3 py-2 text-base leading-6 font-medium text-white shadow-[0_10px_15px_rgba(52,32,108,0.2),0_4px_6px_rgba(52,32,108,0.2)] transition hover:bg-[#3f2785] disabled:cursor-wait disabled:opacity-70"
          >
            <ExportIcon className="size-4" />
            {busy === tab ? "Generating…" : exportLabel}
          </button>
        </div>
      </div>

      {notice && (
        <p role="status" className="rounded-[14px] border border-white/10 bg-white/5 px-4 py-2.5 text-sm text-[#d1d5dc]">
          {notice}
        </p>
      )}

      {error && (
        <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
          Couldn&apos;t load reports. {error.message}
        </p>
      )}

      <div className="grid grid-cols-2 gap-4 xl:grid-cols-4 xl:gap-6">
        {(data?.kpis ?? []).map((k) => (
          <KpiCard key={k.key} kpi={k} />
        ))}
      </div>

      <div role="tablist" aria-label="Report type" className="flex gap-2 overflow-x-auto rounded-[14px] border border-white/10 bg-black p-1 [scrollbar-width:none]">
        {TABS.map((t) => {
          const Icon = KIND_ICON[t];
          const active = t === tab;
          return (
            <button
              key={t}
              type="button"
              role="tab"
              aria-selected={active}
              onClick={() => setTab(t)}
              className={`flex shrink-0 cursor-pointer items-center gap-1.5 rounded-[10px] px-3 py-2 text-xs leading-4 font-medium whitespace-nowrap transition ${active ? "bg-[#34206c] text-white" : "text-[#9ca3af] hover:text-white"}`}
            >
              <Icon className="size-3.5" /> {REPORT_TAB_LABELS[t]}
            </button>
          );
        })}
      </div>

      {loading || !data ? (
        <p className="py-10 text-center text-sm text-[#9ca3af]">Loading report…</p>
      ) : tab === "user_activity" ? (
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
          <ChartCard title="Weekly Activity Overview" subtitle="User engagement and system usage">
            <WeeklyActivityChart data={data.weeklyActivity} />
          </ChartCard>
          <ChartCard title="User Role Distribution" subtitle="Breakdown by role type">
            <RoleDistributionChart data={data.roleDistribution} />
          </ChartCard>
        </div>
      ) : tab === "authentication" ? (
        <ChartCard title="Authentication Report" subtitle="Login success vs failure trend">
          <AuthenticationChart data={data.authentication} />
        </ChartCard>
      ) : tab === "export_activity" ? (
        <ChartCard title="Export Activity Report" subtitle="Export volume by type and format">
          <ExportVolumeChart data={data.exportActivity} />
        </ChartCard>
      ) : tab === "security" ? (
        <ChartCard title="Security Report" subtitle="Security events and threat indicators">
          <SecurityEventsChart data={data.security} />
        </ChartCard>
      ) : (
        <ChartCard title="Sync Performance Report" subtitle="Successful, failed, and pending sync events">
          <SyncPerformanceChart data={data.syncPerformance} />
        </ChartCard>
      )}

      <section className="rounded-[18px] border border-white/10 bg-black p-4 sm:p-6">
        <h2 className="text-base leading-6 font-semibold text-white">Available Reports</h2>
        <ul className="grid grid-cols-1 gap-3 pt-5 md:grid-cols-2">
          {(available.data ?? []).map((r) => {
            const Icon = KIND_ICON[r.kind];
            return (
              <li key={r.kind}>
                <button
                  type="button"
                  onClick={() => generate(r.kind, r.title)}
                  disabled={busy !== null}
                  className="flex w-full cursor-pointer items-center gap-4 rounded-[14px] border border-white/10 p-4 text-left transition hover:border-white/20 hover:bg-white/5 disabled:cursor-wait"
                >
                  <span className="flex size-10 shrink-0 items-center justify-center rounded-[10px] bg-[#34206c]/30 text-[#4f39f6]">
                    {busy === r.kind ? <RefreshCw className="size-4 animate-spin" /> : <Icon className="size-4" />}
                  </span>
                  <span className="min-w-0">
                    <span className="block text-sm leading-5 font-medium text-white">{r.title}</span>
                    <span className="block text-xs leading-4 text-[#9ca3af]">
                      {r.description} · {r.range}
                    </span>
                  </span>
                </button>
              </li>
            );
          })}
        </ul>
      </section>
    </div>
  );
}
