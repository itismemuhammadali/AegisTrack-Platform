"use client";

import { type FormEvent, type ReactNode, useState } from "react";
import { ChevronDown, Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import {
  USER_ROLE_LABELS,
  type ManagedUser,
  type UpdateUserInput,
  type UserRole,
} from "@/types/user";

export const FIELD =
  "h-[46px] w-full rounded-[18px] border border-white/10 bg-white/10 px-4 text-base text-[#e5e7eb] outline-none transition-colors placeholder:text-[#6b7280] focus:border-white/30 aria-invalid:border-red-400/60";
export const BTN_CANCEL =
  "h-11 flex-1 cursor-pointer rounded-[18px] border border-white/10 bg-white/10 text-base font-medium text-[#e5e7eb] transition hover:bg-white/15";
export const BTN_SUBMIT =
  "flex h-11 flex-1 cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#3c2579] text-base font-medium whitespace-nowrap text-white shadow-[0_10px_15px_rgba(52,32,108,0.2),0_4px_6px_rgba(52,32,108,0.2)] transition hover:bg-[#4a2f94] disabled:cursor-not-allowed disabled:opacity-60";
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

/** "Edit User" (Figma 610:27072) — opened from the row menu's Edit User. */
export function EditUserModal({
  user,
  onClose,
  onSave,
}: {
  user: ManagedUser;
  onClose: () => void;
  onSave: (input: UpdateUserInput) => Promise<void>;
}) {
  const [name, setName] = useState(user.name);
  const [email, setEmail] = useState(user.email);
  const [role, setRole] = useState<UserRole>(user.role);
  const [touched, setTouched] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const nameError = !name.trim() ? "Full name is required" : null;
  const emailError = !email.trim()
    ? "Email is required"
    : !EMAIL_RE.test(email.trim())
      ? "Enter a valid email"
      : null;

  async function submit(e: FormEvent) {
    e.preventDefault();
    setTouched(true);
    if (nameError || emailError) return;
    setSaving(true);
    setError(null);
    try {
      await onSave({ name, email, role });
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't save changes");
      setSaving(false);
    }
  }

  return (
    <Modal
      title="Edit User"
      subtitle="Update user information"
      onClose={onClose}
      width="max-w-[448px]"
      hideClose
    >
      <form onSubmit={submit} noValidate className="flex flex-col gap-6 pt-2">
        <div className="flex flex-col gap-4">
          <Field
            label="Full Name"
            id="edit-user-name"
            error={touched ? nameError : null}
          >
            <input
              id="edit-user-name"
              value={name}
              onChange={(e) => setName(e.target.value)}
              autoComplete="off"
              aria-invalid={touched && !!nameError}
              className={FIELD}
            />
          </Field>
          <Field
            label="Email"
            id="edit-user-email"
            error={touched ? emailError : null}
          >
            <input
              id="edit-user-email"
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              autoComplete="off"
              aria-invalid={touched && !!emailError}
              className={FIELD}
            />
          </Field>
          <Field label="Role" id="edit-user-role">
            <span className="relative block">
              <select
                id="edit-user-role"
                value={role}
                onChange={(e) => setRole(e.target.value as UserRole)}
                className={`${FIELD} cursor-pointer appearance-none px-6 text-white`}
              >
                {(Object.entries(USER_ROLE_LABELS) as [UserRole, string][]).map(
                  ([v, l]) => (
                    <option key={v} value={v} className="bg-[#0c0e1a]">
                      {l}
                    </option>
                  ),
                )}
              </select>
              <ChevronDown
                className="pointer-events-none absolute top-1/2 right-6 size-6 -translate-y-1/2 text-white"
                strokeWidth={1.5}
              />
            </span>
          </Field>
        </div>

        {error && (
          <p role="alert" className="text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex gap-3">
          <button
            type="button"
            onClick={onClose}
            className="h-11 flex-1 cursor-pointer rounded-[18px] border border-white/10 bg-white/10 text-base font-medium text-[#e5e7eb] transition hover:bg-white/15"
          >
            Cancel
          </button>
          <button type="submit" disabled={saving} className={BTN_SUBMIT}>
            {saving && <Loader2 className="size-4 animate-spin" />}
            Save Changes
          </button>
        </div>
      </form>
    </Modal>
  );
}

export function Field({
  label,
  id,
  error,
  children,
}: {
  label: string;
  id: string;
  error?: string | null;
  children: ReactNode;
}) {
  return (
    <div className="flex flex-col gap-2">
      <label
        htmlFor={id}
        className="text-sm leading-5 font-medium text-[#e5e7eb]"
      >
        {label}
      </label>
      {children}
      {error && <p className="text-xs text-red-300">{error}</p>}
    </div>
  );
}
