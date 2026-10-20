"use client";

import { CircleCheck, Clock, Eye, RotateCcw, TriangleAlert } from "lucide-react";
import type { SyncFailure } from "@/types/syncFailure";
import { SyncStatusBadge } from "./SyncStatusBadge";

const HEADERS = ["User & Device", "Failure Reason", "Error Code", "Retries", "Time", "Status", "Actions"];
const ICON_BTN = "flex size-7 cursor-pointer items-center justify-center rounded-lg text-[#d1d5dc] transition hover:bg-white/10 hover:text-white";

interface RowHandlers {
  onView: (f: SyncFailure) => void;
  onRetry: (f: SyncFailure) => void;
  onResolve: (f: SyncFailure) => void;
}

function UserDevice({ f }: { f: SyncFailure }) {
  return (
    <div className="min-w-0">
      <p className="text-sm leading-5 font-medium text-white">{f.user.name}</p>
      <p className="text-xs leading-4 text-[#9ca3af]">{f.device}</p>
      <p className="truncate text-xs leading-4 text-[#9ca3af]">{f.user.email}</p>
    </div>
  );
}

function Reason({ f }: { f: SyncFailure }) {
  return (
    <div>
      <p className="text-sm leading-5 text-white">{f.reason}</p>
      {f.dataLossRisk && (
        <p className="flex items-center gap-1 pt-1 text-xs leading-4 text-[#ff6467]">
          <TriangleAlert className="size-3" /> Data loss risk
        </p>
      )}
    </div>
  );
}

function ErrorCode({ code }: { code: string }) {
  return <code className="inline-block rounded bg-white/10 px-2 py-1 font-mono text-[11px] leading-4 break-all text-[#d1d5dc]">{code}</code>;
}

function Time({ value }: { value: string }) {
  return (
    <span className="inline-flex items-center gap-1 text-xs leading-4 whitespace-nowrap text-[#9ca3af]">
      <Clock className="size-3" /> {value}
    </span>
  );
}

function Actions({ f, onView, onRetry, onResolve }: { f: SyncFailure } & RowHandlers) {
  const resolved = f.status === "resolved";
  return (
    <div className="flex items-center gap-1">
      <button type="button" className={ICON_BTN} onClick={() => onView(f)} aria-label={`View details for ${f.user.name}`} title="View details">
        <Eye className="size-4" />
      </button>
      {!resolved && (
        <button type="button" className={ICON_BTN} onClick={() => onRetry(f)} aria-label={`Retry sync for ${f.user.name}`} title="Retry">
          <RotateCcw className="size-4" />
        </button>
      )}
      {!resolved && (
        <button type="button" className={ICON_BTN} onClick={() => onResolve(f)} aria-label={`Mark ${f.user.name}'s failure resolved`} title="Mark resolved">
          <CircleCheck className="size-4" />
        </button>
      )}
      {/* Resolved rows keep a (disabled) resolve tick, matching Figma's two-icon row. */}
      {resolved && (
        <span className={`${ICON_BTN} cursor-default hover:bg-transparent`} aria-hidden>
          <CircleCheck className="size-4" />
        </span>
      )}
    </div>
  );
}

export function SyncFailureTable({ failures, loading, ...handlers }: { failures: SyncFailure[]; loading: boolean } & RowHandlers) {
  if (loading) return <p className="py-8 text-center text-sm text-[#9ca3af]">Loading sync failures…</p>;
  if (failures.length === 0) return <p className="py-8 text-center text-sm text-[#9ca3af]">No sync failures found.</p>;

  return (
    <>
      {/* xl+: table */}
      <div className="hidden xl:block">
        <table className="w-full table-fixed text-left">
          <colgroup>
            <col className="w-[16%]" />
            <col className="w-[20%]" />
            <col className="w-[16%]" />
            <col className="w-[7%]" />
            <col className="w-[12%]" />
            <col className="w-[12%]" />
            <col className="w-[11%]" />
          </colgroup>
          <thead>
            <tr className="border-b border-white/10">
              {HEADERS.map((h) => (
                <th key={h} className={`px-4 py-4 text-xs leading-4 font-medium text-[#d1d5dc] ${h === "Retries" ? "text-center" : ""}`}>
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {failures.map((f) => (
              <tr key={f.id} className="border-b border-white/10 last:border-0">
                <td className="px-4 py-4">
                  <UserDevice f={f} />
                </td>
                <td className="px-4 py-4">
                  <Reason f={f} />
                </td>
                <td className="px-4 py-4">
                  <ErrorCode code={f.errorCode} />
                </td>
                <td className="px-4 py-4 text-center text-sm leading-5 text-white">{f.retries}</td>
                <td className="px-4 py-4">
                  <Time value={f.time} />
                </td>
                <td className="px-4 py-4">
                  <SyncStatusBadge status={f.status} />
                </td>
                <td className="px-4 py-4">
                  <Actions f={f} {...handlers} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* < xl: cards */}
      <ul className="flex flex-col divide-y divide-white/10 xl:hidden">
        {failures.map((f) => (
          <li key={f.id} className="flex flex-col gap-3 p-4">
            <div className="flex items-start justify-between gap-3">
              <UserDevice f={f} />
              <SyncStatusBadge status={f.status} />
            </div>
            <Reason f={f} />
            <div className="flex flex-wrap items-center gap-3">
              <ErrorCode code={f.errorCode} />
              <span className="text-xs leading-4 text-[#9ca3af]">
                Retries: <span className="text-white">{f.retries}</span>
              </span>
              <Time value={f.time} />
              <div className="ml-auto">
                <Actions f={f} {...handlers} />
              </div>
            </div>
          </li>
        ))}
      </ul>
    </>
  );
}
