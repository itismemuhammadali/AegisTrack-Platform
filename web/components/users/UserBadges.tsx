import { Shield } from "lucide-react";
import { USER_ROLE_LABELS, type UserRole, type UserStatus } from "@/types/user";

const PILL =
  "inline-flex items-center gap-1.5 rounded-[14px] border px-2.5 py-1 text-xs leading-4 font-medium whitespace-nowrap";

export function RoleBadge({ role }: { role: UserRole }) {
  return (
    <span className={`${PILL} border-white/20 bg-white/10 text-white`}>
      {role === "admin" && <Shield className="size-3" />}
      {USER_ROLE_LABELS[role]}
    </span>
  );
}

const STATUS: Record<UserStatus, { label: string; cls: string; dot: string }> =
  {
    active: {
      label: "Active",
      cls: "border-[#00c950]/20 bg-[#00c950]/10 text-[#05df72]",
      dot: "bg-[#05df72]",
    },
    inactive: {
      label: "Inactive",
      cls: "border-white/20 bg-white/10 text-white",
      dot: "bg-white",
    },
    disabled: {
      label: "Disabled",
      cls: "border-[#fb2c36]/20 bg-[#fb2c36]/10 text-[#ff6467]",
      dot: "bg-[#ff6467]",
    },
  };

export function StatusBadge({
  status,
  dot = true,
}: {
  status: UserStatus;
  dot?: boolean;
}) {
  const s = STATUS[status];
  return (
    <span className={`${PILL} ${s.cls}`}>
      {dot && <span className={`size-1.5 rounded-full ${s.dot}`} />}
      {s.label}
    </span>
  );
}
