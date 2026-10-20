import Image from "next/image";

export function BrandMark({ showText = true }: { showText?: boolean }) {
  return (
    <div className="flex items-center gap-3">
      <Image src="/images/logo.png" alt="SecureTrack logo" width={34} height={40} className="h-10 w-auto shrink-0" />
      {showText && (
        <div className="flex flex-col">
          <p className="text-base leading-6 font-semibold whitespace-nowrap text-[#e5e7eb]">SecureTrack</p>
          <p className="text-xs leading-4 text-[#9ca3af]">Admin Portal</p>
        </div>
      )}
    </div>
  );
}
