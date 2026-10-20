import type { CreateUserInput, ManagedUser, UpdateUserInput, UserListQuery, ViewerAccessLevel } from "@/types/user";
import { apiRequest } from "./apiClient";
import { dbList, dbGet, dbSet, dbDelete, INITIAL_USERS } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

function toQueryString(q: UserListQuery) {
  const p = new URLSearchParams();
  if (q.status && q.status !== "all") p.set("status", q.status);
  if (q.role && q.role !== "all") p.set("role", q.role);
  if (q.search) p.set("search", q.search);
  const s = p.toString();
  return s ? `?${s}` : "";
}

export const userService = {
  async list(query: UserListQuery = {}): Promise<ManagedUser[]> {
    if (!USE_MOCK) return apiRequest<ManagedUser[]>(`/users${toQueryString(query)}`);
    const all = await dbList<ManagedUser>("users", INITIAL_USERS);
    const search = query.search?.trim().toLowerCase();
    return all.filter(
      (u) =>
        (!query.status || query.status === "all" || u.status === query.status) &&
        (!query.role || query.role === "all" || u.role === query.role) &&
        (!search || u.name.toLowerCase().includes(search) || u.email.toLowerCase().includes(search)),
    );
  },

  async get(id: string): Promise<ManagedUser> {
    if (!USE_MOCK) return apiRequest<ManagedUser>(`/users/${id}`);
    const u = await dbGet<ManagedUser>("users", id);
    if (!u) throw new Error("User not found");
    return u;
  },

  async create(input: CreateUserInput): Promise<ManagedUser> {
    if (!USE_MOCK) return apiRequest<ManagedUser>("/users", { method: "POST", body: JSON.stringify(input) });
    const email = input.email.trim();
    const all = await dbList<ManagedUser>("users", INITIAL_USERS);
    if (all.some((u) => u.email.toLowerCase() === email.toLowerCase())) throw new Error("A user with this email already exists");
    const user: ManagedUser = { id: `u${Date.now()}`, name: input.name.trim(), email, role: input.role, status: "active", lastActive: "Just now" };
    await dbSet("users", user.id, user);
    return user;
  },

  async update(id: string, input: UpdateUserInput): Promise<ManagedUser> {
    if (!USE_MOCK) return apiRequest<ManagedUser>(`/users/${id}`, { method: "PATCH", body: JSON.stringify(input) });
    const email = input.email.trim();
    const all = await dbList<ManagedUser>("users", INITIAL_USERS);
    if (all.some((u) => u.id !== id && u.email.toLowerCase() === email.toLowerCase())) throw new Error("Another user already uses this email");
    const updated = await dbSet<ManagedUser>("users", id, { name: input.name.trim(), email, role: input.role });
    return updated;
  },

  async resetPassword(id: string, temporaryPassword: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/users/${id}/reset-password`, { method: "POST", body: JSON.stringify({ temporaryPassword }) });
      return;
    }
    const u = await dbGet<ManagedUser>("users", id);
    if (!u) throw new Error("User not found");
  },

  async assignViewer(trackedUserId: string, viewerId: string, accessLevel: ViewerAccessLevel): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/users/${trackedUserId}/viewers`, { method: "POST", body: JSON.stringify({ viewerId, accessLevel }) });
      return;
    }
    const u = await dbGet<ManagedUser>("users", viewerId);
    if (!u || u.role !== "authorized_viewer") throw new Error("Viewer not found");
  },

  async setDisabled(id: string, disabled: boolean): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/users/${id}/${disabled ? "disable" : "enable"}`, { method: "POST" });
      return;
    }
    await dbSet("users", id, { status: disabled ? "disabled" : "active" });
  },

  async remove(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/users/${id}`, { method: "DELETE" });
      return;
    }
    await dbDelete("users", id);
  },
};
