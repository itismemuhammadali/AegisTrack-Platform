import type { Metadata } from "next";
import { EscalationsView } from "@/components/escalations/EscalationsView";

export const metadata: Metadata = { title: "Escalations | SecureTrack" };

export default function EscalationsPage() {
  return <EscalationsView />;
}
