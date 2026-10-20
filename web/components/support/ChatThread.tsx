"use client";

import Image from "next/image";
import { type FormEvent, useEffect, useRef, useState } from "react";
import { ChevronLeft, Paperclip, Send, Smile, X } from "lucide-react";
import { supportService } from "@/services/supportService";
import type { SupportMessage } from "@/types/support";

const EMOJIS = ["👍", "🙏", "✅", "👀", "😊", "⚠️"];

function Bubble({ m }: { m: SupportMessage }) {
  const self = m.from === "self";
  return (
    <div className={`flex ${self ? "justify-end" : "justify-start"}`}>
      <div
        className={`flex w-fit max-w-[280px] flex-col gap-2 rounded-xl p-3 ${
          self ? "bg-[linear-gradient(90deg,#2f1d63_0%,#4a2d8f_100%)]" : "bg-white/10"
        }`}
      >
        {m.imageUrl && (
          <Image src={m.imageUrl} alt="Attached screenshot" width={256} height={160} unoptimized className="h-auto w-full rounded-lg object-cover" />
        )}
        {m.text && <p className="text-[13px] leading-5 whitespace-pre-wrap text-white">{m.text}</p>}
        <p className={`text-[10px] leading-3 text-[#9ca3af] ${self ? "text-right" : ""}`}>{m.time}</p>
      </div>
    </div>
  );
}

/** Chat thread (Figma 673:3393). Used by Super Admin inbox and Admin "Send Message". */
export function ChatThread({ conversationId, onBack }: { conversationId: string; onBack: () => void }) {
  const [messages, setMessages] = useState<SupportMessage[] | null>(null);
  const [text, setText] = useState("");
  const [file, setFile] = useState<File | null>(null);
  const [sending, setSending] = useState(false);
  const [emojiOpen, setEmojiOpen] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const fileRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    let active = true;
    supportService.messages(conversationId).then((m) => active && setMessages(m));
    return () => {
      active = false;
    };
  }, [conversationId]);

  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: "smooth" });
  }, [messages]);

  async function submit(e: FormEvent) {
    e.preventDefault();
    const body = text.trim();
    if ((!body && !file) || sending) return;
    setSending(true);
    try {
      const msg = await supportService.send(conversationId, body, file ?? undefined);
      setMessages((prev) => [...(prev ?? []), msg]);
      setText("");
      setFile(null);
    } finally {
      setSending(false);
    }
  }

  return (
    <div className="flex h-[calc(100dvh-220px)] min-h-[520px] flex-col lg:max-h-[1100px]">
      <header className="flex h-[60px] shrink-0 items-center border-b border-white/10 px-4">
        <button
          type="button"
          onClick={onBack}
          aria-label="Back"
          className="flex size-9 cursor-pointer items-center justify-center rounded-lg border border-white/20 text-white transition hover:bg-white/10"
        >
          <ChevronLeft className="size-5" />
        </button>
      </header>

      <div ref={scrollRef} className="flex flex-1 flex-col gap-3 overflow-y-auto px-4 py-4 [scrollbar-width:thin] sm:px-8">
        <div className="flex items-center gap-3 py-2" aria-hidden>
          <span className="h-px flex-1 bg-white/10" />
          <span className="text-[10px] leading-[13px] tracking-[0.6px] text-[#9ca3af] uppercase">Today</span>
          <span className="h-px flex-1 bg-white/10" />
        </div>
        {messages === null ? (
          <p className="py-8 text-center text-sm text-[#9ca3af]">Loading messages…</p>
        ) : messages.length === 0 ? (
          <p className="py-8 text-center text-sm text-[#9ca3af]">Start the conversation — our team usually replies within a few minutes.</p>
        ) : (
          messages.map((m) => <Bubble key={m.id} m={m} />)
        )}
      </div>

      <form onSubmit={submit} className="shrink-0 border-t border-white/10 px-4 pt-3 pb-5">
        {file && (
          <p className="mb-2 flex w-fit items-center gap-2 rounded-full bg-white/10 px-3 py-1 text-xs text-white">
            <Paperclip className="size-3" />
            <span className="max-w-[200px] truncate">{file.name}</span>
            <button type="button" onClick={() => setFile(null)} aria-label="Remove attachment" className="cursor-pointer text-[#9ca3af] hover:text-white">
              <X className="size-3" />
            </button>
          </p>
        )}
        <div className="relative flex items-center gap-3">
          <input ref={fileRef} type="file" accept="image/*,.pdf,.txt,.log" hidden onChange={(e) => setFile(e.target.files?.[0] ?? null)} />
          <button
            type="button"
            onClick={() => fileRef.current?.click()}
            aria-label="Attach file"
            className="flex size-11 shrink-0 cursor-pointer items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20"
          >
            <Paperclip className="size-5" />
          </button>
          <label className="flex h-11 min-w-0 flex-1 items-center gap-2 rounded-full border border-white/10 bg-white/5 pr-3 pl-4 focus-within:border-white/30">
            <input
              value={text}
              onChange={(e) => setText(e.target.value)}
              placeholder="Type a message..."
              aria-label="Message"
              className="w-full min-w-0 bg-transparent text-sm text-white outline-none placeholder:text-[#9ca3af]"
            />
            <button type="button" onClick={() => setEmojiOpen((o) => !o)} aria-label="Insert emoji" aria-expanded={emojiOpen} className="cursor-pointer text-[#9ca3af] hover:text-white">
              <Smile className="size-5" />
            </button>
          </label>
          {emojiOpen && (
            <div className="absolute right-14 bottom-full mb-2 flex gap-1 rounded-xl border border-white/10 bg-[#0c1227] p-1.5 shadow-xl">
              {EMOJIS.map((e) => (
                <button
                  key={e}
                  type="button"
                  className="cursor-pointer rounded-lg px-1.5 py-1 text-lg hover:bg-white/10"
                  onClick={() => {
                    setText((t) => t + e);
                    setEmojiOpen(false);
                  }}
                >
                  {e}
                </button>
              ))}
            </div>
          )}
          <button
            type="submit"
            disabled={sending || (!text.trim() && !file)}
            aria-label="Send message"
            className="flex size-11 shrink-0 cursor-pointer items-center justify-center rounded-full bg-[#7f22fe] text-white transition hover:bg-[#8e51ff] disabled:cursor-not-allowed disabled:opacity-60"
          >
            <Send className="size-5" />
          </button>
        </div>
      </form>
    </div>
  );
}
