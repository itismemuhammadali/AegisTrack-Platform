"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { type FormEvent, useState } from "react";
import { GradientButton } from "@/components/forms/GradientButton";
import { IconInput } from "@/components/forms/IconInput";
import { savePendingReset } from "@/lib/session";
import { validateEmail } from "@/lib/validation";
import { authService } from "@/services/authService";
import { AuthStepHeader } from "./AuthStepHeader";

/** Forgot password step 1: request an OTP to the admin's email. */
export function ForgotPasswordForm() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [error, setError] = useState<string>();
  const [formError, setFormError] = useState<string>();
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    const err = validateEmail(email);
    setError(err);
    setFormError(undefined);
    if (err) return;

    setLoading(true);
    try {
      const res = await authService.requestPasswordReset(email.trim());
      savePendingReset({ requestId: res.requestId, email: email.trim(), step: "verify" });
      router.push("/forgot-password/verify");
    } catch (e) {
      setFormError(e instanceof Error ? e.message : "Could not send the code. Please try again.");
      setLoading(false);
    }
  }

  return (
    <div className="flex w-full flex-col gap-8">
      <AuthStepHeader
        compact
        icon="/icons/mail-lg.svg"
        iconBg="light"
        title="Reset Password"
        subtitle="Enter your email to receive OTP Code"
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
        <IconInput
          label="Admin Email"
          icon="/icons/mail.svg"
          type="email"
          name="email"
          autoComplete="email"
          autoFocus
          placeholder="admin@securetrack.io"
          value={email}
          onChange={(e) => {
            setEmail(e.target.value);
            if (error) setError(undefined);
          }}
          error={error}
          disabled={loading}
        />
        <GradientButton type="submit" loading={loading} className="shadow-none">
          Send Verify Code
        </GradientButton>
        <Link href="/login" className="text-sm leading-5 text-white/60 transition-colors hover:text-white">
          Back to Sign in
        </Link>
      </form>
    </div>
  );
}
