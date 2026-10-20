import Image from "next/image";
import { type InputHTMLAttributes, type ReactNode, useId } from "react";

interface IconInputProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string;
  icon: string;
  error?: string;
  /** Optional element after the input, e.g. a show/hide password toggle. */
  trailing?: ReactNode;
}

export function IconInput({ label, icon, error, trailing, id, className = "", ...props }: IconInputProps) {
  const autoId = useId();
  const inputId = id ?? autoId;
  const errorId = `${inputId}-error`;

  return (
    <div className="flex w-full flex-col gap-2">
      <label htmlFor={inputId} className="text-sm font-medium leading-5 text-[#e5e7eb]">
        {label}
      </label>
      <div
        className={`flex w-full items-center gap-4 rounded-[18px] border bg-white/10 p-4 transition-colors focus-within:border-white/40 hover:border-white/20 ${
          error ? "border-red-400/70" : "border-white/10"
        }`}
      >
        <Image src={icon} alt="" width={20} height={20} className="size-5 shrink-0" />
        <input
          id={inputId}
          aria-invalid={!!error}
          aria-describedby={error ? errorId : undefined}
          className={`w-full min-w-0 bg-transparent text-base text-[#e5e7eb] placeholder:text-[#9ca3af] outline-none disabled:opacity-60 ${className}`}
          {...props}
        />
        {trailing}
      </div>
      {error && (
        <p id={errorId} className="text-xs text-red-400">
          {error}
        </p>
      )}
    </div>
  );
}
