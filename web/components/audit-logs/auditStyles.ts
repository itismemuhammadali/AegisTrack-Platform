import { Download, Image, LockKeyhole, LogIn, RefreshCw, ShieldOff, TriangleAlert, UserCog, UserX, type LucideIcon } from "lucide-react";
import type { AuditEventType, AuditSeverity } from "@/types/auditLog";

interface TypeStyle {
  Icon: LucideIcon;
  /** Type tag in the table. */
  tag: string;
  /** Summary tile (tinted gradient + border). */
  tile: string;
  icon: string;
}

export const AUDIT_TYPE_STYLE: Record<AuditEventType, TypeStyle> = {
  export: { Icon: Download, tag: "border-[#2b7fff]/40 bg-[#2b7fff]/10 text-[#51a2ff]", tile: "border-[#2b7fff]/30 from-[#2b7fff]/20", icon: "text-[#51a2ff]" },
  login: { Icon: LogIn, tag: "border-[#00c950]/40 bg-[#00c950]/10 text-[#05df72]", tile: "border-[#00c950]/30 from-[#00c950]/20", icon: "text-[#05df72]" },
  login_fail: { Icon: LockKeyhole, tag: "border-[#ff6900]/40 bg-[#ff6900]/10 text-[#ff8904]", tile: "", icon: "text-[#ff8904]" },
  screenshot: { Icon: Image, tag: "border-[#ad46ff]/40 bg-[#ad46ff]/10 text-[#c27aff]", tile: "border-[#ad46ff]/30 from-[#ad46ff]/20", icon: "text-[#c27aff]" },
  security: { Icon: TriangleAlert, tag: "border-[#fb2c36]/40 bg-[#fb2c36]/10 text-[#ff6467]", tile: "border-[#fb2c36]/30 from-[#fb2c36]/20", icon: "text-[#ff6467]" },
  sync: { Icon: RefreshCw, tag: "border-[#f0b100]/40 bg-[#f0b100]/10 text-[#fdc700]", tile: "border-[#f0b100]/30 from-[#f0b100]/20", icon: "text-[#fdc700]" },
  account: { Icon: UserX, tag: "border-[#f6339a]/40 bg-[#f6339a]/10 text-[#fb64b6]", tile: "", icon: "text-[#fb64b6]" },
  permission: { Icon: ShieldOff, tag: "border-[#615fff]/40 bg-[#615fff]/10 text-[#7c86ff]", tile: "border-[#615fff]/30 from-[#615fff]/20", icon: "text-[#7c86ff]" },
  admin: { Icon: UserCog, tag: "border-[#00b8db]/40 bg-[#00b8db]/10 text-[#00d3f2]", tile: "border-[#00b8db]/30 from-[#00b8db]/20", icon: "text-[#00d3f2]" },
};

export const AUDIT_SEVERITY_STYLE: Record<AuditSeverity, string> = {
  info: "bg-[#2b7fff]/10 text-[#51a2ff]",
  warning: "bg-[#f0b100]/10 text-[#fdc700]",
  critical: "bg-[#fb2c36]/10 text-[#ff6467]",
};
