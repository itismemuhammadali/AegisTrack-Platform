"use client";

import { useEffect, useState } from "react";
import {
  CircleCheck,
  CircleX,
  MapPin,
  Search,
  Wifi,
  type LucideIcon,
} from "lucide-react";
import { FilterSelect } from "@/components/ui/FilterSelect";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { trackingService } from "@/services/trackingService";
import {
  SYNC_STATUS_LABELS,
  type SyncStatus,
  type TrackingSync,
} from "@/types/tracking";
import { ActivityDetailsModal } from "./ActivityDetailsModal";
import { TrackingTable } from "./TrackingTable";

const TILE_TONES = {
  blue: "bg-[#2b7fff]/20 text-[#51a2ff]",
  green: "bg-[#00c950]/20 text-[#05df72]",
  red: "bg-[#fb2c36]/20 text-[#ff6467]",
  purple: "bg-[#ad46ff]/20 text-[#c27aff]",
} as const;

function Tile({
  icon: Icon,
  tone,
  value,
  label,
}: {
  icon: LucideIcon;
  tone: keyof typeof TILE_TONES;
  value: number | string;
  label: string;
}) {
  return (
    <div className="flex items-center gap-3 rounded-[18px] bg-black p-4">
      <span
        className={`flex size-10 shrink-0 items-center justify-center rounded-[10px] ${TILE_TONES[tone]}`}
      >
        <Icon className="size-5" />
      </span>
      <div className="min-w-0">
        <p className="text-2xl leading-7 font-semibold text-white">{value}</p>
        <p className="text-xs leading-4 text-[#9ca3af]">{label}</p>
      </div>
    </div>
  );
}

/** Same content for Admin (222:3535) and Super Admin (610:27491); only the sidebar differs. */
export function TrackingActivityView() {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<SyncStatus | "all">("all");
  const [viewing, setViewing] = useState<TrackingSync | null>(null);
  const debouncedSearch = useDebouncedValue(search, 250);

  const { data, loading, error } = useAsync(
    () => trackingService.list({ search: debouncedSearch, status }),
    [debouncedSearch, status],
  );
  const stats = useAsync(() => trackingService.stats(), []);

  const [rows, setRows] = useState<TrackingSync[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const s = stats.data;
  const dash = "–";

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div>
        <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">
          Tracking Activity
        </h1>
        <p className="pt-1 text-sm leading-5 text-[#9ca3af]">
          Real-time location sync monitoring
        </p>
      </div>

      <div className="grid grid-cols-2 gap-4 xl:grid-cols-4 xl:gap-5">
        <Tile
          icon={MapPin}
          tone="blue"
          value={s?.total ?? dash}
          label="Total Syncs"
        />
        <Tile
          icon={CircleCheck}
          tone="green"
          value={s?.successful ?? dash}
          label="Successful"
        />
        <Tile
          icon={CircleX}
          tone="red"
          value={s?.failed ?? dash}
          label="Failed"
        />
        <Tile
          icon={Wifi}
          tone="purple"
          value={s?.onlineUsers ?? dash}
          label="Online Users"
        />
      </div>

      <section className="flex flex-col gap-6 rounded-[18px] border border-white/10 bg-black p-4 sm:p-6">
        <div className="flex flex-col gap-3 sm:flex-row sm:gap-6">
          <label className="flex min-w-0 flex-1 items-center gap-4 rounded-[18px] border border-white/10 p-4 transition-colors focus-within:border-white/30">
            <Search className="size-5 shrink-0 text-white" strokeWidth={1.75} />
            <input
              type="search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search by user or location..."
              aria-label="Search by user or location"
              className="w-full min-w-0 bg-transparent text-base text-white outline-none placeholder:text-white"
            />
          </label>
          <FilterSelect
            label="Filter by status"
            allLabel="All Status"
            value={status}
            onChange={setStatus}
            options={SYNC_STATUS_LABELS}
          />
        </div>

        {error ? (
          <p
            role="alert"
            className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300"
          >
            Couldn&apos;t load tracking activity. {error.message}
          </p>
        ) : (
          <TrackingTable
            syncs={rows}
            loading={loading && rows.length === 0}
            onView={setViewing}
          />
        )}
      </section>

      {viewing && (
        <ActivityDetailsModal sync={viewing} onClose={() => setViewing(null)} />
      )}
    </div>
  );
}
