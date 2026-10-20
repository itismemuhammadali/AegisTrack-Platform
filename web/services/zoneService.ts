import type { Zone, ZoneDetail, ZoneInput, ZoneListQuery, ZoneStats } from "@/types/zone";
import { apiRequest } from "./apiClient";
import { dbList, dbGet, dbSet, dbDelete, INITIAL_ZONES } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const mockExtras: Record<string, any> = {
  z1: {
    assignedUserNames: ["Johnathan Vance", "Marcus Sterling", "Elena Rostova"],
    activity: [
      { id: "a1", kind: "entry", label: "Johnathan Vance — Zone entry", time: "2 mins ago" },
      { id: "a2", kind: "exit", label: "Marcus Sterling — Zone exit", time: "18 mins ago" },
      { id: "a3", kind: "check-in", label: "Elena Rostova — Check-in completed", time: "1 hour ago" },
    ],
  },
};

const MOCK_ASSIGNABLE = ["Johnathan Vance", "Marcus Sterling", "Elena Rostova", "Sarah Johnson", "Emma Davis"];

function mapToZone(z: any): Zone {
  return {
    id: z.id,
    name: z.name,
    latitude: z.lat ?? z.latitude ?? 37.7749,
    longitude: z.lng ?? z.longitude ?? -122.4194,
    type: z.type,
    assignedUsers: z.assignedUsersCount ?? z.assignedUsers ?? 0,
    status: z.status ?? "active",
    lastActivity: z.lastActivity ?? "Today",
    description: z.description,
  };
}

export const zoneService = {
  async list({ search = "", type = "all", status = "all" }: ZoneListQuery = {}): Promise<Zone[]> {
    if (!USE_MOCK) {
      const p = new URLSearchParams();
      if (search.trim()) p.set("search", search.trim());
      if (type !== "all") p.set("type", type);
      if (status !== "all") p.set("status", status);
      const qs = p.toString();
      return apiRequest(`/zones${qs ? `?${qs}` : ""}`);
    }
    const raw = await dbList("zones", INITIAL_ZONES);
    const zones = raw.map(mapToZone);
    const s = search.trim().toLowerCase();
    return zones.filter(
      (z) => (type === "all" || z.type === type) && (status === "all" || z.status === status) && (!s || z.name.toLowerCase().includes(s)),
    );
  },

  async stats(): Promise<ZoneStats> {
    if (!USE_MOCK) return apiRequest("/zones/stats");
    const raw = await dbList("zones", INITIAL_ZONES);
    const zones = raw.map(mapToZone);
    return { totalZones: zones.length, activeAlerts: 3, usersAssigned: zones.reduce((n, z) => n + z.assignedUsers, 0) };
  },

  async setActive(id: string, active: boolean): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/zones/${id}`, { method: "PATCH", body: JSON.stringify({ status: active ? "active" : "inactive" }) });
      return;
    }
    await dbSet("zones", id, { status: active ? "active" : "inactive" });
  },

  async get(id: string): Promise<ZoneDetail> {
    if (!USE_MOCK) return apiRequest(`/zones/${id}`);
    const raw = await dbGet<any>("zones", id);
    if (!raw) throw new Error("Zone not found");
    const zone = mapToZone(raw);
    const extra = mockExtras[id] ?? {
      assignedUserNames: ["Johnathan Vance"],
      activity: [{ id: "a1", kind: "entry", label: `${zone.name} active`, time: "Today" }],
    };
    return { ...zone, ...extra };
  },

  async assignableUsers(): Promise<string[]> {
    if (!USE_MOCK) return apiRequest("/zones/assignable-users");
    return MOCK_ASSIGNABLE;
  },

  async create(input: ZoneInput): Promise<Zone> {
    if (!USE_MOCK) return apiRequest("/zones", { method: "POST", body: JSON.stringify(input) });
    const name = input.name.trim();
    const raw = await dbList("zones", INITIAL_ZONES);
    if (raw.some((z) => z.name.toLowerCase() === name.toLowerCase())) throw new Error(`${name} already exists`);
    const newRecord = {
      id: `z${Date.now()}`,
      name,
      lat: (input as any).latitude ?? 37.7749,
      lng: (input as any).longitude ?? -122.4194,
      radius: (input as any).radius ?? 500,
      type: input.type,
      description: input.description,
      assignedUsersCount: input.assignedUserNames.length,
      status: "active",
      createdAt: new Date().toISOString().slice(0, 10),
    };
    await dbSet("zones", newRecord.id, newRecord);
    return mapToZone(newRecord);
  },

  async update(id: string, input: ZoneInput): Promise<Zone> {
    if (!USE_MOCK) return apiRequest(`/zones/${id}`, { method: "PATCH", body: JSON.stringify(input) });
    const patch = {
      name: input.name.trim(),
      lat: (input as any).latitude ?? 37.7749,
      lng: (input as any).longitude ?? -122.4194,
      radius: (input as any).radius ?? 500,
      type: input.type,
      description: input.description,
      assignedUsersCount: input.assignedUserNames.length,
    };
    const updated = await dbSet("zones", id, patch);
    return mapToZone(updated);
  },

  async remove(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/zones/${id}`, { method: "DELETE" });
      return;
    }
    await dbDelete("zones", id);
  },
};
