import type { SyncStatus, TrackingStats, TrackingSync, TrackingSyncDetail } from "@/types/tracking";
import { apiRequest } from "./apiClient";
import { dbList, dbGet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const u = (id: string, name: string, avatar: string) => ({ id, name, avatarUrl: `/images/avatars/${avatar}.png` });

const initialSyncs: TrackingSync[] = [
  { id: "t1", user: u("u1", "Johnathan Vance", "john"), location: "San Francisco, CA", syncTime: "2 mins ago", status: "success", device: "iPhone 15 Pro", signal: "strong" },
  { id: "t2", user: u("u2", "Sarah Johnson, Esq.", "sarah"), location: "Los Angeles, CA", syncTime: "5 mins ago", status: "success", device: "Samsung S24", signal: "strong" },
  { id: "t3", user: u("u3", "Marcus Sterling", "mike"), location: "Oakland, CA", syncTime: "15 mins ago", status: "failed", device: "iPhone 13", signal: "weak" },
  { id: "t4", user: u("u4", "Emma Davis, Esq.", "emma"), location: "San Francisco, CA", syncTime: "30 mins ago", status: "success", device: "Google Pixel 8", signal: "medium" },
  { id: "t5", user: u("u5", "Elena Rostova", "robert"), location: "San Jose, CA", syncTime: "1 hour ago", status: "success", device: "iPhone 15", signal: "strong" },
  { id: "t6", user: u("u6", "Lisa Anderson", "lisa"), location: "San Francisco, CA", syncTime: "2 hours ago", status: "failed", device: "OnePlus 12", signal: "weak" },
];

const mockDetails: Record<string, Omit<TrackingSyncDetail, keyof TrackingSync>> = {
  t1: { coordinates: "37.7749° N, 122.4194° W", syncedAt: "Oct 7, 2026 2:30 PM", os: "iOS 18.0", batteryLevel: 87, gpsAccuracy: 5, speed: 0, altitude: 52 },
  t2: { coordinates: "34.0522° N, 118.2437° W", syncedAt: "Oct 7, 2026 2:27 PM", os: "Android 15", batteryLevel: 64, gpsAccuracy: 8, speed: 32, altitude: 89 },
  t3: { coordinates: "37.7833° N, 122.4167° W", syncedAt: "Oct 7, 2026 2:17 PM", os: "iOS 17.5", batteryLevel: 12, gpsAccuracy: 45, speed: 0, altitude: 181 },
  t4: { coordinates: "37.7752° N, 122.4175° W", syncedAt: "Oct 7, 2026 2:02 PM", os: "Android 15", batteryLevel: 53, gpsAccuracy: 12, speed: 5, altitude: 15 },
  t5: { coordinates: "37.3382° N, 121.8863° W", syncedAt: "Oct 7, 2026 1:32 PM", os: "iOS 18.0", batteryLevel: 91, gpsAccuracy: 4, speed: 58, altitude: 331 },
  t6: { coordinates: "37.7749° N, 122.4194° W", syncedAt: "Oct 7, 2026 12:32 PM", os: "Android 14", batteryLevel: 8, gpsAccuracy: 60, speed: 0, altitude: 12 },
};

export const trackingService = {
  async list({ search = "", status = "all" }: { search?: string; status?: SyncStatus | "all" } = {}): Promise<TrackingSync[]> {
    if (!USE_MOCK) {
      const p = new URLSearchParams();
      if (search.trim()) p.set("search", search.trim());
      if (status !== "all") p.set("status", status);
      const qs = p.toString();
      return apiRequest(`/tracking/syncs${qs ? `?${qs}` : ""}`);
    }
    const s = search.trim().toLowerCase();
    const syncs = await dbList<TrackingSync>("tracking_syncs", initialSyncs);
    return syncs.filter(
      (t) => (status === "all" || t.status === status) && (!s || t.user.name.toLowerCase().includes(s) || t.location.toLowerCase().includes(s)),
    );
  },

  async get(id: string): Promise<TrackingSyncDetail> {
    if (!USE_MOCK) return apiRequest(`/tracking/syncs/${id}`);
    const syncs = await dbList<TrackingSync>("tracking_syncs", initialSyncs);
    const sync = syncs.find((t) => t.id === id);
    if (!sync) throw new Error("Activity not found");
    return { ...sync, ...(mockDetails[id] || { coordinates: "37.7749° N, 122.4194° W", syncedAt: "Just now", os: "iOS 18.0", batteryLevel: 95, gpsAccuracy: 5, speed: 0, altitude: 50 }) };
  },

  async stats(): Promise<TrackingStats> {
    if (!USE_MOCK) return apiRequest("/tracking/stats");
    const syncs = await dbList<TrackingSync>("tracking_syncs", initialSyncs);
    const successful = syncs.filter((t) => t.status === "success").length;
    return { total: syncs.length, successful, failed: syncs.length - successful, onlineUsers: successful };
  },
};

