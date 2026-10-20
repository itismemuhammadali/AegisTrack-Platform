/**
 * Admin capability catalogue shown on "Role & Permission Details".
 * Level 2 = everything in Level 1 plus the locked advanced areas.
 * Item lists for collapsed groups are placeholders until product confirms them.
 */
export interface CapabilityItem {
  label: string;
  /** false → shown struck-through (not available at this level). */
  allowed: boolean;
}

export interface CapabilityGroup {
  id: string;
  title: string;
  items: CapabilityItem[];
}

export const ADMIN_LEVEL_1: CapabilityGroup[] = [
  {
    id: "user-management",
    title: "User Management",
    items: [
      { label: "Create users", allowed: true },
      { label: "Edit users", allowed: true },
      { label: "Disable users", allowed: true },
      { label: "View user details", allowed: true },
      { label: "Delete users permanently", allowed: false },
      { label: "Override user permissions", allowed: false },
    ],
  },
  {
    id: "viewer-assignments",
    title: "Viewer Assignments",
    items: [
      { label: "Assign viewers to tracked users", allowed: true },
      { label: "Revoke viewer access", allowed: true },
      { label: "View assignment history", allowed: true },
    ],
  },
  {
    id: "monitoring",
    title: "Monitoring",
    items: [
      { label: "View tracking activity", allowed: true },
      { label: "Review security alerts", allowed: true },
      { label: "Review sync failures", allowed: true },
      { label: "Resolve escalations", allowed: false },
    ],
  },
  {
    id: "support",
    title: "Support",
    items: [
      { label: "View support tickets", allowed: true },
      { label: "Respond to tickets", allowed: true },
    ],
  },
];

export const ADMIN_LEVEL_2: CapabilityGroup[] = [
  { id: "legal-hold", title: "Legal Hold", items: [{ label: "Place and release legal holds", allowed: true }, { label: "View held records", allowed: true }] },
  { id: "export-settings", title: "Export Settings", items: [{ label: "Configure export formats", allowed: true }, { label: "Manage export destinations", allowed: true }] },
  { id: "retention-rules", title: "Retention Rules", items: [{ label: "Create retention policies", allowed: true }, { label: "Edit retention periods", allowed: true }] },
  { id: "permission-overrides", title: "Permission Overrides", items: [{ label: "Override user permissions", allowed: true }, { label: "Delete users permanently", allowed: true }] },
  { id: "escalation-resolution", title: "Escalation Resolution", items: [{ label: "Resolve escalations", allowed: true }, { label: "Reassign escalations", allowed: true }] },
  { id: "secure-export", title: "Secure Export Management", items: [{ label: "Approve secure exports", allowed: true }, { label: "Audit export history", allowed: true }] },
];
