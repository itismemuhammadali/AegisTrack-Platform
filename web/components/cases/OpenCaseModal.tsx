"use client";

import { useState } from "react";
import { CircleCheck, FileText, Lock, MapPin, TriangleAlert, type LucideIcon } from "lucide-react";
import { DetailTile, Modal } from "@/components/ui/Modal";
import { useAsync } from "@/hooks/useAsync";
import { caseService } from "@/services/caseService";
import type { CaseDetail, CaseRecord, CaseTimelineKind } from "@/types/case";
import { legalHoldService } from "@/services/legalHoldService";
import { CaseStatusBadge } from "./CaseBadges";
import { BTN_CANCEL } from "@/components/users/EditUserModal";
import { initials } from "@/components/check-ins/CheckInTable";

const TABS = ["Overview", "Users", "Location Logs", "Check-ins", "Flags", "Reports", "Court Documents", "Legal Hold"] as const;
type Tab = (typeof TABS)[number];

const TIMELINE_ICON: Record<CaseTimelineKind, { icon: LucideIcon; cls: string }> = {
  zone: { icon: MapPin, cls: "text-[#51a2ff]" },
  "check-in": { icon: CircleCheck, cls: "text-[#05df72]" },
  "location-log": { icon: FileText, cls: "text-[#51a2ff]" },
  flag: { icon: TriangleAlert, cls: "text-[#ff8904]" },
};

/** Tabs whose records come from the case file (Figma 1069:1333 … 1069:4105); label used in the placeholder. */
const RECORD_TABS: Partial<Record<Tab, string>> = {
  "Location Logs": "logs",
  "Check-ins": "checkins",
  Flags: "flags",
  Reports: "reports",
  "Court Documents": "documents",
};

const SCROLL = "overflow-y-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden";

function Empty({ children }: { children: string }) {
  return <p className="rounded-[18px] border border-white/10 bg-white/10 px-4 py-8 text-center text-sm text-[#9ca3af]">{children}</p>;
}

function Timeline({ events }: { events: CaseDetail["timeline"] }) {
  return (
    <ul className="flex flex-col gap-2">
      {events.map((e) => {
        const { icon: Icon, cls } = TIMELINE_ICON[e.kind];
        return (
          <li key={e.id} className="flex items-start gap-3 rounded-[18px] bg-white/10 p-3">
            <Icon className={`mt-0.5 size-4 shrink-0 ${cls}`} />
            <p className="min-w-0 flex-1 text-xs leading-4 font-medium text-[#e5e7eb]">{e.label}</p>
            <span className="shrink-0 text-xs leading-4 text-[#9ca3af]">{e.time}</span>
          </li>
        );
      })}
    </ul>
  );
}

/** Users tab (Figma 1069:626). */
function UsersTab({ detail }: { detail: CaseDetail }) {
  if (detail.members.length === 0) return <Empty>No users assigned to this case.</Empty>;
  return (
    <ul className="flex flex-col gap-2">
      {detail.members.map((m) => (
        <li key={m.name} className="flex items-center gap-3 rounded-[18px] bg-white/10 p-3">
          <span aria-hidden className="flex size-8 shrink-0 items-center justify-center rounded-full bg-[linear-gradient(135deg,#ad46ff_0%,#4f39f6_100%)] text-xs leading-4 font-semibold text-white">
            {initials(m.name)}
          </span>
          <div className="min-w-0 flex-1">
            <p className="truncate text-sm leading-5 font-medium text-[#e5e7eb]">{m.name}</p>
            <p className="text-xs leading-4 text-white/60">{m.role}</p>
          </div>
          <span className={`shrink-0 rounded-full px-2 py-1 text-xs leading-4 ${m.status === "active" ? "bg-[#00c950]/10 text-[#05df72]" : "bg-white/10 text-[#9ca3af]"}`}>
            {m.status === "active" ? "Active" : "Inactive"}
          </span>
        </li>
      ))}
    </ul>
  );
}

/** Location Logs / Check-ins / Flags / Reports / Court Documents (Figma 1069:1333 … 1069:4105). */
function RecordsPlaceholder({ kind }: { kind: string }) {
  return (
    <div className="flex flex-col items-center rounded-[18px] border border-white/10 bg-white/10 p-8 text-center">
      <FileText className="size-8 text-white/60" strokeWidth={1.5} />
      <p className="pt-2 text-sm leading-5 text-white/60 capitalize">{kind} — records loaded from case file</p>
      <p className="pt-1 text-xs leading-4 text-[#9ca3af]/60">Case data integration point</p>
    </div>
  );
}

