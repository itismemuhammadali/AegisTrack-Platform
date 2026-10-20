"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

export default function VerifyCodePage() {
  const router = useRouter();
  useEffect(() => {
    // OTP verification removed for web admin direct sign-in
    router.replace("/dashboard");
  }, [router]);

  return (
    <div className="flex min-h-[300px] items-center justify-center text-sm text-white/60">
      Redirecting to dashboard...
    </div>
  );
}

