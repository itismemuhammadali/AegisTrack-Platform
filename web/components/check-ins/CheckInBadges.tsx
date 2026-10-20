import { Camera, Fingerprint } from "lucide-react";
import { CHECKIN_FREQUENCY_LABELS, CHECKIN_STATUS_LABELS, type CheckInFrequency, type CheckInStatus, type VerificationMethod } from "@/types/checkIn";

const PILL = "inline-flex items-center gap-1 rounded-[14px] border px-2.5 py-1 text-xs leading-4 font-medium whitespace-nowrap";

const STATUS: Record<CheckInStatus, { cls: string; dot: string }> = {
  active: { cls: "border-[#00c950]/30 bg-[#00c950]/10 text-[#05df72]", dot: "bg-[#05df72]" },
  paused: { cls: "border-[#f0b100]/30 bg-[#f0b100]/10 text-[#fdc700]", dot: "bg-[#fdc700]" },
};

export function CheckInStatusBadge({ status }: { status: CheckInStatus }) {
  const s = STATUS[status];
  return (
    <span className={`${PILL} ${s.cls}`}>
      <span className={`size-1.5 rounded-full ${s.dot}`} />
      {CHECKIN_STATUS_LABELS[status]}
    </span>
  );
}

export function FrequencyBadge({ frequency }: { frequency: CheckInFrequency }) {
  return (
    <span className="inline-flex rounded-lg bg-white/10 px-2 py-0.5 text-xs leading-5 whitespace-nowrap text-white">
      {CHECKIN_FREQUENCY_LABELS[frequency]}
    </span>
  );
}

const METHOD = {
  biometric: { label: "Biometric", Icon: Fingerprint, cls: "text-[#c27aff]" },
  selfie: { label: "Selfie", Icon: Camera, cls: "text-[#51a2ff]" },
} as const;

export function VerificationMethods({ methods }: { methods: VerificationMethod[] }) {
  if (methods.length === 0) return null;
  return (
    <div className="flex flex-wrap gap-x-1.5">
      {methods.map((m) => {
        const { label, Icon, cls } = METHOD[m];
        return (
          <span key={m} className={`inline-flex items-center gap-0.5 text-[10px] leading-[15px] ${cls}`}>
            <Icon className="size-2.5" />
            {label}
          </span>
        );
      })}
    </div>
  );
}
