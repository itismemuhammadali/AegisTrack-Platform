import {
  Activity,
  Archive,
  ChartColumn,
  CircleAlert,
  CircleArrowUp,
  CircleQuestionMark,
  Download,
  FileText,
  LayoutGrid,
  Lock,
  type LucideIcon,
  RefreshCw,
  Settings,
  UserCheck,
  UserCog,
  Users,
} from "lucide-react";
import type { AdminRole } from "@/types/auth";

export interface NavItem {
  label: string;
  href: string;
  icon: LucideIcon;
  /** Roles allowed to see and open this section. */
  roles: readonly AdminRole[];
}

const ALL: readonly AdminRole[] = ["SUPER_ADMIN", "ADMIN"];
const SUPER_ONLY: readonly AdminRole[] = ["SUPER_ADMIN"];

/**
 * Single source of truth for sidebar order and role access.
 * Order matches the Figma sidebars (Admin: 222:2903, Super Admin: 610:17369).
 */
export const NAV_ITEMS: readonly NavItem[] = [
  { label: "Dashboard", href: "/dashboard", icon: LayoutGrid, roles: ALL },
  { label: "Users", href: "/users", icon: Users, roles: ALL },
  { label: "Access Assignments", href: "/access-assignments", icon: UserCheck, roles: ALL },
  { label: "Cases", href: "/cases", icon: UserCheck, roles: ALL },
  { label: "Zones / Geofencing", href: "/zones", icon: UserCheck, roles: ALL },
  { label: "Scheduled Check-ins", href: "/check-ins", icon: UserCheck, roles: ALL },
  { label: "Security Alerts", href: "/security-alerts", icon: CircleAlert, roles: ALL },
  { label: "Sync Failures", href: "/sync-failures", icon: RefreshCw, roles: ALL },
  { label: "Audit Logs", href: "/audit-logs", icon: FileText, roles: ALL },
  { label: "Export Settings", href: "/export-settings", icon: Download, roles: SUPER_ONLY },
  { label: "Retention Rules", href: "/retention-rules", icon: Archive, roles: SUPER_ONLY },
  { label: "Legal Hold", href: "/legal-hold", icon: Lock, roles: SUPER_ONLY },
  { label: "Escalations", href: "/escalations", icon: CircleArrowUp, roles: SUPER_ONLY },
  { label: "Reports", href: "/reports", icon: ChartColumn, roles: ALL },
  { label: "Tracking Activity", href: "/tracking-activity", icon: Activity, roles: ALL },
  { label: "Support", href: "/support", icon: CircleQuestionMark, roles: ALL },
  { label: "Admin Management", href: "/admin-management", icon: UserCog, roles: SUPER_ONLY },
  { label: "Settings", href: "/settings", icon: Settings, roles: ALL },
];

export function navItemsForRole(role: AdminRole) {
  return NAV_ITEMS.filter((item) => item.roles.includes(role));
}

/** True when `role` may open `pathname` (matches the nav section it belongs to). */
export function canAccessPath(role: AdminRole, pathname: string) {
  const item = NAV_ITEMS.find((i) => pathname === i.href || pathname.startsWith(`${i.href}/`));
  return !item || item.roles.includes(role);
}
