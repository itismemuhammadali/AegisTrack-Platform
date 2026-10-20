import Image from "next/image";
import { Fragment, type ReactNode } from "react";

interface AuthStepHeaderProps {
  icon: string;
  title: string;
  subtitle: ReactNode;
  /** Figma uses a lighter tile on Email Verification (20%) than on 2FA/Device (10%). */
  iconBg?: "light" | "subtle";
  /** Reset Password frames use a tighter header: 10px gap, 24px title, 14px subtitle. */
  compact?: boolean;
}

export function AuthStepHeader({ icon, title, subtitle, iconBg = "subtle", compact }: AuthStepHeaderProps) {
  const Wrapper = compact ? "div" : Fragment;
  return (
    <Wrapper {...(compact ? { className: "flex flex-col gap-2.5" } : {})}>
      <div
        className={`flex size-14 items-center justify-center rounded-2xl ${iconBg === "light" ? "bg-white/20" : "bg-white/10"}`}
      >
        <Image src={icon} alt="" width={28} height={28} className="size-7" />
      </div>
      <div className="flex flex-col gap-2">
        <h2
          className={`font-bold text-[#e5e7eb] ${compact ? "text-2xl leading-8" : "text-2xl leading-9 sm:text-[30px]"}`}
        >
          {title}
        </h2>
        <p className={`leading-5 break-words text-[#9ca3af] ${compact ? "text-sm" : "text-base"}`}>{subtitle}</p>
      </div>
    </Wrapper>
  );
}
