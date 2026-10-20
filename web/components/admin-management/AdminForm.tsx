"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { type FormEvent, type ReactNode, useEffect, useId, useRef, useState } from "react";
import { ArrowLeft, Camera, Check, ChevronDown, Eye, EyeOff, Loader2, TriangleAlert, UserPlus } from "lucide-react";
import { Avatar } from "@/components/ui/Avatar";
import { Toggle } from "@/components/ui/Toggle";
import { isStrongPassword, PASSWORD_RULES, validateEmail } from "@/lib/validation";
import { adminAccountService } from "@/services/adminAccountService";
import { ADMIN_ROLE_OPTIONS, type AdminAccount, type AdminAccountRole, type AdminAccountStatus, fullName } from "@/types/adminAccount";
import { BTN_PRIMARY, BTN_SECONDARY, INPUT } from "./adminStyles";

const MAX_PHOTO_BYTES = 2 * 1024 * 1024;
const LIST = "/admin-management";

/**
 * Create (Figma 634:717) and edit (Figma 634:1792) share one form.
 * Edit adds Account Status + Danger Zone and keeps the role fixed, matching the designs.
 */
export function AdminForm({ admin }: { admin?: AdminAccount }) {
  const editing = Boolean(admin);
  const router = useRouter();
  const fileRef = useRef<HTMLInputElement>(null);

  const [firstName, setFirstName] = useState(admin?.firstName ?? "");
  const [lastName, setLastName] = useState(admin?.lastName ?? "");
  const [email, setEmail] = useState(admin?.email ?? "");
  const [password, setPassword] = useState("");
  const [role, setRole] = useState<AdminAccountRole>("admin");
  const [status, setStatus] = useState<AdminAccountStatus>(admin?.status ?? "active");
  const [sendInvite, setSendInvite] = useState(true);
  const [photo, setPhoto] = useState<File | null>(null);
  const [preview, setPreview] = useState<string | undefined>(admin?.avatarUrl);
  const [photoError, setPhotoError] = useState<string | null>(null);
  const [touched, setTouched] = useState(false);
  const [saving, setSaving] = useState<"save" | "deactivate" | "delete" | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!photo) return;
    const url = URL.createObjectURL(photo);
    setPreview(url); // eslint-disable-line react-hooks/set-state-in-effect -- derived object URL needs cleanup
    return () => URL.revokeObjectURL(url);
  }, [photo]);

  // Password is required on create; on edit, blank keeps the current one.
  const errors = {
    firstName: firstName.trim() ? undefined : "First name is required",
    lastName: lastName.trim() ? undefined : "Last name is required",
    email: validateEmail(email),
    password: !password ? (editing ? undefined : "Password is required") : isStrongPassword(password) ? undefined : "Password doesn't meet the requirements",
  };
  const valid = !Object.values(errors).some(Boolean);
  const show = (k: keyof typeof errors) => (touched ? errors[k] : undefined);

  function pickPhoto(file: File | undefined) {
    setPhotoError(null);
    if (!file) return;
    if (!file.type.startsWith("image/")) return setPhotoError("Choose an image file");
    if (file.size > MAX_PHOTO_BYTES) return setPhotoError("Max file size 2MB");
    setPhoto(file);
  }

  async function submit(e: FormEvent) {
    e.preventDefault();
    setTouched(true);
    if (!valid || saving) return;
    setSaving("save");
    setError(null);
    try {
      if (admin) await adminAccountService.update(admin.id, { firstName, lastName, email, password: password || undefined, status, photo });
      else await adminAccountService.create({ firstName, lastName, email, password, role, sendInvite, photo });
      router.push(LIST);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't save admin");
      setSaving(null);
    }
  }

  async function deactivate() {
    if (!admin || !window.confirm(`Deactivate ${fullName(admin)}? They lose dashboard access immediately.`)) return;
    setSaving("deactivate");
    setError(null);
    try {
      await adminAccountService.setStatus(admin.id, "inactive");
      setStatus("inactive");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't deactivate account");
    } finally {
      setSaving(null);
    }
  }

  async function remove() {
    if (!admin || !window.confirm(`Permanently delete ${fullName(admin)}? This clears all of their configuration history and can't be undone.`)) return;
    setSaving("delete");
    setError(null);
    try {
      await adminAccountService.remove(admin.id);
      router.push(LIST);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't delete account");
      setSaving(null);
    }
  }

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <Link href={LIST} className="flex items-center gap-2 self-start text-sm font-semibold text-white hover:text-white/80">
        <ArrowLeft className="size-4" />
        Back to Admin List
      </Link>

      <div>
        <h1 className="text-2xl font-bold text-[#f3f4f6]">{editing ? "Edit Admin" : "Add New Admin"}</h1>
        <p className="pt-1 text-sm text-[#9ca3af]">Provision high-clearance user profiles with custom policy roles</p>
      </div>

      <form onSubmit={submit} noValidate className={`flex flex-col rounded-2xl border border-white/[0.08] bg-[#0c0e1a] ${editing ? "gap-8 p-5 sm:p-8" : "gap-6 p-5 sm:p-6"}`}>
        <div className="flex flex-col gap-8 md:flex-row md:gap-10">
          <div className="flex shrink-0 flex-col items-center gap-3 md:w-[180px]">
            <input ref={fileRef} type="file" accept="image/*" className="sr-only" onChange={(e) => pickPhoto(e.target.files?.[0])} aria-label="Upload photo" />
            {preview ? (
              <>
                <button type="button" onClick={() => fileRef.current?.click()} className="cursor-pointer rounded-full" aria-label="Change image">
                  <Avatar src={preview} name={`${firstName} ${lastName}`} size={120} />
                </button>
                <button type="button" onClick={() => fileRef.current?.click()} className="cursor-pointer text-[13px] font-semibold text-[#6366f1] hover:text-[#818cf8]">
                  Change Image
                </button>
              </>
            ) : (
              <>
                <button
                  type="button"
                  onClick={() => fileRef.current?.click()}
                  className="flex size-[120px] cursor-pointer flex-col items-center justify-center gap-2 rounded-full border-2 border-dashed border-white/[0.08] bg-white/[0.04] text-[#6b7280] transition hover:border-white/20"
                >
                  <Camera className="size-6" />
                  <span className="text-xs">Upload Photo</span>
                </button>
                <p className="text-xs text-[#6b7280]">Max file size 2MB</p>
              </>
            )}
            {photoError && (
              <p role="alert" className="text-xs text-red-300">
                {photoError}
              </p>
            )}
          </div>

          <div className="flex min-w-0 flex-1 flex-col gap-5">
            <div className="grid grid-cols-1 gap-5 sm:grid-cols-2">
              <Field label="First Name" error={show("firstName")}>
                {(id, invalid) => <input id={id} value={firstName} onChange={(e) => setFirstName(e.target.value)} placeholder="Enter first name" autoComplete="given-name" aria-invalid={invalid} className={INPUT} />}
              </Field>
              <Field label="Last Name" error={show("lastName")}>
                {(id, invalid) => <input id={id} value={lastName} onChange={(e) => setLastName(e.target.value)} placeholder="Enter last name" autoComplete="family-name" aria-invalid={invalid} className={INPUT} />}
              </Field>
              <Field label="Email Address" error={show("email")}>
                {(id, invalid) => <input id={id} type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="name@securetrack.io" autoComplete="off" aria-invalid={invalid} className={INPUT} />}
              </Field>
              <Field label={editing ? "Enter Password" : "Set Password"} error={show("password")}>
                {(id, invalid) => <PasswordField id={id} value={password} onChange={setPassword} placeholder={editing ? "Leave blank to keep current" : "Set password"} invalid={invalid} />}
              </Field>
            </div>

            {password && (
              <ul className="-mt-2 grid grid-cols-1 gap-1 sm:grid-cols-3">
                {PASSWORD_RULES.map((r) => {
                  const ok = r.test(password);
                  return (
                    <li key={r.id} className={`flex items-center gap-1.5 text-xs ${ok ? "text-[#05df72]" : "text-[#9ca3af]"}`}>
                      <Check className={`size-3 ${ok ? "" : "opacity-30"}`} /> {r.label}
                    </li>
                  );
                })}
              </ul>
            )}

            {editing ? (
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div className="flex items-center gap-3">
                  <span className="text-sm font-semibold text-[#f3f4f6]">Account Status</span>
                  <Toggle checked={status === "active"} onChange={(v) => setStatus(v ? "active" : "inactive")} label="Account active" />
                  <span className={`text-sm ${status === "active" ? "text-[#10b981]" : "text-[#9ca3af]"}`}>{status === "active" ? "Active" : "Inactive"}</span>
                </div>
                <p className="text-[13px] text-[#6b7280]">Last modified: {admin?.lastModified}</p>
              </div>
            ) : (
              <Field label="Select Admin Role">
                {(id) => (
                  <span className="relative block">
                    <select id={id} value={role} onChange={(e) => setRole(e.target.value as AdminAccountRole)} className={`${INPUT} cursor-pointer appearance-none pr-10`}>
                      {(Object.entries(ADMIN_ROLE_OPTIONS) as [AdminAccountRole, string][]).map(([v, l]) => (
                        <option key={v} value={v} className="bg-[#0c0e1a]">
                          {l}
                        </option>
                      ))}
                    </select>
                    <ChevronDown className="pointer-events-none absolute top-1/2 right-3 size-[18px] -translate-y-1/2 text-[#f3f4f6]" />
                  </span>
                )}
              </Field>
            )}
          </div>
        </div>

        {editing ? (
          <section className="flex flex-col gap-4 rounded-xl border border-[#ef4444]/20 bg-[#ef4444]/[0.04] p-5 sm:p-6">
            <h2 className="flex items-center gap-2 text-base font-bold text-[#ef4444]">
              <TriangleAlert className="size-5" />
              Danger Zone
            </h2>
            <p className="text-[13px] text-[#9ca3af]">
              Deactivating this administrator account instantly revokes access to the dashboard. Deleting is irreversible and clears all admin configuration histories.
            </p>
            <div className="flex flex-wrap gap-3">
              <button
                type="button"
                onClick={deactivate}
                disabled={saving !== null || status === "inactive"}
                className="flex cursor-pointer items-center gap-2 rounded-lg border border-[#ef4444] px-4 py-2 text-[13px] font-semibold text-[#ef4444] transition hover:bg-[#ef4444]/10 disabled:cursor-not-allowed disabled:opacity-40"
              >
                {saving === "deactivate" && <Loader2 className="size-3.5 animate-spin" />}
                Deactivate Account
              </button>
              <button
                type="button"
                onClick={remove}
                disabled={saving !== null}
                className="flex cursor-pointer items-center gap-2 rounded-lg bg-[#ef4444] px-4 py-2 text-[13px] font-semibold text-[#f3f4f6] transition hover:bg-[#dc2626] disabled:cursor-not-allowed disabled:opacity-40"
              >
                {saving === "delete" && <Loader2 className="size-3.5 animate-spin" />}
                Delete Account permanently
              </button>
            </div>
          </section>
        ) : (
          <div className="flex items-center justify-between gap-4 pt-4">
            <div>
              <p className="text-sm font-semibold text-[#f3f4f6]">Send secure verification invite</p>
              <p className="pt-1 text-xs text-[#9ca3af]">Admin will receive a secure registration URL via email valid for 24 hours</p>
            </div>
            <Toggle checked={sendInvite} onChange={setSendInvite} label="Send secure verification invite" />
          </div>
        )}

        {error && (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex flex-wrap justify-end gap-3">
          <Link href={LIST} className={BTN_SECONDARY}>
            {editing ? "Cancel Changes" : "Cancel"}
          </Link>
          <button type="submit" disabled={saving !== null || (touched && !valid)} className={BTN_PRIMARY}>
            {saving === "save" ? <Loader2 className="size-4 animate-spin" /> : editing ? <Check className="size-4" /> : <UserPlus className="size-4" />}
            {editing ? "Save Changes" : "Create Admin Account"}
          </button>
        </div>
      </form>
    </div>
  );
}

function Field({ label, error, children }: { label: string; error?: string; children: (id: string, invalid: boolean) => ReactNode }) {
  const id = useId();
  return (
    <div className="flex min-w-0 flex-col gap-2">
      <label htmlFor={id} className="text-sm font-semibold text-[#f3f4f6]">
        {label}
      </label>
      {children(id, Boolean(error))}
      {error && <p className="text-xs text-red-300">{error}</p>}
    </div>
  );
}

function PasswordField({ id, value, onChange, placeholder, invalid }: { id: string; value: string; onChange: (v: string) => void; placeholder: string; invalid: boolean }) {
  const [visible, setVisible] = useState(false);
  return (
    <span className="relative block">
      <input
        id={id}
        type={visible ? "text" : "password"}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        autoComplete="new-password"
        aria-invalid={invalid}
        className={`${INPUT} pr-10`}
      />
      <button
        type="button"
        onClick={() => setVisible((v) => !v)}
        aria-label={visible ? "Hide password" : "Show password"}
        className="absolute top-1/2 right-3 -translate-y-1/2 cursor-pointer text-[#6b7280] hover:text-white"
      >
        {visible ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
      </button>
    </span>
  );
}
