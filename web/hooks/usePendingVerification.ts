"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { getPendingVerification } from "@/lib/session";
import type { PendingVerification } from "@/types/auth";

const STEP_ROUTES: Record<PendingVerification["step"], string> = {
  email: "/verify-code",
  totp: "/two-factor",
  device: "/device-verification",
};

/**
 * Loads the in-progress sign-in and guards the step order: with no sign-in in progress
 * the user goes back to /login; if they're on the wrong step they're sent to the right one.
 */
export function usePendingVerification(step: PendingVerification["step"]) {
  const router = useRouter();
  const [pending, setPending] = useState<PendingVerification | null>(null);

  useEffect(() => {
    const p = getPendingVerification();
    if (!p) router.replace("/login");
    else if (p.step !== step) router.replace(STEP_ROUTES[p.step]);
    else setPending(p); // eslint-disable-line react-hooks/set-state-in-effect -- reads browser-only storage after mount
  }, [router, step]);

  return pending;
}
