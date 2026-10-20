import { Clock } from "lucide-react";
import { AUDIT_SEVERITY_LABELS, AUDIT_TYPE_LABELS, type AuditEventType, type AuditLogEntry, type AuditSeverity } from "@/types/auditLog";
import { AUDIT_SEVERITY_STYLE, AUDIT_TYPE_STYLE } from "./auditStyles";

const HEADERS = ["Timestamp", "User", "Event", "Type", "Severity", "Device / IP"];

export function AuditTypeTag({ type }: { type: AuditEventType }) {
  const { Icon, tag } = AUDIT_TYPE_STYLE[type];
  return (
    <span className={`inline-flex items-center gap-1 rounded-md border px-2 py-0.5 text-xs leading-4 whitespace-nowrap ${tag}`}>
      <Icon className="size-3" />
      {AUDIT_TYPE_LABELS[type]}
    </span>
  );
}

function SeverityTag({ severity }: { severity: AuditSeverity }) {
  return <span className={`inline-flex rounded px-2 py-0.5 text-xs leading-4 ${AUDIT_SEVERITY_STYLE[severity]}`}>{AUDIT_SEVERITY_LABELS[severity]}</span>;
}

function Timestamp({ value }: { value: string }) {
  return (
    <span className="inline-flex items-center gap-1.5 font-mono text-[11px] leading-4 whitespace-nowrap text-[#9ca3af]">
      <Clock className="size-3" />
      {value}
    </span>
  );
}

function UserCell({ entry }: { entry: AuditLogEntry }) {
  return (
    <div>
      <p className="text-sm leading-5 text-white">{entry.user.name}</p>
      <p className="text-xs leading-4 text-[#9ca3af]">{entry.user.role}</p>
    </div>
  );
}

function DeviceCell({ entry }: { entry: AuditLogEntry }) {
  return (
    <div>
      <p className="text-xs leading-4 text-white">{entry.device}</p>
      <p className="font-mono text-[11px] leading-4 text-[#9ca3af]">{entry.ip}</p>
    </div>
  );
}

export function AuditLogTable({ entries, loading }: { entries: AuditLogEntry[]; loading: boolean }) {
  if (loading) return <p className="py-8 text-center text-sm text-[#9ca3af]">Loading events…</p>;
  if (entries.length === 0) return <p className="py-8 text-center text-sm text-[#9ca3af]">No events match your filters.</p>;

  return (
    <>
      {/* lg+: table */}
      <div className="hidden lg:block">
        <table className="w-full table-fixed text-left">
          <colgroup>
            <col className="w-[18%]" />
            <col className="w-[14%]" />
            <col className="w-[24%]" />
            <col className="w-[14%]" />
            <col className="w-[10%]" />
            <col className="w-[20%]" />
          </colgroup>
          <thead>
            <tr className="border-b border-white/10">
              {HEADERS.map((h) => (
                <th key={h} className="px-4 py-3 text-xs leading-4 font-medium tracking-[0.6px] text-[#9ca3af] uppercase">
                  {h}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {entries.map((e) => (
              <tr key={e.id} className={`border-b border-white/10 last:border-0 ${e.severity === "critical" ? "bg-[#fb2c36]/10" : ""}`}>
                <td className="px-4 py-3">
                  <Timestamp value={e.timestamp} />
                </td>
                <td className="px-4 py-3">
                  <UserCell entry={e} />
                </td>
                <td className="px-4 py-3 text-sm leading-5 text-white">{e.event}</td>
                <td className="px-4 py-3">
                  <AuditTypeTag type={e.type} />
                </td>
                <td className="px-4 py-3">
                  <SeverityTag severity={e.severity} />
                </td>
                <td className="px-4 py-3">
                  <DeviceCell entry={e} />
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* < lg: cards */}
      <ul className="flex flex-col divide-y divide-white/10 lg:hidden">
        {entries.map((e) => (
          <li key={e.id} className={`flex flex-col gap-2 p-4 ${e.severity === "critical" ? "bg-[#fb2c36]/10" : ""}`}>
            <div className="flex flex-wrap items-center justify-between gap-2">
              <p className="text-sm leading-5 font-medium text-white">{e.event}</p>
              <div className="flex gap-1.5">
                <AuditTypeTag type={e.type} />
                <SeverityTag severity={e.severity} />
              </div>
            </div>
            <div className="flex flex-wrap items-end justify-between gap-2">
              <UserCell entry={e} />
              <DeviceCell entry={e} />
            </div>
            <Timestamp value={e.timestamp} />
          </li>
        ))}
      </ul>
    </>
  );
}
