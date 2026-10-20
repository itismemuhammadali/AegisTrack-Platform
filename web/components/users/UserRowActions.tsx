"use client";

import { useEffect, useRef, useState } from "react";
import {
  EllipsisVertical,
  Eye,
  RefreshCw,
  SquarePen,
  Trash2,
  UserPlus,
} from "lucide-react";
import type { ManagedUser } from "@/types/user";

export type UserRowAction =
  "view" | "edit" | "reset-password" | "assign-viewer" | "delete";

interface UserRowActionsProps {
  user: ManagedUser;
  onAction: (action: UserRowAction, user: ManagedUser) => void;
}

const ITEM =
  "flex h-9 w-full cursor-pointer items-center gap-3 rounded-[14px] px-3 text-left text-sm leading-5 font-medium whitespace-nowrap transition-colors";

const ITEMS = [
  { action: "view", label: "View Details", icon: Eye },
  { action: "edit", label: "Edit User", icon: SquarePen },
  { action: "reset-password", label: "Reset Password", icon: RefreshCw },
  { action: "assign-viewer", label: "Assign Viewer", icon: UserPlus },
] as const;

/** Row "⋮" menu (Figma 610:26993) — same for Admin and Super Admin. */
export function UserRowActions({ user, onAction }: UserRowActionsProps) {
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) return;
    const onDown = (e: MouseEvent) =>
      !ref.current?.contains(e.target as Node) && setOpen(false);
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && setOpen(false);
    document.addEventListener("mousedown", onDown);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("mousedown", onDown);
      document.removeEventListener("keydown", onKey);
    };
  }, [open]);

  function pick(action: UserRowAction) {
    setOpen(false);
    onAction(action, user);
  }

  return (
    <div ref={ref} className="relative inline-flex">
      <button
        type="button"
        aria-label={`Actions for ${user.name}`}
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
          className="absolute top-full right-0 z-20 mt-1 flex w-[192px] flex-col rounded-[18px] border border-white/10 bg-[linear-gradient(133.5deg,rgba(12,18,39,0.4)_0%,rgba(12,18,39,0.9)_50%,rgba(12,18,39,0.4)_100%),linear-gradient(#0c0e1a,#0c0e1a)] p-1 drop-shadow-[0_25px_25px_rgba(0,0,0,0.25)]"
        >
          {ITEMS.map(({ action, label, icon: Icon }) => (
            <button
              key={action}
              role="menuitem"
              type="button"
              className={`${ITEM} text-[#e5e7eb] hover:bg-white/10`}
              onClick={() => pick(action)}
            >
              <Icon className="size-4 shrink-0" /> {label}
            </button>
          ))}
          <div className="my-1 border-t border-white/10" />
          <button
            role="menuitem"
            type="button"
            className={`${ITEM} text-[#ef4444] hover:bg-[#ef4444]/10`}
            onClick={() => pick("delete")}
          >
            <Trash2 className="size-4 shrink-0" /> Delete User
          </button>
        </div>
      )}
    </div>
  );
}
