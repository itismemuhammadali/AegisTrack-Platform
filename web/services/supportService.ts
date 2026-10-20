import type { SupportConversation, SupportMessage } from "@/types/support";
import { apiRequest } from "./apiClient";
import { dbList, dbSet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

export const ADMIN_SUPPORT_THREAD_ID = "support";
export const DOCS_URL = process.env.NEXT_PUBLIC_DOCS_URL ?? "https://docs.securetrack.io";

const initialConversations: SupportConversation[] = [
  { id: "c1", participant: { name: "Emma Johnson", avatarUrl: "/images/avatars/emma-johnson.png" }, lastMessage: "Yes, I can help on Saturday!", lastAt: "2m ago", unread: 2 },
  { id: "c2", participant: { name: "Sophia Martinez", avatarUrl: "/images/avatars/sophia-martinez.png" }, lastMessage: "What time should I arrive?", lastAt: "1h ago", unread: 0 },
  { id: "c3", participant: { name: "Olivia Chen", avatarUrl: "/images/avatars/olivia-chen.png" }, lastMessage: "Thank you for the update!", lastAt: "3h ago", unread: 0 },
];

const sampleThread = (): SupportMessage[] => [
  { id: "m1", from: "other", time: "10:24 AM", text: "Hey team, my geofence alert just triggered. But I haven't left my designated security zone. Can you double check the sync on my device?" },
  { id: "m2", from: "self", time: "10:25 AM", text: "Let me verify that for you immediately. Pulling up your active geofencing coordinates from the SecureTrack control panel now..." },
  { id: "m3", from: "other", time: "10:26 AM", imageUrl: "/images/support/sync-conflict.png", text: "Thanks. Here is a screenshot of the system error showing on my side. It mentions a sync conflict." },
  { id: "m4", from: "self", time: "10:28 AM", text: "Ah, I see the conflict. Your local geofence node is running an outdated cached zone definition. I am forcing a remote partition sync from our admin console right now." },
  { id: "m5", from: "self", time: "10:29 AM", text: "Done! Please verify if the alert has resolved on your device now." },
];

const nowTime = () => new Date().toLocaleTimeString([], { hour: "numeric", minute: "2-digit" });

export const supportService = {
  async conversations(): Promise<SupportConversation[]> {
    if (!USE_MOCK) return apiRequest("/support/conversations");
    return dbList<SupportConversation>("support_conversations", initialConversations);
  },

  async messages(conversationId: string): Promise<SupportMessage[]> {
    if (!USE_MOCK) return apiRequest(`/support/conversations/${conversationId}/messages`);
    const coll = `support_messages_${conversationId}`;
    return dbList<SupportMessage>(coll, conversationId === ADMIN_SUPPORT_THREAD_ID ? [] : sampleThread());
  },

  async send(conversationId: string, text: string, attachment?: File): Promise<SupportMessage> {
    if (!USE_MOCK) {
      const body = new FormData();
      body.set("text", text);
      if (attachment) body.set("attachment", attachment);
      return apiRequest(`/support/conversations/${conversationId}/messages`, { method: "POST", body });
    }
    const coll = `support_messages_${conversationId}`;
    const id = `m${Date.now()}`;
    const msg: SupportMessage = {
      id,
      from: "self",
      text,
      time: nowTime(),
      imageUrl: attachment?.type.startsWith("image/") ? URL.createObjectURL(attachment) : undefined,
    };
    await dbSet<SupportMessage>(coll, id, msg);
    await dbSet<SupportConversation>("support_conversations", conversationId, {
      lastMessage: text,
      lastAt: "Just now",
      unread: 0,
    });
    return msg;
  },
};

