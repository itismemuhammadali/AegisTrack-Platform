import type { Metadata } from "next";
import { EditAdminView } from "@/components/admin-management/EditAdminView";

export const metadata: Metadata = { title: "Edit Admin | SecureTrack" };

export default async function EditAdminPage({ params }: PageProps<"/admin-management/[id]">) {
  const { id } = await params;
  return <EditAdminView id={id} />;
}
