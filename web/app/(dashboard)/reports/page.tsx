import type { Metadata } from "next";
import { ReportsView } from "@/components/reports/ReportsView";

export const metadata: Metadata = { title: "Reports & Analytics | SecureTrack" };

export default function ReportsPage() {
  return <ReportsView />;
}
