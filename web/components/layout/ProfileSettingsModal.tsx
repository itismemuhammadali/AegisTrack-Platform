"use client";

import {
  type ChangeEvent,
  type FormEvent,
  type ReactNode,
  useEffect,
  useRef,
  useState,
} from "react";
import {
  Building2,
  Camera,
  Loader2,
  Mail,
  Phone,
  Shield,
  User,
  X,
} from "lucide-react";
import { Avatar } from "@/components/ui/Avatar";
import { useAuth } from "@/components/providers/AuthProvider";
import { useAsync } from "@/hooks/useAsync";
import { profileService } from "@/services/profileService";
import type { AdminProfile } from "@/types/profile";

const ROLE_LABEL = {
  SUPER_ADMIN: "Super Administrator",
  ADMIN: "Administrator",
} as const;
const DEFAULT_AVATAR = "/images/avatar.png";
const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const MAX_PHOTO_BYTES = 5 * 1024 * 1024;

type Draft = {
  name: string;
  email: string;
  organization: string;
  phone: string;
};

/**
 * "Profile Settings" (Figma 610:27246 view / 610:27318 edit) — opened from the header
 * account menu's View Profile. Same for Admin and Super Admin.
 */
export function ProfileSettingsModal({ onClose }: { onClose: () => void }) {
  const { user, updateUser } = useAuth();
  const { data, loading, error } = useAsync(
    () => profileService.get(user),
    [user.email],
  );
  const [profile, setProfile] = useState<AdminProfile | null>(null);
  const [editing, setEditing] = useState(false);
  const [draft, setDraft] = useState<Draft>({
    name: "",
    email: "",
    organization: "",
    phone: "",
  });
  const [photo, setPhoto] = useState<File | null>(null);
  const [preview, setPreview] = useState<string | null>(null);
  const [touched, setTouched] = useState(false);
  const [saving, setSaving] = useState(false);
  const [saveError, setSaveError] = useState<string | null>(null);
  const fileRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    if (data) setProfile(data); // eslint-disable-line react-hooks/set-state-in-effect -- local copy updated after save
  }, [data]);

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => e.key === "Escape" && onClose();
    document.addEventListener("keydown", onKey);
    const overflow = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    return () => {
      document.removeEventListener("keydown", onKey);
      document.body.style.overflow = overflow;
    };
  }, [onClose]);

  useEffect(
    () => () => void (preview && URL.revokeObjectURL(preview)),
    [preview],
  );

  function startEdit() {
    if (!profile) return;
    setDraft({
      name: profile.name,
      email: profile.email,
      organization: profile.organization,
      phone: profile.phone,
    });
    setTouched(false);
    setSaveError(null);
    setEditing(true);
  }

  function cancelEdit() {
    setEditing(false);
    setPhoto(null);
    setPreview(null);
    setSaveError(null);
  }

  function pickPhoto(e: ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    e.target.value = "";
    if (!file) return;
    if (!file.type.startsWith("image/"))
      return setSaveError("Choose an image file");
    if (file.size > MAX_PHOTO_BYTES)
      return setSaveError("Photo must be 5 MB or smaller");
    if (!editing) startEdit();
    setSaveError(null);
    setPhoto(file);
    setPreview(URL.createObjectURL(file));
  }

  const errors = {
    name: !draft.name.trim() ? "Full name is required" : null,
    email: !draft.email.trim()
      ? "Email is required"
      : !EMAIL_RE.test(draft.email.trim())
        ? "Enter a valid email"
        : null,
  };

  async function save(e: FormEvent) {
    e.preventDefault();
    setTouched(true);
    if (errors.name || errors.email) return;
    setSaving(true);
    setSaveError(null);
    try {
      const next = await profileService.update(user, { ...draft, photo });
      setProfile(next);
      updateUser({
        name: next.name,
        email: next.email,
        avatarUrl: next.avatarUrl,
      });
      setEditing(false);
      setPhoto(null);
      setPreview(null);
    } catch (err) {
      setSaveError(
        err instanceof Error ? err.message : "Couldn't save profile",
      );
    } finally {
      setSaving(false);
    }
  }

  const values: Draft = editing
    ? draft
    : {
        name: profile?.name ?? "",
        email: profile?.email ?? "",
        organization: profile?.organization ?? "",
        phone: profile?.phone ?? "",
      };
  const set = (k: keyof Draft) => (e: ChangeEvent<HTMLInputElement>) =>
    setDraft((d) => ({ ...d, [k]: e.target.value }));
  const avatar = preview ?? profile?.avatarUrl ?? DEFAULT_AVATAR;

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-black/70 p-4 backdrop-blur-sm"
      onMouseDown={(e) => e.target === e.currentTarget && onClose()}
    >
      <form
        role="dialog"
        aria-modal="true"
        aria-label="Profile Settings"
        onSubmit={save}
        noValidate
        className="my-auto flex w-full max-w-[672px] flex-col overflow-hidden rounded-2xl border border-white/10 bg-[linear-gradient(127.7deg,rgba(12,18,39,0.4)_0%,rgba(12,18,39,0.9)_50%,rgba(12,18,39,0.4)_100%),linear-gradient(#0c1227,#0c1227)] shadow-2xl"
      >
        <header className="flex h-[69px] items-center justify-between border-b border-white/10 bg-white/10 px-6">
          <h2 className="text-xl leading-7 font-semibold text-[#e5e7eb]">
            Profile Settings
          </h2>
          <button
            type="button"
            onClick={onClose}
            aria-label="Close"
            className="flex size-9 cursor-pointer items-center justify-center rounded-[14px] bg-white/10 text-white transition hover:bg-white/15"
          >
            <X className="size-5" />
          </button>
        </header>

        {error ? (
          <p
            role="alert"
            className="m-6 rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300"
          >
            Couldn&apos;t load your profile. {error.message}
          </p>
        ) : !profile ? (
          <div className="flex justify-center p-16" aria-busy={loading}>
            <Loader2 className="size-6 animate-spin text-[#9ca3af]" />
          </div>
        ) : (
          <div className="flex flex-col gap-6 p-4 sm:p-6">
            <div className="flex flex-wrap items-center gap-4 border-b border-white/10 pb-4">
              <div className="relative size-24 shrink-0 rounded-full bg-[linear-gradient(135deg,#ad46ff_0%,#4f39f6_100%)]">
                <Avatar src={avatar} name={profile.name} size={96} />
                <button
                  type="button"
                  onClick={() => fileRef.current?.click()}
                  aria-label="Change profile photo"
                  className="absolute top-16 left-16 flex size-8 cursor-pointer items-center justify-center rounded-full bg-[#34206c] text-white shadow-md transition hover:bg-[#44298c]"
                >
                  <Camera className="size-4" />
                </button>
                <input
                  ref={fileRef}
                  type="file"
                  accept="image/*"
                  hidden
                  onChange={pickPhoto}
                />
              </div>
              <div className="flex min-w-0 flex-1 flex-col items-start gap-2">
                <p className="max-w-full truncate text-xl leading-7 font-semibold text-[#e5e7eb]">
                  {profile.name}
                </p>
                <p className="max-w-full truncate text-sm leading-5 text-[#9ca3af]">
                  {profile.email}
                </p>
                <span className="inline-flex items-center gap-2 rounded-[14px] border border-white/20 bg-white/10 px-3 py-1.5 text-sm leading-5 font-medium text-white">
                  <Shield className="size-4" />
                  {ROLE_LABEL[profile.role]}
                </span>
              </div>
              <button
                type="button"
                onClick={editing ? cancelEdit : startEdit}
                className="cursor-pointer rounded-[18px] bg-[#34206c] px-4 py-[7px] text-base leading-6 font-medium whitespace-nowrap text-white transition hover:bg-[#44298c]"
              >
                {editing ? "Cancel" : "Edit Profile"}
              </button>
            </div>

            <div className="flex flex-col gap-4">
              <ProfileField
                id="profile-name"
                label="Full Name"
                icon={<User className="size-5" />}
                editing={editing}
                error={touched ? errors.name : null}
              >
                <input
                  id="profile-name"
                  value={values.name}
                  onChange={set("name")}
                  readOnly={!editing}
                  autoComplete="name"
                  aria-invalid={touched && !!errors.name}
                />
              </ProfileField>
              <ProfileField
                id="profile-email"
                label="Email Address"
                icon={<Mail className="size-5" />}
                editing={editing}
                error={touched ? errors.email : null}
              >
                <input
                  id="profile-email"
                  type="email"
                  value={values.email}
                  onChange={set("email")}
                  readOnly={!editing}
                  autoComplete="email"
                  aria-invalid={touched && !!errors.email}
                />
              </ProfileField>
              <ProfileField
                id="profile-org"
                label="Organization"
                icon={<Building2 className="size-5" />}
                editing={editing}
              >
                <input
                  id="profile-org"
                  value={values.organization}
                  onChange={set("organization")}
                  readOnly={!editing}
                  autoComplete="organization"
                />
              </ProfileField>
              <ProfileField
                id="profile-phone"
                label="Phone Number"
                icon={<Phone className="size-5" />}
                editing={editing}
              >
                <input
                  id="profile-phone"
                  type="tel"
                  value={values.phone}
                  onChange={set("phone")}
                  readOnly={!editing}
                  autoComplete="tel"
                />
              </ProfileField>
            </div>

            <section className="flex flex-col gap-4 border-t border-white/10 pt-4">
              <h3 className="text-base leading-6 font-semibold text-[#e5e7eb]">
                Security Information
              </h3>
              <div className="flex flex-col gap-2.5">
                <InfoRow label="Last Login" value={profile.lastLogin} />
                <InfoRow label="Account Created" value={profile.createdAt} />
              </div>
            </section>

            {saveError && (
              <p role="alert" className="text-sm text-red-300">
                {saveError}
              </p>
            )}

            {editing && (
              <div className="flex gap-4 border-t border-white/10 pt-4">
                <button
                  type="button"
                  onClick={cancelEdit}
                  className="h-14 flex-1 cursor-pointer rounded-[18px] bg-white/10 text-base font-medium text-[#e5e7eb] transition hover:bg-white/15"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={saving}
                  className="flex h-14 flex-1 cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#34206c] text-base font-medium whitespace-nowrap text-white shadow-[0_10px_15px_rgba(52,32,108,0.2),0_4px_6px_rgba(52,32,108,0.2)] transition hover:bg-[#44298c] disabled:cursor-not-allowed disabled:opacity-60"
                >
                  {saving && <Loader2 className="size-4 animate-spin" />}
                  Save Changes
                </button>
              </div>
            )}
          </div>
        )}
      </form>
    </div>
  );
}