/** Legal Hold tab (Figma 1069:4798). */
function LegalHoldTab({ caseId }: { caseId: string }) {
  const { data, loading, error } = useAsync(() => legalHoldService.list(), []);
  if (error) return <Empty>{`Couldn't load legal hold. ${error.message}`}</Empty>;
  if (loading || !data) return <div className="h-[88px] animate-pulse rounded-[18px] bg-white/5" />;
  const hold = data.find((h) => h.caseId === caseId && h.status === "active");
  if (!hold) return <Empty>No active legal hold on this case.</Empty>;
  return (
    <div className="flex flex-col gap-4">
      <div className="rounded-[18px] border border-[#fb2c36]/30 bg-[#fb2c36]/10 p-4">
        <p className="flex items-center gap-2 text-base leading-6 font-semibold text-[#ffa2a2]">
          <Lock className="size-5 text-[#ff6467]" /> Legal Hold Active
        </p>
        <p className="pt-1 text-sm leading-5 text-[#9ca3af]">
          Records protected from archiving or deletion while hold is active. Legal Hold prevents protected records from being archived or removed.
        </p>
      </div>
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
        <DetailTile label="Applied By">{hold.appliedBy}</DetailTile>
        <DetailTile label="Applied Date">{hold.appliedAt}</DetailTile>
        <DetailTile label="Authorization" className="sm:col-span-2">
          {hold.authorization}
        </DetailTile>
      </div>
    </div>
  );
}

function TabBody({ tab, detail }: { tab: Tab; detail: CaseDetail }) {
  if (tab === "Overview")
    return (
      <div className="flex flex-col gap-4">
        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
          <DetailTile label="Status">
            <CaseStatusBadge status={detail.status} />
          </DetailTile>
          <DetailTile label="Created">{detail.createdAt}</DetailTile>
          {detail.courtOrder && <DetailTile label="Court Order">{detail.courtOrder}</DetailTile>}
        </div>
        <div className="flex flex-col gap-1 rounded-[18px] border border-white/10 bg-white/10 p-4">
          <p className="text-xs leading-4 text-[#9ca3af]">Description</p>
          <p className="text-sm leading-5 break-words text-[#e5e7eb]">{detail.description || "—"}</p>
        </div>
        <div className="flex flex-col gap-3">
          <h4 className="text-sm leading-5 font-semibold text-[#e5e7eb]">Evidence Timeline</h4>
          {detail.timeline.length ? <Timeline events={detail.timeline} /> : <Empty>No evidence recorded yet.</Empty>}
        </div>
      </div>
    );
  if (tab === "Users") return <UsersTab detail={detail} />;
  if (tab === "Legal Hold") return <LegalHoldTab caseId={detail.id} />;
  return <RecordsPlaceholder kind={RECORD_TABS[tab] ?? tab} />;
}

/** "Open Case" (Figma 613:29313) — opened from the row menu, same for Admin and Super Admin. */
export function OpenCaseModal({ record, onClose }: { record: CaseRecord; onClose: () => void }) {
  const [tab, setTab] = useState<Tab>("Overview");
  const { data, loading, error } = useAsync(() => caseService.get(record.id), [record.id]);

  return (
    <Modal
      title={record.title}
      subtitle={record.number}
      titleAside={
        record.legalHold && (
          <span className="inline-flex items-center gap-1 rounded-[4px] border border-[#fb2c36]/40 bg-[#fb2c36]/20 px-2 py-0.5 text-[10px] leading-[15px] font-bold text-[#ff6467]">
            <Lock className="size-3" /> LEGAL HOLD
          </span>
        )
      }
      onClose={onClose}
      width="max-w-[770px]"
    >
      <div className="flex flex-col gap-[14px] pt-3.5">
        <div role="tablist" className={`flex gap-1 border-b border-white/10 pb-3 ${SCROLL.replace("overflow-y-auto", "overflow-x-auto")}`}>
          {TABS.map((t) => (
            <button
              key={t}
              role="tab"
              type="button"
              aria-selected={tab === t}
              onClick={() => setTab(t)}
              className={`shrink-0 cursor-pointer rounded-[14px] px-3 py-1.5 text-xs leading-4 font-medium whitespace-nowrap transition-colors ${tab === t ? "bg-[#34206c] text-white" : "text-[#9ca3af] hover:text-[#e5e7eb]"}`}
            >
              {t}
            </button>
          ))}
        </div>

        <div className={`pt-2 ${SCROLL} ${tab === "Overview" ? "h-[512px] max-h-[calc(100dvh-340px)] min-h-[240px]" : "max-h-[calc(100dvh-340px)]"}`}>
          {error ? (
            <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
              Couldn&apos;t load case. {error.message}
            </p>
          ) : loading || !data ? (
            <div className="flex flex-col gap-3">
              {[0, 1, 2].map((i) => (
                <div key={i} className="h-[66px] animate-pulse rounded-[18px] bg-white/5" />
              ))}
            </div>
          ) : (
            <TabBody tab={tab} detail={data} />
          )}
        </div>

        <div className="border-t border-white/10 pt-4">
          <button type="button" onClick={onClose} className={`${BTN_CANCEL} w-full`}>
            Close
          </button>
        </div>
      </div>
    </Modal>
  );
}
