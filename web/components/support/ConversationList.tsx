import { Avatar } from "@/components/ui/Avatar";
import type { SupportConversation } from "@/types/support";

export function ConversationList({ conversations, onOpen }: { conversations: SupportConversation[]; onOpen: (c: SupportConversation) => void }) {
  if (conversations.length === 0) return <p className="text-sm text-[#9ca3af]">No conversations yet.</p>;
  return (
    <ul className="flex flex-col gap-4">
      {conversations.map((c) => (
        <li key={c.id}>
          <button
            type="button"
            onClick={() => onOpen(c)}
            className="flex w-full cursor-pointer items-center gap-4 rounded-2xl border border-white/20 bg-[#0c0e1a] p-4 text-left backdrop-blur-[2px] transition hover:border-white/30 hover:bg-white/5 sm:p-6"
          >
            <Avatar src={c.participant.avatarUrl} name={c.participant.name} size={48} />
            <span className="flex min-w-0 flex-1 flex-col gap-1">
              <span className="flex items-center justify-between gap-3">
                <span className="truncate text-lg leading-[27px] font-semibold text-white">{c.participant.name}</span>
                <span className="shrink-0 text-sm leading-5 text-white">{c.lastAt}</span>
              </span>
              <span className="flex items-center justify-between gap-3">
                <span className="truncate text-sm leading-5 text-white">{c.lastMessage}</span>
                {c.unread > 0 && (
                  <span className="flex size-5 shrink-0 items-center justify-center rounded-full bg-[linear-gradient(90deg,#2f1d63_0%,#4a2d8f_100%)] text-xs leading-4 font-medium text-white">
                    {c.unread}
                    <span className="sr-only"> unread</span>
                  </span>
                )}
              </span>
            </span>
          </button>
        </li>
      ))}
    </ul>
  );
}
