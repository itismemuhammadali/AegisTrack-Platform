"use client";

import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { type FormEvent, useState } from "react";
import { Checkbox } from "@/components/forms/Checkbox";
import { GradientButton } from "@/components/forms/GradientButton";
import { IconInput } from "@/components/forms/IconInput";
import { PasswordInput } from "@/components/forms/PasswordInput";
import { validateEmail, validatePassword } from "@/lib/validation";
import { saveSession } from "@/lib/session";
import { authService } from "@/services/authService";
import type { SocialProvider } from "@/types/auth";
import { SocialLoginButtons } from "./SocialLoginButtons";

type FieldErrors = { email?: string; password?: string };

export function LoginForm({ passwordReset = false }: { passwordReset?: boolean }) {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [rememberMe, setRememberMe] = useState(false);
  const [errors, setErrors] = useState<FieldErrors>({});
  const [formError, setFormError] = useState<string>();
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    const next = { email: validateEmail(email), password: validatePassword(password) };
    setErrors(next);
    setFormError(undefined);
    if (next.email || next.password) return;

    setLoading(true);
    try {
      const res = await authService.directLogin({ email: email.trim(), password, rememberMe });
      saveSession(res.user, res.accessToken, rememberMe);
      router.replace("/dashboard");
    } catch (err) {
      setFormError(err instanceof Error ? err.message : "Unable to sign in. Please try again.");
      setLoading(false);
    }
  }

  function handleSocial(provider: SocialProvider) {
    window.location.href = authService.socialLoginUrl(provider);
  }

  return (
    <div className="flex w-full flex-col gap-8">
      <div className="flex flex-col gap-2">
        <h2 className="text-2xl leading-9 font-bold text-[#e5e7eb] sm:text-[30px]">Admin Sign In</h2>
        <p className="text-sm leading-5 text-[#9ca3af]">Securely access the management dashboard</p>
      </div>

      <form
        noValidate
        onSubmit={handleSubmit}
        className="flex w-full flex-col gap-6 rounded-2xl border border-white/10 bg-white/5 p-4 sm:p-6"
      >
        {passwordReset && !formError && (
          <p role="status" className="rounded-xl border border-[#00c950]/20 bg-[#00c950]/10 px-4 py-3 text-sm text-[#05df72]">
            Password reset successfully. Sign in with your new password.
          </p>
        )}
        {formError && (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            {formError}
          </p>
        )}

        {/* Demo Fast-Fill Box */}
        <div className="flex flex-col gap-2 rounded-xl border border-purple-500/25 bg-purple-500/10 p-3 text-xs">
          <div className="flex items-center justify-between text-purple-300 font-medium">
            <span>Demo Mode Credentials</span>
            <span className="rounded bg-purple-500/20 px-1.5 py-0.5 text-[10px] text-purple-300 font-mono">Zero-Config Mock</span>
          </div>
          <div className="flex flex-wrap gap-2 pt-0.5">
            <button
              type="button"
              onClick={() => {
                setEmail("superadmin@securetrack.io");
                setPassword("SuperAdmin@123");
                setErrors({});
                setFormError(undefined);
              }}
              className="cursor-pointer rounded-lg border border-purple-400/30 bg-purple-500/20 px-2.5 py-1 text-purple-200 transition-colors hover:bg-purple-500/40"
            >
              Autofill Super Admin
            </button>
            <button
              type="button"
              onClick={() => {
                setEmail("admin@securetrack.io");
                setPassword("Admin@123");
                setErrors({});
                setFormError(undefined);
              }}
              className="cursor-pointer rounded-lg border border-purple-400/30 bg-purple-500/20 px-2.5 py-1 text-purple-200 transition-colors hover:bg-purple-500/40"
            >
              Autofill Admin
            </button>
          </div>
        </div>

        <IconInput
          label="Admin Email"
          icon="/icons/mail.svg"
          type="email"
          name="email"
          autoComplete="email"
          placeholder="admin@securetrack.io"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          error={errors.email}
          disabled={loading}
        />
        <PasswordInput
          label="Password"
          name="password"
          autoComplete="current-password"
          placeholder="Enter your password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          error={errors.password}
          disabled={loading}
        />

        <div className="flex w-full flex-wrap items-center justify-between gap-2">
          <Checkbox label="Remember me" checked={rememberMe} onChange={(e) => setRememberMe(e.target.checked)} />
          <Link
            href="/forgot-password"
            className="text-sm leading-5 font-medium text-white transition-colors hover:text-white/70"
          >
            Forgot Password?
          </Link>
        </div>

        <GradientButton type="submit" loading={loading}>
          Secure Sign in
        </GradientButton>

        <SocialLoginButtons onSelect={handleSocial} disabled={loading} />
      </form>

      <div className="flex w-full items-center justify-center gap-2 rounded-[18px] border border-[#00c950]/20 bg-[#00c950]/10 px-4 py-[17px]">
        <Image src="/icons/shield.svg" alt="" width={16} height={16} className="size-4" />
        <span className="text-xs leading-4 font-medium text-[#05df72]">Protected by 256-bit encryption &amp; MFA</span>
      </div>
    </div>
  );
}
