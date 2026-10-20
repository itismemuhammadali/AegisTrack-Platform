"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

export default function TwoFactorPage() {
  const router = useRouter();
  useEffect(() => {
    // 2FA/OTP removed for web admin direct sign-in
    router.replace("/dashboard");
  }, [router]);

  return (
    <div className="flex min-h-[300px] items-center justify-center text-sm text-white/60">
      Redirecting to dashboard...
    </div>
  );
}

