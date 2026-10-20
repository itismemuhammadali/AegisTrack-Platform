"use client";

import { type FormEvent, useState } from "react";
import { Eye, EyeOff, Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import { BTN_CANCEL, BTN_SUBMIT, FIELD, Field } from "./EditUserModal";

const MIN_LENGTH = 8;

/** "Reset Password" (Figma 222:5073 / 610:27097) — Users row menu and Settings → Change Password. */
export function ResetPasswordModal({
  name,
  onClose,
  onReset,
}: {
  /** Whose password is being reset, shown in the subtitle. */
  name: string;
  onClose: () => void;
  onReset: (password: string) => Promise<void>;
}) {
  const [password, setPassword] = useState("");
  const [show, setShow] = useState(false);
  const [touched, setTouched] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fieldError = !password
    ? "Enter a temporary password"
    : password.length < MIN_LENGTH
      ? `Use at least ${MIN_LENGTH} characters`
      : null;

  async function submit(e: FormEvent) {
    e.preventDefault();
    setTouched(true);
    if (fieldError) return;
    setSaving(true);
    setError(null);
    try {
      await onReset(password);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't reset password");
      setSaving(false);
    }
  }

  return (
    <Modal
      title="Reset Password"
      subtitle={`Generate a new temporary password for ${name}`}
      onClose={onClose}
      width="max-w-[448px]"
      hideClose
    >
      <form onSubmit={submit} noValidate className="flex flex-col gap-6 pt-2">
        <div className="flex flex-col gap-4">
          <Field
            label="New Temporary Password"
            id="reset-password"
            error={touched ? fieldError : null}
          >
            <span className="relative block">
              <input
                id="reset-password"
                type={show ? "text" : "password"}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Enter new password"
                autoComplete="new-password"
                aria-invalid={touched && !!fieldError}
                className={`${FIELD} pr-12 placeholder:text-[#e5e7eb]/50`}
              />
              <button
                type="button"
                onClick={() => setShow((s) => !s)}
                aria-label={show ? "Hide password" : "Show password"}
                className="absolute top-1/2 right-3 flex size-8 -translate-y-1/2 cursor-pointer items-center justify-center rounded-[14px] text-[#9ca3af] transition hover:text-white"
              >
                {show ? (
                  <EyeOff className="size-4" />
                ) : (
                  <Eye className="size-4" />
                )}
              </button>
            </span>
          </Field>
          <p className="rounded-[18px] border border-[#2b7fff]/20 bg-[#2b7fff]/10 p-4 text-sm leading-5 text-[#51a2ff]">
            User will be required to change password on next login
          </p>
        </div>

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
            Reset Password
          </button>
        </div>
      </form>
    </Modal>
  );
}
