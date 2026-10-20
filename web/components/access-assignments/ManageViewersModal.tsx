"use client";

import { useState } from "react";
import { Check, Loader2, Search } from "lucide-react";
import { Avatar } from "@/components/ui/Avatar";
import { Modal } from "@/components/ui/Modal";
import { useAsync } from "@/hooks/useAsync";
import { accessAssignmentService } from "@/services/accessAssignmentService";
import type { TrackedUserAssignment } from "@/types/accessAssignment";

/** "Manage Viewer Access" (Figma 610:27423) — same for Admin and Super Admin. */
export function ManageViewersModal({ assignment, onClose, onSave }: { assignment: TrackedUserAssignment; onClose: () => void; onSave: (viewerIds: string[]) => Promise<void> }) {
  const viewers = useAsync(() => accessAssignmentService.viewers(), []);
  const [selected, setSelected] = useState(() => new Set(assignment.viewers.map((v) => v.id)));
  const [search, setSearch] = useState("");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const q = search.trim().toLowerCase();
  const options = (viewers.data ?? []).filter((v) => !q || v.name.toLowerCase().includes(q) || v.email.toLowerCase().includes(q));
  const original = new Set(assignment.viewers.map((v) => v.id));
  const changed = selected.size !== original.size || [...selected].some((id) => !original.has(id));

  function toggle(id: string) {
    setSelected((s) => {
      const next = new Set(s);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  async function save() {
    setSaving(true);
    setError(null);
    try {
      await onSave([...selected]);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't save assignments");
      setSaving(false);
    }
  }

  return (
    <Modal title="Manage Viewer Access" subtitle={`For: ${assignment.name}`} onClose={onClose} width="max-w-[448px]">
      <label className="relative block">
        <Search className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-[#9ca3af]" />
        <input
          type="search"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search viewers..."
          aria-label="Search viewers"
          className="h-[38px] w-full rounded-[18px] border border-white/10 bg-white/10 pr-4 pl-[37px] text-sm text-[#e5e7eb] outline-none placeholder:text-[#9ca3af] focus:border-white/30"
        />
      </label>

      <ul className="flex max-h-[224px] flex-col gap-2.5 overflow-y-auto [scrollbar-width:none] [&::-webkit-scrollbar]:hidden" aria-busy={viewers.loading}>
        {viewers.error && <li className="text-sm text-red-300">Couldn&apos;t load viewers. {viewers.error.message}</li>}
        {viewers.loading && [0, 1, 2].map((i) => <li key={i} className="h-[60px] shrink-0 animate-pulse rounded-[18px] bg-white/5" />)}
        {!viewers.loading && !viewers.error && options.length === 0 && <li className="py-6 text-center text-sm text-[#9ca3af]">No viewers found.</li>}
        {options.map((v) => {
          const on = selected.has(v.id);
          return (
            <li key={v.id} className="shrink-0">
              <button
                type="button"
                role="checkbox"
                aria-checked={on}
                onClick={() => toggle(v.id)}
                className={`flex w-full cursor-pointer items-center gap-3 rounded-[18px] border p-[13px] text-left transition ${
                  on ? "border-[#34206c]/40 bg-[#34206c]/20" : "border-transparent hover:bg-white/5"
                }`}
              >
                <Avatar src={v.avatarUrl} name={v.name} size={32} />
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-sm leading-5 font-medium text-[#e5e7eb]">{v.name}</span>
                  <span className="block truncate text-xs leading-4 font-medium text-[#9ca3af]">{v.email}</span>
                </span>
                {on && <Check className="size-4 shrink-0 text-[#8b5cf6]" />}
              </button>
            </li>
          );
        })}
      </ul>

      {error && (
        <p role="alert" className="text-sm text-red-300">
          {error}
        </p>
      )}

      <div className="flex gap-3">
        <button type="button" onClick={onClose} className="flex-1 cursor-pointer rounded-[18px] border border-[#9ca3af] px-4 py-2.5 text-sm leading-5 font-medium text-[#e5e7eb] transition hover:bg-white/5">
          Cancel
        </button>
        <button
          type="button"
          onClick={save}
          disabled={saving || !changed}
          className="flex flex-1 cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#34206c] px-4 py-2.5 text-sm leading-5 font-medium whitespace-nowrap text-white transition hover:bg-[#3f2785] disabled:cursor-not-allowed disabled:opacity-60"
        >
          {saving && <Loader2 className="size-4 animate-spin" />}
          Save Assignments
        </button>
      </div>
    </Modal>
  );
}
