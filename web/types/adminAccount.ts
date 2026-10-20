export type AdminAccountRole = "super_admin" | "admin" | "moderator";
export type AdminAccountStatus = "active" | "inactive";

export interface AdminAccount {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
  role: AdminAccountRole;
  status: AdminAccountStatus;
  avatarUrl?: string;
  lastLogin: string;
  lastModified: string;
}

export interface AdminListQuery {
  search?: string;
  role?: AdminAccountRole | "all";
  status?: AdminAccountStatus | "all";
  page?: number;
  pageSize?: number;
}

export interface AdminListPage {
  items: AdminAccount[];
  total: number;
}

export interface CreateAdminInput {
  firstName: string;
  lastName: string;
  email: string;
  password: string;
  role: AdminAccountRole;
  sendInvite: boolean;
  photo?: File | null;
}

export interface UpdateAdminInput {
  firstName: string;
  lastName: string;
  email: string;
  /** Empty keeps the current password. */
  password?: string;
  status: AdminAccountStatus;
  photo?: File | null;
}

export const ADMIN_ROLE_LABELS: Record<AdminAccountRole, string> = {
  super_admin: "Super Admin",
  admin: "Admin",
  moderator: "Moderator",
};

/** Long labels used by the "Select Admin Role" dropdown (Figma 634:717). */
export const ADMIN_ROLE_OPTIONS: Record<AdminAccountRole, string> = {
  super_admin: "Super Admin (Full platform and policy control)",
  admin: "Admin (Access configuration and reporting operations)",
  moderator: "Moderator (Monitoring and review only)",
};

export const ADMIN_STATUS_LABELS: Record<AdminAccountStatus, string> = {
  active: "Active",
  inactive: "Inactive",
};

export const fullName = (a: Pick<AdminAccount, "firstName" | "lastName">) => `${a.firstName} ${a.lastName}`.trim();
