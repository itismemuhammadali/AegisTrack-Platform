"use client";

import { Users } from "lucide-react";
import { Avatar } from "@/components/ui/Avatar";
import type { ManagedUser } from "@/types/user";
import { RoleBadge, StatusBadge } from "./UserBadges";
import { type UserRowAction, UserRowActions } from "./UserRowActions";

interface UserTableProps {
  users: ManagedUser[];
  loading: boolean;
  onAction: (action: UserRowAction, user: ManagedUser) => void;
}

export function UserTable({ users, loading, onAction }: UserTableProps) {
  if (loading) {
    return (
      <div className="flex flex-col gap-2" aria-busy aria-label="Loading users">
        {Array.from({ length: 6 }, (_, i) => (
          <div
            key={i}
            className="h-[73px] animate-pulse rounded-xl bg-white/5"
          />
        ))}
      </div>
    );
  }

  if (users.length === 0) {
    return (
      <div className="flex flex-col items-center gap-2 py-16 text-center">
        <Users className="size-8 text-[#9ca3af]" />
        <p className="text-sm font-medium text-[#e5e7eb]">No users found</p>
        <p className="text-xs text-[#9ca3af]">
          Try a different search or filter.
        </p>
      </div>
    );
  }

  return (
    <>
      {/* ≥ md: table */}
      <table className="hidden w-full table-fixed border-collapse text-left md:table">
        <thead>
          <tr className="border-b border-white/10 text-xs leading-4 font-medium tracking-[0.6px] text-white uppercase">
            <th className="w-[31%] px-4 py-3 font-medium">User</th>
            <th className="w-[23%] px-4 py-3 font-medium">Role</th>
            <th className="w-[16%] px-4 py-3 font-medium">Status</th>
            <th className="px-4 py-3 font-medium">Last Active</th>
            <th className="w-[96px] px-4 py-3 text-right font-medium">
              Actions
            </th>
          </tr>
        </thead>
        <tbody>
          {users.map((u) => (
            <tr
              key={u.id}
              className="h-[73px] border-b border-white/10 transition-colors last:border-0 hover:bg-white/[0.03]"
            >
              <td className="px-4">
                <div className="flex min-w-0 items-center gap-3">
                  <Avatar src={u.avatarUrl} name={u.name} />
                  <div className="min-w-0">
                    <p className="truncate text-sm leading-5 font-medium text-white">
                      {u.name}
                    </p>
                    <p className="truncate text-xs leading-4 text-white">
                      {u.email}
                    </p>
                  </div>
                </div>
              </td>
              <td className="px-4">
                <RoleBadge role={u.role} />
              </td>
              <td className="px-4">
                <StatusBadge status={u.status} />
              </td>
              <td className="px-4 text-sm leading-5 whitespace-nowrap text-white">
                {u.lastActive}
              </td>
              <td className="px-4 text-right">
                <UserRowActions user={u} onAction={onAction} />
              </td>
            </tr>
          ))}
        </tbody>
      </table>

      {/* < md: stacked cards */}
      <ul className="flex flex-col gap-3 md:hidden">
        {users.map((u) => (
          <li
            key={u.id}
            className="flex flex-col gap-3 rounded-[18px] border border-white/10 bg-white/5 p-4"
          >
            <div className="flex items-start gap-3">
              <Avatar src={u.avatarUrl} name={u.name} />
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm leading-5 font-medium text-white">
                  {u.name}
                </p>
                <p className="truncate text-xs leading-4 text-white">
                  {u.email}
                </p>
              </div>
              <UserRowActions user={u} onAction={onAction} />
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <RoleBadge role={u.role} />
              <StatusBadge status={u.status} />
              <span className="ml-auto text-xs text-[#9ca3af]">
                {u.lastActive}
              </span>
            </div>
          </li>
        ))}
      </ul>
    </>
  );
}
