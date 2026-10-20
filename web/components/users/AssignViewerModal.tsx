"use client";

import { type FormEvent, type ReactNode, useState } from "react";
import { ChevronDown, Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import { useAsync } from "@/hooks/useAsync";
import { userService } from "@/services/userService";
import {
  USER_ROLE_LABELS,
  VIEWER_ACCESS_LABELS,
  type ManagedUser,
  type ViewerAccessLevel,
} from "@/types/user";
import { BTN_CANCEL, BTN_SUBMIT, FIELD, Field } from "./EditUserModal";

/** "Assign Viewer Access" (Figma 222:5092) — opened from the row menu's Assign Viewer. */
export function AssignViewerModal({
  user,
  onClose,
  onAssign,
}: {
  user: ManagedUser;
  onClose: () => void;
  onAssign: (viewerId: string, level: ViewerAccessLevel) => Promise<void>;
}) {
  const viewers = useAsync(
    () => userService.list({ role: "authorized_viewer" }),
    [],
  );
  const options = (viewers.data ?? []).filter((v) => v.id !== user.id);
  const [picked, setPicked] = useState("");
  const [level, setLevel] = useState<ViewerAccessLevel>("read_only");
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const viewerId = picked || options[0]?.id || "";

  async function submit(e: FormEvent) {
    e.preventDefault();
    if (!viewerId) return;
    setSaving(true);
    setError(null);
    try {
      await onAssign(viewerId, level);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't assign access");
      setSaving(false);
    }
  }

  return (
    <Modal
      title="Assign Viewer Access"
      subtitle={`Grant viewer access to ${user.name}'s tracking data`}
      onClose={onClose}
      width="max-w-[448px]"
      hideClose
    >
      <form onSubmit={submit} className="flex flex-col gap-6 pt-2">
        <div className="flex flex-col gap-4">
          <Field label="Select Viewer" id="assign-viewer">
            <Select
              id="assign-viewer"
              value={viewerId}
              onChange={setPicked}
              disabled={viewers.loading || options.length === 0}
            >
              {viewers.loading && <option value="">Loading viewers…</option>}
              {!viewers.loading && options.length === 0 && (
                <option value="">No authorized viewers available</option>
              )}
              {options.map((v) => (
                <option key={v.id} value={v.id} className="bg-[#0c0e1a]">
                  {v.name} ({USER_ROLE_LABELS[v.role]})
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Access Level" id="assign-level">
            <Select
              id="assign-level"
              value={level}
              onChange={(v) => setLevel(v as ViewerAccessLevel)}
            >
              {(
                Object.entries(VIEWER_ACCESS_LABELS) as [
                  ViewerAccessLevel,
                  string,
                ][]
              ).map(([v, l]) => (
                <option key={v} value={v} className="bg-[#0c0e1a]">
                  {l}
                </option>
              ))}
            </Select>
          </Field>
        </div>

        {(error || viewers.error) && (
          <p role="alert" className="text-sm text-red-300">
            {error ?? `Couldn't load viewers. ${viewers.error?.message}`}
          </p>
        )}

        <div className="flex gap-2.5">
          <button
            type="button"
            onClick={onClose}
            className={`${BTN_CANCEL} h-14`}
          >
            Cancel
          </button>
          <button
            type="submit"
            disabled={saving || !viewerId}
            className={`${BTN_SUBMIT} h-14`}
          >
            {saving && <Loader2 className="size-4 animate-spin" />}
            Assign Access
          </button>
        </div>
      </form>
    </Modal>
  );
}

function Select({
  id,
  value,
  onChange,
  disabled,
  children,
}: {
  id: string;
  value: string;
  onChange: (v: string) => void;
  disabled?: boolean;
  children: ReactNode;
}) {
  return (
    <span className="relative block">
      <select
        id={id}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        disabled={disabled}
        className={`${FIELD} h-14 cursor-pointer appearance-none truncate pr-14 pl-6 text-white disabled:cursor-default disabled:opacity-60`}
      >
        {children}
      </select>
      <ChevronDown
        className="pointer-events-none absolute top-1/2 right-6 size-6 -translate-y-1/2 text-white"
        strokeWidth={1.5}
      />
    </span>
  );
}
