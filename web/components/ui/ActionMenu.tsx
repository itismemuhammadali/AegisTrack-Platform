"use client";

import { useEffect, useRef, useState } from "react";
import { EllipsisVertical, type LucideIcon } from "lucide-react";

const ITEM = "flex h-9 w-full cursor-pointer items-center gap-3 rounded-[14px] px-3 text-left text-sm leading-5 font-medium whitespace-nowrap transition-colors";

export interface ActionMenuItem {
  label: string;
  icon: LucideIcon;
  onSelect: () => void;
  /** Red destructive item, drawn below a divider (Figma "Delete …"). */
  danger?: boolean;
}

/** Row-level ⋮ dropdown in the Figma "Action" style. Closes on outside click / Escape. */
export function ActionMenu({ label, items, width = "w-[176px]" }: { label: string; items: ActionMenuItem[]; width?: string }) {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const onDown = (e: MouseEvent) => !ref.current?.contains(e.target as Node) && setOpen(false);
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && setOpen(false);
    document.addEventListener("mousedown", onDown);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("mousedown", onDown);
      document.removeEventListener("keydown", onKey);
    };
  }, [open]);

  const regular = items.filter((i) => !i.danger);
  const danger = items.filter((i) => i.danger);

  function render({ label, icon: Icon, onSelect, danger }: ActionMenuItem) {
    return (
      <button
        key={label}
        role="menuitem"
        type="button"
        className={`${ITEM} ${danger ? "text-[#ef4444] hover:bg-[#ef4444]/10" : "text-[#e5e7eb] hover:bg-white/10"}`}
        onClick={() => {
          setOpen(false);
          onSelect();
        }}
      >
        <Icon className="size-4 shrink-0" /> {label}
      </button>
    );
  }

  return (
    <div ref={ref} className="relative inline-flex">
      <button
        type="button"
        aria-label={label}
        aria-haspopup="menu"
        aria-expanded={open}
        onClick={() => setOpen((o) => !o)}
        className="flex size-8 cursor-pointer items-center justify-center rounded-[14px] text-white transition-colors hover:bg-white/10"
      >
        <EllipsisVertical className="size-4" />
      </button>

      {open && (
        <div
          role="menu"
          className={`absolute top-full right-0 z-20 mt-1 flex ${width} flex-col rounded-[18px] border border-white/10 bg-[linear-gradient(140deg,rgba(12,18,39,0.4)_0%,rgba(12,18,39,0.9)_50%,rgba(12,18,39,0.4)_100%),linear-gradient(#0c0e1a,#0c0e1a)] p-1 drop-shadow-[0_25px_25px_rgba(0,0,0,0.25)]`}
        >
          {regular.map(render)}
          {danger.length > 0 && regular.length > 0 && <div className="my-1 border-t border-white/10" />}
          {danger.map(render)}
        </div>
      )}
    </div>
  );
}
