import type { Metadata } from "next";
import { AuthLayout } from "@/components/auth/AuthLayout";
import { ForgotPasswordVerifyForm } from "@/components/auth/ForgotPasswordVerifyForm";

export const metadata: Metadata = { title: "Email Verification | SecureTrack" };

export default function ForgotPasswordVerifyPage() {
  return (
    <AuthLayout>
      <ForgotPasswordVerifyForm />
    </AuthLayout>
  );
}
