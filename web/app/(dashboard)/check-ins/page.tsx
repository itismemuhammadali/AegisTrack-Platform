import type { Metadata } from "next";
import { CheckInScheduleView } from "@/components/check-ins/CheckInScheduleView";

export const metadata: Metadata = { title: "Scheduled Check-ins | SecureTrack" };

export default function CheckInsPage() {
  return <CheckInScheduleView />;
}
