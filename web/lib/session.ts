import type {
  AdminUser,
  PendingPasswordReset,
  PendingVerification,
} from "@/types/auth";

const KEY = "st_session";

/** Client-side session store. Replace with httpOnly cookies once the API issues them. */
export function saveSession(user: AdminUser, token: string, persist: boolean) {
  const store = persist ? localStorage : sessionStorage;
  try {
    store.setItem(KEY, JSON.stringify({ user, token }));
  } catch {}
}

/** Rewrites the stored user (e.g. after a profile edit) in whichever store holds the session. */
export function updateSessionUser(user: AdminUser) {
  try {
    for (const store of [localStorage, sessionStorage]) {
      const raw = store.getItem(KEY);
      if (raw) store.setItem(KEY, JSON.stringify({ ...JSON.parse(raw), user }));
    }
  } catch {}
}

export function clearSession() {
  try {
    localStorage.removeItem(KEY);
    sessionStorage.removeItem(KEY);
  } catch {}
}

export function getSession(): { user: AdminUser; token: string } | null {
  try {
    const raw = localStorage.getItem(KEY) ?? sessionStorage.getItem(KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

const PENDING_KEY = "st_pending_verification";

/** Holds the login challenge between Sign In and Email Verification (kept out of the URL). */
export function savePendingVerification(pending: PendingVerification) {
  try {
    sessionStorage.setItem(PENDING_KEY, JSON.stringify(pending));
  } catch {}
}

export function getPendingVerification(): PendingVerification | null {
  try {
    const raw = sessionStorage.getItem(PENDING_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

export function clearPendingVerification() {
  try {
    sessionStorage.removeItem(PENDING_KEY);
  } catch {}
}

const RESET_KEY = "st_pending_reset";

export function savePendingReset(pending: PendingPasswordReset) {
  try {
    sessionStorage.setItem(RESET_KEY, JSON.stringify(pending));
  } catch {}
}

export function getPendingReset(): PendingPasswordReset | null {
  try {
    const raw = sessionStorage.getItem(RESET_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

export function clearPendingReset() {
  try {
    sessionStorage.removeItem(RESET_KEY);
  } catch {}
}
