export type NotificationKind = "critical" | "success" | "warning" | "info";

export interface AppNotification {
  id: string;
  kind: NotificationKind;
  title: string;
  message: string;
  time: string;
  read: boolean;
}
