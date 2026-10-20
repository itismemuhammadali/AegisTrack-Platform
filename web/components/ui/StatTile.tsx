import type { LucideIcon } from "lucide-react";

const TONES = {
  green: "bg-[#00c950]/10 text-[#05df72]",
  red: "bg-[#fb2c36]/10 text-[#ff6467]",
  yellow: "bg-[#f0b100]/10 text-[#fdc700]",
  purple: "bg-[#ad46ff]/10 text-[#c27aff]",
  blue: "bg-[#2b7fff]/10 text-[#51a2ff]",
} as const;

export type StatTileTone = keyof typeof TONES;

/** Translucent summary tile: tinted icon circle + value + label (Cases, Zones…). */
export function StatTile({ icon: Icon, value, label, tone }: { icon: LucideIcon; value: number | string; label: string; tone: StatTileTone }) {
  return (
    <div className="flex items-center gap-4 rounded-[18px] border border-white/20 bg-white/10 p-4">
      <span className={`flex size-10 shrink-0 items-center justify-center rounded-full ${TONES[tone]}`}>
        <Icon className="size-5" />
      </span>
      <div className="min-w-0">
        <p className="text-xl leading-7 font-semibold text-white">{value}</p>
        <p className="truncate text-xs leading-4 text-[#9ca3af]">{label}</p>
      </div>
    </div>
  );
}
