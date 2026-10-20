"use client";

interface Option<T extends string> {
  value: T;
  label: string;
}

interface SegmentedControlProps<T extends string> {
  options: readonly Option<T>[];
  value: T;
  onChange: (value: T) => void;
  /** `lg` = page tabs (black track, 14px); `sm` = in-card filters (translucent track, 12px). */
  size?: "sm" | "lg";
  ariaLabel: string;
}

export function SegmentedControl<T extends string>({ options, value, onChange, size = "sm", ariaLabel }: SegmentedControlProps<T>) {
  const lg = size === "lg";
  return (
    <div
      role="tablist"
      aria-label={ariaLabel}
      className={`inline-flex w-fit max-w-full gap-1 overflow-x-auto p-1 [scrollbar-width:none] ${lg ? "rounded-[18px] bg-black" : "rounded-[18px] bg-white/10"}`}
    >
      {options.map((o) => {
        const active = o.value === value;
        return (
          <button
            key={o.value}
            type="button"
            role="tab"
            aria-selected={active}
            onClick={() => onChange(o.value)}
            className={`shrink-0 cursor-pointer rounded-[14px] font-medium whitespace-nowrap transition-colors ${
              lg ? "px-4 py-2 text-sm leading-5 sm:min-w-[134px]" : "px-3 py-1.5 text-xs leading-4"
            } ${active ? "bg-[#34206c] text-white shadow-[0_1px_1.5px_rgba(0,0,0,0.1),0_1px_1px_rgba(0,0,0,0.1)]" : "text-[#9ca3af] hover:text-white"}`}
          >
            {o.label}
          </button>
        );
      })}
    </div>
  );
}
