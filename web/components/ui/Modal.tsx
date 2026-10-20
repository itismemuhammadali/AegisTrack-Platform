"use client";

import { type ReactNode, useEffect } from "react";
import { X } from "lucide-react";

interface ModalProps {
  title: ReactNode;
  subtitle?: string;
  /** Extra element beside the title (e.g. a severity badge). */
  titleAside?: ReactNode;
  onClose: () => void;
  /** Tailwind max-width class; Figma dialogs are 512px or 700px wide. */
  width?: string;
  /** Some Figma dialogs (e.g. Edit User) have no × button. */
  hideClose?: boolean;
  children: ReactNode;
}

/** Dialog shell from the Figma modals (Apply Legal Hold, Legal Hold Details, Escalation Details). */
export function Modal({
  title,
  subtitle,
  titleAside,
  onClose,
  width = "max-w-[512px]",
  hideClose,
  children,
}: ModalProps) {
  useEffect(() => {
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    document.addEventListener("keydown", onKey);
    const overflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    return () => {
      document.removeEventListener("keydown", onKey);
      document.body.style.overflow = overflow;
    };
  }, [onClose]);

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/70 p-4 backdrop-blur-sm"
      onMouseDown={(e) => e.target === e.currentTarget && onClose()}
    >
      <div
        role="dialog"
        aria-modal="true"
        aria-label={typeof title === "string" ? title : undefined}
        className={`my-auto flex w-full ${width} flex-col gap-4 rounded-2xl border border-white/10 p-5 shadow-2xl sm:p-6`}
        style={{
          backgroundImage:
            "linear-gradient(128deg, rgba(12,18,39,0.4) 0%, rgba(12,18,39,0.9) 50%, rgba(12,18,39,0.4) 100%), linear-gradient(90deg, #0c0e1a 0%, #0c0e1a 100%)",
        }}
      >
        <div className="flex items-center justify-between gap-4">
          <div className="flex min-w-0 flex-col gap-0.5">
            <div className="flex flex-wrap items-center gap-2">
              <h2 className="text-xl leading-7 font-semibold text-[#e5e7eb]">
                {title}
              </h2>
              {titleAside}
            </div>
            {subtitle && (
              <p className="text-sm leading-5 text-[#9ca3af]">{subtitle}</p>
            )}
          </div>
          {!hideClose && (
            <button
              type="button"
              onClick={onClose}
              aria-label="Close"
              className="shrink-0 cursor-pointer rounded-[14px] bg-white/10 p-2 text-white transition hover:bg-white/15"
            >
              <X className="size-5" />
            </button>
          )}
        </div>
        {children}
      </div>
    </div>
  );
}

/** Label + value tile used inside detail dialogs. */
export function DetailTile({
  label,
  children,
  className = "",
}: {
  label: string;
  children: ReactNode;
  className?: string;
}) {
  return (
    <div
      className={`flex flex-col gap-1 rounded-[18px] border border-white/10 bg-white/10 p-3 ${className}`}
    >
      <p className="text-xs leading-4 text-[#9ca3af]">{label}</p>
      <div className="text-sm leading-5 font-medium break-words text-[#e5e7eb]">
        {children}
      </div>
    </div>
  );
}

/** Timeline row (icon, action, actor, date) used by Hold History / Investigation History. */
export function HistoryRow({
  icon,
  action,
  actor,
  date,
}: {
  icon: ReactNode;
  action: string;
  actor: string;
  date: string;
}) {
  return (
    <li className="flex items-start gap-3 rounded-[18px] bg-white/10 p-3">
      <span className="shrink-0 pt-0.5">{icon}</span>
      <div className="min-w-0 flex-1">
        <p className="text-xs leading-4 font-medium text-[#e5e7eb]">{action}</p>
        <p className="truncate text-xs leading-4 text-[#9ca3af]">{actor}</p>
      </div>
      <span className="shrink-0 text-xs leading-4 text-[#9ca3af]">{date}</span>
    </li>
  );
}
