"use client";

import type { ReactNode } from "react";
import type { AdminRole } from "@/types/auth";
import { useAuth } from "./AuthProvider";

interface CanProps {
  /** Render when the user holds this permission (Super Admin always passes). */
  permission?: string;
  /** Render only for these roles. */
  roles?: readonly AdminRole[];
  children: ReactNode;
  fallback?: ReactNode;
}

export function Can({ permission, roles, children, fallback = null }: CanProps) {
  const { user, can } = useAuth();
  const allowed = (!roles || roles.includes(user.role)) && (!permission || can(permission));
  return <>{allowed ? children : fallback}</>;
}
