"use client";

import { useEffect, useState } from "react";
import { Clock, FileText, Mail, Sheet, Shield, TriangleAlert, UserCheck, type LucideIcon } from "lucide-react";
import { Toggle } from "@/components/ui/Toggle";
import { useAsync } from "@/hooks/useAsync";
import { exportSettingsService } from "@/services/exportSettingsService";
import {
  EXPORT_CHANNEL_META,
  EXPORT_ROLE_LABELS,
  EXPORT_STATUS_LABELS,
  type ExportActivityStatus,
  type ExportChannel,
  type ExportChannelSettings,
  type ExportRole,
} from "@/types/exportSettings";

const CHANNEL_ICON: Record<ExportChannel, { icon: LucideIcon; tone: string }> = {
  pdf: { icon: FileText, tone: "bg-[#ff6467]/10 text-[#ff6467]" },
  spreadsheet: { icon: Sheet, tone: "bg-[#05df72]/10 text-[#05df72]" },
  email: { icon: Mail, tone: "bg-[#51a2ff]/10 text-[#51a2ff]" },
};

const STATUS_STYLE: Record<ExportActivityStatus, string> = {
  success: "bg-[#00c950]/20 text-[#05df72]",
  blocked: "bg-[#fb2c36]/20 text-[#ff6467]",
  pending_approval: "bg-[#f0b100]/20 text-[#fdc700]",
};

