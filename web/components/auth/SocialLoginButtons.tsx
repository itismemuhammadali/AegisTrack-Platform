import Image from "next/image";
import type { SocialProvider } from "@/types/auth";

const PROVIDERS: { id: SocialProvider; label: string; icon: string }[] = [
  { id: "google", label: "Continue with Google", icon: "/icons/google.svg" },
  { id: "apple", label: "Continue with Apple", icon: "/icons/apple.svg" },
  { id: "facebook", label: "Continue with Facebook", icon: "/icons/facebook.svg" },
];

export function SocialLoginButtons({
  onSelect,
  disabled,
}: {
  onSelect: (provider: SocialProvider) => void;
  disabled?: boolean;
}) {
  return (
    <>
      <div className="flex w-full items-center gap-4 py-4">
        <span className="h-px flex-1 bg-white/60" />
        <span className="text-sm leading-5 whitespace-nowrap text-white/60">Or Continue with</span>
        <span className="h-px flex-1 bg-white/60" />
      </div>
      <div className="flex w-full gap-3 sm:gap-4">
        {PROVIDERS.map((p) => (
          <button
            key={p.id}
            type="button"
            aria-label={p.label}
            disabled={disabled}
            onClick={() => onSelect(p.id)}
            className="flex flex-1 cursor-pointer items-center justify-center rounded-2xl border border-white/10 bg-white/5 px-4 py-5 transition hover:border-white/20 hover:bg-white/10 disabled:cursor-not-allowed disabled:opacity-50 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white"
          >
            <Image src={p.icon} alt="" width={24} height={24} className="size-6" />
          </button>
        ))}
      </div>
    </>
  );
}
