import { TriangleAlert } from "lucide-react";
import { Panel } from "@/components/ui/Panel";
import type { ServiceHealth, ServiceStatus } from "@/types/dashboard";

const STATUS: Record<ServiceStatus, { label: string; dot: string; text: string }> = {
  operational: { label: "Operational", dot: "bg-[#05df72]", text: "text-[#05df72]" },
  degraded: { label: "Degraded", dot: "bg-[#fdc700]", text: "text-[#fdc700]" },
  down: { label: "Down", dot: "bg-[#ff6467]", text: "text-[#ff6467]" },
};

export function SystemHealth({ services }: { services: ServiceHealth[] }) {
  const degraded = services.filter((s) => s.status !== "operational");

  return (
    <Panel title="System Health" subtitle="Current platform status">
      <ul className="flex flex-col gap-3 pt-4">
        {services.map((s) => {
          const st = STATUS[s.status];
          return (
            <li key={s.name} className="flex items-center justify-between gap-3">
              <span className="truncate text-sm leading-5 text-[#e5e7eb]">{s.name}</span>
              <span className="flex shrink-0 items-center gap-1.5 text-xs leading-4">
                {s.detail && <span className="text-[#9ca3af]">{s.detail}</span>}
                <span className={`size-2 rounded-full ${st.dot}`} />
                <span className={st.text}>{st.label}</span>
              </span>
            </li>
          );
        })}
      </ul>

      {degraded.length > 0 && (
        <div className="mt-4 rounded-[18px] border border-[#f0b100]/20 bg-[#f0b100]/10 p-3">
          <p className="flex items-center gap-2 text-xs leading-4 font-medium text-[#ffdf20]">
            <TriangleAlert className="size-4" />
            {degraded.length} service{degraded.length > 1 ? "s" : ""} degraded
          </p>
          <p className="pt-1 text-xs leading-4 text-[#9ca3af]">
            {degraded.length === 1
              ? `${degraded[0].name.replace(/ Service$/, "")} experiencing elevated failure rate.`
              : degraded.map((d) => d.name).join(", ")}
          </p>
        </div>
      )}
    </Panel>
  );
}
