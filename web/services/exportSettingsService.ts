import type { ExportActivity, ExportChannel, ExportChannelSettings, ExportSettingsOverview } from "@/types/exportSettings";
import { apiRequest } from "./apiClient";
import { dbList, dbSet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

type ExportChannelRecord = ExportChannelSettings & { id: string };

const initialChannels: ExportChannelRecord[] = [
  { id: "pdf", channel: "pdf", enabled: true, requireApproval: false, auditAll: true, maxRecords: 5000, allowedRoles: ["admin", "authorized_viewer"] },
  { id: "spreadsheet", channel: "spreadsheet", enabled: true, requireApproval: true, auditAll: true, maxRecords: 10000, allowedRoles: ["admin"] },
  { id: "email", channel: "email", enabled: false, requireApproval: true, auditAll: true, maxRecords: 1000, allowedRoles: ["admin"] },
];

const initialActivity: ExportActivity[] = [
  { id: "e1", channel: "pdf", user: "emma.davis@defensecounsel.org", records: 247, time: "5 mins ago", status: "success" },
  { id: "e2", channel: "spreadsheet", user: "admin@securetrack.io", records: 1840, time: "1 hour ago", status: "success" },
  { id: "e3", channel: "pdf", user: "sarah.j@lawfirm.com", records: 89, time: "3 hours ago", status: "success" },
  { id: "e4", channel: "email", user: "mark.thompson@example.com", records: null, time: "Yesterday", status: "blocked" },
  { id: "e5", channel: "spreadsheet", user: "lisa.anderson@example.com", records: 432, time: "Yesterday", status: "pending_approval" },
];

export const exportSettingsService = {
  async get(): Promise<ExportSettingsOverview> {
    if (!USE_MOCK) return apiRequest("/export-settings");
    const channels = await dbList<ExportChannelRecord>("export_channels", initialChannels);
    return { activeAssignments: 6, channels: channels.map((c) => ({ ...c, allowedRoles: [...c.allowedRoles] })) };
  },

  async update(channel: ExportChannel, patch: Partial<Omit<ExportChannelSettings, "channel">>): Promise<ExportChannelSettings> {
    if (!USE_MOCK) return apiRequest(`/export-settings/${channel}`, { method: "PATCH", body: JSON.stringify(patch) });
    const channels = await dbList<ExportChannelRecord>("export_channels", initialChannels);
    const existing = channels.find((c) => c.channel === channel);
    const updated = { ...(existing || { id: channel, channel, enabled: true, requireApproval: false, auditAll: true, maxRecords: 5000, allowedRoles: ["admin"] }), ...patch };
    await dbSet<ExportChannelRecord>("export_channels", channel, updated);
    return updated;
  },

  async activity(): Promise<ExportActivity[]> {
    if (!USE_MOCK) return apiRequest("/export-settings/activity");
    return dbList<ExportActivity>("export_activities", initialActivity);
  },
};

