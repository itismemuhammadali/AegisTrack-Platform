"use client";

import { useEffect, useState } from "react";
import { Briefcase, ChevronDown, Plus, Search } from "lucide-react";
import { Can } from "@/components/providers/Can";
import { StatTile } from "@/components/ui/StatTile";
import { useAsync } from "@/hooks/useAsync";
import { useDebouncedValue } from "@/hooks/useDebouncedValue";
import { caseService } from "@/services/caseService";
import { CASE_STATUS_LABELS, type CaseRecord, type CaseStatusFilter, type CreateCaseInput } from "@/types/case";
import { CaseTable } from "./CaseTable";
import { CreateCaseModal } from "./CreateCaseModal";
import { OpenCaseModal } from "./OpenCaseModal";

/** Same content for Admin (607:6905) and Super Admin (610:18804); only the sidebar differs. */
export function CaseManagementView() {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<CaseStatusFilter>("all");
  const debouncedSearch = useDebouncedValue(search, 250);
  const [version, setVersion] = useState(0);

  const { data, loading, error } = useAsync(() => caseService.list({ search: debouncedSearch, status }), [debouncedSearch, status, version]);
  const stats = useAsync(() => caseService.stats(), [version]);

  const [rows, setRows] = useState<CaseRecord[]>([]);
  useEffect(() => {
    if (data) setRows(data); // eslint-disable-line react-hooks/set-state-in-effect -- mirrors latest fetched rows
  }, [data]);

  const [opened, setOpened] = useState<CaseRecord | null>(null);
  const [creating, setCreating] = useState(false);
  const [notice, setNotice] = useState<string | null>(null);

  async function handleCreate(input: CreateCaseInput) {
    const record = await caseService.create(input);
    setCreating(false);
    setNotice(`${record.number} was created.`);
    setVersion((v) => v + 1);
  }

  const s = stats.data;
  const dash = "–";

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div className="flex flex-wrap items-start justify-between gap-4">
        <div>
          <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Case Management</h1>
          <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Manage active cases, legal proceedings, and evidence records</p>
        </div>
        <Can permission="cases.create">
          <button
            type="button"
            onClick={() => setCreating(true)}
            className="flex cursor-pointer items-center justify-center gap-2 rounded-[18px] bg-[#34206c] px-4 py-2.5 text-base leading-6 font-medium whitespace-nowrap text-white shadow-[0_10px_15px_rgba(52,32,108,0.2),0_4px_6px_rgba(52,32,108,0.2)] transition hover:bg-[#3f2785]"
          >
            <Plus className="size-4" />
            Create Case
          </button>
        </Can>
      </div>

      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4 xl:pr-7">
        <StatTile icon={Briefcase} value={s?.open ?? dash} label="Open Cases" tone="green" />
        <StatTile icon={Briefcase} value={s?.legalHolds ?? dash} label="Legal Holds Active" tone="red" />
        <StatTile icon={Briefcase} value={s?.pendingReview ?? dash} label="Pending Review" tone="yellow" />
        <StatTile icon={Briefcase} value={s?.total ?? dash} label="Total Cases" tone="purple" />
      </div>

      <section className="flex flex-col gap-6 rounded-[18px] border border-white/10 bg-black p-4 sm:p-6">
        <div className="flex flex-col gap-3 sm:flex-row sm:gap-6">
          <label className="flex min-w-0 flex-1 items-center gap-4 rounded-[18px] border border-white/10 p-4 transition-colors focus-within:border-white/30">
            <Search className="size-5 shrink-0 text-white" strokeWidth={1.75} />
            <input
              type="search"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search cases by name or number..."
              aria-label="Search cases by name or number"
              className="w-full min-w-0 bg-transparent text-base text-white outline-none placeholder:text-white"
            />
          </label>
          <div className="relative sm:w-[210px]">
            <select
              value={status}
              onChange={(e) => setStatus(e.target.value as CaseStatusFilter)}
              aria-label="Filter by status"
              className="h-full min-h-[52px] w-full cursor-pointer appearance-none rounded-[18px] border border-white/10 bg-black px-6 text-base text-white outline-none transition-colors focus:border-white/30"
            >
              <option value="all">All Status</option>
              {Object.entries(CASE_STATUS_LABELS).map(([value, label]) => (
                <option key={value} value={value}>
                  {label}
                </option>
              ))}
            </select>
            <ChevronDown className="pointer-events-none absolute top-1/2 right-4 size-6 -translate-y-1/2 text-white" strokeWidth={1.5} />
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
            Couldn&apos;t load cases. {error.message}
          </p>
        ) : (
          <CaseTable cases={rows} loading={loading && rows.length === 0} onOpen={setOpened} />
        )}
      </section>

      {opened && <OpenCaseModal record={opened} onClose={() => setOpened(null)} />}
      {creating && <CreateCaseModal onClose={() => setCreating(false)} onCreate={handleCreate} />}
    </div>
  );
}
