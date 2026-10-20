import type {
  AdminUser,
  LoginCredentials,
  LoginResponse,
  SocialProvider,
  VerifyEmailCodeResponse,
  VerifyTotpResponse,
} from "@/types/auth";
import { apiRequest } from "./apiClient";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;
const delay = (ms: number) => new Promise((r) => setTimeout(r, ms));
const post = <T>(path: string, body: unknown) =>
  apiRequest<T>(path, { method: "POST", body: JSON.stringify(body) });

/**
 * Demo accounts for the mock backend (used only when NEXT_PUBLIC_API_BASE_URL is unset).
 * Verification codes: any 6 digits except 000000.
 */
export const MOCK_ACCOUNTS: Record<string, { password: string; user: AdminUser }> = {
  "superadmin@securetrack.io": {
    password: "SuperAdmin@123",
    user: { id: "sa-1", name: "Super Admin", email: "superadmin@securetrack.io", role: "SUPER_ADMIN", permissions: ["*"] },
  },
  "admin@securetrack.io": {
    password: "Admin@123",
    user: {
      id: "ad-1",
      name: "Admin User",
      email: "admin@securetrack.io",
      role: "ADMIN",
      permissions: ["cases.create", "access.assign", "exports.manage"],
    },
  },
};

/** Mock rule: "000000" is always rejected so error states can be tested. */
function mockCheckCode(code: string) {
  if (code === "000000") throw new Error("Invalid verification code");
}

export const authService = {
  /** Direct Admin Sign-In: bypasses OTP / 2FA challenges and issues session immediately */
  async directLogin(credentials: LoginCredentials): Promise<{ user: AdminUser; accessToken: string }> {
    await delay(300);
    const email = credentials.email.toLowerCase().trim();
    const account = MOCK_ACCOUNTS[email];
    if (account) {
      if (account.password !== credentials.password) {
        throw new Error("Invalid email or password");
      }
      return {
        user: account.user,
        accessToken: `token_${Date.now()}_${account.user.id}`,
      };
    }
    // Allow any standard admin testing credentials
    if (credentials.password === "SuperAdmin@123" || credentials.password === "Admin@123" || credentials.password.length >= 6) {
      const isSuper = email.includes("super");
      const user: AdminUser = {
        id: `admin_${Date.now()}`,
        name: isSuper ? "Super Administrator" : "Administrator",
        email,
        role: isSuper ? "SUPER_ADMIN" : "ADMIN",
        permissions: isSuper ? ["*"] : ["cases.create", "access.assign", "exports.manage"],
      };
      return { user, accessToken: `token_${Date.now()}` };
    }
    throw new Error("Invalid email or password");
  },

  async login(credentials: LoginCredentials): Promise<LoginResponse> {
    if (USE_MOCK) {
      await delay(400);
      const email = credentials.email.toLowerCase();
      if (MOCK_ACCOUNTS[email]?.password !== credentials.password) throw new Error("Invalid email or password");
      return { challengeId: `mock:${email}`, email, resendAfter: 60 };
    }
    return post("/auth/login", credentials);
  },

  async verifyEmailCode(challengeId: string, code: string): Promise<VerifyEmailCodeResponse> {
    if (USE_MOCK) {
      await delay(800);
      mockCheckCode(code);
      return { challengeId };
    }
    return post("/auth/verify-email-code", { challengeId, code });
  },

  async resendEmailCode(challengeId: string): Promise<{ resendAfter: number }> {
    if (USE_MOCK) {
      await delay(500);
      return { resendAfter: 60 };
    }
    return post("/auth/resend-email-code", { challengeId });
  },

  async verifyTotp(challengeId: string, code: string): Promise<VerifyTotpResponse> {
    if (USE_MOCK) {
      await delay(800);
      mockCheckCode(code);
      const account = MOCK_ACCOUNTS[challengeId.replace(/^mock:/, "")];
      if (!account) throw new Error("Sign-in session expired. Please sign in again.");
      return {
        user: account.user,
        accessToken: "mock-token",
        device: { name: "Chrome on macOS", ip: "192.168.1.100", location: "New York, US" },
        deviceTrusted: false,
      };
    }
    return post("/auth/verify-totp", { challengeId, code });
  },

  async setDeviceTrust(accessToken: string, trusted: boolean): Promise<void> {
    if (USE_MOCK) {
      await delay(500);
      return;
    }
    await apiRequest("/auth/device-trust", {
      method: "POST",
      headers: { Authorization: `Bearer ${accessToken}` },
      body: JSON.stringify({ trusted }),
    });
  },

  async requestPasswordReset(email: string): Promise<{ requestId: string; resendAfter: number }> {
    if (USE_MOCK) {
      await delay(800);
      return { requestId: `mock-reset:${email}`, resendAfter: 60 };
    }
    return post("/auth/password/forgot", { email });
  },

  async resendPasswordResetCode(requestId: string): Promise<{ resendAfter: number }> {
    if (USE_MOCK) {
      await delay(500);
      return { resendAfter: 60 };
    }
    return post("/auth/password/resend-code", { requestId });
  },

  async verifyPasswordResetCode(requestId: string, code: string): Promise<{ resetToken: string }> {
    if (USE_MOCK) {
      await delay(800);
      mockCheckCode(code);
      return { resetToken: "mock-reset-token" };
    }
    return post("/auth/password/verify-code", { requestId, code });
  },

  async resetPassword(resetToken: string, newPassword: string): Promise<void> {
    if (USE_MOCK) {
      await delay(800);
      return;
    }
    await post("/auth/password/reset", { resetToken, newPassword });
  },

  /** Settings → Change Password (Figma 610:27097): sets a new temporary password for the signed-in account. */
  async resetOwnPassword(email: string, temporaryPassword: string): Promise<void> {
    if (USE_MOCK) {
      await delay(600);
      const account = MOCK_ACCOUNTS[email];
      if (account) account.password = temporaryPassword;
      return;
    }
    await post("/auth/password/temporary", { temporaryPassword });
  },

  /** Signed-in password change with the current password. */
  async changePassword(email: string, currentPassword: string, newPassword: string): Promise<void> {
    if (USE_MOCK) {
      await delay(800);
      const account = MOCK_ACCOUNTS[email];
      if (account && account.password !== currentPassword) throw new Error("Current password is incorrect");
      if (account) account.password = newPassword;
      return;
    }
    await post("/auth/password/change", { currentPassword, newPassword });
  },

  /** Returns the provider's OAuth URL to redirect the browser to. */
  socialLoginUrl(provider: SocialProvider): string {
    return `${process.env.NEXT_PUBLIC_API_BASE_URL ?? ""}/auth/oauth/${provider}`;
  },
};
