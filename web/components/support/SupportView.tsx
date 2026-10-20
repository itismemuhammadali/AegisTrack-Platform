"use client";

import { useState } from "react";
import { useAuth } from "@/components/providers/AuthProvider";
import { useAsync } from "@/hooks/useAsync";
import { ADMIN_SUPPORT_THREAD_ID, DOCS_URL, supportService } from "@/services/supportService";
import { ChatThread } from "./ChatThread";
import { ConversationList } from "./ConversationList";

const CARD = "flex min-w-0 flex-col rounded-2xl border border-white/10 bg-[#0c0e1a]";
const BTN = "inline-flex w-fit cursor-pointer items-center rounded-[18px] bg-[#34206c] px-4 py-2 text-sm leading-5 font-medium text-white transition hover:bg-[#3f2785]";

function CardHeading({ title, subtitle }: { title: string; subtitle: string }) {
  return (
    <div className="flex flex-col gap-1">
      <h2 className="text-base leading-6 font-semibold text-[#e5e7eb]">{title}</h2>
      <p className="text-sm leading-5 text-[#9ca3af]">{subtitle}</p>
    </div>
  );
}

/**
 * Admin (222:4584): Contact Support card → "Send Message" opens a thread with the support team.
 * Super Admin (610:26338 → 673:3066): inbox of conversations → chat thread.
 */
export function SupportView() {
  const { user } = useAuth();
  const isSuper = user.role === "SUPER_ADMIN";
  const [openId, setOpenId] = useState<string | null>(null);
  const conversations = useAsync(() => (isSuper ? supportService.conversations() : Promise.resolve([])), [isSuper, openId]);

  return (
    <div className="mx-auto flex w-full max-w-[1600px] flex-col gap-6">
      <div>
        <h1 className="text-2xl leading-8 font-semibold text-[#e5e7eb]">Support</h1>
        <p className="pt-1 text-sm leading-5 text-[#9ca3af]">Get help with SecureTrack Admin Portal</p>
      </div>

      <div className="grid grid-cols-1 items-start gap-4 lg:grid-cols-2">
        <section className={`${CARD} gap-4 p-6`}>
          <CardHeading title="Documentation" subtitle="Browse platform guides and API docs" />
          <a href={DOCS_URL} target="_blank" rel="noopener noreferrer" className={BTN}>
            Open Docs
          </a>
        </section>

        <section className={`${CARD} ${openId ? "overflow-hidden" : "gap-4 p-6"}`}>
          {openId ? (
            <ChatThread conversationId={openId} onBack={() => setOpenId(null)} />
          ) : (
            <>
              <CardHeading title="Contact Support" subtitle="Reach our enterprise support team" />
              {isSuper ? (
                conversations.loading && !conversations.data ? (
                  <p className="text-sm text-[#9ca3af]">Loading conversations…</p>
                ) : (
                  <ConversationList conversations={conversations.data ?? []} onOpen={(c) => setOpenId(c.id)} />
                )
              ) : (
                <button type="button" onClick={() => setOpenId(ADMIN_SUPPORT_THREAD_ID)} className={BTN}>
                  Send Message
                </button>
              )}
            </>
          )}
        </section>
      </div>
    </div>
  );
}
