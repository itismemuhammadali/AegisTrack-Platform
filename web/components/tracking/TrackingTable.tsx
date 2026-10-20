import { CircleCheck, CircleX, Eye, MapPin, Wifi, WifiOff } from "lucide-react";
import { Avatar } from "@/components/ui/Avatar";
import {
  SIGNAL_LABELS,
  SYNC_STATUS_LABELS,
  type SignalStrength,
  type SyncStatus,
  type TrackingSync,
} from "@/types/tracking";

const HEADERS = [
  "User",
  "Location",
  "Sync Time",
  "Status",
  "Device",
  "Signal",
  "Actions",
];

const STATUS: Record<SyncStatus, { cls: string; Icon: typeof CircleCheck }> = {
  success: {
    cls: "border-[#00c950]/30 bg-[#00c950]/10 text-[#05df72]",
    Icon: CircleCheck,
  },
  failed: {
    cls: "border-[#fb2c36]/30 bg-[#fb2c36]/10 text-[#ff6467]",
    Icon: CircleX,
  },
};

const SIGNAL: Record<SignalStrength, { cls: string; Icon: typeof Wifi }> = {
  strong: { cls: "text-[#05df72]", Icon: Wifi },
  medium: { cls: "text-[#fdc700]", Icon: Wifi },
  weak: { cls: "text-[#ff6467]", Icon: WifiOff },
};

function StatusBadge({ status }: { status: SyncStatus }) {
  const { cls, Icon } = STATUS[status];
  return (
    <span
      className={`inline-flex items-center gap-1.5 rounded-full border px-2.5 py-1 text-xs leading-4 font-medium whitespace-nowrap ${cls}`}
    >
      <Icon className="size-3" />
      {SYNC_STATUS_LABELS[status]}
    </span>
  );
}

function Signal({ signal }: { signal: SignalStrength }) {
  const { cls, Icon } = SIGNAL[signal];
  return (
    <span className={`inline-flex items-center gap-2 text-xs leading-4 ${cls}`}>
      <Icon className="size-4" />
      {SIGNAL_LABELS[signal]}
    </span>
  );
}

function UserCell({ t }: { t: TrackingSync }) {
  return (
    <div className="flex min-w-0 items-center gap-3">
      <Avatar src={t.user.avatarUrl} name={t.user.name} size={32} />
      <span className="truncate text-sm leading-5 font-medium text-white">
        {t.user.name}
      </span>
    </div>
  );
}

function Location({ value }: { value: string }) {
  return (
    <span className="inline-flex items-center gap-2 text-sm leading-5 text-white">
      <MapPin className="size-4 shrink-0 text-[#9ca3af]" />
      {value}
    </span>
  );
}

function ViewButton({
  t,
  onView,
}: {
  t: TrackingSync;
  onView: (t: TrackingSync) => void;
}) {
  return (
    <button
      type="button"
      onClick={() => onView(t)}
      aria-label={`View ${t.user.name}'s tracking details`}
      className="inline-flex size-8 cursor-pointer items-center justify-center rounded-[10px] text-white transition hover:bg-white/10"
    >
      <Eye className="size-4" />
    </button>
  );
}

export function TrackingTable({
  syncs,
  loading,
  onView,
}: {
  syncs: TrackingSync[];
  loading: boolean;
  onView: (t: TrackingSync) => void;
}) {
  if (loading)
    return (
      <p className="py-8 text-center text-sm text-[#9ca3af]">
        Loading activity…
      </p>
    );
  if (syncs.length === 0)
    return (
      <p className="py-8 text-center text-sm text-[#9ca3af]">
        No sync activity found.
      </p>
    );

  return (
    <>
      {/* lg+: table */}
      <div className="hidden lg:block">
        <table className="w-full table-fixed text-left">
          <colgroup>
            <col className="w-[19%]" />
            <col className="w-[18%]" />
            <col className="w-[12%]" />
            <col className="w-[13%]" />
            <col className="w-[14%]" />
            <col className="w-[13%]" />
            <col className="w-[11%]" />
          </colgroup>
          <thead>
            <tr className="border-b border-white/10">
              {HEADERS.map((h) => (
                <th
                  key={h}
                  className={`px-4 pt-2 pb-3 text-xs leading-4 font-medium tracking-[0.6px] text-[#9ca3af] uppercase ${h === "Actions" ? "text-center" : ""}`}
                >
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {syncs.map((t) => (
              <tr key={t.id} className="border-b border-white/10 last:border-0">
                <td className="px-4 py-3.5">
                  <UserCell t={t} />
                </td>
                <td className="px-4 py-3.5">
                  <Location value={t.location} />
                </td>
                <td className="px-4 py-3.5 text-sm leading-5 text-[#9ca3af]">
                  {t.syncTime}
                </td>
                <td className="px-4 py-3.5">
                  <StatusBadge status={t.status} />
                </td>
                <td className="px-4 py-3.5 text-sm leading-5 text-white">
                  {t.device}
                </td>
                <td className="px-4 py-3.5">
                  <Signal signal={t.signal} />
                </td>
                <td className="px-4 py-3.5 text-center">
                  <ViewButton t={t} onView={onView} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* < lg: cards */}
      <ul className="flex flex-col gap-3 lg:hidden">
        {syncs.map((t) => (
          <li
            key={t.id}
            className="flex flex-col gap-3 rounded-[18px] border border-white/10 p-4"
          >
            <div className="flex items-center justify-between gap-2">
              <UserCell t={t} />
              <ViewButton t={t} onView={onView} />
            </div>
            <Location value={t.location} />
            <div className="flex flex-wrap items-center gap-3">
              <StatusBadge status={t.status} />
              <Signal signal={t.signal} />
              <span className="text-xs leading-4 text-white">{t.device}</span>
              <span className="ml-auto text-xs leading-4 text-[#9ca3af]">
                {t.syncTime}
              </span>
            </div>
          </li>
        ))}
      </ul>
    </>
  );
}
