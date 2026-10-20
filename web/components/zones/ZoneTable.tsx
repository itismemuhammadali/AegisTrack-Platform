"use client";

import { MapPin, Users } from "lucide-react";
import { formatCoordinates, type Zone } from "@/types/zone";
import { ZONE_TYPE_STYLE, ZoneStatusBadge, ZoneTypeBadge } from "./ZoneBadges";
import { ZoneRowActions, type ZoneRowAction } from "./ZoneRowActions";

const HEADERS = ["Zone Name", "Type", "Assigned Users", "Status", "Last Activity", ""];

function ZoneName({ zone }: { zone: Zone }) {
  return (
    <div className="flex min-w-0 items-center gap-3">
      <span className={`flex size-9 shrink-0 items-center justify-center rounded-full ${ZONE_TYPE_STYLE[zone.type].iconBg}`}>
        <MapPin className="size-4" />
      </span>
      <div className="min-w-0">
        <p className="text-sm leading-5 font-medium text-white">{zone.name}</p>
        <p className="text-xs leading-4 text-[#9ca3af]">{formatCoordinates(zone.latitude, zone.longitude)}</p>
      </div>
    </div>
  );
}

function UserCount({ n }: { n: number }) {
  return (
    <span className="inline-flex items-center gap-1.5 text-sm leading-5 text-white">
      <Users className="size-4 text-[#9ca3af]" />
      {n}
    </span>
  );
}

interface ZoneTableProps {
  zones: Zone[];
  loading: boolean;
  onAction: (action: ZoneRowAction, zone: Zone) => void;
}

export function ZoneTable({ zones, loading, onAction }: ZoneTableProps) {
  if (loading) return <p className="py-8 text-center text-sm text-[#9ca3af]">Loading zones…</p>;
  if (zones.length === 0) return <p className="py-8 text-center text-sm text-[#9ca3af]">No zones found.</p>;

  return (
    <>
      {/* lg+: table */}
      <div className="hidden lg:block">
        <table className="w-full table-fixed border-separate border-spacing-0 text-left">
          <colgroup>
            <col className="w-[28%]" />
            <col className="w-[20%]" />
            <col className="w-[16%]" />
            <col className="w-[12%]" />
            <col className="w-[16%]" />
            <col className="w-[8%]" />
          </colgroup>
          <thead>
            <tr>
              {HEADERS.map((h, i) => (
                <th key={i} className="border-b border-white/10 px-4 pt-2 pb-3 text-xs leading-4 font-medium tracking-[0.6px] text-[#9ca3af] uppercase">
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {zones.map((z) => (
              // Hover draws a full outline around the row (Figma's highlighted last row).
              <tr key={z.id} className="group [&>td]:border-y [&>td]:border-transparent [&>td]:border-b-white/10 group-last:[&>td]:border-b-transparent hover:[&>td]:border-white/20 [&>td:first-child]:border-l [&>td:last-child]:border-r">
                <td className="px-4 py-4">
                  <ZoneName zone={z} />
                </td>
                <td className="px-4 py-4">
                  <ZoneTypeBadge type={z.type} />
                </td>
                <td className="px-4 py-4">
                  <UserCount n={z.assignedUsers} />
                </td>
                <td className="px-4 py-4">
                  <ZoneStatusBadge status={z.status} />
                </td>
                <td className="px-4 py-4 text-sm leading-5 text-[#9ca3af]">{z.lastActivity}</td>
                <td className="px-4 py-4 text-center">
                  <ZoneRowActions zone={z} onAction={onAction} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* < lg: cards */}
      <ul className="flex flex-col gap-3 lg:hidden">
        {zones.map((z) => (
          <li key={z.id} className="flex flex-col gap-3 rounded-[18px] border border-white/10 p-4">
            <div className="flex items-start justify-between gap-2">
              <ZoneName zone={z} />
              <ZoneRowActions zone={z} onAction={onAction} />
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <ZoneTypeBadge type={z.type} />
              <ZoneStatusBadge status={z.status} />
              <UserCount n={z.assignedUsers} />
              <span className="ml-auto text-xs leading-4 text-[#9ca3af]">{z.lastActivity}</span>
            </div>
          </li>
        ))}
      </ul>
    </>
  );
}
