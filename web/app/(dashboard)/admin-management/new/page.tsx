import type { Metadata } from "next";
import { AdminForm } from "@/components/admin-management/AdminForm";

export const metadata: Metadata = { title: "Add New Admin | SecureTrack" };

export default function NewAdminPage() {
  return <AdminForm />;
}
