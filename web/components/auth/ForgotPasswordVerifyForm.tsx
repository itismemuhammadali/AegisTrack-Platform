"use client";

import { useRouter } from "next/navigation";
import { usePendingReset } from "@/hooks/usePendingReset";
import { clearPendingReset, savePendingReset } from "@/lib/session";
import { authService } from "@/services/authService";
import { EmailCodeVerification } from "./EmailCodeVerification";

/** Forgot password step 2: verify the emailed OTP → Reset Password. */
export function ForgotPasswordVerifyForm() {
  const router = useRouter();
  const pending = usePendingReset("verify");

  return (
    <EmailCodeVerification
      email={pending?.email ?? null}
      onVerify={async (code) => {
        if (!pending) return;
        const { resetToken } = await authService.verifyPasswordResetCode(pending.requestId, code);
        savePendingReset({ ...pending, step: "reset", resetToken });
        router.replace("/reset-password");
      }}
      onResend={async () =>
        pending ? (await authService.resendPasswordResetCode(pending.requestId)).resendAfter : 60
      }
      onBack={clearPendingReset}
    />
  );
}
