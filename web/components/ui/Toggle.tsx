"use client";

interface ToggleProps {
  checked: boolean;
  onChange: (checked: boolean) => void;
  label: string;
  disabled?: boolean;
  /** Track colour when on: purple (default) or green for master "Allowed" switches. */
  tone?: "purple" | "green";
}

/** 44×24 switch: purple track when on, dark track when off (Figma Settings). */
export function Toggle({ checked, onChange, label, disabled, tone = "purple" }: ToggleProps) {
  return (
    <button
      type="button"
      role="switch"
      aria-checked={checked}
      aria-label={label}
      disabled={disabled}
      onClick={() => onChange(!checked)}
      className={`relative inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full transition-colors disabled:cursor-not-allowed disabled:opacity-60 ${
        checked ? (tone === "green" ? "bg-[#00c950]" : "bg-[#34206c]") : "bg-white/15"
      }`}
    >
      <span className={`inline-block size-5 rounded-full bg-white shadow transition-transform ${checked ? "translate-x-[22px]" : "translate-x-0.5"}`} />
    </button>
  );
}
