import type { AppNotification } from "@/types/notification";
import { apiRequest } from "./apiClient";
import { dbList, dbSet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const initialNotifications: AppNotification[] = [
  { id: "n1", kind: "critical", title: "Multiple Failed Login Attempts", message: "5 failed attempts from IP 192.168.1.45", time: "30 minutes ago", read: false },
  { id: "n2", kind: "success", title: "Export Completed", message: "User activity report is ready for download", time: "1 hour ago", read: false },
  { id: "n3", kind: "warning", title: "Unusual Export Activity", message: "User exported data 10 times in 1 hour", time: "3 hours ago", read: false },
  { id: "n4", kind: "info", title: "New User Created", message: "Johnathan Vance added as Tracked User", time: "5 hours ago", read: true },
  { id: "n5", kind: "success", title: "System Backup Complete", message: "Daily backup completed successfully", time: "8 hours ago", read: true },
];

export const notificationService = {
  async list(): Promise<AppNotification[]> {
    if (!USE_MOCK) return apiRequest("/notifications");
    return dbList<AppNotification>("notifications", initialNotifications);
  },

  async markRead(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/notifications/${id}/read`, { method: "POST" });
      return;
    }
    await dbSet<AppNotification>("notifications", id, { read: true });
  },

  async markAllRead(): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest("/notifications/read-all", { method: "POST" });
      return;
    }
    const list = await dbList<AppNotification>("notifications", initialNotifications);
    for (const item of list) {
      await dbSet<AppNotification>("notifications", item.id, { read: true });
    }
  },
};

