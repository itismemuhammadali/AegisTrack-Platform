"use client";

import { type FormEvent, useState } from "react";
import { Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import { BTN_SUBMIT, FIELD } from "@/components/users/EditUserModal";
import { useAsync } from "@/hooks/useAsync";
import { caseService } from "@/services/caseService";
import type { CreateCaseInput } from "@/types/case";

const AREA = "w-full resize-none rounded-[18px] border border-white/10 bg-white/10 px-4 text-sm leading-5 text-[#e5e7eb] outline-none transition-colors placeholder:text-[#9ca3af] focus:border-white/30";
const INPUT = `${FIELD} h-[52px] placeholder:text-[#9ca3af]`;
const BTN_OUTLINE = "h-11 flex-1 cursor-pointer rounded-[18px] border border-white/60 text-base font-medium text-[#e5e7eb] transition hover:bg-white/5";

function Field({ id, label, error, hint, children }: { id: string; label: string; error?: string | null; hint?: string; children: React.ReactNode }) {
  return (
    <div className="flex flex-col gap-2.5">
      <label htmlFor={id} className="text-sm leading-5 font-medium text-[#e5e7eb]">
        {label}
      </label>
      {children}
      {hint && <p className="text-xs leading-4 text-[#9ca3af]">{hint}</p>}
      {error && <p className="text-xs leading-4 text-red-300">{error}</p>}
    </div>
  );
}

/** "Create Case" (Figma 613:28590) — opened from the Create Case button, same for Admin and Super Admin. */
export function CreateCaseModal({ onClose, onCreate }: { onClose: () => void; onCreate: (input: CreateCaseInput) => Promise<void> }) {
  const [title, setTitle] = useState("");
  const [number, setNumber] = useState("");
  const [description, setDescription] = useState("");
  const [assigned, setAssigned] = useState<string[]>([]);
  const [courtOrder, setCourtOrder] = useState("");
  const [supportingInfo, setSupportingInfo] = useState("");
  const [touched, setTouched] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const users = useAsync(() => caseService.assignableUsers(), []);

  const titleError = !title.trim() ? "Case name is required" : null;
  const numberError = !number.trim() ? "Case number is required" : null;

  async function submit(e: FormEvent) {
    e.preventDefault();
    setTouched(true);
    if (titleError || numberError) return;
    setSaving(true);
    setError(null);
    try {
      await onCreate({ title, number, description, assignedUsers: assigned, courtOrder, supportingInfo });
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't create case");
      setSaving(false);
    }
  }

  return (
    <Modal title="Create Case" subtitle="Open a new case file" onClose={onClose} width="max-w-[560px]">
      <form onSubmit={submit} noValidate className="flex flex-col gap-6 pt-2">
        <div className="flex flex-col gap-4">
          <Field id="case-title" label="Case Name" error={touched ? titleError : null}>
            <input id="case-title" value={title} onChange={(e) => setTitle(e.target.value)} placeholder="e.g. State v. Johnson" aria-invalid={touched && !!titleError} className={INPUT} />
          </Field>
          <Field id="case-number" label="Case Number / Reference" error={touched ? numberError : null}>
            <input id="case-number" value={number} onChange={(e) => setNumber(e.target.value)} placeholder="e.g. CASE-2025-006" aria-invalid={touched && !!numberError} className={INPUT} />
          </Field>
          <Field id="case-description" label="Description">
            <textarea id="case-description" rows={1} value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Case description and context..." className={`${AREA} min-h-[54px] py-4`} />
          </Field>
          <Field id="case-users" label="Assigned Users" hint="Hold Ctrl/Cmd to select multiple">
            <select
              id="case-users"
              multiple
              value={assigned}
              onChange={(e) => setAssigned(Array.from(e.target.selectedOptions, (o) => o.value))}
              size={Math.max(users.data?.length ?? 5, 1)}
              className="w-full rounded-[18px] border border-white/10 bg-white/10 p-2.5 text-sm text-[#e5e7eb] outline-none transition-colors [scrollbar-width:none] focus:border-white/30 [&::-webkit-scrollbar]:hidden [&>option]:rounded-lg [&>option]:py-[3px] [&>option:checked]:bg-[linear-gradient(#34206c,#34206c)] [&>option:checked]:text-white"
            >
              {users.data?.map((u) => (
                <option key={u} value={u}>
                  {u}
                </option>
              ))}
            </select>
          </Field>
          <Field id="case-court-order" label="Court Order Reference (optional)">
            <input id="case-court-order" value={courtOrder} onChange={(e) => setCourtOrder(e.target.value)} placeholder="e.g. CO-2025-XXXX" className={INPUT} />
          </Field>
          <Field id="case-supporting" label="Supporting Information">
            <textarea id="case-supporting" value={supportingInfo} onChange={(e) => setSupportingInfo(e.target.value)} placeholder="Additional notes, attorney contact, etc." className={`${AREA} h-20 py-2.5`} />
          </Field>
        </div>

        {error && (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex gap-4">
          <button type="button" onClick={onClose} className={BTN_OUTLINE}>
            Cancel
          </button>
          <button type="submit" disabled={saving} className={BTN_SUBMIT}>
            {saving && <Loader2 className="size-4 animate-spin" />}
            Create Case
          </button>
        </div>
      </form>
    </Modal>
  );
}
