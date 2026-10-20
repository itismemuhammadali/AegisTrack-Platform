import type { ReactNode } from "react";

interface PanelProps {
  title?: ReactNode;
  subtitle?: ReactNode;
  /** Right side of the header (icon, "Live" indicator, action…). */
  action?: ReactNode;
  children: ReactNode;
  className?: string;
}

/** Dark translucent card used by every dashboard widget. */
export function Panel({ title, subtitle, action, children, className = "" }: PanelProps) {
  return (
    <section
      className={`flex min-w-0 flex-col rounded-2xl border border-white/10 bg-black/60 p-4 backdrop-blur-[24px] sm:p-6 ${className}`}
    >
      {(title || action) && (
        <header className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            {title && <h3 className="text-base leading-6 font-semibold text-[#e5e7eb]">{title}</h3>}
            {subtitle && <p className="pt-0.5 text-xs leading-4 text-[#9ca3af]">{subtitle}</p>}
          </div>
          {action && <div className="shrink-0">{action}</div>}
        </header>
      )}
      {children}
    </section>
  );
}
