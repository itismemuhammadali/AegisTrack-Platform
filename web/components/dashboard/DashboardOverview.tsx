"use client";

import { useAsync } from "@/hooks/useAsync";
import { dashboardService } from "@/services/dashboardService";
import { ActivityFeed } from "./ActivityFeed";
import { Escalations, OpenCases } from "./CasesAndEscalations";
import { ExportActivityChart, TrackingActivityChart } from "./charts";
import { QuickActions } from "./QuickActions";
import { RecentAuditEvents } from "./RecentAuditEvents";
import { StatCard } from "./StatCard";
import { SystemHealth } from "./SystemHealth";

/** Shared by Admin and Super Admin — role differences live in the sidebar and permission-gated actions. */
export function DashboardOverview() {
  const { data, error, loading } = useAsync(() => dashboardService.getOverview());

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div>
        <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Dashboard Overview</h1>
        <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Monitor your tracking platform and user activity</p>
      </div>

      {error && (
        <p role="alert" className="rounded-2xl border border-red-400/30 bg-red-500/10 px-4 py-3 text-sm text-red-300">
          Couldn&apos;t load dashboard data. {error.message}
        </p>
      )}

      {loading || !data ? (
        !error && <DashboardSkeleton />
      ) : (
        <>
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4 xl:gap-6">
            {data.stats.map((m) => (
              <StatCard key={m.id} metric={m} />
            ))}
          </div>

          <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
            <TrackingActivityChart data={data.trackingActivity} />
            <ExportActivityChart data={data.exportActivity} />
          </div>

          <div className="grid grid-cols-1 gap-6 xl:grid-cols-[minmax(0,1fr)_347px]">
            <ActivityFeed events={data.activityFeed} />
            <SystemHealth services={data.systemHealth} />
          </div>

          <QuickActions />

          <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
            <OpenCases cases={data.openCases} />
            <Escalations items={data.escalations} />
          </div>

          <RecentAuditEvents events={data.recentAudit} />
        </>
      )}
    </div>
  );
}

function DashboardSkeleton() {
  const block = "animate-pulse rounded-2xl border border-white/10 bg-white/5";
  return (
    <div className="flex flex-col gap-6" aria-busy aria-label="Loading dashboard">
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4 xl:gap-6">
        {Array.from({ length: 4 }, (_, i) => (
          <div key={i} className={`${block} h-40`} />
        ))}
      </div>
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <div className={`${block} h-[340px]`} />
        <div className={`${block} h-[340px]`} />
      </div>
      <div className={`${block} h-[396px]`} />
    </div>
  );
}
