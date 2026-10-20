import type { Metadata } from "next";
import { TrackingActivityView } from "@/components/tracking/TrackingActivityView";

export const metadata: Metadata = { title: "Tracking Activity | SecureTrack" };

export default function TrackingActivityPage() {
  return <TrackingActivityView />;
}
