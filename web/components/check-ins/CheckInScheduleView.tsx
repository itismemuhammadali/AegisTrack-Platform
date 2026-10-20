"use client";

import { useEffect, useState } from "react";
import { CircleCheck, CircleX, Clock, Plus, Search, TriangleAlert } from "lucide-react";
import { useAuth } from "@/components/providers/AuthProvider";
import { FilterSelect } from "@/components/ui/FilterSelect";
import { StatTile } from "@/components/ui/StatTile";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { checkInService } from "@/services/checkInService";
import { CHECKIN_STATUS_LABELS, type CheckInSchedule, type CheckInScheduleInput, type CheckInStatus } from "@/types/checkIn";
import { CheckInDetailsModal } from "./CheckInDetailsModal";
import { CheckInFormModal } from "./CheckInFormModal";
import { CheckInTable, type CheckInRowAction } from "./CheckInTable";
import { DeleteCheckInModal } from "./DeleteCheckInModal";

/** Admin (608:9214) and Super Admin (610:19594): same content; Super Admin shows user photos. */
export function CheckInScheduleView() {
  const { user } = useAuth();
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<CheckInStatus | "all">("all");
  const debouncedSearch = useDebouncedValue(search, 250);
  const [version, setVersion] = useState(0);

  const { data, loading, error } = useAsync(() => checkInService.list({ search: debouncedSearch, status }), [debouncedSearch, status, version]);
  const stats = useAsync(() => checkInService.stats(), [version]);

  const [rows, setRows] = useState<CheckInSchedule[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const [viewing, setViewing] = useState<CheckInSchedule | null>(null);
  // `null` = closed, `"new"` = Create Schedule, a schedule = Edit Schedule.
  const [form, setForm] = useState<CheckInSchedule | "new" | null>(null);
  const [deleting, setDeleting] = useState<CheckInSchedule | null>(null);
  const [notice, setNotice] = useState<{ text: string; error?: boolean } | null>(null);

  function done(text: string) {
    setNotice({ text });
    setVersion((v) => v + 1);
  }

  async function handleAction(action: CheckInRowAction, s: CheckInSchedule) {
    if (action === "view") setViewing(s);
    else if (action === "edit") setForm(s);
    else if (action === "delete") setDeleting(s);
    else {
      try {
        await checkInService.sendReminder(s.id);
        setNotice({ text: `Reminder sent to ${s.user.name}.` });
      } catch (err) {
        setNotice({ text: `Couldn't send reminder. ${err instanceof Error ? err.message : ""}`, error: true });
      }
    }
  }

  async function handleSave(input: CheckInScheduleInput) {
    const saved = form === "new" || !form ? await checkInService.create(input) : await checkInService.update(form.id, input);
    setForm(null);
    done(`${saved.name} was ${form === "new" ? "created" : "updated"}.`);
  }

  async function handleDelete() {
    if (!deleting) return;
    await checkInService.remove(deleting.id);
    setDeleting(null);
    done(`${deleting.name} was deleted.`);
  }

  const st = stats.data;
  const dash = "–";

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Scheduled Check-ins</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Manage check-in schedules, reminders, and compliance tracking</p>
        </div>
        <button
          type="button"
          onClick={() => setForm("new")}
          className="flex cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#34206c] px-4 py-2.5 text-base leading-6 font-medium whitespace-nowrap text-white shadow-[0_10px_15px_rgba(52,32,108,0.2),0_4px_6px_rgba(52,32,108,0.2)] transition hover:bg-[#3f2785]"
        >
          <Plus className="size-4" />
          Create Schedule
        </button>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4 xl:pr-7">
        <StatTile icon={CircleCheck} tone="green" value={st?.activeSchedules ?? dash} label="Active Schedules" />
        <StatTile icon={CircleX} tone="red" value={st?.missedCheckIns ?? dash} label="Missed Check-ins" />
        <StatTile icon={Clock} tone="blue" value={st?.dueToday ?? dash} label="Due Today" />
        <StatTile icon={TriangleAlert} tone="yellow" value={st?.paused ?? dash} label="Paused" />
      </div>

      <section className="flex flex-col gap-6 rounded-[18px] border border-white/10 bg-black p-4 sm:p-6">
        <div className="flex flex-col gap-3 sm:flex-row sm:gap-6">
          <label className="flex min-w-0 flex-1 items-center gap-4 rounded-[18px] border border-white/10 p-4 transition-colors focus-within:border-white/30">
            <Search className="size-5 shrink-0 text-white" strokeWidth={1.75} />
            <input
              type="search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search by user or schedule name..."
              aria-label="Search by user or schedule name"
              className="w-full min-w-0 bg-transparent text-base text-white outline-none placeholder:text-white"
            />
          </label>
          <FilterSelect label="Filter by status" allLabel="All Status" value={status} onChange={setStatus} options={CHECKIN_STATUS_LABELS} />
        </div>

        {notice && (
          <p
            role="status"
            className={`flex items-center justify-between gap-4 rounded-xl border px-4 py-3 text-sm ${notice.error ? "border-red-400/30 bg-red-500/10 text-red-300" : "border-[#00c950]/30 bg-[#00c950]/10 text-[#05df72]"}`}
          >
            {notice.text}
            <button type="button" onClick={() => setNotice(null)} className="cursor-pointer text-xs font-medium underline">
              Dismiss
            </button>
          </p>
        )}

        {error ? (
          <p role="alert" className="rounded-xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
            Couldn&apos;t load schedules. {error.message}
          </p>
        ) : (
          <CheckInTable schedules={rows} loading={loading && rows.length === 0} showPhotos={user.role === "SUPER_ADMIN"} onAction={handleAction} />
        )}
      </section>

      {viewing && (
        <CheckInDetailsModal
          schedule={viewing}
          onClose={() => setViewing(null)}
          onEdit={() => {
            setForm(viewing);
            setViewing(null);
          }}
        />
      )}
      {form && <CheckInFormModal key={form === "new" ? "new" : form.id} schedule={form === "new" ? undefined : form} onClose={() => setForm(null)} onSave={handleSave} />}
      {deleting && <DeleteCheckInModal schedule={deleting} onClose={() => setDeleting(null)} onDelete={handleDelete} />}
    </div>
  );
}
