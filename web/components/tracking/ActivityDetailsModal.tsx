"use client";

import type { ReactNode } from "react";
import {
  CircleCheck,
  CircleX,
  Clock,
  MapPin,
  Smartphone,
  Wifi,
  WifiOff,
} from "lucide-react";
import { Avatar } from "@/components/ui/Avatar";
import { Modal } from "@/components/ui/Modal";
import { useAsync } from "@/hooks/useAsync";
import { trackingService } from "@/services/trackingService";
import {
  SIGNAL_LABELS,
  SYNC_STATUS_LABELS,
  type SignalStrength,
  type TrackingSync,
} from "@/types/tracking";

const SIGNAL_TONE: Record<SignalStrength, string> = {
  strong: "text-[#05df72]",
  medium: "text-[#fdc700]",
  weak: "text-[#ff6467]",
};

/** "Activity Details" (Figma 222:5127) — opened from the eye button on Tracking Activity. */
export function ActivityDetailsModal({
  sync,
  onClose,
}: {
  sync: TrackingSync;
  onClose: () => void;
}) {
  const {
    data: d,
    loading,
    error,
  } = useAsync(() => trackingService.get(sync.id), [sync.id]);
  const ok = sync.status === "success";
  const StatusIcon = ok ? CircleCheck : CircleX;

  return (
    <Modal title="Activity Details" onClose={onClose} width="max-w-[672px]">
      <div className="-mx-5 flex flex-col gap-6 border-y border-white/10 px-5 py-6 sm:-mx-6 sm:px-6">
        <div className="flex items-center gap-4 border-b border-white/10 pb-6">
          <Avatar src={sync.user.avatarUrl} name={sync.user.name} size={64} />
          <div className="min-w-0 flex-1">
            <h3 className="truncate text-lg leading-7 font-semibold text-[#e5e7eb]">
              {sync.user.name}
            </h3>
            <p className="text-sm leading-5 text-[#9ca3af]">
              Tracking Session Details
            </p>
          </div>
          <span
            className={`inline-flex shrink-0 items-center gap-2 rounded-[14px] border px-3 py-2 text-sm leading-5 font-medium ${
              ok
                ? "border-[#00c950]/20 bg-[#00c950]/10 text-[#05df72]"
                : "border-[#fb2c36]/20 bg-[#fb2c36]/10 text-[#ff6467]"
            }`}
          >
            <StatusIcon className="size-4" />
            {SYNC_STATUS_LABELS[sync.status]}
          </span>
        </div>

        {error ? (
          <p role="alert" className="text-sm text-red-300">
            Couldn&apos;t load activity details. {error.message}
          </p>
        ) : (
          <>
            <div className="grid gap-4 sm:grid-cols-2" aria-busy={loading}>
              <InfoTile
                icon={<MapPin className="size-5 text-[#51a2ff]" />}
                label="Location"
                value={sync.location}
                sub={d?.coordinates}
              />
              <InfoTile
                icon={<Clock className="size-5 text-[#c27aff]" />}
                label="Sync Time"
                value={sync.syncTime}
                sub={d?.syncedAt}
              />
              <InfoTile
                icon={<Smartphone className="size-5 text-[#05df72]" />}
                label="Device"
                value={sync.device}
                sub={d?.os}
              />
              <InfoTile
                icon={
                  sync.signal === "weak" ? (
                    <WifiOff className={`size-5 ${SIGNAL_TONE.weak}`} />
                  ) : (
                    <Wifi className={`size-5 ${SIGNAL_TONE[sync.signal]}`} />
                  )
                }
                label="Signal Strength"
                value={
                  <span className={SIGNAL_TONE[sync.signal]}>
                    {SIGNAL_LABELS[sync.signal]}
                  </span>
                }
                sub={ok ? "Connected" : "Disconnected"}
              />
            </div>

            <section className="flex flex-col gap-3 rounded-[18px] border border-white/10 bg-white/10 p-4">
              <h4 className="text-sm leading-5 font-semibold text-[#e5e7eb]">
                Sync Details
              </h4>
              <dl className="flex flex-col gap-2 text-xs leading-4">
                <Row label="Battery Level" value={d && `${d.batteryLevel}%`} />
                <Row
                  label="GPS Accuracy"
                  value={d && `± ${d.gpsAccuracy} meters`}
                />
                <Row
                  label="Speed"
                  value={
                    d &&
                    `${d.speed} km/h${d.speed === 0 ? " (Stationary)" : ""}`
                  }
                />
                <Row label="Altitude" value={d && `${d.altitude} meters`} />
              </dl>
            </section>
          </>
        )}
      </div>

      <button
        type="button"
        onClick={onClose}
        className="h-11 w-full cursor-pointer rounded-[18px] bg-[#3c2579] text-base font-medium text-[#e5e7eb] transition hover:bg-[#4a2f94]"
      >
        Close
      </button>
    </Modal>
  );
}

function InfoTile({
  icon,
  label,
  value,
  sub,
}: {
  icon: ReactNode;
  label: string;
  value: ReactNode;
  sub?: string;
}) {
  return (
    <div className="flex flex-col gap-1 rounded-[18px] border border-white/10 bg-white/10 p-4">
      <div className="mb-2 flex items-center gap-3">
        {icon}
        <span className="text-xs leading-4 text-[#9ca3af]">{label}</span>
      </div>
      <p className="truncate text-sm leading-5 font-medium text-[#e5e7eb]">
        {value}
      </p>
      {sub ? (
        <p className="truncate text-xs leading-4 text-[#9ca3af]">{sub}</p>
      ) : (
        <span className="h-4 w-28 animate-pulse rounded bg-white/10" />
      )}
    </div>
  );
}

function Row({ label, value }: { label: string; value?: string | null }) {
  return (
    <div className="flex items-center justify-between gap-4">
      <dt className="text-[#9ca3af]">{label}</dt>
      <dd className="text-right font-medium text-[#e5e7eb]">
        {value ?? (
          <span className="inline-block h-3 w-16 animate-pulse rounded bg-white/10" />
        )}
      </dd>
    </div>
  );
}
