"use client";

import { usePathname, useRouter } from "next/navigation";
import {
  createContext,
  type ReactNode,
  useCallback,
  useContext,
  useEffect,
  useState,
} from "react";
import { canAccessPath } from "@/lib/navigation";
import { can as canFn } from "@/lib/permissions";
import { clearSession, getSession, updateSessionUser } from "@/lib/session";
import type { AdminUser } from "@/types/auth";

interface AuthContextValue {
  user: AdminUser;
  can: (permission: string) => boolean;
  logout: () => void;
  /** Merges profile changes into the signed-in user and the stored session. */
  updateUser: (patch: Partial<AdminUser>) => void;
}

const AuthContext = createContext<AuthContextValue | null>(null);

/**
 * Guards the admin area: no session → /login; role not allowed on this path → /dashboard.
 * Replace with a server-side check in proxy.ts once sessions move to httpOnly cookies.
 */
export function AuthProvider({ children }: { children: ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const [user, setUser] = useState<AdminUser | null>(null);

  useEffect(() => {
    const session = getSession();
    if (!session) {
      router.replace("/login");
      return;
    }
    if (!canAccessPath(session.user.role, pathname)) {
      router.replace("/dashboard");
      return;
    }
    setUser(session.user); // eslint-disable-line react-hooks/set-state-in-effect -- reads browser-only storage after mount
  }, [router, pathname]);

  const logout = useCallback(() => {
    clearSession();
    router.replace("/login");
  }, [router]);

  const updateUser = useCallback((patch: Partial<AdminUser>) => {
    setUser((u) => {
      if (!u) return u;
      const next = { ...u, ...patch };
      updateSessionUser(next);
      return next;
    });
  }, []);

  const can = useCallback(
    (permission: string) => canFn(user, permission),
    [user],
  );

  if (!user) {
    return (
      <div
        className="flex min-h-screen items-center justify-center bg-[#0c1227]"
        aria-busy
      >
        <span className="size-8 animate-spin rounded-full border-2 border-white/20 border-t-white" />
      </div>
    );
  }

  return (
    <AuthContext.Provider value={{ user, can, logout, updateUser }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used inside <AuthProvider>");
  return ctx;
}
