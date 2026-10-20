import type { SystemInfo, SystemSettings } from "@/types/settings";
import { apiRequest } from "./apiClient";
import { dbGet, dbSet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const defaultSettings: SystemSettings = {
  security: { twoFactor: false, sessionTimeout: true, ipWhitelist: false },
  notifications: { failedSync: true, newUser: true, securityAlerts: true, exportCompletion: false },
  retention: { logRetentionDays: "30", autoDeleteExportsDays: "30", automaticBackup: true },
  exports: { encryptedPdf: true, watermark: false, defaultFormat: "pdf" },
};

const mockInfo: SystemInfo = {
  platformVersion: "v2.4.1",
  databaseStatus: "Connected (Firestore)",
  lastBackup: "2 hours ago",
  storageUsed: "42.3 GB",
  activeSessions: 89,
  uptime: "45 days",
};

export const settingsService = {
  async get(): Promise<SystemSettings> {
    if (!USE_MOCK) return apiRequest("/settings");
    const doc = await dbGet<any>("settings", "global_settings");
    return doc ? { ...defaultSettings, ...doc } : structuredClone(defaultSettings);
  },

  /** Persists one section; the UI saves each change as it's made. */
  async update<K extends keyof SystemSettings>(section: K, patch: Partial<SystemSettings[K]>): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/settings/${section}`, { method: "PATCH", body: JSON.stringify(patch) });
      return;
    }
    const current = await this.get();
    const updated = { ...current, [section]: { ...current[section], ...patch } };
    await dbSet("settings", "global_settings", updated);
  },

  async systemInfo(): Promise<SystemInfo> {
    if (!USE_MOCK) return apiRequest("/settings/system-info");
    return mockInfo;
  },
};

