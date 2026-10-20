"use client";

import { useEffect, useState } from "react";
import { Calendar, ChevronDown, Download, Filter, Search } from "lucide-react";
import { Can } from "@/components/providers/Can";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { auditLogService } from "@/services/auditLogService";
import {
  AUDIT_SEVERITY_LABELS,
  AUDIT_TYPE_LABELS,
  type AuditEventType,
  type AuditLogEntry,
  type AuditSeverity,
  type AuditStatKey,
} from "@/types/auditLog";
import { AuditLogTable } from "./AuditLogTable";
import { AUDIT_TYPE_STYLE } from "./auditStyles";

const STAT_TILES: AuditStatKey[] = ["export", "login", "screenshot", "security", "sync", "permission", "admin"];

const PILL = "h-9 cursor-pointer appearance-none rounded-full border border-white/20 bg-white/5 px-4 text-sm text-[#9ca3af] outline-none transition-colors focus:border-white/40 [&>option]:bg-[#0c1227]";

function PillSelect<T extends string>({ value, onChange, label, allLabel, options, className = "" }: {
  value: T | "all";
  onChange: (v: T | "all") => void;
  label: string;
  allLabel: string;
  options: Record<T, string>;
  className?: string;
}) {
  return (
    <div className={`relative ${className}`}>
      <select value={value} onChange={(e) => onChange(e.target.value as T | "all")} aria-label={label} className={`${PILL} w-full pr-10`}>
        <option value="all">{allLabel}</option>
        {(Object.entries(options) as [T, string][]).map(([v, l]) => (
          <option key={v} value={v}>
            {l}
          </option>
        ))}
      </select>
      <ChevronDown className="pointer-events-none absolute top-1/2 right-4 size-4 -translate-y-1/2 text-white" />
    </div>
  );
}

function toCsv(entries: AuditLogEntry[]) {
  const esc = (v: string) => `"${v.replace(/"/g, '""')}"`;
  const header = ["Timestamp", "User", "Role", "Event", "Type", "Severity", "Device", "IP"];
  const lines = entries.map((e) =>
    [e.timestamp, e.user.name, e.user.role, e.event, AUDIT_TYPE_LABELS[e.type], AUDIT_SEVERITY_LABELS[e.severity], e.device, e.ip].map(esc).join(","),
  );
  return [header.join(","), ...lines].join("\n");
}

/** Same content for Admin (222:3900) and Super Admin (610:23396); only the sidebar differs. */
export function AuditLogView() {
  const [search, setSearch] = useState("");
  const [type, setType] = useState<AuditEventType | "all">("all");
  const [severity, setSeverity] = useState<AuditSeverity | "all">("all");
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const debouncedSearch = useDebouncedValue(search, 250);

  const { data, loading, error } = useAsync(
    () => auditLogService.list({ search: debouncedSearch, type, severity, from, to }),
    [debouncedSearch, type, severity, from, to],
  );
  const stats = useAsync(() => auditLogService.stats(), []);

  const [rows, setRows] = useState<AuditLogEntry[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const hasFilters = !!(search || from || to || type !== "all" || severity !== "all");
  function clearAll() {
    setSearch("");
    setType("all");
    setSeverity("all");
    setFrom("");
    setTo("");
  }

  function exportCsv() {
    const url = URL.createObjectURL(new Blob([toCsv(rows)], { type: "text/csv" }));
    const a = Object.assign(document.createElement("a"), { href: url, download: `audit-logs-${new Date().toISOString().slice(0, 10)}.csv` });
    a.click();
    URL.revokeObjectURL(url);
  }

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Audit Logs</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Comprehensive system activity monitoring</p>
        </div>
        <Can permission="exports.manage">
          <button
            type="button"
            onClick={exportCsv}
            disabled={rows.length === 0}
            className="flex cursor-pointer items-center gap-2 rounded-[14px] border border-white/10 bg-black px-4 py-2.5 text-base leading-6 font-medium text-white transition hover:bg-white/10 disabled:cursor-not-allowed disabled:opacity-50"
          >
            <Download className="size-4" />
            Export Logs
          </button>
        </Can>
      </div>

      <div className="grid grid-cols-2 gap-3 sm:grid-cols-4 xl:grid-cols-7">
        {STAT_TILES.map((key) => {
          const { Icon, tile, icon } = AUDIT_TYPE_STYLE[key];
          return (
            <div key={key} className={`flex flex-col rounded-[14px] border bg-gradient-to-br to-transparent p-3 ${tile}`}>
              <Icon className={`size-4 ${icon}`} />
              <p className="pt-2 text-lg leading-7 font-semibold text-white">{stats.data?.[key] ?? "–"}</p>
              <p className="pt-1 text-xs leading-4 text-[#9ca3af]">{AUDIT_TYPE_LABELS[key]}</p>
            </div>
          );
        })}
      </div>

      <section className="flex flex-col gap-3 rounded-[18px] border border-white/10 bg-black p-4">
        <header className="flex items-center justify-between">
          <h2 className="flex items-center gap-2 text-sm leading-5 font-medium text-white">
            <Filter className="size-4" /> Filters
          </h2>
          <button type="button" onClick={clearAll} disabled={!hasFilters} className="cursor-pointer text-xs leading-4 text-white transition hover:text-[#9ca3af] disabled:cursor-default disabled:opacity-50">
            Clear all
          </button>
        </header>
        <div className="flex flex-col gap-3 lg:flex-row">
          <label className="flex h-9 min-w-0 items-center gap-3 rounded-full border border-white/10 bg-white/10 px-4 focus-within:border-white/30 lg:flex-[1_1_0]">
            <Search className="size-4 shrink-0 text-[#9ca3af]" />
            <input
              type="search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search by user, activity, or IP..."
              aria-label="Search by user, activity, or IP"
              className="w-full min-w-0 bg-transparent text-sm text-white outline-none placeholder:text-[#9ca3af]"
            />
          </label>
          <div className="flex flex-col gap-3 sm:flex-row lg:w-[46%]">
            <PillSelect className="sm:flex-1" label="Filter by event type" allLabel="All Event Type" value={type} onChange={setType} options={AUDIT_TYPE_LABELS} />
            <PillSelect className="sm:flex-1" label="Filter by severity" allLabel="All Severity" value={severity} onChange={setSeverity} options={AUDIT_SEVERITY_LABELS} />
          </div>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Calendar className="size-4 text-[#9ca3af]" />
          <input type="date" value={from} max={to || undefined} onChange={(e) => setFrom(e.target.value)} aria-label="From date" className={`${PILL} w-[150px] [color-scheme:dark]`} />
          <span className="text-xs text-[#9ca3af]">to</span>
          <input type="date" value={to} min={from || undefined} onChange={(e) => setTo(e.target.value)} aria-label="To date" className={`${PILL} w-[150px] [color-scheme:dark]`} />
        </div>
      </section>

      <section className="overflow-hidden rounded-[18px] border border-white/10 bg-black/60">
        <p className="border-b border-white/10 px-4 py-4 text-sm leading-5 text-[#d1d5dc]">
          {rows.length} event{rows.length === 1 ? "" : "s"} found
        </p>
        {error ? (
          <p role="alert" className="m-4 rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            Couldn&apos;t load audit logs. {error.message}
          </p>
        ) : (
          <AuditLogTable entries={rows} loading={loading && rows.length === 0} />
        )}
      </section>
    </div>
  );
}
