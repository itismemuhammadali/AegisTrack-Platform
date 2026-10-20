"use client";

import type { ReactNode } from "react";
import { ChevronDown, type LucideIcon } from "lucide-react";
import { Toggle } from "@/components/ui/Toggle";

export const ICON_TONES = {
  neutral: "bg-white/10 text-white",
  blue: "bg-[#2b7fff]/15 text-[#51a2ff]",
  purple: "bg-[#ad46ff]/15 text-[#c27aff]",
  green: "bg-[#00c950]/15 text-[#05df72]",
  red: "bg-[#fb2c36]/15 text-[#ff6467]",
} as const;

interface SettingsCardProps {
  icon: LucideIcon;
  tone: keyof typeof ICON_TONES;
  title: string;
  subtitle: string;
  /** Super Admin frame uses a bordered navy card; Admin frame is flat black. */
  variant: "black" | "navy";
  children: ReactNode;
  className?: string;
  /** Spread rows over the full card height when a taller sibling stretches the grid row. */
  spread?: boolean;
}

export function SettingsCard({ icon: Icon, tone, title, subtitle, variant, children, className = "", spread }: SettingsCardProps) {
  return (
    <section
      className={`flex min-w-0 flex-col rounded-[18px] p-4 sm:p-6 ${variant === "navy" ? "border border-white/10 bg-[#0c0e1a]" : "bg-black"} ${className}`}
    >
      <header className="flex items-center gap-3">
        <span className={`flex size-10 shrink-0 items-center justify-center rounded-full ${ICON_TONES[tone]}`}>
          <Icon className="size-5" />
        </span>
        <div className="min-w-0">
          <h2 className="text-base leading-6 font-semibold text-white">{title}</h2>
          <p className="text-xs leading-4 text-[#9ca3af]">{subtitle}</p>
        </div>
      </header>
      <div className={`flex flex-1 flex-col pt-6 ${spread ? "justify-between" : ""}`}>{children}</div>
    </section>
  );
}

export function ToggleRow({ label, hint, checked, onChange }: { label: string; hint: string; checked: boolean; onChange: (v: boolean) => void }) {
  return (
    <div className="flex items-center justify-between gap-4 py-[17px] first:pt-0">
      <div className="min-w-0">
        <p className="text-sm leading-5 text-white">{label}</p>
        <p className="text-xs leading-4 text-[#9ca3af]">{hint}</p>
      </div>
      <Toggle label={label} checked={checked} onChange={onChange} />
    </div>
  );
}

export function SelectRow<T extends string>({ label, value, options, onChange }: { label: string; value: T; options: Record<T, string>; onChange: (v: T) => void }) {
  return (
    <label className="flex flex-col gap-2 pb-6 last:pb-0">
      <span className="text-sm leading-5 text-white">{label}</span>
      <span className="relative">
        <select
          value={value}
          onChange={(e) => onChange(e.target.value as T)}
          className="h-10 w-full cursor-pointer appearance-none rounded-[14px] border border-white/10 bg-transparent px-4 text-base text-white outline-none transition-colors focus:border-white/30 [&>option]:bg-[#0c1227]"
        >
          {(Object.entries(options) as [T, string][]).map(([v, l]) => (
            <option key={v} value={v}>
              {l}
            </option>
          ))}
        </select>
        <ChevronDown className="pointer-events-none absolute top-1/2 right-4 size-5 -translate-y-1/2 text-white" />
      </span>
    </label>
  );
}
