import type { InputHTMLAttributes } from "react";

interface CheckboxProps extends Omit<InputHTMLAttributes<HTMLInputElement>, "type"> {
  label: string;
}

export function Checkbox({ label, ...props }: CheckboxProps) {
  return (
    <label className="flex cursor-pointer items-center gap-2 text-sm font-medium leading-5 text-white select-none">
      <span className="relative flex size-4 shrink-0">
      <input
        type="checkbox"
        className="peer size-4 shrink-0 cursor-pointer appearance-none rounded border border-white bg-transparent checked:border-[#4a2d8f] checked:bg-[#4a2d8f] focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white"
        {...props}
      />
      <svg
        viewBox="0 0 16 16"
        className="pointer-events-none absolute inset-0 hidden size-4 text-white peer-checked:block"
        aria-hidden
      >
        <path d="M4 8.5 6.5 11 12 5.5" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
      </svg>
      </span>
      {label}
    </label>
  );
}
