"use client";

import Link from "next/link";
import { type FormEvent, useState } from "react";
import { GradientButton } from "@/components/forms/GradientButton";
import { OtpInput } from "@/components/forms/OtpInput";
import { useCountdown } from "@/hooks/useCountdown";
import { AuthStepHeader } from "./AuthStepHeader";

const CODE_LENGTH = 6;
const RESEND_SECONDS = 60;

interface EmailCodeVerificationProps {
  /** Null while the pending flow is loading from storage. */
  email: string | null;
  /** Resolve on success (the caller navigates); throw to show an error. */
  onVerify: (code: string) => Promise<void>;
  /** Returns seconds until the next resend is allowed. */
  onResend: () => Promise<number>;
  onBack?: () => void;
}

/** "Email Verification" screen body — shared by sign-in and forgot-password flows. */
export function EmailCodeVerification({ email, onVerify, onResend, onBack }: EmailCodeVerificationProps) {
  const [code, setCode] = useState("");
  const [error, setError] = useState<string>();
  const [loading, setLoading] = useState(false);
  const [resending, setResending] = useState(false);
  const { seconds, restart } = useCountdown(RESEND_SECONDS);
  const ready = email !== null;

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!ready) return;
    if (code.length !== CODE_LENGTH) {
      setError(`Enter the ${CODE_LENGTH}-digit code`);
      return;
    }
    setError(undefined);
    setLoading(true);
    try {
      await onVerify(code);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Verification failed. Please try again.");
      setCode("");
      setLoading(false);
    }
  }

  async function handleResend() {
    if (!ready || seconds > 0) return;
    setResending(true);
    setError(undefined);
    try {
      restart(await onResend());
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not resend code.");
    } finally {
      setResending(false);
    }
  }

  return (
    <div className="flex w-full flex-col gap-8">
      <AuthStepHeader
        icon="/icons/mail-lg.svg"
        iconBg="light"
        title="Email Verification"
        subtitle={
          <>
            We sent a 6-digit code to <span className="font-medium text-[#e5e7eb]">{email ?? "…"}</span>
            <span className="mt-1 block font-mono text-xs text-purple-300/80">
              (Demo Mock: enter any 6 digits, e.g. 123456)
            </span>
          </>
        }
      />

      <form
        noValidate
        onSubmit={handleSubmit}
        className="flex w-full flex-col items-center gap-6 rounded-2xl border border-white/10 bg-white/5 p-4 sm:p-6"
      >
        <div className="flex w-full flex-col gap-2 pb-8">
          <p className="text-sm leading-5 font-medium text-[#e5e7eb]">Enter Verification Code</p>
          <OtpInput
            value={code}
            onChange={(v) => {
              setCode(v);
              if (error) setError(undefined);
            }}
            length={CODE_LENGTH}
            disabled={loading || !ready}
            invalid={!!error}
            autoFocus
          />
          {error && (
            <p role="alert" className="pt-2 text-center text-xs text-red-400">
              {error}
            </p>
          )}
          <div className="pt-6 text-center text-sm leading-5">
            {seconds > 0 ? (
              <span className="text-[#6b7280]">
                Resend code in <span className="font-medium text-white">{seconds}s</span>
              </span>
            ) : (
              <button
                type="button"
                onClick={handleResend}
                disabled={resending}
                className="cursor-pointer font-medium text-white transition-colors hover:text-white/70 disabled:opacity-60"
              >
                {resending ? "Sending…" : "Resend code"}
              </button>
            )}
          </div>
        </div>

        <GradientButton type="submit" loading={loading} disabled={!ready}>
          Verify Code
        </GradientButton>

        <Link href="/login" onClick={onBack} className="text-sm leading-5 text-white/60 transition-colors hover:text-white">
          Back to Sign in
        </Link>
      </form>
    </div>
  );
}
