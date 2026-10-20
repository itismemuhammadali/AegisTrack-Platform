import type { Metadata } from "next";
import { AuditLogView } from "@/components/audit-logs/AuditLogView";

export const metadata: Metadata = { title: "Audit Logs | SecureTrack" };

export default function AuditLogsPage() {
  return <AuditLogView />;
}
