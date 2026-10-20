import type { Metadata } from "next";
import { SupportView } from "@/components/support/SupportView";

export const metadata: Metadata = { title: "Support | SecureTrack" };

export default function SupportPage() {
  return <SupportView />;
}
