import type { LucideIcon } from "lucide-react";

const TONES = {
  red: { border: "border-[#fb2c36]/30", icon: "text-[#ff6467]" },
  orange: { border: "border-[#ff6900]/30", icon: "text-[#ff8904]" },
  yellow: { border: "border-[#f0b100]/30", icon: "text-[#fdc700]" },
  purple: { border: "border-[#34206c]/60", icon: "text-[#4f39f6]" },
} as const;

interface SecurityStatCardProps {
  icon: LucideIcon;
  value: number | string;
  label: string;
  tone: keyof typeof TONES;
  /** Pulsing dot in the corner (critical alerts present). */
  live?: boolean;
}

export function SecurityStatCard({ icon: Icon, value, label, tone, live }: SecurityStatCardProps) {
  const t = TONES[tone];
  return (
    <div className={`relative flex flex-col rounded-[18px] border bg-black/60 p-4 ${t.border}`}>
      <Icon className={`size-5 ${t.icon}`} />
      {live && (
        <span className="absolute top-5 right-7 flex size-2">
          <span className="absolute inline-flex size-full animate-ping rounded-full bg-[#ff6467] opacity-60" />
          <span className="relative inline-flex size-2 rounded-full bg-[#ff6467]" />
        </span>
      )}
      <p className="pt-3 text-2xl leading-8 font-semibold text-white">{value}</p>
      <p className="pt-1 text-xs leading-4 text-[#9ca3af]">{label}</p>
    </div>
  );
}
