import { DashboardShell } from "@/components/layout/DashboardShell";
import { AuthProvider } from "@/components/providers/AuthProvider";

export default function DashboardLayout({ children }: LayoutProps<"/">) {
  return (
    <AuthProvider>
      <DashboardShell>{children}</DashboardShell>
    </AuthProvider>
  );
}
