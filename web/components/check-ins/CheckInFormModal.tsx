"use client";

import { type FormEvent, type ReactNode, useEffect, useState } from "react";
import { Calendar, Camera, Check, ChevronDown, Fingerprint, Loader2 } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import { BTN_SUBMIT } from "@/components/users/EditUserModal";
import { useAsync } from "@/hooks/useAsync";
import { checkInService } from "@/services/checkInService";
import {
  CHECKIN_FREQUENCY_LABELS,
  REMINDER_OPTIONS,
  type CheckInFrequency,
  type CheckInSchedule,
  type CheckInScheduleInput,
  type VerificationMethod,
} from "@/types/checkIn";

const CONTROL = "h-[46px] w-full rounded-[18px] border border-white/10 bg-white/10 px-4 text-base text-[#e5e7eb] outline-none transition-colors focus:border-white/30 aria-invalid:border-red-400/60";
const BTN_OUTLINE = "h-11 flex-1 cursor-pointer rounded-[18px] border border-white/10 text-base font-medium text-[#e5e7eb] transition hover:bg-white/5";

function Field({ id, label, error, children }: { id: string; label: string; error?: string | null; children: ReactNode }) {
  return (
    <div className="flex min-w-0 flex-1 flex-col gap-1.5">
      <label htmlFor={id} className="text-sm leading-5 font-medium text-[#e5e7eb]">
        {label}
      </label>
      {children}
      {error && <p className="text-xs leading-4 text-red-300">{error}</p>}
    </div>
  );
}

function Select({ id, value, onChange, invalid, children }: { id: string; value: string; onChange: (v: string) => void; invalid?: boolean; children: ReactNode }) {
  return (
    <div className="relative">
      <select id={id} value={value} onChange={(e) => onChange(e.target.value)} aria-invalid={invalid} className={`${CONTROL} cursor-pointer appearance-none pr-10 [&>option]:bg-[#0c0e1a]`}>
        {children}
      </select>
      <ChevronDown className="pointer-events-none absolute top-1/2 right-4 size-4 -translate-y-1/2 text-[#e5e7eb]" />
    </div>
  );
}

function Requirement({ checked, onChange, icon, label }: { checked: boolean; onChange: (v: boolean) => void; icon: ReactNode; label: string }) {
  return (
    <label className="flex cursor-pointer items-center gap-3 pt-3">
      <input type="checkbox" checked={checked} onChange={(e) => onChange(e.target.checked)} className="peer sr-only" />
      <span aria-hidden className={`flex size-4 shrink-0 items-center justify-center rounded-[2px] border peer-focus-visible:ring-2 peer-focus-visible:ring-[#ad46ff]/50 ${checked ? "border-[#ad46ff] bg-[#ad46ff]" : "border-[#767676] bg-white"}`}>
        {checked && <Check className="size-3.5 text-white" strokeWidth={3} />}
      </span>
      {icon}
      <span className="text-sm leading-5 font-medium text-[#e5e7eb]">{label}</span>
    </label>
  );
}

