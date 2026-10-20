export type UserRole = "tracked_user" | "authorized_viewer" | "admin";
export type UserStatus = "active" | "inactive" | "disabled";

export interface ManagedUser {
  id: string;
  name: string;
  email: string;
  avatarUrl?: string;
  role: UserRole;
  status: UserStatus;
  /** Human-readable, e.g. "2 mins ago". Backend may send ISO instead — format in the UI then. */
  lastActive: string;
  phone?: string;
  location?: string;
}

export interface UpdateUserInput {
  name: string;
  email: string;
  role: UserRole;
}

export type UserStatusFilter = "all" | "active" | "disabled";

export interface UserListQuery {
  status?: UserStatusFilter;
  role?: UserRole | "all";
  search?: string;
}

export const USER_ROLE_LABELS: Record<UserRole, string> = {
  tracked_user: "Tracked User",
  authorized_viewer: "Authorized Viewer",
  admin: "Admin",
};

export interface CreateUserInput extends UpdateUserInput {
  temporaryPassword: string;
}

export type ViewerAccessLevel = "read_only" | "full_access";

export const VIEWER_ACCESS_LABELS: Record<ViewerAccessLevel, string> = {
  read_only: "Read Only",
  full_access: "Full Access",
};
