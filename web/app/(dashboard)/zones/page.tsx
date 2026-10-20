import type { Metadata } from "next";
import { ZoneManagementView } from "@/components/zones/ZoneManagementView";

export const metadata: Metadata = { title: "Zones / Geofencing | SecureTrack" };

export default function ZonesPage() {
  return <ZoneManagementView />;
}
