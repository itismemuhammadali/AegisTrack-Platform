"use client";

import { Eye, RefreshCw, SquarePen, Trash2 } from "lucide-react";
import { Avatar } from "@/components/ui/Avatar";
import { ActionMenu } from "@/components/ui/ActionMenu";
import type { CheckInSchedule } from "@/types/checkIn";
import { CheckInStatusBadge, FrequencyBadge, VerificationMethods } from "./CheckInBadges";

const HEADERS = ["User", "Schedule", "Time", "Frequency", "Status", "Last Check-in", "Next Check-in", ""];

export function initials(name: string) {
  return name
    .split(" ")
    .map((p) => p[0])
    .slice(0, 2)
    .join("")
    .toUpperCase();
}

/** Admin frame (608:9214) shows initials; Super Admin frame (610:19594) shows photos. */
function UserCell({ schedule, showPhoto }: { schedule: CheckInSchedule; showPhoto: boolean }) {
  const { name, avatarUrl } = schedule.user;
  return (
    <div className="flex min-w-0 items-center gap-2">
      {showPhoto ? (
        <Avatar src={avatarUrl} name={name} size={32} />
      ) : (
        <span aria-hidden className="flex size-8 shrink-0 items-center justify-center rounded-full bg-[#8e51ff] text-xs leading-4 font-semibold text-white">
          {initials(name)}
        </span>
      )}
      <span className="truncate text-sm leading-5 font-medium text-white">{name}</span>
    </div>
  );
}

function ScheduleCell({ schedule }: { schedule: CheckInSchedule }) {
  return (
    <div className="min-w-0">
      <p className="text-sm leading-5 text-white">{schedule.name}</p>
      <VerificationMethods methods={schedule.methods} />
    </div>
  );
}

function LastCheckIn({ schedule }: { schedule: CheckInSchedule }) {
  return (
    <div>
      <p className="text-xs leading-4 text-[#9ca3af]">{schedule.lastCheckIn}</p>
      {schedule.missedCount > 0 && <p className="text-[10px] leading-[15px] text-[#ff6467]">{schedule.missedCount} missed</p>}
    </div>
  );
}

export type CheckInRowAction = "view" | "edit" | "remind" | "delete";

/** Row "⋮" menu (Figma 622:8249) — same for Admin and Super Admin. */
function Actions({ schedule, onAction }: { schedule: CheckInSchedule; onAction: (action: CheckInRowAction, s: CheckInSchedule) => void }) {
  return (
    <ActionMenu
      label={`Actions for ${schedule.name}`}
      items={[
        { label: "View Details", icon: Eye, onSelect: () => onAction("view", schedule) },
        { label: "Edit Schedule", icon: SquarePen, onSelect: () => onAction("edit", schedule) },
        { label: "Send Reminder", icon: RefreshCw, onSelect: () => onAction("remind", schedule) },
        { label: "Delete", icon: Trash2, danger: true, onSelect: () => onAction("delete", schedule) },
      ]}
    />
  );
}

interface CheckInTableProps {
  schedules: CheckInSchedule[];
  loading: boolean;
  showPhotos: boolean;
  onAction: (action: CheckInRowAction, s: CheckInSchedule) => void;
}

export function CheckInTable({ schedules, loading, showPhotos, onAction }: CheckInTableProps) {
  if (loading) return <p className="py-8 text-center text-sm text-[#9ca3af]">Loading schedules…</p>;
  if (schedules.length === 0) return <p className="py-8 text-center text-sm text-[#9ca3af]">No schedules found.</p>;

  return (
    <>
      {/* xl+: table (8 columns need the room) */}
      <div className="hidden xl:block">
        <table className="w-full table-fixed border-separate border-spacing-0 text-left">
          <colgroup>
            <col className="w-[15%]" />
            <col className="w-[20%]" />
            <col className="w-[9%]" />
            <col className="w-[10%]" />
            <col className="w-[10%]" />
            <col className="w-[13%]" />
            <col className="w-[16%]" />
            <col className="w-[7%]" />
          </colgroup>
          <thead>
            <tr>
              {HEADERS.map((h, i) => (
                <th key={i} className="border-b border-white/10 px-3 pt-2 pb-3 text-xs leading-4 font-medium tracking-[0.6px] text-[#9ca3af] uppercase">
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {schedules.map((s) => (
              <tr key={s.id} className="group [&>td]:border-y [&>td]:border-transparent [&>td]:border-b-white/10 group-last:[&>td]:border-b-transparent hover:[&>td]:border-white/20 [&>td:first-child]:border-l [&>td:last-child]:border-r">
                <td className="px-3 py-3.5">
                  <UserCell schedule={s} showPhoto={showPhotos} />
                </td>
                <td className="px-3 py-3.5">
                  <ScheduleCell schedule={s} />
                </td>
                <td className="px-3 py-3.5 text-sm leading-5 whitespace-nowrap text-[#9ca3af]">{s.time}</td>
                <td className="px-3 py-3.5">
                  <FrequencyBadge frequency={s.frequency} />
                </td>
                <td className="px-3 py-3.5">
                  <CheckInStatusBadge status={s.status} />
                </td>
                <td className="px-3 py-3.5">
                  <LastCheckIn schedule={s} />
                </td>
                <td className="px-3 py-3.5 text-xs leading-4 text-[#9ca3af]">{s.nextCheckIn}</td>
                <td className="px-3 py-3.5 text-center">
                  <Actions schedule={s} onAction={onAction} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* < xl: cards */}
      <ul className="grid grid-cols-1 gap-3 md:grid-cols-2 xl:hidden">
        {schedules.map((s) => (
          <li key={s.id} className="flex flex-col gap-3 rounded-[18px] border border-white/10 p-4">
            <div className="flex items-start justify-between gap-2">
              <UserCell schedule={s} showPhoto={showPhotos} />
              <Actions schedule={s} onAction={onAction} />
            </div>
            <ScheduleCell schedule={s} />
            <div className="flex flex-wrap items-center gap-2">
              <span className="text-sm leading-5 text-[#9ca3af]">{s.time}</span>
              <FrequencyBadge frequency={s.frequency} />
              <CheckInStatusBadge status={s.status} />
            </div>
            <dl className="grid grid-cols-2 gap-2 border-t border-white/10 pt-3">
              <div>
                <dt className="text-[10px] leading-[15px] tracking-[0.6px] text-[#6a7282] uppercase">Last check-in</dt>
                <dd>
                  <LastCheckIn schedule={s} />
                </dd>
              </div>
              <div>
                <dt className="text-[10px] leading-[15px] tracking-[0.6px] text-[#6a7282] uppercase">Next check-in</dt>
                <dd className="text-xs leading-4 text-[#9ca3af]">{s.nextCheckIn}</dd>
              </div>
            </dl>
          </li>
        ))}
      </ul>
    </>
  );
}
