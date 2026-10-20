import type { AdminUser } from "@/types/auth";
import type { AdminProfile, UpdateProfileInput } from "@/types/profile";
import { apiRequest } from "./apiClient";
import { dbGet, dbSet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const defaults = {
  organization: "SecureTrack Inc. / Hughes Law Group",
  phone: "+1 (555) 482-1920",
  lastLogin: "Just now",
  createdAt: "January 15, 2026",
};

export const profileService = {
  /** The signed-in admin's own profile. */
  async get(user: AdminUser): Promise<AdminProfile> {
    if (!USE_MOCK) return apiRequest("/me/profile");
    const extra = await dbGet<any>("profiles", user.email);
    const extras = extra ? { ...defaults, ...extra } : defaults;
    return {
      name: extras.name || user.name,
      email: user.email,
      role: user.role,
      avatarUrl: extras.avatarUrl || user.avatarUrl,
      organization: extras.organization,
      phone: extras.phone,
      lastLogin: extras.lastLogin,
      createdAt: extras.createdAt,
    };
  },

  async update(
    user: AdminUser,
    input: UpdateProfileInput,
  ): Promise<AdminProfile> {
    if (!USE_MOCK) {
      const fd = new FormData();
      fd.append("name", input.name.trim());
      fd.append("email", input.email.trim());
      fd.append("organization", input.organization.trim());
      fd.append("phone", input.phone.trim());
      if (input.photo) fd.append("photo", input.photo);
      return apiRequest("/me/profile", { method: "PATCH", body: fd });
    }
    const prev = await dbGet<any>("profiles", user.email);
    const next = {
      ...(prev || defaults),
      name: input.name.trim(),
      email: input.email.trim(),
      organization: input.organization.trim(),
      phone: input.phone.trim(),
      avatarUrl: input.photo ? URL.createObjectURL(input.photo) : prev?.avatarUrl || user.avatarUrl,
    };
    await dbSet("profiles", input.email.trim(), next);
    return {
      role: user.role,
      ...next,
    };
  },
};

