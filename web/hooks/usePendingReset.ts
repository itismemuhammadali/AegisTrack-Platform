"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { getPendingReset } from "@/lib/session";
import type { PendingPasswordReset } from "@/types/auth";

const STEP_ROUTES: Record<PendingPasswordReset["step"], string> = {
  verify: "/forgot-password/verify",
  reset: "/reset-password",
};

/** Loads the in-progress password reset and keeps the user on the correct step. */
export function usePendingReset(step: PendingPasswordReset["step"]) {
  const router = useRouter();
  const [pending, setPending] = useState<PendingPasswordReset | null>(null);

  useEffect(() => {
    const p = getPendingReset();
    if (!p) router.replace("/forgot-password");
    else if (p.step !== step) router.replace(STEP_ROUTES[p.step]);
    else setPending(p); // eslint-disable-line react-hooks/set-state-in-effect -- reads browser-only storage after mount
  }, [router, step]);

  return pending;
}
