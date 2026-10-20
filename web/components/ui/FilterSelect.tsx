import { ChevronDown } from "lucide-react";

/** Native select styled as the 210px filter dropdown used beside search bars. */
export function FilterSelect<T extends string>({ value, onChange, label, allLabel, options }: {
  value: T | "all";
  onChange: (v: T | "all") => void;
  label: string;
  allLabel: string;
  options: Record<T, string>;
}) {
  return (
    <div className="relative sm:w-[210px]">
      <select
        value={value}
        onChange={(e) => onChange(e.target.value as T | "all")}
        aria-label={label}
        className="h-full min-h-[52px] w-full cursor-pointer appearance-none rounded-[18px] border border-white/10 bg-black px-6 text-base text-white outline-none transition-colors focus:border-white/30"
      >
        <option value="all">{allLabel}</option>
        {(Object.entries(options) as [T, string][]).map(([v, l]) => (
          <option key={v} value={v}>
            {l}
          </option>
        ))}
      </select>
      <ChevronDown className="pointer-events-none absolute top-1/2 right-4 size-6 -translate-y-1/2 text-white" strokeWidth={1.5} />
    </div>
  );
}
