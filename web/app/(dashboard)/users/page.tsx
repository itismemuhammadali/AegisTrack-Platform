import type { Metadata } from "next";
import { UserManagementView } from "@/components/users/UserManagementView";

export const metadata: Metadata = { title: "User Management | SecureTrack" };

export default function UsersPage() {
  return <UserManagementView />;
}
