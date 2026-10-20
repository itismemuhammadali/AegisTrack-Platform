"use client";

import { type ReactNode, useEffect, useState } from "react";
import { Archive, Clock, Database, Loader2, Shield, Trash2 } from "lucide-react";
import { Toggle } from "@/components/ui/Toggle";
import { useAsync } from "@/hooks/useAsync";
import { retentionService } from "@/services/retentionService";
import { formatRetention, type RetentionPolicy } from "@/types/retention";

type Editable = Pick<RetentionPolicy, "retentionDays" | "autoDelete" | "archiveFirst" | "complianceMode">;

/** Super Admin only (Figma 610:20465). Edits are local until "Save Rules". */
export function RetentionRulesView() {
  const { data, loading, error } = useAsync(() => retentionService.get(), []);
  const [policies, setPolicies] = useState<RetentionPolicy[]>([]);
  const [expanded, setExpanded] = useState<string | null>(null);
  const [dirty, setDirty] = useState<Set<string>>(new Set());
  const [saving, setSaving] = useState(false);
  const [notice, setNotice] = useState<{ ok: boolean; text: string } | null>(null);

  useEffect(() => {
    if (!data) return;
    setPolicies(data.policies); // eslint-disable-line react-hooks/set-state-in-effect -- seeds editable copy
    setExpanded((e) => e ?? data.policies[0]?.id ?? null);
  }, [data]);

  function edit(id: string, patch: Partial<Editable>) {
    setPolicies((ps) => ps.map((p) => (p.id === id ? { ...p, ...patch } : p)));
    setDirty((d) => new Set(d).add(id));
    setNotice(null);
  }

  const invalid = policies.find((p) => dirty.has(p.id) && (p.retentionDays < 1 || (p.complianceMode && p.retentionDays < p.minRetentionDays)));

  async function save() {
    if (invalid || dirty.size === 0) return;
    setSaving(true);
    setNotice(null);
    try {
      await retentionService.save(
        policies.filter((p) => dirty.has(p.id)).map(({ id, retentionDays, autoDelete, archiveFirst, complianceMode }) => ({ id, retentionDays, autoDelete, archiveFirst, complianceMode })),
      );
      setDirty(new Set());
      setNotice({ ok: true, text: "Retention rules saved." });
    } catch (err) {
      setNotice({ ok: false, text: err instanceof Error ? err.message : "Couldn't save retention rules" });
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Retention Rules</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Configure data retention, archiving, and compliance policies</p>
        </div>
        <button
          type="button"
          onClick={save}
          disabled={saving || dirty.size === 0 || Boolean(invalid)}
          className="flex cursor-pointer items-center gap-2 rounded-[18px] bg-[#34206c] px-4 py-2.5 text-base leading-6 font-medium text-white transition hover:bg-[#3f2785] disabled:cursor-not-allowed disabled:opacity-60"
        >
          {saving ? <Loader2 className="size-4 animate-spin" /> : <Archive className="size-4" />}
          Save Rules
        </button>
      </div>

      {notice && (
        <p role="status" className={`rounded-xl border px-4 py-3 text-sm ${notice.ok ? "border-[#00c950]/30 bg-[#00c950]/10 text-[#05df72]" : "border-red-400/30 bg-red-500/10 text-red-300"}`}>
          {notice.text}
        </p>
      )}

      {error ? (
        <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
          Couldn&apos;t load retention rules. {error.message}
        </p>
      ) : (
        <>
          <section className="rounded-[18px] border border-white/20 bg-[#0c0e1a] p-[17px]">
            <p className="flex items-center gap-2 text-sm leading-5 font-medium text-[#e5e7eb]">
              <Shield className="size-4 text-white" />
              Active Compliance Standards
            </p>
            <div className="flex flex-wrap gap-2 pt-2">
              {(data?.standards ?? []).map((s) => (
                <span
                  key={s.name}
                  className={`rounded-full border px-3 py-1 text-xs leading-4 font-medium ${s.active ? "border-white/40 bg-white/10 text-white" : "border-[#01303f] text-[#9ca3af]"}`}
                >
                  {s.name} {s.active ? "✓" : "—"}
                </span>
              ))}
            </div>
            <p className="pt-2 text-xs leading-4 text-[#9ca3af]">
              Retention periods must comply with active standards. Policies marked as compliance mode cannot be shortened below minimum requirements.
            </p>
          </section>

          <div className="flex flex-col gap-4">
            {loading && policies.length === 0
              ? [0, 1, 2, 3].map((i) => <div key={i} className="h-[128px] animate-pulse rounded-2xl border border-white/10 bg-[#0c0e1a]" />)
              : policies.map((p) => (
                  <PolicyCard
                    key={p.id}
                    policy={p}
                    open={expanded === p.id}
                    onToggleOpen={() => setExpanded((e) => (e === p.id ? null : p.id))}
                    onEdit={(patch) => edit(p.id, patch)}
                  />
                ))}
          </div>

          <section className="flex flex-col gap-4 rounded-2xl border border-white/10 bg-[#0c0e1a] p-5 sm:p-[25px]">
            <h2 className="flex items-center gap-3 text-base leading-6 font-semibold text-[#e5e7eb]">
              <Shield className="size-5 text-[#34206c]" />
              Global Archive Settings
            </h2>
            <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
              {(data?.archive ?? []).map((a) => (
                <div key={a.label} className="rounded-[18px] bg-white/10 p-4">
                  <p className="text-sm leading-5 font-medium text-[#e5e7eb]">{a.label}</p>
                  <p className="py-1 text-xs leading-4 text-[#9ca3af]">{a.description}</p>
                  <p className={`pt-1 text-xs leading-4 ${a.active ? "text-[#05df72]" : "text-[#9ca3af]"}`}>● {a.status}</p>
                </div>
              ))}
            </div>
          </section>
        </>
      )}
    </div>
  );
}

function PolicyCard({ policy: p, open, onToggleOpen, onEdit }: { policy: RetentionPolicy; open: boolean; onToggleOpen: () => void; onEdit: (patch: Partial<Editable>) => void }) {
  const tooShort = p.complianceMode && p.retentionDays < p.minRetentionDays;

  return (
    <article className={`rounded-2xl border bg-[#0c0e1a] p-5 sm:p-[25px] ${p.complianceMode ? "border-[#34206c]/30" : "border-white/10"}`}>
      <div className="flex items-start justify-between gap-4">
        <div className="flex min-w-0 items-center gap-3">
          <span className="flex size-10 shrink-0 items-center justify-center rounded-[18px] bg-[#34206c]/10 text-[#34206c]">
            <Database className="size-5" />
          </span>
          <div className="min-w-0">
            <div className="flex flex-wrap items-center gap-2">
              <h2 className="text-base leading-6 font-semibold text-[#e5e7eb]">{p.name}</h2>
              {p.complianceMode && <span className="rounded-full border border-[#34206c]/30 bg-[#34206c]/20 px-2 py-0.5 text-xs leading-4 text-[#34206c]">Compliance</span>}
            </div>
            <p className="pt-0.5 text-xs leading-4 text-[#9ca3af]">{p.description}</p>
          </div>
        </div>
        <button
          type="button"
          onClick={onToggleOpen}
          aria-expanded={open}
          className="shrink-0 cursor-pointer rounded-[14px] bg-white/10 px-3 py-1.5 text-xs leading-4 font-medium text-[#e5e7eb] transition hover:bg-white/15"
        >
          {open ? "Collapse" : "Edit"}
        </button>
      </div>

      <div className="flex flex-wrap items-center gap-x-6 gap-y-2 pt-4 text-xs leading-4">
        <Meta icon={<Clock className="size-3.5" />} label="Retention:">
          <span className="font-medium text-[#e5e7eb]">{formatRetention(p.retentionDays)}</span>
        </Meta>
        <Meta icon={<Trash2 className="size-3.5" />} label="Auto-delete:">
          <span className={p.autoDelete ? "font-medium text-[#05df72]" : "text-[#9ca3af]"}>{p.autoDelete ? "Enabled" : "Disabled"}</span>
        </Meta>
        <Meta icon={<Archive className="size-3.5" />} label="Archive first:">
          <span className={p.archiveFirst ? "font-medium text-[#05df72]" : "text-[#9ca3af]"}>{p.archiveFirst ? "Yes" : "No"}</span>
        </Meta>
        <span className="flex flex-wrap items-center gap-1.5">
          <span className="text-[#9ca3af]">Applies to:</span>
          {p.appliesTo.map((a) => (
            <span key={a} className="rounded-full bg-white/10 px-2 py-0.5 text-[#e5e7eb]">
              {a}
            </span>
          ))}
        </span>
      </div>

      {open && (
        <div className="mt-4 grid grid-cols-1 gap-x-6 gap-y-4 border-t border-white/10 pt-4 md:grid-cols-2">
          <div className="flex flex-col gap-4">
            <label className="flex flex-col gap-1">
              <span className="text-sm leading-5 font-medium text-[#e5e7eb]">Retention Period (days)</span>
              <input
                type="number"
                min={1}
                inputMode="numeric"
                value={Number.isFinite(p.retentionDays) ? p.retentionDays : ""}
                onChange={(e) => onEdit({ retentionDays: e.target.valueAsNumber })}
                aria-invalid={tooShort}
                className={`h-[38px] w-full rounded-[14px] border bg-white/10 px-[13px] text-sm text-[#e5e7eb] outline-none focus:border-white/30 ${tooShort ? "border-red-400/60" : "border-white/10"}`}
              />
              {tooShort && <span className="text-xs text-red-300">Compliance mode requires at least {p.minRetentionDays} days.</span>}
            </label>
            <SwitchRow title="Auto-Delete After Retention" hint="Automatically delete records when retention period expires" checked={p.autoDelete} onChange={(v) => onEdit({ autoDelete: v })} />
          </div>
          <div className="flex flex-col gap-4">
            <SwitchRow title="Archive Before Delete" hint="Move to cold storage archive before permanent deletion" checked={p.archiveFirst} onChange={(v) => onEdit({ archiveFirst: v })} />
            <SwitchRow title="Compliance Mode" hint="Lock settings to meet regulatory requirements" checked={p.complianceMode} onChange={(v) => onEdit({ complianceMode: v })} />
          </div>
        </div>
      )}
    </article>
  );
}

function Meta({ icon, label, children }: { icon: ReactNode; label: string; children: ReactNode }) {
  return (
    <span className="flex items-center gap-1.5 text-[#9ca3af]">
      {icon}
      {label}
      {children}
    </span>
  );
}

function SwitchRow({ title, hint, checked, onChange }: { title: string; hint: string; checked: boolean; onChange: (v: boolean) => void }) {
  return (
    <div className="flex items-start justify-between gap-4">
      <div className="min-w-0">
        <p className="text-sm leading-5 font-medium text-[#e5e7eb]">{title}</p>
        <p className="pt-0.5 text-xs leading-4 text-[#9ca3af]">{hint}</p>
      </div>
      <span className="pt-0.5">
        <Toggle checked={checked} onChange={onChange} label={title} />
      </span>
    </div>
  );
}