/** Icon-prefixed field: dimmed and read-only in view mode, editable in edit mode. */
function ProfileField({
  id,
  label,
  icon,
  editing,
  error,
  children,
}: {
  id: string;
  label: string;
  icon: ReactNode;
  editing: boolean;
  error?: string | null;
  children: ReactNode;
}) {
  return (
    <div className="flex flex-col gap-2">
      <label
        htmlFor={id}
        className={`text-sm leading-5 font-medium ${editing ? "text-white" : "text-[#e5e7eb]"}`}
      >
        {label}
      </label>
      <div
        className={`flex items-center gap-4 rounded-[18px] border bg-white/10 px-4 transition-colors focus-within:border-white/30 [&_input]:h-14 [&_input]:w-full [&_input]:min-w-0 [&_input]:bg-transparent [&_input]:text-base [&_input]:outline-none ${
          error ? "border-red-400/60" : "border-white/10"
        } ${editing ? "text-white [&_input]:text-white" : "opacity-50 [&_input]:text-[#e5e7eb]"}`}
      >
        <span className="shrink-0">{icon}</span>
        {children}
      </div>
      {error && <p className="text-xs text-red-300">{error}</p>}
    </div>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex flex-col rounded-[18px] border border-white/10 bg-white/10 p-4">
      <p className="text-sm leading-5 font-medium text-[#e5e7eb]">{label}</p>
      <p className="text-xs leading-4 text-[#9ca3af]">{value}</p>
    </div>
  );
}
