import type { Metadata } from "next";
import { RetentionRulesView } from "@/components/retention/RetentionRulesView";

export const metadata: Metadata = { title: "Retention Rules | SecureTrack" };

export default function RetentionRulesPage() {
  return <RetentionRulesView />;
}
