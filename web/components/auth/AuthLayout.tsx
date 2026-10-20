import type { ReactNode } from "react";
import { AuthBrandPanel } from "./AuthBrandPanel";
import { BrandLogo } from "./BrandLogo";

/** Shared split layout for Sign In, Forgot Password, MFA, etc. */
export function AuthLayout({ children }: { children: ReactNode }) {
  return (
    <div className="flex min-h-screen w-full bg-white">
      <AuthBrandPanel />
      <main className="flex min-h-screen flex-1 flex-col bg-[linear-gradient(126deg,rgba(12,18,39,0.4)_0%,rgba(12,18,39,0.9)_50%,rgba(12,18,39,0.4)_100%),linear-gradient(#2b2f3f,#2b2f3f)]">
        <header className="bg-[linear-gradient(124deg,#34206c_0%,#312c85_100%)] px-4 py-5 sm:px-8 lg:hidden">
          <BrandLogo />
        </header>
        <div className="flex flex-1 items-center justify-center px-4 py-10 sm:px-8 lg:px-12 xl:px-[136px] xl:py-8">
          <div className="w-full max-w-[560px] lg:max-w-[520px] xl:max-w-[640px]">{children}</div>
        </div>
      </main>
    </div>
  );
}
