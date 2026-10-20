export type AdminRole = "SUPER_ADMIN" | "ADMIN";

export type SocialProvider = "google" | "apple" | "facebook";

export interface LoginCredentials {
  email: string;
  password: string;
  rememberMe: boolean;
}

export interface AdminUser {
  id: string;
  name: string;
  email: string;
  role: AdminRole;
  permissions: string[];
  avatarUrl?: string;
}

/** Step 1: credentials accepted, a 6-digit code was emailed. */
export interface LoginResponse {
  challengeId: string;
  email: string;
  /** Seconds before a new code may be requested. */
  resendAfter: number;
}

/** Step 2: email code verified; authenticator (TOTP) code is required next. */
export interface VerifyEmailCodeResponse {
  challengeId: string;
}

export interface DeviceInfo {
  /** e.g. "Chrome on macOS" */
  name: string;
  ip: string;
  /** e.g. "New York, US" */
  location: string;
}

/** Step 3: authenticator code verified, session issued. */
export interface VerifyTotpResponse {
  user: AdminUser;
  accessToken: string;
  device: DeviceInfo;
  /** When false, the Device Verification step is shown before entering the app. */
  deviceTrusted: boolean;
}

/** Sign-in state carried between the auth steps (kept out of the URL). */
export interface PendingVerification {
  challengeId: string;
  email: string;
  rememberMe: boolean;
  step: "email" | "totp" | "device";
  /** Present once the TOTP step succeeds. */
  auth?: VerifyTotpResponse;
}

/** Forgot-password flow state carried between its steps (kept out of the URL). */
export interface PendingPasswordReset {
  requestId: string;
  email: string;
  step: "verify" | "reset";
  /** Issued once the emailed code is verified; authorizes setting the new password. */
  resetToken?: string;
}
