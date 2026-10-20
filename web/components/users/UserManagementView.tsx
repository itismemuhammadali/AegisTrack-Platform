"use client";

import { useState } from "react";
import { Plus } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { SegmentedControl } from "@/components/ui/SegmentedControl";
import { userService } from "@/services/userService";
import type { CreateUserInput } from "@/types/user";
import { CreateUserModal } from "./CreateUserModal";
import { RolePermissionDetails } from "./RolePermissionDetails";
import { UserListPanel } from "./UserListPanel";

type Tab = "list" | "permissions";
const TABS = [
  { value: "list", label: "User List" },
  { value: "permissions", label: "Role & Permission Details" },
] as const;

/**
 * Admin: tabs for User List + Role & Permission Details (Figma 222:3294 / 607:3673).
 * Super Admin: user list only, no tabs (Figma 610:22732).
 */
export function UserManagementView() {
  const { user } = useAuth();
  const showTabs = user.role === "ADMIN";
  const [tab, setTab] = useState<Tab>("list");
  const [creating, setCreating] = useState(false);
  const [created, setCreated] = useState<{ name: string; n: number } | null>(null);

  async function handleCreate(input: CreateUserInput) {
    const u = await userService.create(input);
    setCreating(false);
    setTab("list");
    setCreated((c) => ({ name: u.name, n: (c?.n ?? 0) + 1 }));
  }

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">
            User Management
          </h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">
            Manage tracked users and authorized viewers
          </p>
        </div>
        <button
          type="button"
          onClick={() => setCreating(true)}
          className="flex cursor-pointer items-center justify-center gap-2 self-start rounded-[18px] bg-[#34206c] px-6 py-4 text-base leading-6 font-medium whitespace-nowrap text-white shadow-[0_10px_7.5px_rgba(52,32,108,0.2),0_4px_3px_rgba(52,32,108,0.2)] transition hover:bg-[#3f2785]"
        >
          <Plus className="size-4" />
          Create User
        </button>
      </div>

      {showTabs && (
        <SegmentedControl
          ariaLabel="User management sections"
          size="lg"
          options={TABS}
          value={tab}
          onChange={setTab}
        />
      )}

      {showTabs && tab === "permissions" ? (
        <RolePermissionDetails />
      ) : (
        <UserListPanel refreshKey={created?.n ?? 0} notice={created ? `${created.name} was created.` : null} />
      )}

      {creating && <CreateUserModal onClose={() => setCreating(false)} onCreate={handleCreate} />}
    </div>
  );
}
