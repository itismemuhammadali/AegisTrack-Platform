import type { Metadata } from "next";
import { ExportSettingsView } from "@/components/export-settings/ExportSettingsView";

export const metadata: Metadata = { title: "Export Settings | SecureTrack" };

export default function ExportSettingsPage() {
  return <ExportSettingsView />;
}
