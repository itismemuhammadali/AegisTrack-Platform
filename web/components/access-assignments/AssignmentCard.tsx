import { Plus, X } from "lucide-react";
import { Avatar } from "@/components/ui/Avatar";
import type { TrackedUserAssignment } from "@/types/accessAssignment";

function viewerLabel(n: number) {
  if (n === 0) return "No viewers assigned";
  return `${n} viewer${n === 1 ? "" : "s"}`;
}

interface AssignmentCardProps {
  assignment: TrackedUserAssignment;
  onRemoveViewer: (viewerId: string) => void;
  onManage?: () => void;
}

export function AssignmentCard({ assignment, onRemoveViewer, onManage }: AssignmentCardProps) {
  const { name, email, avatarUrl, viewers } = assignment;
  return (
    <article className="rounded-[18px] border border-white/10 bg-black/60 p-[17px] md:pr-[59px]">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div className="flex min-w-0 items-center gap-3">
          <Avatar src={avatarUrl} name={name} size={40} />
          <div className="min-w-0">
            <p className="truncate text-sm leading-5 font-medium text-[#e5e7eb]">{name}</p>
            <p className="truncate text-xs leading-4 text-[#9ca3af]">{email}</p>
          </div>
        </div>
        <div className="flex items-center gap-3">
          <span className="text-xs leading-4 whitespace-nowrap text-[#9ca3af]">{viewerLabel(viewers.length)}</span>
          <button
            type="button"
            onClick={onManage}
            className="flex cursor-pointer items-center gap-1.5 rounded-[14px] bg-[#34206c] px-3 py-1.5 text-xs leading-4 font-medium text-white transition hover:bg-[#3f2785]"
          >
            <Plus className="size-3" />
            Manage
          </button>
        </div>
      </div>

      {viewers.length > 0 && (
        <ul className="mt-3 flex flex-wrap gap-2 border-t border-white/10 pt-3">
          {viewers.map((v) => (
            <li key={v.id} className="flex items-center gap-1.5 rounded-[14px] bg-white/10 px-2.5 py-1">
              <span className="flex size-5 items-center justify-center rounded-full bg-white/30 text-xs leading-4 font-bold text-white">
                {v.name[0]}
              </span>
              <span className="text-xs leading-4 text-[#e5e7eb]">{v.name}</span>
              <button
                type="button"
                onClick={() => onRemoveViewer(v.id)}
                aria-label={`Remove ${v.name}`}
                className="cursor-pointer pl-1 text-[#9ca3af] transition hover:text-white"
              >
                <X className="size-3" />
              </button>
            </li>
          ))}
        </ul>
      )}
    </article>
  );
}
