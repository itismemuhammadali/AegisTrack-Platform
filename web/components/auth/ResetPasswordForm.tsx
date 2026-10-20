"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { type FormEvent, useState } from "react";
import { GradientButton } from "@/components/forms/GradientButton";
import { PasswordInput } from "@/components/forms/PasswordInput";
import { usePendingReset } from "@/hooks/usePendingReset";
import { clearPendingReset } from "@/lib/session";
import { isStrongPassword, PASSWORD_RULES } from "@/lib/validation";
import { authService } from "@/services/authService";
import { AuthStepHeader } from "./AuthStepHeader";

type FieldErrors = { password?: string; confirm?: string };

/** Forgot password step 3: set a new password → back to Sign In. */
export function ResetPasswordForm() {
  const router = useRouter();
  const pending = usePendingReset("reset");
  const [password, setPassword] = useState("");
  const [confirm, setConfirm] = useState("");
  const [errors, setErrors] = useState<FieldErrors>({});
  const [formError, setFormError] = useState<string>();
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!pending?.resetToken) return;
    const next: FieldErrors = {
      password: !password
        ? "Password is required"
        : !isStrongPassword(password)
          ? "Password does not meet all requirements"
          : undefined,
      confirm: !confirm ? "Please confirm your password" : confirm !== password ? "Passwords do not match" : undefined,
    };
    setErrors(next);
    setFormError(undefined);
    if (next.password || next.confirm) return;

    setLoading(true);
    try {
      await authService.resetPassword(pending.resetToken, password);
      clearPendingReset();
      router.replace("/login?reset=success");
    } catch (err) {
      setFormError(err instanceof Error ? err.message : "Could not reset password. Please try again.");
      setLoading(false);
    }
  }

  return (
    <div className="flex w-full flex-col gap-8">
      <AuthStepHeader
        compact
        icon="/icons/lock-lg.svg"
        iconBg="light"
        title="Create New Password"
        subtitle={
          <>
            Set a new password for <span className="font-medium text-[#e5e7eb]">{pending?.email ?? "…"}</span>
          </>
        }
      />

      <form
        noValidate
        onSubmit={handleSubmit}
        className="flex w-full flex-col items-center gap-6 rounded-2xl border border-white/10 bg-white/5 p-4 sm:p-6"
      >
        {formError && (
          <p role="alert" className="w-full rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            {formError}
          </p>
        )}

        <PasswordInput
          label="New Password"
          name="new-password"
          autoComplete="new-password"
          autoFocus
          placeholder="Enter new password"
          value={password}
          onChange={(e) => {
            setPassword(e.target.value);
            if (errors.password) setErrors((x) => ({ ...x, password: undefined }));
          }}
          error={errors.password}
          disabled={loading || !pending}
        />

        <ul className="grid w-full grid-cols-1 gap-x-4 gap-y-2 sm:grid-cols-2" aria-label="Password requirements">
          {PASSWORD_RULES.map((rule) => {
            const met = rule.test(password);
            return (
              <li
                key={rule.id}
                className={`flex items-center gap-2 text-xs leading-4 transition-colors ${met ? "text-[#05df72]" : "text-[#9ca3af]"}`}
              >
                <span
                  className={`flex size-4 shrink-0 items-center justify-center rounded-full border ${
                    met ? "border-[#05df72] bg-[#00c950]/20" : "border-white/20"
                  }`}
                  aria-hidden
                >
                  {met && (
                    <svg viewBox="0 0 16 16" className="size-3">
                      <path d="M4 8.5 6.5 11 12 5.5" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                  )}
                </span>
                {rule.label}
                <span className="sr-only">{met ? "(met)" : "(not met)"}</span>
              </li>
            );
          })}
        </ul>

        <PasswordInput
          label="Confirm Password"
          name="confirm-password"
          autoComplete="new-password"
          placeholder="Re-enter new password"
          value={confirm}
          onChange={(e) => {
            setConfirm(e.target.value);
            if (errors.confirm) setErrors((x) => ({ ...x, confirm: undefined }));
          }}
          error={errors.confirm}
          disabled={loading || !pending}
        />

        <GradientButton type="submit" loading={loading} disabled={!pending} className="shadow-none">
          Reset Password
        </GradientButton>

        <Link
          href="/login"
          onClick={clearPendingReset}
          className="text-sm leading-5 text-white/60 transition-colors hover:text-white"
        >
          Back to Sign in
        </Link>
      </form>
    </div>
  );
}
