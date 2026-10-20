import Link from "next/link";
import { CircleAlert, Download, type LucideIcon, Plus, RefreshCw, UserPlus } from "lucide-react";
import { Can } from "@/components/providers/Can";

interface QuickAction {
  label: string;
  href: string;
  icon: LucideIcon;
  className: string;
  /** Permission needed; Super Admin always passes. */
  permission?: string;
}

const ACTIONS: QuickAction[] = [
  { label: "Create Case", href: "/cases/new", icon: Plus, permission: "cases.create", className: "border-[#34206c]/20 bg-white/10 text-white" },
  { label: "Assign Viewer", href: "/access-assignments/new", icon: UserPlus, permission: "access.assign", className: "border-[#2b7fff]/20 bg-[#2b7fff]/10 text-[#51a2ff]" },
  { label: "Review Security Alerts", href: "/security-alerts", icon: CircleAlert, className: "border-[#fb2c36]/20 bg-[#fb2c36]/10 text-[#ff6467]" },
  { label: "Review Failed Syncs", href: "/sync-failures", icon: RefreshCw, className: "border-[#f0b100]/20 bg-[#f0b100]/10 text-[#fdc700]" },
  { label: "Manage Exports", href: "/reports", icon: Download, permission: "exports.manage", className: "border-[#00c950]/20 bg-[#00c950]/10 text-[#05df72]" },
];

export function QuickActions() {
  return (
    <section className="flex flex-col gap-2.5 rounded-2xl border border-white/10 bg-black/60 p-5 backdrop-blur-[24px]">
      <div className="flex items-center gap-2">
        <h3 className="text-sm leading-5 font-semibold text-[#e5e7eb]">Quick Actions</h3>
        <span className="rounded-[10px] bg-[#fb2c36] px-1.5 py-0.5 text-[9px] leading-[13.5px] font-black text-white">★ NEW</span>
      </div>
      <div className="flex flex-wrap gap-2">
        {ACTIONS.map(({ label, href, icon: Icon, className, permission }) => {
          const link = (
            <Link
              key={label}
              href={href}
              className={`flex items-center gap-2 rounded-[18px] border px-4 py-2 text-sm leading-5 font-medium whitespace-nowrap transition hover:brightness-125 ${className}`}
            >
              <Icon className="size-3.5" />
              {label}
            </Link>
          );
          return permission ? (
            <Can key={label} permission={permission}>
              {link}
            </Can>
          ) : (
            link
          );
        })}
      </div>
    </section>
  );
}
