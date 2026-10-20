export interface SupportConversation {
  id: string;
  participant: { name: string; avatarUrl?: string };
  lastMessage: string;
  lastAt: string; // display, e.g. "2m ago"
  unread: number;
}

export interface SupportMessage {
  id: string;
  /** "self" = the signed-in admin; "other" = the person on the far side. */
  from: "self" | "other";
  text: string;
  imageUrl?: string;
  time: string; // display, e.g. "10:24 AM"
}
