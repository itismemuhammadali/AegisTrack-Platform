"use client";

import { type FormEvent, type ReactNode, useEffect, useState } from "react";
import Image from "next/image";
import { Loader2, MapPin } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import { BTN_SUBMIT, FIELD } from "@/components/users/EditUserModal";
import { useAsync } from "@/hooks/useAsync";
import { zoneService } from "@/services/zoneService";
import { ZONE_TYPE_LABELS, type Zone, type ZoneInput, type ZoneType } from "@/types/zone";
import { ZONE_TYPE_STYLE } from "./ZoneBadges";

const TYPE_ACTIVE: Record<ZoneType, string> = {
  allowed: "border-[#00c950]/20 bg-[#05df72]/10 text-[#05df72]",
  restricted: "border-[#fb2c36]/20 bg-[#fb2c36]/10 text-[#ff6467]",
  checkin: "border-[#2b7fff]/20 bg-[#2b7fff]/10 text-[#51a2ff]",
};
const BTN_OUTLINE = "h-11 flex-1 cursor-pointer rounded-[18px] border border-white/10 text-base font-medium text-[#e5e7eb] transition hover:bg-white/5";

function Field({ id, label, error, hint, children }: { id?: string; label: string; error?: string | null; hint?: string; children: ReactNode }) {
  const Label = id ? "label" : "p";
  return (
    <div className="flex flex-col gap-1.5">
      <Label htmlFor={id} className="text-sm leading-5 font-medium text-[#e5e7eb]">
        {label}
      </Label>
      {children}
      {hint && <p className="pt-1 text-xs leading-4 text-[#9ca3af]">{hint}</p>}
      {error && <p className="text-xs leading-4 text-red-300">{error}</p>}
    </div>
  );
}

/** "Create Zone" (Figma 622:2988); the same form edits an existing zone. */
export function ZoneFormModal({ zone, onClose, onSave }: { zone?: Zone; onClose: () => void; onSave: (input: ZoneInput) => Promise<void> }) {
  const editing = !!zone;
  const [name, setName] = useState(zone?.name ?? "");
  const [type, setType] = useState<ZoneType>(zone?.type ?? "allowed");
  const [description, setDescription] = useState(zone?.description ?? "");
  const [assigned, setAssigned] = useState<string[]>([]);
  const [touched, setTouched] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const users = useAsync(() => zoneService.assignableUsers(), []);
  const detail = useAsync(() => (zone ? zoneService.get(zone.id) : Promise.resolve(null)), [zone?.id]);
  useEffect(() => {
    if (detail.data) setAssigned(detail.data.assignedUserNames); // eslint-disable-line react-hooks/set-state-in-effect -- seed selection once details load
  }, [detail.data]);

  const nameError = !name.trim() ? "Zone name is required" : null;

  async function submit(e: FormEvent) {
    e.preventDefault();
    setTouched(true);
    if (nameError) return;
    setSaving(true);
    setError(null);
    try {
      await onSave({ name, type, description, assignedUserNames: assigned });
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't save zone");
      setSaving(false);
    }
  }

  return (
    <Modal
      title={editing ? "Edit Zone" : "Create Zone"}
      subtitle={editing ? "Update this geofence zone" : "Define a new geofence zone"}
      onClose={onClose}
      width="max-w-[512px]"
    >
      <form onSubmit={submit} noValidate className="flex flex-col gap-4">
        <div className="flex flex-col gap-2.5">
          <Field id="zone-name" label="Zone Name" error={touched ? nameError : null}>
            <input id="zone-name" value={name} onChange={(e) => setName(e.target.value)} placeholder="e.g. Warehouse District" aria-invalid={touched && !!nameError} className={`${FIELD} placeholder:text-[#9ca3af]`} />
          </Field>

          <Field label="Zone Type">
            <div role="radiogroup" aria-label="Zone Type" className="grid grid-cols-3 gap-2 pt-1.5">
              {(Object.keys(ZONE_TYPE_LABELS) as ZoneType[]).map((t) => {
                const { Icon } = ZONE_TYPE_STYLE[t];
                const on = type === t;
                return (
                  <button
                    key={t}
                    type="button"
                    role="radio"
                    aria-checked={on}
                    onClick={() => setType(t)}
                    className={`flex cursor-pointer flex-col items-center gap-1 rounded-[18px] border p-3 text-xs leading-4 font-medium transition-colors ${on ? TYPE_ACTIVE[t] : "border-white/10 bg-white/10 text-[#9ca3af] hover:text-[#e5e7eb]"}`}
                  >
                    <Icon className="size-4" />
                    <span className="text-center">{ZONE_TYPE_LABELS[t]}</span>
                  </button>
                );
              })}
            </div>
          </Field>

          <Field label="Map / Draw Zone">
            <div className="relative flex h-[267px] items-center justify-center overflow-hidden rounded-[18px] border border-white/10">
              <Image src="/images/zones/map-preview.png" alt="" fill sizes="462px" className="object-cover" />
              <div className="relative flex flex-col items-center gap-2">
                <MapPin className="size-[62px] fill-white/10 text-white/60" strokeWidth={1.25} />
                <span className="text-sm leading-5 text-[#a0a7b8]">Map Preview</span>
              </div>
            </div>
          </Field>

          <Field id="zone-description" label="Description">
            <textarea
              id="zone-description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="Zone description..."
              className="h-20 w-full resize-none rounded-[18px] border border-white/10 bg-white/10 px-4 py-2.5 text-sm leading-5 text-[#e5e7eb] outline-none transition-colors placeholder:text-[#9ca3af] focus:border-white/30"
            />
          </Field>

          <Field id="zone-users" label="Assign Users" hint="Hold Ctrl/Cmd to select multiple">
            <select
              id="zone-users"
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
        </div>

        {error && (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            {error}
          </p>
        )}

        <div className="flex gap-3">
          <button type="button" onClick={onClose} className={BTN_OUTLINE}>
            Cancel
          </button>
          <button type="submit" disabled={saving} className={BTN_SUBMIT}>
            {saving && <Loader2 className="size-4 animate-spin" />}
            Save Zone
          </button>
        </div>
      </form>
    </Modal>
  );
}
