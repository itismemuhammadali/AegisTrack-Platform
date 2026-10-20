"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { GradientButton } from "@/components/forms/GradientButton";
import { saveSession } from "@/lib/session";
import { MOCK_ACCOUNTS } from "@/services/authService";

export function TwoFactorForm() {
  const router = useRouter();

  useEffect(() => {
    // Auto-bypass OTP/2FA into dashboard
    const admin = MOCK_ACCOUNTS["admin@securetrack.io"].user;
    saveSession(admin, `token_${Date.now()}`, true);
    router.replace("/dashboard");
  }, [router]);

  return (
    <div className="flex w-full flex-col items-center gap-6 rounded-2xl border border-white/10 bg-white/5 p-8 text-center">
      <div className="rounded-full bg-emerald-500/10 p-3 text-emerald-400">
        <svg className="size-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
        </svg>
      </div>
      <div>
        <h3 className="text-xl font-bold text-white">Direct Sign-In Active</h3>
        <p className="mt-1 text-sm text-gray-400">
          Two-factor challenge has been disabled. Redirecting directly to dashboard...
        </p>
      </div>
      <GradientButton
        onClick={() => {
          const admin = MOCK_ACCOUNTS["admin@securetrack.io"].user;
          saveSession(admin, `token_${Date.now()}`, true);
          router.replace("/dashboard");
        }}
      >
        Go to Dashboard
      </GradientButton>
    </div>
  );
}

