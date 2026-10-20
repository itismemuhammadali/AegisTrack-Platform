"use client";

import { useEffect, useState } from "react";
import { Map, Plus, Search, TriangleAlert, Users } from "lucide-react";
import { FilterSelect } from "@/components/ui/FilterSelect";
import { StatTile } from "@/components/ui/StatTile";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { zoneService } from "@/services/zoneService";
import { ZONE_STATUS_LABELS, ZONE_TYPE_LABELS, type Zone, type ZoneInput, type ZoneStatus, type ZoneType } from "@/types/zone";
import { DeleteZoneModal } from "./DeleteZoneModal";
import { ZoneDetailsModal } from "./ZoneDetailsModal";
import { ZoneFormModal } from "./ZoneFormModal";
import type { ZoneRowAction } from "./ZoneRowActions";
import { ZoneTable } from "./ZoneTable";

/** Same content for Admin (608:8618) and Super Admin (610:19165); only the sidebar differs. */
export function ZoneManagementView() {
  const [search, setSearch] = useState("");
  const [type, setType] = useState<ZoneType | "all">("all");
  const [status, setStatus] = useState<ZoneStatus | "all">("all");
  const debouncedSearch = useDebouncedValue(search, 250);
  const [version, setVersion] = useState(0);

  const { data, loading, error } = useAsync(() => zoneService.list({ search: debouncedSearch, type, status }), [debouncedSearch, type, status, version]);
  const stats = useAsync(() => zoneService.stats(), [version]);

  const [rows, setRows] = useState<Zone[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const [viewing, setViewing] = useState<Zone | null>(null);
  // `null` = closed, `"new"` = Create Zone, a zone = Edit Zone.
  const [form, setForm] = useState<Zone | "new" | null>(null);
  const [deleting, setDeleting] = useState<Zone | null>(null);
  const [notice, setNotice] = useState<string | null>(null);

  function handleAction(action: ZoneRowAction, zone: Zone) {
    if (action === "view") setViewing(zone);
    else if (action === "edit") setForm(zone);
    else setDeleting(zone);
  }

  function done(message: string) {
    setNotice(message);
    setVersion((v) => v + 1);
  }

  async function handleSave(input: ZoneInput) {
    const saved = form === "new" || !form ? await zoneService.create(input) : await zoneService.update(form.id, input);
    setForm(null);
    done(`${saved.name} was ${form === "new" ? "created" : "updated"}.`);
  }

  async function handleDelete() {
    if (!deleting) return;
    await zoneService.remove(deleting.id);
    setDeleting(null);
    done(`${deleting.name} was deleted.`);
  }

  const s = stats.data;
  const dash = "–";

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Zones / Geofencing</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Manage geofence zones, restrictions, and check-in areas</p>
        </div>
        <button
          type="button"
          onClick={() => setForm("new")}
          className="flex cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#34206c] px-4 py-2.5 text-base leading-6 font-medium whitespace-nowrap text-white shadow-[0_10px_15px_rgba(52,32,108,0.2),0_4px_6px_rgba(52,32,108,0.2)] transition hover:bg-[#3f2785]"
        >
          <Plus className="size-4" />
          Create Zone
        </button>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
        <StatTile icon={Map} tone="purple" value={s?.totalZones ?? dash} label="Total Zones" />
        <StatTile icon={TriangleAlert} tone="red" value={s?.activeAlerts ?? dash} label="Active Alerts" />
        <StatTile icon={Users} tone="blue" value={s?.usersAssigned ?? dash} label="Users Assigned" />
      </div>

      <section className="flex flex-col gap-6 rounded-[18px] border border-white/10 bg-black p-4 sm:p-6">
        <div className="flex flex-col gap-3 md:flex-row md:gap-6">
          <label className="flex min-w-0 flex-1 items-center gap-4 rounded-[18px] border border-white/10 p-4 transition-colors focus-within:border-white/30">
            <Search className="size-5 shrink-0 text-white" strokeWidth={1.75} />
            <input
              type="search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search zones..."
              aria-label="Search zones"
              className="w-full min-w-0 bg-transparent text-base text-white outline-none placeholder:text-white"
            />
          </label>
          <div className="flex flex-col gap-3 sm:flex-row sm:gap-6">
            <FilterSelect label="Filter by type" allLabel="All Type" value={type} onChange={setType} options={ZONE_TYPE_LABELS} />
            <FilterSelect label="Filter by status" allLabel="All Status" value={status} onChange={setStatus} options={ZONE_STATUS_LABELS} />
          </div>
        </div>

        {notice && (
          <p role="status" className="flex items-center justify-between gap-4 rounded-xl border border-[#00c950]/30 bg-[#00c950]/10 px-4 py-3 text-sm text-[#05df72]">
            {notice}
            <button type="button" onClick={() => setNotice(null)} className="cursor-pointer text-xs font-medium underline">
              Dismiss
            </button>
          </p>
        )}

        {error ? (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            Couldn&apos;t load zones. {error.message}
          </p>
        ) : (
          <ZoneTable zones={rows} loading={loading && rows.length === 0} onAction={handleAction} />
        )}
      </section>

      {viewing && (
        <ZoneDetailsModal
          zone={viewing}
          onClose={() => setViewing(null)}
          onEdit={() => {
            setForm(viewing);
            setViewing(null);
          }}
        />
      )}
      {form && <ZoneFormModal key={form === "new" ? "new" : form.id} zone={form === "new" ? undefined : form} onClose={() => setForm(null)} onSave={handleSave} />}
      {deleting && <DeleteZoneModal zone={deleting} onClose={() => setDeleting(null)} onDelete={handleDelete} />}
    </div>
  );
}
