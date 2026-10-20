"use client";

import { useEffect, useState } from "react";
import { ChevronDown, CircleAlert, Eye, Flag, RefreshCw, Search, Shield } from "lucide-react";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { securityService } from "@/services/securityService";
import { userService } from "@/services/userService";
import {
  EVENT_STATUS_LABELS,
  EVENT_TYPE_LABELS,
  SEVERITY_LABELS,
  type SecurityEvent,
  type SecurityEventStatus,
  type SecurityEventType,
  type SecuritySeverity,
} from "@/types/security";
import { SecurityEventCard } from "./SecurityEventCard";
import { SecurityStatCard } from "./SecurityStatCard";
import { SyncFailureBanner } from "@/components/sync-failures/SyncFailureBanner";

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
      <select
        value={value}
        onChange={(e) => onChange(e.target.value as T | "all")}
        aria-label={label}
        className="h-9 w-full cursor-pointer appearance-none rounded-full border border-white/20 bg-white/5 pr-10 pl-6 text-sm text-[#9ca3af] outline-none transition-colors focus:border-white/40 [&>option]:bg-[#0c1227]"
      >
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

/** Same content for Admin (226:13552) and Super Admin (610:21494); only the sidebar differs. */
export function SecurityCenterView() {
  const [search, setSearch] = useState("");
  const [severity, setSeverity] = useState<SecuritySeverity | "all">("all");
  const [status, setStatus] = useState<SecurityEventStatus | "all">("all");
  const [type, setType] = useState<SecurityEventType | "all">("all");
  const debouncedSearch = useDebouncedValue(search, 250);
  const [version, setVersion] = useState(0);
  const [expandedId, setExpandedId] = useState<string | null>("e1");

  const { data, loading, error } = useAsync(
    () => securityService.list({ search: debouncedSearch, severity, status, type }),
    [debouncedSearch, severity, status, type, version],
  );
  const stats = useAsync(() => securityService.stats(), [version]);

  const [rows, setRows] = useState<SecurityEvent[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const refresh = () => setVersion((v) => v + 1);

  async function handleSetStatus(event: SecurityEvent, next: SecurityEventStatus) {
    await securityService.setStatus(event.id, next);
    refresh();
  }

  async function handleDisableUser(event: SecurityEvent) {
    if (!event.userId || !window.confirm(`Disable ${event.userEmail}? They will lose access until re-enabled.`)) return;
    await userService.setDisabled(event.userId, true);
    refresh();
  }

  const s = stats.data;
  const dash = "–";

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Security Center</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Monitor and respond to security threats and suspicious activity</p>
        </div>
        <button
          type="button"
          onClick={refresh}
          className="mt-2 flex cursor-pointer items-center gap-2 rounded-full border border-white/10 bg-black px-3 py-2 text-sm leading-5 font-medium text-white transition hover:bg-white/10"
        >
          <RefreshCw className={`size-4 ${loading ? "animate-spin" : ""}`} />
          Refresh
        </button>
      </div>

      <div className="grid grid-cols-2 gap-4 xl:grid-cols-4">
        <SecurityStatCard icon={CircleAlert} tone="red" value={s?.critical ?? dash} label="Critical Alerts" live={!!s?.critical} />
        <SecurityStatCard icon={Shield} tone="orange" value={s?.high ?? dash} label="High Severity" />
        <SecurityStatCard icon={Eye} tone="yellow" value={s?.active ?? dash} label="Active Events" />
        <SecurityStatCard icon={Flag} tone="purple" value={s?.open ?? dash} label="Open Events" />
      </div>

      <SyncFailureBanner count={s?.syncFailures ?? 0} onRetryAll={async () => { await securityService.retryAllSyncFailures(); refresh(); }} />

      <section className="flex flex-col gap-3 rounded-[18px] border border-white/10 bg-black/60 p-4">
        <label className="flex h-9 items-center gap-3 rounded-full border border-white/10 bg-white/10 px-4 focus-within:border-white/30">
          <Search className="size-4 shrink-0 text-[#9ca3af]" />
          <input
            type="search"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search events by user or description..."
            aria-label="Search events by user or description"
            className="w-full min-w-0 bg-transparent text-sm text-white outline-none placeholder:text-[#9ca3af]"
          />
        </label>
        <div className="flex flex-wrap gap-3">
          <PillSelect className="w-full sm:w-[150px]" label="Filter by severity" allLabel="All Severity" value={severity} onChange={setSeverity} options={SEVERITY_LABELS} />
          <PillSelect className="w-full sm:w-[150px]" label="Filter by status" allLabel="All Status" value={status} onChange={setStatus} options={EVENT_STATUS_LABELS} />
          <PillSelect className="w-full sm:w-[200px]" label="Filter by type" allLabel="All Type" value={type} onChange={setType} options={EVENT_TYPE_LABELS} />
        </div>
      </section>

      <div className="flex flex-col gap-3" aria-busy={loading}>
        {error && (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            Couldn&apos;t load security events. {error.message}
          </p>
        )}
        {!error && loading && rows.length === 0 && <p className="py-8 text-center text-sm text-[#9ca3af]">Loading events…</p>}
        {!error && !loading && rows.length === 0 && <p className="py-8 text-center text-sm text-[#9ca3af]">No security events match your filters.</p>}
        {rows.map((e) => (
          <SecurityEventCard
            key={e.id}
            event={e}
            expanded={expandedId === e.id}
            onToggle={() => setExpandedId((id) => (id === e.id ? null : e.id))}
            onSetStatus={(next) => handleSetStatus(e, next)}
            onDisableUser={() => handleDisableUser(e)}
          />
        ))}
      </div>
    </div>
  );
}
