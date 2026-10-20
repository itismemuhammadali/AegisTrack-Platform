import type { Metadata } from "next";
import { SecurityCenterView } from "@/components/security/SecurityCenterView";

export const metadata: Metadata = { title: "Security Center | SecureTrack" };

export default function SecurityAlertsPage() {
  return <SecurityCenterView />;
}
