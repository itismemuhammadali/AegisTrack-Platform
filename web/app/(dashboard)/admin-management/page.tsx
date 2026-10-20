import type { Metadata } from "next";
import { AdminListView } from "@/components/admin-management/AdminListView";

export const metadata: Metadata = { title: "Admin Management | SecureTrack" };

export default function AdminManagementPage() {
  return <AdminListView />;
}
