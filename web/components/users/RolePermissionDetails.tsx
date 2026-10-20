"use client";

import { useState } from "react";
import { ChevronDown, CircleCheck, CircleX, Lock } from "lucide-react";
import {
  ADMIN_LEVEL_1,
  ADMIN_LEVEL_2,
  type CapabilityGroup,
} from "@/lib/adminLevels";

function CapabilityAccordion({
  group,
  open,
  onToggle,
  advanced,
}: {
  group: CapabilityGroup;
  open: boolean;
  onToggle: () => void;
  advanced?: boolean;
}) {
  const panelId = `cap-${group.id}`;
  return (
    <div
      className={`overflow-hidden rounded-[18px] border ${advanced ? "border-[#ad46ff]/20 bg-[#ad46ff]/5" : "border-white/10"}`}
    >
      <button
        type="button"
        onClick={onToggle}
        aria-expanded={open}
        aria-controls={panelId}
        className="flex w-full cursor-pointer items-center justify-between gap-3 p-3 text-left transition-colors hover:bg-white/[0.03]"
      >
        <span className="flex items-center gap-2 text-sm leading-5 font-medium text-[#e5e7eb]">
          {group.title}
          {advanced && (
            <Lock className="size-3 text-[#c27aff]" aria-label="Level 2 only" />
          )}
        </span>
        <ChevronDown
          className={`size-4 shrink-0 text-[#e5e7eb] transition-transform ${open ? "rotate-180" : ""}`}
        />
      </button>
      {open && (
        <ul
          id={panelId}
          className="flex flex-col gap-1.5 border-t border-white/10 px-3 pt-2 pb-3"
        >
          {group.items.map((item) => (
            <li
              key={item.label}
              className="flex items-center gap-2 text-xs leading-4"
            >
              {item.allowed ? (
                <CircleCheck
                  className="size-3 shrink-0 text-[#05df72]"
                  aria-label="Allowed"
                />
              ) : (
                <CircleX
                  className="size-3 shrink-0 text-[#ff6467]"
                  aria-label="Not allowed"
                />
              )}
              <span
                className={
                  item.allowed
                    ? "text-[#9ca3af]"
                    : "text-[#9ca3af]/60 line-through"
                }
              >
                {item.label}
              </span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

function LevelColumn({
  badge,
  badgeCls,
  groups,
  advanced,
}: {
  badge: string;
  badgeCls: string;
  groups: CapabilityGroup[];
  advanced?: boolean;
}) {
  // Figma shows the first Level 1 group expanded by default.
  const [openId, setOpenId] = useState<string | null>(
    advanced ? null : (groups[0]?.id ?? null),
  );
  return (
    <div className="flex min-w-0 flex-col gap-3">
      <span
        className={`self-start rounded-[14px] border px-3 py-1 text-xs leading-4 font-bold ${badgeCls}`}
      >
        {badge}
      </span>
      <div className="flex flex-col gap-2">
        {groups.map((g) => (
          <CapabilityAccordion
            key={g.id}
            group={g}
            advanced={advanced}
            open={openId === g.id}
            onToggle={() => setOpenId((cur) => (cur === g.id ? null : g.id))}
          />
        ))}
      </div>
    </div>
  );
}

export function RolePermissionDetails() {
  return (
    <section className="flex flex-col gap-2.5 rounded-2xl border border-[#01303f] bg-black p-4 sm:p-6">
      <h2 className="text-base leading-6 font-semibold text-[#e5e7eb]">
        Role &amp; Permission Details
      </h2>
      <p className="text-sm leading-5 text-[#9ca3af]">
        Admin Level 1 and Level 2 permission breakdown. Level 2 includes all
        Level 1 permissions plus advanced capabilities.
      </p>
      <div className="grid grid-cols-1 gap-4 pt-2.5 lg:grid-cols-2">
        <LevelColumn
          badge="Admin Level 1 — Routine Management"
          badgeCls="border-[#2b7fff]/30 bg-[#2b7fff]/20 text-[#8ec5ff]"
          groups={ADMIN_LEVEL_1}
        />
        <LevelColumn
          badge="Admin Level 2 — Advanced + All Level 1"
          badgeCls="border-[#ad46ff]/30 bg-[#ad46ff]/20 text-[#dab2ff]"
          groups={ADMIN_LEVEL_2}
          advanced
        />
      </div>
    </section>
  );
}
