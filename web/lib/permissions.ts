import type { AdminUser } from "@/types/auth";

/** Super Admin implicitly holds every permission; Admin only what the backend granted. */
export function can(user: AdminUser | null | undefined, permission: string) {
  if (!user) return false;
  return user.role === "SUPER_ADMIN" || user.permissions.includes(permission);
}
