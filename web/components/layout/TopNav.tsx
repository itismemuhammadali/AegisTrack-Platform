"use client";

import Image from "next/image";
import { useEffect, useRef, useState } from "react";
import { Bell, Menu, Search } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { useAsync } from "@/hooks/useAsync";
import { notificationService } from "@/services/notificationService";
import type { AppNotification } from "@/types/notification";
import { NotificationsPanel } from "./NotificationsPanel";
import { ProfileMenu } from "./ProfileMenu";
import { ProfileSettingsModal } from "./ProfileSettingsModal";

interface TopNavProps {
  onOpenMenu: () => void;
}

export function TopNav({ onOpenMenu }: TopNavProps) {
  const { user, logout } = useAuth();
  const [open, setOpen] = useState(false);
  const [profileOpen, setProfileOpen] = useState(false);
  const [settingsOpen, setSettingsOpen] = useState(false);
  const profileRef = useRef<HTMLDivElement>(null);
  const [version, setVersion] = useState(0);
  const bellRef = useRef<HTMLDivElement>(null);
  const notifications = useAsync(() => notificationService.list(), [version]);
  const [items, setItems] = useState<AppNotification[] | null>(null);
  useEffect(() => {
    if (notifications.data) setItems(notifications.data); // eslint-disable-line react-hooks/set-state-in-effect -- keeps list visible during refetch
  }, [notifications.data]);
  const notificationCount = items?.filter((n) => !n.read).length ?? 0;

  useEffect(() => {
    if (!open) return;
    const onPointer = (e: PointerEvent) => {
      if (!bellRef.current?.contains(e.target as Node)) setOpen(false);
    };
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && setOpen(false);
    document.addEventListener("pointerdown", onPointer);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("pointerdown", onPointer);
      document.removeEventListener("keydown", onKey);
    };
  }, [open]);

  useEffect(() => {
    if (!profileOpen) return;
    const onPointer = (e: PointerEvent) => {
      if (!profileRef.current?.contains(e.target as Node))
        setProfileOpen(false);
    };
    const onKey = (e: KeyboardEvent) =>
      e.key === "Escape" && setProfileOpen(false);
    document.addEventListener("pointerdown", onPointer);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("pointerdown", onPointer);
      document.removeEventListener("keydown", onKey);
    };
  }, [profileOpen]);

  async function markRead(id: string) {
    setItems(
      (list) =>
        list?.map((n) => (n.id === id ? { ...n, read: true } : n)) ?? null,
    );
    await notificationService.markRead(id).catch(() => undefined);
    setVersion((v) => v + 1);
  }

  async function markAllRead() {
    setItems((list) => list?.map((n) => ({ ...n, read: true })) ?? null);
    await notificationService.markAllRead().catch(() => undefined);
    setVersion((v) => v + 1);
  }

  return (
    <header className="sticky top-0 z-30 flex h-[72px] items-center justify-between gap-3 border-b border-white/10 bg-[linear-gradient(175deg,rgba(12,18,39,0.4)_0%,rgba(12,18,39,0.9)_50%,rgba(12,18,39,0.4)_100%),linear-gradient(#000,#000)] px-4 sm:px-6 xl:h-[100px]">
      <div className="flex min-w-0 flex-1 items-center gap-3">
        <button
          type="button"
          onClick={onOpenMenu}
          aria-label="Open menu"
          className="flex size-10 shrink-0 cursor-pointer items-center justify-center rounded-[14px] text-[#e5e7eb] hover:bg-white/10 xl:hidden"
        >
          <Menu className="size-5" />
        </button>

        <form
          role="search"
          className="relative w-full max-w-[576px]"
          onSubmit={(e) => e.preventDefault()}
        >
          <Search
            className="pointer-events-none absolute top-1/2 left-3 size-5 -translate-y-1/2 text-white/60"
            strokeWidth={1.75}
          />
          <input
            type="search"
            aria-label="Search"
            placeholder="Search users, logs, reports..."
            className="h-[46px] w-full rounded-[18px] border border-white/10 bg-white/10 pr-4 pl-10 text-base text-[#e5e7eb] outline-none placeholder:text-white/60 transition-colors focus:border-white/30"
          />
        </form>
      </div>

      <div className="flex shrink-0 items-center gap-2 sm:gap-4">
        <div className="hidden items-center gap-2 rounded-[14px] border border-[#00c950]/20 bg-[#00c950]/10 px-3 py-[7px] md:flex">
          <span className="size-2 rounded-full bg-[#00c950] opacity-90" />
          <span className="text-xs leading-4 font-medium whitespace-nowrap text-[#05df72]">
            System Online
          </span>
        </div>

        <div ref={bellRef} className="relative">
          <button
            type="button"
            onClick={() => {
              if (!open) setVersion((v) => v + 1);
              setOpen((o) => !o);
            }}
            aria-expanded={open}
            aria-haspopup="dialog"
            aria-label={`Notifications${notificationCount ? ` (${notificationCount} unread)` : ""}`}
            className="relative flex size-10 cursor-pointer items-center justify-center rounded-[18px] text-[#e5e7eb] transition-colors hover:bg-white/10"
          >
            <Bell className="size-5" strokeWidth={1.75} />
            {notificationCount > 0 && (
              <span className="absolute top-1 left-5 flex size-4 items-center justify-center rounded-full bg-[#ef4444] text-[10px] leading-none font-semibold text-white">
                {notificationCount}
              </span>
            )}
          </button>
          {open && (
            <NotificationsPanel
              items={items}
              loading={notifications.loading}
              error={notifications.error}
              onClose={() => setOpen(false)}
              onRead={markRead}
              onReadAll={markAllRead}
            />
          )}
        </div>

        <div ref={profileRef} className="relative">
          <button
            type="button"
            onClick={() => setProfileOpen((o) => !o)}
            aria-expanded={profileOpen}
            aria-haspopup="menu"
            aria-label="Account menu"
            className="cursor-pointer rounded-full p-1 transition hover:ring-2 hover:ring-white/20 sm:px-3"
          >
            <Image
              src={user.avatarUrl ?? "/images/avatar.png"}
              unoptimized={user.avatarUrl?.startsWith("blob:")}
              alt=""
              width={32}
              height={32}
              className="size-8 rounded-full object-cover"
            />
          </button>
          {profileOpen && (
            <ProfileMenu
              user={user}
              onViewProfile={() => {
                setProfileOpen(false);
                setSettingsOpen(true);
              }}
              onSignOut={logout}
            />
          )}
        </div>
      </div>
      {settingsOpen && (
        <ProfileSettingsModal onClose={() => setSettingsOpen(false)} />
      )}
    </header>
  );
}
