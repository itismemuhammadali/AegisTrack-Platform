"use client";

import Link from "next/link";
import { useAsync } from "@/hooks/useAsync";
import { adminAccountService } from "@/services/adminAccountService";
import { AdminForm } from "./AdminForm";

/** Loads the admin, then renders the shared form in edit mode (Figma 634:1792). */
export function EditAdminView({ id }: { id: string }) {
  const { data, loading, error } = useAsync(() => adminAccountService.get(id), [id]);

  if (loading) return <div className="mx-auto h-[420px] w-full max-w-[1600px] animate-pulse rounded-2xl border border-white/[0.08] bg-[#0c0e1a]" aria-busy aria-label="Loading admin" />;

  if (error || !data) {
    return (
      <div className="mx-auto flex w-full max-w-[1600px] flex-col items-start gap-3">
        <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
          Couldn&apos;t load this admin. {error?.message}
        </p>
        <Link href="/admin-management" className="text-sm font-semibold text-white underline">
          Back to Admin List
        </Link>
      </div>
    );
  }

  return <AdminForm key={data.id} admin={data} />;
}
