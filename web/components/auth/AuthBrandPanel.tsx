import { BrandLogo } from "./BrandLogo";

const SECURITY_FEATURES = ["256-bit Encryption", "MFA Protected", "SOC 2 Compliant"];

/** Left marketing panel on auth screens. Hidden below `lg`; AuthLayout shows a compact header there. */
export function AuthBrandPanel() {
  return (
    <aside className="relative hidden h-full min-h-screen w-[48.6%] max-w-[900px] shrink-0 flex-col justify-between overflow-hidden bg-[linear-gradient(124deg,#34206c_0%,#312c85_100%)] px-10 py-16 lg:flex xl:px-[60px] xl:py-[100px]">
      {/* Decorative glows */}
      <div className="pointer-events-none absolute inset-x-0 top-[86px] h-[852px] opacity-10" aria-hidden>
        <div className="absolute top-0 left-0 size-96 rounded-full bg-white blur-[64px]" />
        <div className="absolute top-[468px] left-[48%] size-96 rounded-full bg-white blur-[64px]" />
      </div>

      <div className="relative">
        <BrandLogo />
      </div>

      <div className="relative flex max-w-[625px] flex-col gap-6">
        <h1 className="text-3xl font-bold text-white xl:text-4xl">
          Secure Location Logging
          <br />& Data Management
        </h1>
        <p className="text-base leading-7 text-white/80 xl:text-lg">
          Enterprise-grade GPS tracking platform with advanced security, comprehensive audit trails, and
          real-time monitoring capabilities.
        </p>
      </div>

      <ul className="relative flex max-w-[624px] gap-4">
        {SECURITY_FEATURES.map((feature) => (
          <li
            key={feature}
            className="flex-1 rounded-[18px] border border-white/20 bg-white/10 px-2 py-3.5 text-center text-xs leading-4 font-medium text-white"
          >
            {feature}
          </li>
        ))}
      </ul>
    </aside>
  );
}
