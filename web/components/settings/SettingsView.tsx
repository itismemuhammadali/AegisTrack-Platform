"use client";

import { useEffect, useState } from "react";
import { Bell, Database, Lock, Mail, Shield } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { useAsync } from "@/hooks/useAsync";
import { settingsService } from "@/services/settingsService";
import { EXPORT_FORMAT_LABELS, RETENTION_LABELS, type SystemSettings } from "@/types/settings";
import { ResetPasswordModal } from "@/components/users/ResetPasswordModal";
import { authService } from "@/services/authService";
import { SelectRow, SettingsCard, ToggleRow } from "./SettingsPrimitives";

/** Admin (610:14832) and Super Admin (610:26535): identical content; Super Admin cards are bordered navy. */
export function SettingsView() {
  const { user } = useAuth();
  const variant = user.role === "SUPER_ADMIN" ? "navy" : "black";
  const loaded = useAsync(() => settingsService.get(), []);
  const info = useAsync(() => settingsService.systemInfo(), []);
  const [settings, setSettings] = useState<SystemSettings | null>(null);
  const [saveError, setSaveError] = useState<string | null>(null);
  const [pwOpen, setPwOpen] = useState(false);
  const [pwNotice, setPwNotice] = useState(false);

  useEffect(() => {
    if (loaded.data) setSettings(loaded.data); // eslint-disable-line react-hooks/set-state-in-effect -- seed editable copy
  }, [loaded.data]);

  /** Optimistic update; rolls back that section if the save fails. */
  function set<K extends keyof SystemSettings>(section: K, patch: Partial<SystemSettings[K]>) {
    if (!settings) return;
    const prev = settings[section];
    setSettings({ ...settings, [section]: { ...prev, ...patch } });
    setSaveError(null);
    settingsService.update(section, patch).catch((e: unknown) => {
      setSettings((s) => (s ? { ...s, [section]: prev } : s));
      setSaveError(e instanceof Error ? e.message : "Couldn't save setting");
    });
  }

  const infoItems: [string, string | number | undefined][] = [
    ["Platform Version", info.data?.platformVersion],
    ["Database Status", info.data?.databaseStatus],
    ["Last Backup", info.data?.lastBackup],
    ["Total Storage Used", info.data?.storageUsed],
    ["Active Sessions", info.data?.activeSessions],
    ["System Uptime", info.data?.uptime],
  ];

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div>
        <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Settings</h1>
        <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Manage system configuration and preferences</p>
      </div>

      {(loaded.error || saveError) && (
        <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
          {loaded.error ? `Couldn't load settings. ${loaded.error.message}` : saveError}
        </p>
      )}

      {pwNotice && (
        <p role="status" className="flex items-center justify-between gap-4 rounded-xl border border-[#00c950]/30 bg-[#00c950]/10 px-4 py-3 text-sm text-[#05df72]">
          Your password was reset. You&apos;ll be asked to change it on your next login.
          <button type="button" onClick={() => setPwNotice(false)} className="cursor-pointer text-xs font-medium underline">
            Dismiss
          </button>
        </p>
      )}

      {!settings ? (
        <p className="py-10 text-center text-sm text-[#9ca3af]">Loading settings…</p>
      ) : (
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-2 lg:pr-2.5">
          <SettingsCard variant={variant} icon={Shield} tone="neutral" title="Security Settings" subtitle="Authentication and access control">
            <ToggleRow label="Two-Factor Authentication" hint="Require 2FA for all admin logins" checked={settings.security.twoFactor} onChange={(v) => set("security", { twoFactor: v })} />
            <ToggleRow label="Session Timeout" hint="Auto-logout after 30 minutes of inactivity" checked={settings.security.sessionTimeout} onChange={(v) => set("security", { sessionTimeout: v })} />
            <ToggleRow label="IP Whitelist" hint="Restrict access to approved IP addresses" checked={settings.security.ipWhitelist} onChange={(v) => set("security", { ipWhitelist: v })} />
            <div className="mt-auto border-t border-white/10 pt-4">
              <button
                type="button"
                onClick={() => setPwOpen(true)}
                className="h-[52px] w-full cursor-pointer rounded-[18px] bg-[linear-gradient(90deg,#2f1d63_0%,#4a2d8f_100%)] text-base font-medium text-white transition hover:brightness-125"
              >
                Change Password
              </button>
            </div>
          </SettingsCard>

          <SettingsCard variant={variant} icon={Bell} tone="blue" title="Notification Preferences" subtitle="Configure system alerts">
            <ToggleRow label="Failed Sync Alerts" hint="Notify when location sync fails" checked={settings.notifications.failedSync} onChange={(v) => set("notifications", { failedSync: v })} />
            <ToggleRow label="New User Notifications" hint="Alert when new users are created" checked={settings.notifications.newUser} onChange={(v) => set("notifications", { newUser: v })} />
            <ToggleRow label="Security Alerts" hint="High-priority security warnings" checked={settings.notifications.securityAlerts} onChange={(v) => set("notifications", { securityAlerts: v })} />
            <ToggleRow label="Export Completion" hint="Notify when exports are ready" checked={settings.notifications.exportCompletion} onChange={(v) => set("notifications", { exportCompletion: v })} />
          </SettingsCard>

          <SettingsCard variant={variant} icon={Database} tone="purple" title="Data Retention" subtitle="Configure data storage policies">
            <SelectRow label="Log Retention Period" value={settings.retention.logRetentionDays} options={RETENTION_LABELS} onChange={(v) => set("retention", { logRetentionDays: v })} />
            <SelectRow label="Auto-Delete Exports After" value={settings.retention.autoDeleteExportsDays} options={RETENTION_LABELS} onChange={(v) => set("retention", { autoDeleteExportsDays: v })} />
            <ToggleRow label="Automatic Backup" hint="Daily backup of all tracking data" checked={settings.retention.automaticBackup} onChange={(v) => set("retention", { automaticBackup: v })} />
          </SettingsCard>

          <SettingsCard variant={variant} icon={Lock} tone="green" spread title="Export Settings" subtitle="Configure export permissions and formats">
            <ToggleRow label="Encrypted PDF Exports" hint="Apply password protection to PDFs" checked={settings.exports.encryptedPdf} onChange={(v) => set("exports", { encryptedPdf: v })} />
            <ToggleRow label="Watermark Exports" hint="Add security watermark to exports" checked={settings.exports.watermark} onChange={(v) => set("exports", { watermark: v })} />
            <SelectRow label="Default Export Format" value={settings.exports.defaultFormat} options={EXPORT_FORMAT_LABELS} onChange={(v) => set("exports", { defaultFormat: v })} />
          </SettingsCard>

          <SettingsCard variant={variant} icon={Mail} tone="red" title="System Information" subtitle="Platform details and status" className="lg:col-span-2 lg:-mr-2.5">
            <dl className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
              {infoItems.map(([label, value]) => (
                <div key={label} className="rounded-[14px] border border-white/10 px-4 py-3.5">
                  <dt className="text-xs leading-4 text-[#9ca3af]">{label}</dt>
                  <dd className="pt-1.5 text-sm leading-5 font-medium text-white">{value ?? "–"}</dd>
                </div>
              ))}
            </dl>
          </SettingsCard>
        </div>
      )}

      {pwOpen && (
        <ResetPasswordModal
          name={user.name}
          onClose={() => setPwOpen(false)}
          onReset={async (password) => {
            await authService.resetOwnPassword(user.email, password);
            setPwOpen(false);
            setPwNotice(true);
          }}
        />
      )}
    </div>
  );
}
