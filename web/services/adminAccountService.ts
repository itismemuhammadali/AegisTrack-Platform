import type { AdminAccount, AdminListPage, AdminListQuery, CreateAdminInput, UpdateAdminInput } from "@/types/adminAccount";
import { apiRequest } from "./apiClient";
import { dbList, dbGet, dbSet, dbDelete } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;
const IMG = "/images/admins";

const seed: AdminAccount[] = [
  { id: "a1", firstName: "Julian", lastName: "Drake", email: "j.drake@securetrack.io", role: "super_admin", status: "active", avatarUrl: `${IMG}/julian-drake.png`, lastLogin: "2 mins ago", lastModified: "1 week ago by Super Admin" },
  { id: "a2", firstName: "Elena", lastName: "Rostova", email: "e.rostova@securetrack.io", role: "admin", status: "active", avatarUrl: `${IMG}/elena-rostova.png`, lastLogin: "1 hour ago", lastModified: "2 days ago by Super Admin" },
  { id: "a3", firstName: "Marcus", lastName: "Thorne", email: "m.thorne@securetrack.io", role: "admin", status: "inactive", avatarUrl: `${IMG}/marcus-thorne.png`, lastLogin: "3 days ago", lastModified: "3 days ago by Super Admin" },
  { id: "a4", firstName: "Aria", lastName: "Sterling", email: "a.sterling@securetrack.io", role: "moderator", status: "active", avatarUrl: `${IMG}/aria-sterling.png`, lastLogin: "12 hours ago", lastModified: "5 days ago by Super Admin" },
  { id: "a5", firstName: "Keanu", lastName: "Briggs", email: "k.briggs@securetrack.io", role: "moderator", status: "active", avatarUrl: `${IMG}/keanu-briggs.png`, lastLogin: "Just now", lastModified: "1 day ago by Super Admin" },
  { id: "a6", firstName: "Lian", lastName: "Song", email: "l.song@securetrack.io", role: "admin", status: "active", avatarUrl: `${IMG}/lian-song.png`, lastLogin: "4 hours ago", lastModified: "4 days ago by Super Admin" },
];

const FILLER = ["Noah Patel", "Ivy Chen", "Omar Haddad", "Grace Kim", "Leo Martins", "Maya Singh", "Ethan Cole", "Zara Ali", "Felix Weber", "Nina Park", "Hugo Laurent", "Sara Ortiz", "Dev Rao", "Chloe Brooks", "Ravi Shah", "Mila Novak", "Tom Hayes", "Ana Silva"];
const initialAdmins: AdminAccount[] = [
  ...seed,
  ...FILLER.map((n, i): AdminAccount => {
    const [firstName, lastName] = n.split(" ");
    return {
      id: `a${i + 7}`,
      firstName,
      lastName,
      email: `${firstName[0].toLowerCase()}.${lastName.toLowerCase()}@securetrack.io`,
      role: i % 3 === 0 ? "moderator" : "admin",
      status: i % 5 === 4 ? "inactive" : "active",
      lastLogin: `${(i % 6) + 1} days ago`,
      lastModified: "2 weeks ago by Super Admin",
    };
  }),
];

function toFormData(input: CreateAdminInput | UpdateAdminInput) {
  const fd = new FormData();
  for (const [k, v] of Object.entries(input)) {
    if (v === undefined || v === null || v === "") continue;
    fd.append(k, v instanceof File ? v : String(v));
  }
  return fd;
}

export const adminAccountService = {
  async list({ search = "", role = "all", status = "all", page = 1, pageSize = 6 }: AdminListQuery = {}): Promise<AdminListPage> {
    if (!USE_MOCK) {
      const p = new URLSearchParams({ page: String(page), pageSize: String(pageSize) });
      if (search.trim()) p.set("search", search.trim());
      if (role !== "all") p.set("role", role);
      if (status !== "all") p.set("status", status);
      return apiRequest(`/admins?${p}`);
    }
    const s = search.trim().toLowerCase();
    const admins = await dbList<AdminAccount>("admins", initialAdmins);
    const all = admins.filter(
      (a) => (role === "all" || a.role === role) && (status === "all" || a.status === status) && (!s || `${a.firstName} ${a.lastName} ${a.email}`.toLowerCase().includes(s)),
    );
    return { items: all.slice((page - 1) * pageSize, page * pageSize), total: all.length };
  },

  async get(id: string): Promise<AdminAccount> {
    if (!USE_MOCK) return apiRequest(`/admins/${id}`);
    const a = await dbGet<AdminAccount>("admins", id);
    if (!a) {
      const all = await dbList<AdminAccount>("admins", initialAdmins);
      const found = all.find((x) => x.id === id);
      if (!found) throw new Error("Admin not found");
      return found;
    }
    return a;
  },

  async create(input: CreateAdminInput): Promise<AdminAccount> {
    if (!USE_MOCK) return apiRequest("/admins", { method: "POST", body: toFormData(input) });
    const id = `a${Date.now()}`;
    const admin: AdminAccount = {
      id,
      firstName: input.firstName.trim(),
      lastName: input.lastName.trim(),
      email: input.email.trim(),
      role: input.role,
      status: "active",
      avatarUrl: input.photo ? URL.createObjectURL(input.photo) : undefined,
      lastLogin: "Never",
      lastModified: "Just now by Super Admin",
    };
    await dbSet<AdminAccount>("admins", id, admin);
    return admin;
  },

  async update(id: string, input: UpdateAdminInput): Promise<AdminAccount> {
    if (!USE_MOCK) return apiRequest(`/admins/${id}`, { method: "PATCH", body: toFormData(input) });
    const existing = await this.get(id);
    const updated: AdminAccount = {
      ...existing,
      firstName: input.firstName.trim(),
      lastName: input.lastName.trim(),
      email: input.email.trim(),
      status: input.status,
      avatarUrl: input.photo ? URL.createObjectURL(input.photo) : existing.avatarUrl,
      lastModified: "Just now by Super Admin",
    };
    await dbSet<AdminAccount>("admins", id, updated);
    return updated;
  },

  async setStatus(id: string, status: AdminAccount["status"]): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/admins/${id}`, { method: "PATCH", body: JSON.stringify({ status }) });
      return;
    }
    await dbSet<AdminAccount>("admins", id, { status });
  },

  async remove(id: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/admins/${id}`, { method: "DELETE" });
      return;
    }
    await dbDelete("admins", id);
  },
};

