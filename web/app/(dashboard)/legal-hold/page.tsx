import type { Metadata } from "next";
import { LegalHoldView } from "@/components/legal-hold/LegalHoldView";

export const metadata: Metadata = { title: "Legal Hold | SecureTrack" };

export default function LegalHoldPage() {
  return <LegalHoldView />;
}
