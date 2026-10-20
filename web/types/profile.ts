import type { AdminRole } from "./auth";

export interface AdminProfile {
  name: string;
  email: string;
  organization: string;
  phone: string;
  role: AdminRole;
  avatarUrl?: string;
  /** e.g. "May 18, 2026 at 2:30 PM" */
  lastLogin: string;
  /** e.g. "January 15, 2025" */
  createdAt: string;
}

export interface UpdateProfileInput {
  name: string;
  email: string;
  organization: string;
  phone: string;
  photo?: File | null;
}
