import type { Metadata } from "next";
import { DashboardOverview } from "@/components/dashboard/DashboardOverview";

export const metadata: Metadata = { title: "Dashboard | SecureTrack" };

export default function DashboardPage() {
  return <DashboardOverview />;
}
