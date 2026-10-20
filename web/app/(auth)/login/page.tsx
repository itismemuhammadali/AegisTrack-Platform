import type { Metadata } from "next";
import { AuthLayout } from "@/components/auth/AuthLayout";
import { LoginForm } from "@/components/auth/LoginForm";

export const metadata: Metadata = { title: "Admin Sign In | SecureTrack" };

export default async function LoginPage({ searchParams }: PageProps<"/login">) {
  const { reset } = await searchParams;
  return (
    <AuthLayout>
      <LoginForm passwordReset={reset === "success"} />
    </AuthLayout>
  );
}