/** "Create Check-in Schedule" (Figma 622:3867); the same form edits an existing schedule. */
export function CheckInFormModal({ schedule, onClose, onSave }: { schedule?: CheckInSchedule; onClose: () => void; onSave: (input: CheckInScheduleInput) => Promise<void> }) {
  const editing = !!schedule;
  const [userId, setUserId] = useState(schedule?.user.id ?? "");
  const [name, setName] = useState(schedule?.name ?? "");
  const [startsAt, setStartsAt] = useState("");
  const [frequency, setFrequency] = useState<CheckInFrequency>(schedule?.frequency ?? "daily");
  const [methods, setMethods] = useState<VerificationMethod[]>(schedule?.methods ?? ["biometric", "selfie"]);
  const [reminderMinutes, setReminderMinutes] = useState(30);
  const [touched, setTouched] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const users = useAsync(() => checkInService.trackedUsers(), []);
  const detail = useAsync(() => (schedule ? checkInService.get(schedule.id) : Promise.resolve(null)), [schedule?.id]);
  useEffect(() => {
    if (!detail.data) return;
    setStartsAt(detail.data.startsAt); // eslint-disable-line react-hooks/set-state-in-effect -- seed fields once details load
    setReminderMinutes(detail.data.reminderMinutes);
  }, [detail.data]);

  const errors = {
    user: !userId ? "Select a tracked user" : null,
    name: !name.trim() ? "Schedule name is required" : null,
    startsAt: !startsAt ? "Pick a date and time" : null,
  };

  function toggle(m: VerificationMethod, on: boolean) {
    setMethods((cur) => (on ? [...cur.filter((x) => x !== m), m] : cur.filter((x) => x !== m)));
  }

  async function submit(e: FormEvent) {
    e.preventDefault();
    setTouched(true);
    if (errors.user || errors.name || errors.startsAt) return;
    setSaving(true);
    setError(null);
    try {
      // Keep a stable order: biometric first, then selfie.
      const ordered = (["biometric", "selfie"] as const).filter((m) => methods.includes(m));
      await onSave({ userId, name, startsAt, frequency, methods: ordered, reminderMinutes });
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't save schedule");
      setSaving(false);
    }
  }

  return (
    <Modal
      title={editing ? "Edit Check-in Schedule" : "Create Check-in Schedule"}
      subtitle={editing ? "Update this compliance check-in" : "Set up a new compliance check-in"}
      onClose={onClose}
      width="max-w-[512px]"
    >
      <form onSubmit={submit} noValidate className="flex flex-col gap-4">
        <Field id="checkin-user" label="Tracked User" error={touched ? errors.user : null}>
          <Select id="checkin-user" value={userId} onChange={setUserId} invalid={touched && !!errors.user}>
            <option value="" disabled>
              Select user...
            </option>
            {users.data?.map((u) => (
              <option key={u.id} value={u.id}>
                {u.name}
              </option>
            ))}
          </Select>
        </Field>

        <Field id="checkin-name" label="Schedule Name" error={touched ? errors.name : null}>
          <input id="checkin-name" value={name} onChange={(e) => setName(e.target.value)} placeholder="e.g. Daily Morning Check-in" aria-invalid={touched && !!errors.name} className={`${CONTROL} placeholder:text-[#9ca3af]`} />
        </Field>

        <div className="flex flex-col gap-4 sm:flex-row">
          <Field id="checkin-starts" label="Date / Time" error={touched ? errors.startsAt : null}>
            <div className="relative">
              <input
                id="checkin-starts"
                type="datetime-local"
                value={startsAt}
                onChange={(e) => setStartsAt(e.target.value)}
                aria-invalid={touched && !!errors.startsAt}
                className={`${CONTROL} pr-9 pl-3.5 text-[15px] [color-scheme:dark] [&::-webkit-calendar-picker-indicator]:absolute [&::-webkit-calendar-picker-indicator]:right-3 [&::-webkit-calendar-picker-indicator]:size-6 [&::-webkit-calendar-picker-indicator]:cursor-pointer [&::-webkit-calendar-picker-indicator]:opacity-0`}
              />
              <Calendar className="pointer-events-none absolute top-1/2 right-3.5 size-5 -translate-y-1/2 text-[#e5e7eb]" strokeWidth={1.75} />
            </div>
          </Field>
          <Field id="checkin-frequency" label="Frequency">
            <Select id="checkin-frequency" value={frequency} onChange={(v) => setFrequency(v as CheckInFrequency)}>
              {Object.entries(CHECKIN_FREQUENCY_LABELS).map(([value, label]) => (
                <option key={value} value={value}>
                  {label}
                </option>
              ))}
            </Select>
          </Field>
        </div>

        <fieldset className="rounded-[18px] border border-white/10 bg-white/10 p-4">
          <legend className="float-left text-sm leading-5 font-medium text-[#e5e7eb]">Verification Requirements</legend>
          <div className="clear-left">
            <Requirement checked={methods.includes("biometric")} onChange={(on) => toggle("biometric", on)} icon={<Fingerprint className="size-4 text-[#c27aff]" />} label="Require biometric verification" />
            <Requirement checked={methods.includes("selfie")} onChange={(on) => toggle("selfie", on)} icon={<Camera className="size-4 text-[#51a2ff]" />} label="Require selfie photo" />
          </div>
        </fieldset>

        <Field id="checkin-reminder" label="Reminder Settings">
          <Select id="checkin-reminder" value={String(reminderMinutes)} onChange={(v) => setReminderMinutes(Number(v))}>
            {REMINDER_OPTIONS.map((o) => (
              <option key={o.minutes} value={o.minutes}>
                {o.label}
              </option>
            ))}
          </Select>
        </Field>

        {error && (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex gap-3 pt-2">
          <button type="button" onClick={onClose} className={BTN_OUTLINE}>
            Cancel
          </button>
          <button type="submit" disabled={saving} className={BTN_SUBMIT}>
            {saving && <Loader2 className="size-4 animate-spin" />}
            {editing ? "Save Changes" : "Create Schedule"}
          </button>
        </div>
      </form>
    </Modal>
  );
}
