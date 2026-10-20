import type { ReactNode } from "react";
import type { Tone } from "@/types/dashboard";

const TONES: Record<Tone, string> = {
  green: "bg-[#00c950]/10 text-[#05df72]",
  blue: "bg-[#2b7fff]/10 text-[#51a2ff]",
  yellow: "bg-[#f0b100]/10 text-[#fdc700]",
  red: "bg-[#fb2c36]/20 text-[#ff6467]",
  orange: "bg-[#ff6900]/20 text-[#ff8904]",
  purple: "bg-[#ad46ff]/10 text-[#dab2ff]",
  cyan: "bg-[#00b8db]/10 text-[#00d3f2]",
  neutral: "bg-white/10 text-white",
};

interface BadgeProps {
  tone?: Tone;
  size?: "sm" | "md";
  className?: string;
  children: ReactNode;
}

/** Pill-shaped status label. `sm` = 10px (priority tags), `md` = 12px (statuses). */
export function Badge({ tone = "neutral", size = "md", className = "", children }: BadgeProps) {
  return (
    <span
      className={`inline-flex items-center rounded-full whitespace-nowrap ${
        size === "sm" ? "px-1.5 py-0.5 text-[10px] leading-[15px]" : "px-2 py-0.5 text-xs leading-4"
      } ${TONES[tone]} ${className}`}
    >
      {children}
    </span>
  );
}
