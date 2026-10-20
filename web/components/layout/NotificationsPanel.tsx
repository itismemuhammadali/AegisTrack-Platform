"use client";

import { CircleCheck, Info, TriangleAlert, X } from "lucide-react";
import type { AppNotification, NotificationKind } from "@/types/notification";

const KIND_STYLE: Record<NotificationKind, { icon: typeof Info; className: string }> = {
  critical: { icon: TriangleAlert, className: "bg-[#fb2c36]/10 text-[#ff6467]" },
  success: { icon: CircleCheck, className: "bg-[#00c950]/10 text-[#05df72]" },
  warning: { icon: TriangleAlert, className: "bg-[#ff6900]/10 text-[#ff8904]" },
  info: { icon: Info, className: "bg-[#2b7fff]/10 text-[#51a2ff]" },
};

interface NotificationsPanelProps {
  items: AppNotification[] | null;
  loading: boolean;
  error: Error | null;
  onClose: () => void;
  onRead: (id: string) => void;
  onReadAll: () => void;
}

/** Header notifications dropdown (Figma 610:26894) — shared by Admin and Super Admin. */
export function NotificationsPanel({ items, loading, error, onClose, onRead, onReadAll }: NotificationsPanelProps) {
  const unread = items?.some((n) => !n.read) ?? false;

  return (
    <div
      role="dialog"
      aria-label="Notifications"
      className="absolute top-[calc(100%+8px)] right-0 z-50 flex max-h-[min(498px,calc(100dvh-96px))] w-[min(382px,calc(100vw-32px))] flex-col overflow-hidden rounded-[18px] border border-white/10 bg-[linear-gradient(127.5deg,rgba(12,18,39,0.4)_0%,rgba(12,18,39,0.9)_50%,rgba(12,18,39,0.4)_100%),linear-gradient(#0c0e1a,#0c0e1a)] shadow-[0_25px_50px_-12px_rgba(0,0,0,0.25)]"
    >
      <div className="flex h-[52px] shrink-0 items-center justify-between border-b border-white/10 px-4">
        <h3 className="text-lg leading-[27px] font-semibold text-[#e5e7eb]">Notifications</h3>
        <button type="button" onClick={onClose} aria-label="Close notifications" className="flex size-6 cursor-pointer items-center justify-center rounded-[14px] text-[#e5e7eb] transition hover:bg-white/10">
          <X className="size-4" />
        </button>
      </div>

      <ul className="min-h-0 flex-1 overflow-y-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden" aria-busy={loading}>
        {error && <li className="px-4 py-6 text-sm text-red-300">Couldn&apos;t load notifications. {error.message}</li>}
        {loading && !items && [0, 1, 2].map((i) => <li key={i} className="h-[89px] animate-pulse border-b border-white/10 bg-white/[0.02]" />)}
        {items?.length === 0 && <li className="px-4 py-10 text-center text-sm text-[#9ca3af]">You&apos;re all caught up.</li>}
        {items?.map((n) => {
          const { icon: Icon, className } = KIND_STYLE[n.kind];
          return (
            <li key={n.id} className={`border-b border-white/10 ${n.read ? "" : "bg-[#3c2579]/5"}`}>
              <button type="button" onClick={() => !n.read && onRead(n.id)} className={`flex w-full gap-3 px-4 pt-3 pb-3 text-left ${n.read ? "cursor-default" : "cursor-pointer hover:bg-white/[0.03]"}`}>
                <span className={`flex size-8 shrink-0 items-center justify-center rounded-[14px] ${className}`}>
                  <Icon className="size-4" />
                </span>
                <span className="flex min-w-0 flex-1 flex-col gap-1">
                  <span className="text-sm leading-5 font-medium text-[#e5e7eb]">{n.title}</span>
                  <span className="text-xs leading-4 text-[#9ca3af]">{n.message}</span>
                  <span className="text-xs leading-4 text-[#9ca3af]">{n.time}</span>
                </span>
                {!n.read ? <span className="mt-2 mr-3 size-2 shrink-0 rounded-full bg-[#3c2579]" aria-label="Unread" /> : <span className="w-5 shrink-0" />}
              </button>
            </li>
          );
        })}
      </ul>

      <div className="shrink-0 border-t border-white/10 px-4 py-4">
        <button type="button" onClick={onReadAll} disabled={!unread} className="cursor-pointer text-xs leading-4 font-medium text-white transition hover:text-[#c4b4ff] disabled:cursor-default disabled:opacity-50 disabled:hover:text-white">
          Mark all as read
        </button>
      </div>
    </div>
  );
}
