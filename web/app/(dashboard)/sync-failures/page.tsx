import type { Metadata } from "next";
import { SyncFailureView } from "@/components/sync-failures/SyncFailureView";

export const metadata: Metadata = { title: "Sync Failures | SecureTrack" };

export default function SyncFailuresPage() {
  return <SyncFailureView />;
}
