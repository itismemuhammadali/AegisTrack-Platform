"use client";

import { useEffect, useRef, useState } from "react";
import { ChevronDown, RefreshCw, Search } from "lucide-react";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { syncFailureService } from "@/services/syncFailureService";
import { SYNC_STATUS_LABELS, type SyncFailure, type SyncFailureStatus } from "@/types/syncFailure";
import { SyncFailureBanner } from "./SyncFailureBanner";
import { SyncFailureDetails } from "./SyncFailureDetails";
import { SyncFailureTable } from "./SyncFailureTable";
import { SYNC_STATUS_STYLE } from "./SyncStatusBadge";

function SyncStatTile({ status, value }: { status: SyncFailureStatus; value: number | string }) {
  const { Icon, tile } = SYNC_STATUS_STYLE[status];
  return (
    <div className="flex flex-col rounded-[18px] border border-white/10 bg-black/60 p-4">
      <span className={`flex size-8 items-center justify-center rounded-full ${tile}`}>
        <Icon className="size-4" />
      </span>
      <p className="pt-3 text-xl leading-7 font-semibold text-white">{value}</p>
      <p className="pt-0.5 text-xs leading-4 text-[#d1d5dc]">{SYNC_STATUS_LABELS[status]}</p>
    </div>
  );
}

/** Same content for Admin (225:12235) and Super Admin (610:20945); only the sidebar differs. */
export function SyncFailureView() {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<SyncFailureStatus | "all">("all");
  const debouncedSearch = useDebouncedValue(search, 250);
  const [version, setVersion] = useState(0);
  const [selectedId, setSelectedId] = useState<string | null>("f1");
  const detailsRef = useRef<HTMLElement>(null);

  const { data, loading, error } = useAsync(() => syncFailureService.list({ search: debouncedSearch, status }), [debouncedSearch, status, version]);
  const stats = useAsync(() => syncFailureService.stats(), [version]);

  const [rows, setRows] = useState<SyncFailure[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const refresh = () => setVersion((v) => v + 1);
  const selected = rows.find((f) => f.id === selectedId) ?? null;

  function view(f: SyncFailure) {
    setSelectedId(f.id);
    requestAnimationFrame(() => detailsRef.current?.scrollIntoView({ behavior: "smooth", block: "start" }));
  }
  async function retry(f: SyncFailure) {
    await syncFailureService.retry(f.id);
    refresh();
  }
  async function resolve(f: SyncFailure) {
    await syncFailureService.resolve(f.id);
    refresh();
  }

  const s = stats.data;
  const dash = "–";

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Sync Failure Management</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Monitor and manage GPS data synchronization failures</p>
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
        <SyncStatTile status="failed" value={s?.failed ?? dash} />
        <SyncStatTile status="pending" value={s?.pending ?? dash} />
        <SyncStatTile status="retrying" value={s?.retrying ?? dash} />
        <SyncStatTile status="resolved" value={s?.resolved ?? dash} />
      </div>

      <SyncFailureBanner
        count={s?.failed ?? 0}
        onRetryAll={async () => {
          await syncFailureService.retryAll();
          refresh();
        }}
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:gap-3">
        <label className="flex h-[52px] min-w-0 flex-1 items-center gap-3 rounded-[18px] border border-white/20 bg-white/10 px-4 focus-within:border-white/40">
          <Search className="size-4 shrink-0 text-[#9ca3af]" />
          <input
            type="search"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search by user, error, or code..."
            aria-label="Search by user, error, or code"
            className="w-full min-w-0 bg-transparent text-sm text-white outline-none placeholder:text-[#9ca3af]"
          />
        </label>
        <div className="relative sm:w-[255px]">
          <select
            value={status}
            onChange={(e) => setStatus(e.target.value as SyncFailureStatus | "all")}
            aria-label="Filter by status"
            className="h-[52px] w-full cursor-pointer appearance-none rounded-[18px] border border-white/20 bg-white/10 px-3 text-sm text-[#9ca3af] outline-none transition-colors focus:border-white/40 [&>option]:bg-[#0c1227]"
          >
            <option value="all">All Status</option>
            {Object.entries(SYNC_STATUS_LABELS).map(([v, l]) => (
              <option key={v} value={v}>
                {l}
              </option>
            ))}
          </select>
          <ChevronDown className="pointer-events-none absolute top-1/2 right-4 size-4 -translate-y-1/2 text-white" />
        </div>
      </div>

      <section className="overflow-hidden rounded-[18px] border border-white/10 bg-black/60">
        {error ? (
          <p role="alert" className="m-4 rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            Couldn&apos;t load sync failures. {error.message}
          </p>
        ) : (
          <SyncFailureTable failures={rows} loading={loading && rows.length === 0} onView={view} onRetry={retry} onResolve={resolve} />
        )}
      </section>

      {selected && (
        <SyncFailureDetails
          ref={detailsRef}
          failure={selected}
          onClose={() => setSelectedId(null)}
          onRetry={() => retry(selected)}
          onResolve={() => resolve(selected)}
        />
      )}
    </div>
  );
}
