"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { ChevronDown, Eye, Search, SquarePen, Trash2, UserPlus, Users } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { Avatar } from "@/components/ui/Avatar";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { adminAccountService } from "@/services/adminAccountService";
import {
  ADMIN_ROLE_LABELS,
  ADMIN_STATUS_LABELS,
  type AdminAccount,
  type AdminAccountRole,
  type AdminAccountStatus,
  fullName,
} from "@/types/adminAccount";
import { BTN_PRIMARY, BTN_SECONDARY, ROLE_BADGE } from "./adminStyles";

const PAGE_SIZE = 6;

/** Super Admin only (Figma 632:2). */
export function AdminListView() {
  const { user } = useAuth();
  const [search, setSearch] = useState("");
  const [role, setRole] = useState<AdminAccountRole | "all">("all");
  const [status, setStatus] = useState<AdminAccountStatus | "all">("all");
  const [page, setPage] = useState(1);
  const [version, setVersion] = useState(0);
  const [actionError, setActionError] = useState<string | null>(null);
  const debouncedSearch = useDebouncedValue(search, 250);

  const { data, loading, error } = useAsync(
    () => adminAccountService.list({ search: debouncedSearch, role, status, page, pageSize: PAGE_SIZE }),
    [debouncedSearch, role, status, page, version],
  );

  const [rows, setRows] = useState<AdminAccount[]>([]);
  const [total, setTotal] = useState(0);
  useEffect(() => {
    if (!data) return;
    setRows(data.items); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched page
    setTotal(data.total);
  }, [data]);

  const pages = Math.max(1, Math.ceil(total / PAGE_SIZE));
  // Deleting the last row of the final page leaves it empty; step back a page.
  useEffect(() => {
    if (page > pages) setPage(pages); // eslint-disable-line react-hooks/set-state-in-effect -- clamps page after deletes
  }, [page, pages]);

  function changeFilter<T>(set: (v: T) => void) {
    return (v: T) => {
      set(v);
      setPage(1);
    };
  }

  async function handleDelete(a: AdminAccount) {
    if (!window.confirm(`Delete ${fullName(a)}? Their access is revoked immediately and this can't be undone.`)) return;
    setActionError(null);
    try {
      await adminAccountService.remove(a.id);
      setVersion((v) => v + 1);
    } catch (err) {
      setActionError(err instanceof Error ? err.message : "Couldn't delete admin");
    }
  }

  const first = total === 0 ? 0 : (page - 1) * PAGE_SIZE + 1;
  const last = Math.min(page * PAGE_SIZE, total);

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <h1 className="sr-only">Admin Management</h1>

      <div className="flex flex-col gap-3 lg:flex-row lg:items-center lg:justify-between">
        <div className="flex flex-col gap-3 sm:flex-row sm:flex-wrap">
          <label className="flex items-center gap-2 rounded-lg border border-white/[0.08] bg-[#0c0e1a] px-4 py-2 focus-within:border-white/25 sm:w-[230px]">
            <Search className="size-4 shrink-0 text-[#9ca3af]" />
            <input
              type="search"
              value={search}
              onChange={(e) => changeFilter(setSearch)(e.target.value)}
              placeholder="Search by name or email..."
              aria-label="Search admins"
              className="w-full min-w-0 bg-transparent text-sm text-[#f3f4f6] outline-none placeholder:text-[#9ca3af]"
            />
          </label>
          <PillSelect label="Role" value={role} onChange={changeFilter(setRole)} options={ADMIN_ROLE_LABELS} />
          <PillSelect label="Status" value={status} onChange={changeFilter(setStatus)} options={ADMIN_STATUS_LABELS} />
        </div>
        <Link href="/admin-management/new" className={`${BTN_PRIMARY} self-start lg:self-auto`}>
          <UserPlus className="size-4" />
          Add New Admin
        </Link>
      </div>

      {(error || actionError) && (
        <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
          {actionError ?? `Couldn't load admins. ${error?.message}`}
        </p>
      )}

      <section className="overflow-hidden rounded-2xl border border-white/[0.08] bg-[#0c0e1a]">
        {loading && rows.length === 0 ? (
          <div className="flex flex-col" aria-busy aria-label="Loading admins">
            {Array.from({ length: PAGE_SIZE }, (_, i) => (
              <div key={i} className="h-[73px] animate-pulse border-b border-white/[0.08] bg-white/[0.02] last:border-0" />
            ))}
          </div>
        ) : rows.length === 0 ? (
          <div className="flex flex-col items-center gap-2 py-16 text-center">
            <Users className="size-8 text-[#9ca3af]" />
            <p className="text-sm font-medium text-[#e5e7eb]">No admins found</p>
            <p className="text-xs text-[#9ca3af]">Try a different search or filter.</p>
          </div>
        ) : (
          <>
            {/* ≥ lg: table */}
            <table className="hidden w-full table-fixed border-collapse text-left lg:table">
              <thead>
                <tr className="border-b border-white/[0.08] bg-white/[0.02] text-xs font-semibold text-[#9ca3af]">
                  <th className="w-[28%] py-3.5 pr-5 pl-6 font-semibold">ADMIN PROFILE</th>
                  <th className="w-[22%] py-3.5 pr-5 font-semibold">EMAIL ADDRESS</th>
                  <th className="w-[14%] py-3.5 pr-5 font-semibold">ROLE</th>
                  <th className="w-[10%] py-3.5 pr-5 font-semibold">STATUS</th>
                  <th className="py-3.5 pr-5 font-semibold">LAST LOGIN</th>
                  <th className="w-[100px] py-3.5 pr-6 text-right font-semibold">ACTIONS</th>
                </tr>
              </thead>
              <tbody>
                {rows.map((a) => (
                  <tr key={a.id} className="border-b border-white/[0.08] transition-colors last:border-0 hover:bg-white/[0.02]">
                    <td className="py-4 pr-5 pl-6">
                      <span className="flex min-w-0 items-center gap-3">
                        <Avatar src={a.avatarUrl} name={fullName(a)} />
                        <span className="truncate text-sm font-semibold text-[#f3f4f6]">{fullName(a)}</span>
                      </span>
                    </td>
                    <td className="truncate py-4 pr-5 text-sm text-[#9ca3af]">{a.email}</td>
                    <td className="py-4 pr-5">
                      <RoleBadge role={a.role} />
                    </td>
                    <td className="py-4 pr-5">
                      <StatusDot status={a.status} />
                    </td>
                    <td className="py-4 pr-5 text-sm text-[#9ca3af]">{a.lastLogin}</td>
                    <td className="py-4 pr-6">
                      <RowActions admin={a} self={a.email === user?.email} onDelete={() => handleDelete(a)} />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            {/* < lg: cards */}
            <ul className="flex flex-col lg:hidden">
              {rows.map((a) => (
                <li key={a.id} className="flex flex-col gap-3 border-b border-white/[0.08] p-4 last:border-0">
                  <div className="flex items-center justify-between gap-3">
                    <span className="flex min-w-0 items-center gap-3">
                      <Avatar src={a.avatarUrl} name={fullName(a)} />
                      <span className="min-w-0">
                        <span className="block truncate text-sm font-semibold text-[#f3f4f6]">{fullName(a)}</span>
                        <span className="block truncate text-xs text-[#9ca3af]">{a.email}</span>
                      </span>
                    </span>
                    <RowActions admin={a} self={a.email === user?.email} onDelete={() => handleDelete(a)} />
                  </div>
                  <div className="flex flex-wrap items-center gap-x-4 gap-y-2 text-xs text-[#9ca3af]">
                    <RoleBadge role={a.role} />
                    <StatusDot status={a.status} />
                    <span>Last login {a.lastLogin}</span>
                  </div>
                </li>
              ))}
            </ul>
          </>
        )}
      </section>

      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <p className="text-sm text-[#9ca3af]">
          Showing {first}-{last} of {total} Administrators
        </p>
        <nav aria-label="Pagination" className="flex flex-wrap gap-2">
          <button type="button" className={BTN_SECONDARY} disabled={page <= 1} onClick={() => setPage((p) => p - 1)}>
            Previous
          </button>
          {Array.from({ length: pages }, (_, i) => i + 1).map((n) =>
            n === page ? (
              <span key={n} aria-current="page" className="rounded-lg bg-[#6366f1]/10 px-4 py-2.5 text-sm font-semibold text-[#f3f4f6]">
                {n}
              </span>
            ) : (
              <button key={n} type="button" className={BTN_SECONDARY} onClick={() => setPage(n)}>
                {n}
              </button>
            ),
          )}
          <button type="button" className={BTN_SECONDARY} disabled={page >= pages} onClick={() => setPage((p) => p + 1)}>
            Next
          </button>
        </nav>
      </div>
    </div>
  );
}

function RoleBadge({ role }: { role: AdminAccountRole }) {
  return <span className={`inline-block rounded-md border px-2.5 py-1 text-xs font-semibold whitespace-nowrap ${ROLE_BADGE[role]}`}>{ADMIN_ROLE_LABELS[role]}</span>;
}

function StatusDot({ status }: { status: AdminAccountStatus }) {
  const active = status === "active";
  return (
    <span className={`flex items-center gap-1.5 text-sm ${active ? "text-[#f3f4f6]" : "text-[#9ca3af]"}`}>
      <span className={`size-2 rounded-full ${active ? "bg-[#10b981]" : "bg-[#6b7280]"}`} />
      {ADMIN_STATUS_LABELS[status]}
    </span>
  );
}

function RowActions({ admin, self, onDelete }: { admin: AdminAccount; self: boolean; onDelete: () => void }) {
  const name = fullName(admin);
  const icon = "cursor-pointer rounded p-0.5 transition";
  return (
    <span className="flex items-center justify-end gap-3">
      <Link href={`/admin-management/${admin.id}`} aria-label={`View ${name}`} className={`${icon} text-[#9ca3af] hover:text-white`}>
        <Eye className="size-4" />
      </Link>
      <Link href={`/admin-management/${admin.id}`} aria-label={`Edit ${name}`} className={`${icon} text-[#9ca3af] hover:text-white`}>
        <SquarePen className="size-4" />
      </Link>
      <button
        type="button"
        onClick={onDelete}
        disabled={self}
        aria-label={`Delete ${name}`}
        title={self ? "You can't delete your own account" : undefined}
        className={`${icon} text-[#ef4444] hover:text-[#f87171] disabled:cursor-not-allowed disabled:opacity-30`}
      >
        <Trash2 className="size-4" />
      </button>
    </span>
  );
}

function PillSelect<T extends string>({ label, value, onChange, options }: { label: string; value: T | "all"; onChange: (v: T | "all") => void; options: Record<T, string> }) {
  return (
    <span className="relative">
      <select
        value={value}
        onChange={(e) => onChange(e.target.value as T | "all")}
        aria-label={`Filter by ${label.toLowerCase()}`}
        className="w-full cursor-pointer appearance-none rounded-lg border border-white/[0.08] bg-[#0c0e1a] py-2 pr-10 pl-4 text-sm text-[#f3f4f6] outline-none focus:border-white/25"
      >
        <option value="all">{label}: All</option>
        {(Object.entries(options) as [T, string][]).map(([v, l]) => (
          <option key={v} value={v}>
            {label}: {l}
          </option>
        ))}
      </select>
      <ChevronDown className="pointer-events-none absolute top-1/2 right-4 size-4 -translate-y-1/2 text-[#f3f4f6]" />
    </span>
  );
}
