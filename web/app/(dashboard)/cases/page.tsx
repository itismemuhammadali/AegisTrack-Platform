import type { Metadata } from "next";
import { CaseManagementView } from "@/components/cases/CaseManagementView";

export const metadata: Metadata = { title: "Case Management | SecureTrack" };

export default function CasesPage() {
  return <CaseManagementView />;
}
