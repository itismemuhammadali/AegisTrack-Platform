import Image from "next/image";

export function BrandLogo() {
  return (
    <div className="flex items-center gap-3">
      <Image src="/images/logo.png" alt="SecureTrack logo" width={50} height={58} priority className="h-[52px] w-auto" />
      <div className="flex flex-col gap-0.5">
        <p className="text-2xl leading-8 font-bold text-white">SecureTrack</p>
        <p className="text-sm leading-5 text-white/70">Admin Portal</p>
      </div>
    </div>
  );
}
