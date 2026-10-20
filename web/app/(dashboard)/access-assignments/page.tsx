import type { Metadata } from "next";
import { AccessAssignmentsView } from "@/components/access-assignments/AccessAssignmentsView";

export const metadata: Metadata = { title: "Access Assignments | SecureTrack" };

export default function AccessAssignmentsPage() {
  return <AccessAssignmentsView />;
}
