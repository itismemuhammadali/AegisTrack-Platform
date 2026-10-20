"use client";

import { type FormEvent, useState } from "react";
import { ChevronDown, Eye, EyeOff, Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import { USER_ROLE_LABELS, type CreateUserInput, type UserRole } from "@/types/user";
import { BTN_CANCEL, BTN_SUBMIT, FIELD, Field } from "./EditUserModal";

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MIN_PASSWORD = 8;
const INPUT = `${FIELD} h-14 placeholder:text-[#9ca3af]`;

/** "Create New User" (Figma 610:27395) — opened from the User Management "Create User" button. */
export function CreateUserModal({ onClose, onCreate }: { onClose: () => void; onCreate: (input: CreateUserInput) => Promise<void> }) {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [role, setRole] = useState<UserRole>("tracked_user");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [touched, setTouched] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const errors = {
    name: !name.trim() ? "Full name is required" : null,
    email: !email.trim() ? "Email is required" : !EMAIL_RE.test(email.trim()) ? "Enter a valid email" : null,
    password: !password ? "Temporary password is required" : password.length < MIN_PASSWORD ? `Use at least ${MIN_PASSWORD} characters` : null,
  };

  async function submit(e: FormEvent) {
    e.preventDefault();
    setTouched(true);
    if (errors.name || errors.email || errors.password) return;
    setSaving(true);
    setError(null);
    try {
      await onCreate({ name, email, role, temporaryPassword: password });
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't create user");
      setSaving(false);
    }
  }

  return (
    <Modal title="Create New User" subtitle="Add a new user to the platform" onClose={onClose} width="max-w-[448px]" hideClose>
      <form onSubmit={submit} noValidate className="flex flex-col gap-4">
        <Field label="Full Name" id="create-user-name" error={touched ? errors.name : null}>
          <input id="create-user-name" value={name} onChange={(e) => setName(e.target.value)} placeholder="John Doe" autoComplete="off" aria-invalid={touched && !!errors.name} className={INPUT} />
        </Field>
        <Field label="Email Address" id="create-user-email" error={touched ? errors.email : null}>
          <input
            id="create-user-email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="john@company.com"
            autoComplete="off"
            aria-invalid={touched && !!errors.email}
            className={INPUT}
          />
        </Field>
        <Field label="Role" id="create-user-role">
          <span className="relative block">
            <select id="create-user-role" value={role} onChange={(e) => setRole(e.target.value as UserRole)} className={`${FIELD} h-14 cursor-pointer appearance-none px-6 text-white`}>
              {(Object.entries(USER_ROLE_LABELS) as [UserRole, string][]).map(([v, l]) => (
                <option key={v} value={v} className="bg-[#0c0e1a]">
                  {l}
                </option>
              ))}
            </select>
            <ChevronDown className="pointer-events-none absolute top-1/2 right-6 size-6 -translate-y-1/2 text-white" strokeWidth={1.5} />
          </span>
        </Field>
        <Field label="Temporary Password" id="create-user-password" error={touched ? errors.password : null}>
          <span className="relative block">
            <input
              id="create-user-password"
              type={showPassword ? "text" : "password"}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Enter temporary password"
              autoComplete="new-password"
              aria-invalid={touched && !!errors.password}
              className={`${INPUT} pr-12`}
            />
            <button
              type="button"
              onClick={() => setShowPassword((s) => !s)}
              aria-label={showPassword ? "Hide password" : "Show password"}
              className="absolute top-1/2 right-3 flex size-8 -translate-y-1/2 cursor-pointer items-center justify-center rounded-[14px] text-[#9ca3af] transition hover:text-white"
            >
              {showPassword ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
            </button>
          </span>
        </Field>

        {error && (
          <p role="alert" className="text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex gap-3">
          <button type="button" onClick={onClose} className={BTN_CANCEL}>
            Cancel
          </button>
          <button type="submit" disabled={saving} className={BTN_SUBMIT}>
            {saving && <Loader2 className="size-4 animate-spin" />}
            Create User
          </button>
        </div>
      </form>
    </Modal>
  );
}