/** Super Admin only (Figma 610:20029). */
export function ExportSettingsView() {
  const overview = useAsync(() => exportSettingsService.get(), []);
  const activity = useAsync(() => exportSettingsService.activity(), []);
  const [channels, setChannels] = useState<ExportChannelSettings[]>([]);
  const [saveError, setSaveError] = useState<string | null>(null);

  useEffect(() => {
    if (overview.data) setChannels(overview.data.channels); // eslint-disable-line react-hooks/set-state-in-effect -- seeds editable copy
  }, [overview.data]);

  /** Optimistic per-channel save; rolls back on failure. */
  async function update(channel: ExportChannel, patch: Partial<Omit<ExportChannelSettings, "channel">>) {
    const prev = channels;
    setChannels((cs) => cs.map((c) => (c.channel === channel ? { ...c, ...patch } : c)));
    setSaveError(null);
    try {
      await exportSettingsService.update(channel, patch);
    } catch (err) {
      setChannels(prev);
      setSaveError(err instanceof Error ? err.message : "Couldn't save export settings");
    }
  }

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Export Settings</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Manage data export permissions and audit controls</p>
        </div>
        <span className="flex items-center gap-2 rounded-[18px] border border-white/20 bg-white/10 p-[13px] text-sm leading-5 font-medium text-white">
          <UserCheck className="size-4" />
          {overview.data ? `${overview.data.activeAssignments} active assignments` : "–"}
        </span>
      </div>

      <div className="flex items-start gap-2.5 rounded-[18px] border border-[#2b7fff]/20 bg-[#2b7fff]/10 p-[17px]">
        <Shield className="mt-0.5 size-5 shrink-0 text-[#8ec5ff]" />
        <div>
          <p className="text-sm leading-5 font-medium text-[#8ec5ff]">Export Audit Logging</p>
          <p className="pt-1 text-xs leading-4 text-[#9ca3af]">
            All export activities are tracked in the audit log regardless of settings below. Admin can review export history at any time.
          </p>
        </div>
      </div>

      {saveError && (
        <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
          {saveError}
        </p>
      )}

      {overview.error ? (
        <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
          Couldn&apos;t load export settings. {overview.error.message}
        </p>
      ) : (
        <div className="flex flex-col gap-4">
          {channels.length === 0
            ? [0, 1, 2].map((i) => <div key={i} className="h-[200px] animate-pulse rounded-2xl border border-white/10 bg-[#0c0e1a]" />)
            : channels.map((c) => <ChannelCard key={c.channel} settings={c} onChange={(patch) => update(c.channel, patch)} />)}
        </div>
      )}

      <section className="rounded-2xl border border-white/10 bg-[#0c0e1a] p-5 sm:p-[25px]">
        <div className="flex items-center justify-between gap-4">
          <div>
            <h2 className="text-base leading-6 font-semibold text-[#e5e7eb]">Export Activity</h2>
            <p className="text-xs leading-4 text-[#9ca3af]">Recent export events and their statuses</p>
          </div>
          <Clock className="size-5 shrink-0 text-[#9ca3af]" />
        </div>

        {activity.error ? (
          <p role="alert" className="mt-4 text-sm text-red-300">
            Couldn&apos;t load export activity. {activity.error.message}
          </p>
        ) : (
          <div className="mt-4 overflow-x-auto">
            <table className="w-full min-w-[640px] text-left">
              <thead>
                <tr className="border-b border-white/10 text-xs leading-4 font-medium text-[#9ca3af]">
                  <th className="w-[22%] pb-3 font-medium">Type</th>
                  <th className="w-[31.5%] pb-3 font-medium">User</th>
                  <th className="w-[10%] pb-3 font-medium">Records</th>
                  <th className="w-[13.5%] pb-3 font-medium">Time</th>
                  <th className="pb-3 font-medium">Status</th>
                </tr>
              </thead>
              <tbody>
                {(activity.data ?? []).map((a) => {
                  const { icon: Icon, tone } = CHANNEL_ICON[a.channel];
                  return (
                    <tr key={a.id} className="border-b border-white/10 last:border-0">
                      <td className="py-3 pr-4">
                        <span className="flex items-center gap-2 text-sm leading-5 text-[#e5e7eb]">
                          <span className={`flex size-7 items-center justify-center rounded-[14px] ${tone}`}>
                            <Icon className="size-3.5" />
                          </span>
                          {EXPORT_CHANNEL_META[a.channel].short}
                        </span>
                      </td>
                      <td className="py-3 pr-4 text-xs leading-4 text-[#9ca3af]">{a.user}</td>
                      <td className="py-3 pr-4 text-sm leading-5 text-[#e5e7eb]">{a.records === null ? "—" : a.records.toLocaleString("en-US")}</td>
                      <td className="py-3 pr-4 text-xs leading-4 text-[#9ca3af]">{a.time}</td>
                      <td className="py-3">
                        <span className={`inline-block rounded-full px-2 py-1 text-xs leading-4 whitespace-nowrap ${STATUS_STYLE[a.status]}`}>{EXPORT_STATUS_LABELS[a.status]}</span>
                      </td>
                    </tr>
                  );
                })}
                {activity.loading && !activity.data && (
                  <tr>
                    <td colSpan={5} className="py-6 text-center text-sm text-[#9ca3af]">
                      Loading…
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </div>
  );
}

function ChannelCard({ settings, onChange }: { settings: ExportChannelSettings; onChange: (patch: Partial<Omit<ExportChannelSettings, "channel">>) => void }) {
  const meta = EXPORT_CHANNEL_META[settings.channel];
  const { icon: Icon, tone } = CHANNEL_ICON[settings.channel];
  const [maxRecords, setMaxRecords] = useState(String(settings.maxRecords));

  function commitMax() {
    const n = Number.parseInt(maxRecords, 10);
    if (!Number.isFinite(n) || n < 1) return setMaxRecords(String(settings.maxRecords));
    if (n !== settings.maxRecords) onChange({ maxRecords: n });
  }

  function toggleRole(role: ExportRole) {
    const has = settings.allowedRoles.includes(role);
    onChange({ allowedRoles: has ? settings.allowedRoles.filter((r) => r !== role) : [...settings.allowedRoles, role] });
  }

  return (
    <article className="flex flex-col gap-4 rounded-2xl border border-white/20 bg-[#0c0e1a] p-5 sm:p-[25px]">
      <div className="flex items-start justify-between gap-4">
        <div className="flex min-w-0 items-center gap-3">
          <span className={`flex size-10 shrink-0 items-center justify-center rounded-[18px] ${tone}`}>
            <Icon className="size-5" />
          </span>
          <div className="min-w-0">
            <h2 className="text-base leading-6 font-semibold text-[#e5e7eb]">{meta.title}</h2>
            <p className="text-xs leading-4 text-[#9ca3af]">{meta.description}</p>
          </div>
        </div>
        <div className="flex shrink-0 items-center gap-2">
          <span className={`text-xs leading-4 font-medium ${settings.enabled ? "text-[#05df72]" : "text-[#ff6467]"}`}>{settings.enabled ? "Allowed" : "Restricted"}</span>
          <Toggle tone="green" checked={settings.enabled} onChange={(v) => onChange({ enabled: v })} label={`Allow ${meta.title}`} />
        </div>
      </div>

      {settings.enabled ? (
        <div className="grid grid-cols-1 gap-4 border-t border-white/10 pt-2 md:grid-cols-3">
          <SwitchField title="Require Approval" hint="Exports need admin approval before processing" checked={settings.requireApproval} onChange={(v) => onChange({ requireApproval: v })} />
          <SwitchField title="Audit All Exports" hint="Log every export attempt to audit trail" checked={settings.auditAll} onChange={(v) => onChange({ auditAll: v })} />
          <label className="flex flex-col">
            <span className="text-sm leading-5 font-medium text-[#e5e7eb]">Max Records per Export</span>
            <span className="pt-1 pb-2 text-xs leading-4 text-[#9ca3af]">Limit data volume per export</span>
            <input
              type="number"
              min={1}
              inputMode="numeric"
              value={maxRecords}
              onChange={(e) => setMaxRecords(e.target.value)}
              onBlur={commitMax}
              onKeyDown={(e) => e.key === "Enter" && e.currentTarget.blur()}
              className="h-[38px] w-full rounded-[14px] border border-white/10 bg-white/10 px-[13px] text-sm text-[#e5e7eb] outline-none focus:border-white/30"
            />
          </label>
        </div>
      ) : (
        <p className="flex items-center gap-2 rounded-[18px] border border-[#fb2c36]/20 bg-[#fb2c36]/10 p-[13px] text-xs leading-4 text-[#ffa2a2]">
          <TriangleAlert className="size-4 shrink-0 text-[#ff6467]" />
          {meta.short} Export is currently restricted. No users can perform this export type.
        </p>
      )}

      <div className="flex flex-wrap items-center gap-2 border-t border-white/10 pt-[9px]">
        <span className="text-xs leading-4 text-[#9ca3af]">Allowed roles:</span>
        {(Object.keys(EXPORT_ROLE_LABELS) as ExportRole[]).map((role) => {
          const on = settings.allowedRoles.includes(role);
          return (
            <button
              key={role}
              type="button"
              aria-pressed={on}
              onClick={() => toggleRole(role)}
              className={`cursor-pointer rounded-full border px-3 py-1 text-xs leading-4 font-medium transition ${
                on ? "border-[#34206c]/40 bg-[#34206c]/20 text-[#34206c]" : "border-white/10 text-[#9ca3af] hover:text-white"
              }`}
            >
              {EXPORT_ROLE_LABELS[role]}
            </button>
          );
        })}
      </div>
    </article>
  );
}

function SwitchField({ title, hint, checked, onChange }: { title: string; hint: string; checked: boolean; onChange: (v: boolean) => void }) {
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
