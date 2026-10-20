"use client";

import { useEffect, useState } from "react";
import { ChevronDown, Search } from "lucide-react";
import { SegmentedControl } from "@/components/ui/SegmentedControl";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { userService } from "@/services/userService";
import {
  USER_ROLE_LABELS,
  type ManagedUser,
  type UpdateUserInput,
  type ViewerAccessLevel,
  type UserRole,
  type UserStatusFilter,
} from "@/types/user";
import { AssignViewerModal } from "./AssignViewerModal";
import { DeleteUserModal } from "./DeleteUserModal";
import { EditUserModal } from "./EditUserModal";
import { ResetPasswordModal } from "./ResetPasswordModal";
import { UserDetailsModal } from "./UserDetailsModal";
import type { UserRowAction } from "./UserRowActions";
import { UserTable } from "./UserTable";

const STATUS_OPTIONS = [
  { value: "all", label: "All Users" },
  { value: "active", label: "Active" },
  { value: "disabled", label: "Disabled" },
] as const;

export function UserListPanel({ refreshKey = 0, notice: externalNotice = null }: { refreshKey?: number; notice?: string | null }) {
  const [status, setStatus] = useState<UserStatusFilter>("all");
  const [role, setRole] = useState<UserRole | "all">("all");
  const [search, setSearch] = useState("");
  const debouncedSearch = useDebouncedValue(search, 250);
  const [version, setVersion] = useState(0);
  const { data, loading, error } = useAsync(
    () => userService.list({ status, role, search: debouncedSearch }),
    [status, role, debouncedSearch, version, refreshKey],
  );
  // Keep showing the previous rows while a refetch runs, so the table doesn't flash.
  const [rows, setRows] = useState<ManagedUser[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const [viewing, setViewing] = useState<ManagedUser | null>(null);
  const [editing, setEditing] = useState<ManagedUser | null>(null);
  const [resetting, setResetting] = useState<ManagedUser | null>(null);
  const [assigning, setAssigning] = useState<ManagedUser | null>(null);
  const [deleting, setDeleting] = useState<ManagedUser | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  useEffect(() => {
    if (externalNotice) setNotice(externalNotice); // eslint-disable-line react-hooks/set-state-in-effect -- shows "user created" from the page header
  }, [externalNotice, refreshKey]);

  const refresh = () => setVersion((v) => v + 1);

  async function handleDelete() {
    if (!deleting) return;
    await userService.remove(deleting.id);
    setNotice(`${deleting.name} was deleted.`);
    setDeleting(null);
    refresh();
  }

  function handleAction(action: UserRowAction, user: ManagedUser) {
    if (action === "view") setViewing(user);
    else if (action === "edit") setEditing(user);
    else if (action === "reset-password") setResetting(user);
    else if (action === "assign-viewer") setAssigning(user);
    else if (action === "delete") setDeleting(user);
  }

  async function handleSaveUser(input: UpdateUserInput) {
    if (!editing) return;
    await userService.update(editing.id, input);
    setEditing(null);
    refresh();
  }

  async function handleResetPassword(password: string) {
    if (!resetting) return;
    await userService.resetPassword(resetting.id, password);
    setNotice(`Temporary password set for ${resetting.name}.`);
    setResetting(null);
  }

  async function handleAssignViewer(
    viewerId: string,
    level: ViewerAccessLevel,
  ) {
    if (!assigning) return;
    await userService.assignViewer(assigning.id, viewerId, level);
    const viewer = rows.find((u) => u.id === viewerId);
    setNotice(
      `${viewer?.name ?? "Viewer"} can now view ${assigning.name}'s tracking data.`,
    );
    setAssigning(null);
  }

  return (
    <section className="flex flex-col gap-6 rounded-2xl border border-white/10 bg-black p-4 sm:p-6">
      <SegmentedControl
        ariaLabel="Filter by status"
        options={STATUS_OPTIONS}
        value={status}
        onChange={setStatus}
      />

      <div className="flex flex-col gap-3 sm:flex-row sm:gap-6">
        <label className="flex min-w-0 flex-1 items-center gap-4 rounded-[18px] border border-white/10 p-4 transition-colors focus-within:border-white/30">
          <Search className="size-5 shrink-0 text-white" strokeWidth={1.75} />
          <input
            type="search"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Search users by name or email..."
            aria-label="Search users by name or email"
            className="w-full min-w-0 bg-transparent text-base text-white outline-none placeholder:text-white"
          />
        </label>
        <div className="relative sm:w-[210px]">
          <select
            value={role}
            onChange={(e) => setRole(e.target.value as UserRole | "all")}
            aria-label="Filter by role"
            className="h-full min-h-[52px] w-full cursor-pointer appearance-none rounded-[18px] border border-white/10 bg-black px-6 text-base text-white outline-none transition-colors focus:border-white/30"
          >
            <option value="all">All Roles</option>
            {Object.entries(USER_ROLE_LABELS).map(([value, label]) => (
              <option key={value} value={value}>
                {label}
              </option>
            ))}
          </select>
          <ChevronDown
            className="pointer-events-none absolute top-1/2 right-4 size-6 -translate-y-1/2 text-white"
            strokeWidth={1.5}
          />
        </div>
      </div>

      {notice && (
        <p
          role="status"
          className="flex items-center justify-between gap-3 rounded-xl border border-[#00c950]/20 bg-[#00c950]/10 px-4 py-3 text-sm text-[#05df72]"
        >
          {notice}
          <button
            type="button"
            onClick={() => setNotice(null)}
            className="cursor-pointer text-xs font-medium hover:underline"
          >
            Dismiss
          </button>
        </p>
      )}

      {error ? (
        <p
          role="alert"
          className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300"
        >
          Couldn&apos;t load users. {error.message}
        </p>
      ) : (
        <UserTable
          users={rows}
          loading={loading && rows.length === 0}
          onAction={handleAction}
        />
      )}

      {viewing && (
        <UserDetailsModal user={viewing} onClose={() => setViewing(null)} />
      )}
      {editing && (
        <EditUserModal
          user={editing}
          onClose={() => setEditing(null)}
          onSave={handleSaveUser}
        />
      )}
      {resetting && (
        <ResetPasswordModal
          name={resetting.name}
          onClose={() => setResetting(null)}
          onReset={handleResetPassword}
        />
      )}
      {assigning && (
        <AssignViewerModal
          user={assigning}
          onClose={() => setAssigning(null)}
          onAssign={handleAssignViewer}
        />
      )}
      {deleting && (
        <DeleteUserModal
          user={deleting}
          onClose={() => setDeleting(null)}
          onDelete={handleDelete}
        />
      )}
    </section>
  );
}
