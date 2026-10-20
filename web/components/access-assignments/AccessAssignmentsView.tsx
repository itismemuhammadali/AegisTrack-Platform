"use client";

import { useEffect, useState } from "react";
import { Search, UserCheck } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { SegmentedControl } from "@/components/ui/SegmentedControl";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { accessAssignmentService } from "@/services/accessAssignmentService";
import type { TrackedUserAssignment } from "@/types/accessAssignment";
import { AssignmentCard } from "./AssignmentCard";
import { AssignmentHistoryTable } from "./AssignmentHistoryTable";
import { ManageViewersModal } from "./ManageViewersModal";

type Tab = "current" | "history";
const TABS = [
  { value: "current", label: "Current Assignments" },
  { value: "history", label: "Assignment History" },
] as const;

/** Same content for Admin (224:7424 / 610:15729) and Super Admin (610:18230 / 610:18569); only the sidebar differs. */
export function AccessAssignmentsView() {
  const { user } = useAuth();
  const [tab, setTab] = useState<Tab>("current");
  const [search, setSearch] = useState("");
  const debouncedSearch = useDebouncedValue(search, 250);
  const [version, setVersion] = useState(0);
  const [managing, setManaging] = useState<TrackedUserAssignment | null>(null);

  const { data, loading, error } = useAsync(() => accessAssignmentService.list(debouncedSearch), [debouncedSearch, version]);
  const history = useAsync(() => accessAssignmentService.history(), [version]);

  // Keep previous rows visible while refetching.
  const [rows, setRows] = useState<TrackedUserAssignment[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const activeCount = rows.reduce((n, a) => n + a.viewers.length, 0);

  async function handleRemove(assignment: TrackedUserAssignment, viewerId: string) {
    const viewer = assignment.viewers.find((v) => v.id === viewerId);
    if (!viewer || !window.confirm(`Remove ${viewer.name}'s access to ${assignment.name}?`)) return;
    await accessAssignmentService.removeViewer(assignment.id, viewerId, user.email);
    setVersion((v) => v + 1);
  }

  async function handleSaveViewers(viewerIds: string[]) {
    if (!managing) return;
    await accessAssignmentService.setViewers(managing.id, viewerIds, user.email);
    setManaging(null);
    setVersion((v) => v + 1);
  }

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Access Assignments</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Assign authorized viewers to specific tracked users</p>
        </div>
        <div className="flex items-center gap-2 rounded-[18px] border border-white/20 bg-white/10 p-[13px] text-sm leading-5 font-medium text-white">
          <UserCheck className="size-4" />
          {activeCount} active assignment{activeCount === 1 ? "" : "s"}
        </div>
      </div>

      <div className="flex gap-2.5 rounded-[18px] border border-[#f0b100]/20 bg-[#f0b100]/10 p-[17px]">
        <UserCheck className="mt-0.5 size-5 shrink-0 text-[#ffdf20]" />
        <div className="flex min-w-0 flex-col gap-1.5">
          <p className="text-sm leading-5 font-medium text-[#ffdf20]">Access Control Policy</p>
          <p className="text-xs leading-4 text-[#9ca3af]">
            Authorized Viewers can only access logs for users explicitly assigned to them. Viewers cannot access data for unassigned users.
          </p>
        </div>
      </div>

      <SegmentedControl ariaLabel="Access assignment sections" size="lg" options={TABS} value={tab} onChange={setTab} />

      {tab === "current" ? (
        <>
          <label className="flex items-center gap-4 rounded-[18px] border border-white/10 bg-white/10 p-[17px] focus-within:border-white/30">
            <Search className="size-5 shrink-0 text-[#9ca3af]" />
            <input
              type="search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search tracked users..."
              className="w-full min-w-0 bg-transparent text-base text-white outline-none placeholder:text-[#9ca3af]"
            />
          </label>

          <div className="flex flex-col gap-2.5" aria-busy={loading}>
            {error && <p className="text-sm text-[#ff6467]">Could not load assignments.</p>}
            {!loading && !error && rows.length === 0 && (
              <p className="rounded-[18px] border border-white/10 bg-black/60 p-6 text-center text-sm text-[#9ca3af]">No tracked users found.</p>
            )}
            {rows.map((a) => (
              <AssignmentCard key={a.id} assignment={a} onRemoveViewer={(id) => handleRemove(a, id)} onManage={() => setManaging(a)} />
            ))}
          </div>
        </>
      ) : (
        <AssignmentHistoryTable entries={history.data ?? []} loading={history.loading} />
      )}

      {managing && <ManageViewersModal assignment={managing} onClose={() => setManaging(null)} onSave={handleSaveViewers} />}
    </div>
  );
}
