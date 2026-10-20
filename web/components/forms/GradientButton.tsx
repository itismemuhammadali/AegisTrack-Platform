import type { ButtonHTMLAttributes } from "react";

interface GradientButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  loading?: boolean;
}

export function GradientButton({ loading, disabled, children, className = "", ...props }: GradientButtonProps) {
  return (
    <button
      disabled={disabled || loading}
      aria-busy={loading}
      className={`flex w-full cursor-pointer items-center justify-center gap-2 rounded-2xl bg-[linear-gradient(90deg,#2f1d63_0%,#4a2d8f_100%)] py-5 text-base leading-6 font-medium text-white shadow-[0_10px_7.5px_rgba(47,29,99,0.3),0_4px_3px_rgba(47,29,99,0.3)] transition hover:brightness-125 active:brightness-95 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:brightness-100 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white ${className}`}
      {...props}
    >
      {loading && (
        <span className="size-4 animate-spin rounded-full border-2 border-white/40 border-t-white" aria-hidden />
      )}
      {children}
    </button>
  );
}
