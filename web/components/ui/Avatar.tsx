import Image from "next/image";

export function Avatar({ src, name, size = 40 }: { src?: string; name: string; size?: number }) {
  if (src) {
    return <Image src={src} alt="" width={size} height={size} unoptimized={src.startsWith("blob:")} className="shrink-0 rounded-full object-cover" style={{ width: size, height: size }} />;
  }
  const initials = name
    .split(" ")
    .map((p) => p[0])
    .slice(0, 2)
    .join("")
    .toUpperCase();
  return (
    <span
      aria-hidden
      className="flex shrink-0 items-center justify-center rounded-full bg-[linear-gradient(135deg,#ad46ff_0%,#4f39f6_100%)] text-sm font-medium text-white"
      style={{ width: size, height: size }}
    >
      {initials}
    </span>
  );
}
