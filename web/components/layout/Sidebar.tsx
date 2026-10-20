"use client";

import Image from "next/image";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { ChevronLeft, LogOut, X } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { navItemsForRole } from "@/lib/navigation";
import { BrandMark } from "./BrandMark";

interface SidebarProps {
  collapsed: boolean;
  onToggleCollapsed: () => void;
  mobileOpen: boolean;
  onCloseMobile: () => void;
}

export function Sidebar({ collapsed, onToggleCollapsed, mobileOpen, onCloseMobile }: SidebarProps) {
  const pathname = usePathname();
  const { user, logout } = useAuth();
  const items = navItemsForRole(user.role);
  // Collapsing only applies to the docked desktop sidebar; the mobile drawer is always full width.
  const rail = collapsed && !mobileOpen;

  return (
    <>
      {/* Mobile / tablet backdrop */}
      <div
        onClick={onCloseMobile}
        aria-hidden
        className={`fixed inset-0 z-40 bg-black/60 backdrop-blur-sm transition-opacity xl:hidden ${
          mobileOpen ? "opacity-100" : "pointer-events-none opacity-0"
        }`}
      />

      <aside
        aria-label="Main navigation"
        className={`fixed inset-y-0 left-0 z-50 flex flex-col border-r border-white/10 bg-[linear-gradient(97deg,rgba(12,18,39,0.4)_0%,rgba(12,18,39,0.9)_50%,rgba(12,18,39,0.4)_100%),linear-gradient(#000,#000)] transition-[width,translate] duration-200 xl:sticky xl:top-0 xl:h-screen xl:translate-x-0 ${
          mobileOpen ? "translate-x-0" : "-translate-x-full"
        } ${rail ? "w-[88px]" : "w-[260px]"}`}
      >
        {/* Header */}
        <div className={`flex h-[100px] shrink-0 items-center border-b border-white/10 px-6 ${rail ? "justify-center px-0" : "justify-between"}`}>
          <BrandMark showText={!rail} />
          <button
            type="button"
            onClick={onToggleCollapsed}
            aria-label={collapsed ? "Expand sidebar" : "Collapse sidebar"}
            className={`hidden size-8 cursor-pointer items-center justify-center rounded-[14px] text-[#e5e7eb] transition hover:bg-white/10 xl:flex ${rail ? "absolute -right-4 border border-white/10 bg-[#0c1227]" : ""}`}
          >
            <ChevronLeft className={`size-5 transition-transform ${collapsed ? "rotate-180" : ""}`} />
          </button>
          <button
            type="button"
            onClick={onCloseMobile}
            aria-label="Close menu"
            className="flex size-8 cursor-pointer items-center justify-center rounded-[14px] text-[#e5e7eb] hover:bg-white/10 xl:hidden"
          >
            <X className="size-5" />
          </button>
        </div>

        {/* Navigation */}
        <nav className="flex min-h-0 flex-1 flex-col gap-4 overflow-y-auto p-4 [scrollbar-width:none] [&::-webkit-scrollbar]:hidden">
          {items.map(({ href, label, icon: Icon }) => {
            const active = pathname === href || pathname.startsWith(`${href}/`);
            return (
              <Link
                key={href}
                href={href}
                onClick={onCloseMobile}
                title={rail ? label : undefined}
                aria-current={active ? "page" : undefined}
                className={`flex shrink-0 items-center gap-4 rounded-[18px] text-base whitespace-nowrap transition-colors ${
                  rail ? "justify-center p-4" : "p-4"
                } ${
                  active
                    ? "bg-[linear-gradient(90deg,#2f1d63_0%,#4a2d8f_100%)] font-semibold text-white shadow-[0_10px_7.5px_rgba(52,32,108,0.2),0_4px_3px_rgba(52,32,108,0.2)]"
                    : "border border-white/10 font-medium text-[#e5e7eb] hover:border-white/20 hover:bg-white/5"
                }`}
              >
                <Icon className="size-5 shrink-0" strokeWidth={1.75} />
                {!rail && <span className="min-w-0">{label}</span>}
              </Link>
            );
          })}
        </nav>

        {/* User + logout */}
        <div className="flex shrink-0 flex-col gap-6 border-t border-[#01303f] p-4">
          <div className={`flex items-center gap-3 ${rail ? "justify-center" : ""}`}>
            <Image
              src={user.avatarUrl ?? "/images/avatar.png"}
              unoptimized={user.avatarUrl?.startsWith("blob:")}
              alt=""
              width={40}
              height={40}
              className="size-10 shrink-0 rounded-full bg-[linear-gradient(135deg,#ad46ff_0%,#4f39f6_100%)] object-cover"
            />
            {!rail && (
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm leading-5 font-medium text-[#e5e7eb]">{user.name}</p>
                <p className="truncate text-xs leading-4 text-[#9ca3af]">{user.email}</p>
              </div>
            )}
          </div>
          <button
            type="button"
            onClick={logout}
            title={rail ? "Logout" : undefined}
            className="flex cursor-pointer items-center justify-center gap-3 rounded-[18px] border border-white/10 px-3 py-2.5 text-sm leading-5 font-medium text-[#ff6467] transition-colors hover:border-[#ff6467]/30 hover:bg-[#ff6467]/10"
          >
            <LogOut className="size-4" />
            {!rail && "Logout"}
          </button>
        </div>
      </aside>
    </>
  );
}
