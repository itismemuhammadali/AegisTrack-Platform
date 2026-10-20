import type { AssignmentHistoryEntry, TrackedUserAssignment, ViewerOption } from "@/types/accessAssignment";
import { apiRequest } from "./apiClient";
import { dbList, dbSet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const initialAssignments: TrackedUserAssignment[] = [
  { id: "u1", name: "Johnathan Vance", email: "j.vance@example.com", avatarUrl: "/images/avatars/john.png", viewers: [{ id: "v1", name: "Sarah Johnson, Esq." }, { id: "v2", name: "Lisa Anderson" }] },
  { id: "u3", name: "Marcus Sterling", email: "m.sterling@example.com", avatarUrl: "/images/avatars/mike.png", viewers: [{ id: "v3", name: "Emma Davis, Esq." }] },
  { id: "u5", name: "Elena Rostova", email: "e.rostova@example.com", avatarUrl: "/images/avatars/robert.png", viewers: [{ id: "v1", name: "Sarah Johnson, Esq." }, { id: "v4", name: "Mark Thompson" }, { id: "v5", name: "Patricia Moore" }] },
  { id: "u7", name: "David Lee", email: "david@example.com", avatarUrl: "/images/avatars/david.png", viewers: [] },
  { id: "u8", name: "Chris Taylor", email: "chris@example.com", avatarUrl: "/images/avatars/chris.png", viewers: [] },
];

const initialViewers: ViewerOption[] = [
  { id: "v1", name: "Sarah Johnson, Esq.", email: "sarah.j@lawfirm.com", avatarUrl: "/images/avatars/sarah.png" },
  { id: "v2", name: "Lisa Anderson", email: "lisa@lawfirm.com", avatarUrl: "/images/avatars/lisa.png" },
  { id: "v3", name: "Emma Davis, Esq.", email: "emma.d@defensecounsel.org", avatarUrl: "/images/avatars/emma.png" },
  { id: "v4", name: "Mark Thompson", email: "mark@example.com", avatarUrl: "/images/avatars/mark.png" },
  { id: "v5", name: "Patricia Moore", email: "patricia@example.com", avatarUrl: "/images/avatars/patricia.png" },
];

const initialHistory: AssignmentHistoryEntry[] = [
  { id: "h1", action: "assigned", trackedUser: "Johnathan Vance", viewer: "Sarah Johnson, Esq.", admin: "admin@securetrack.io", time: "2 hours ago" },
  { id: "h2", action: "removed", trackedUser: "Marcus Sterling", viewer: "Lisa Anderson", admin: "admin@securetrack.io", time: "Yesterday" },
  { id: "h3", action: "assigned", trackedUser: "Elena Rostova", viewer: "Mark Thompson", admin: "admin@securetrack.io", time: "2 days ago" },
];

export const accessAssignmentService = {
  async list(search = ""): Promise<TrackedUserAssignment[]> {
    const q = search.trim();
    if (!USE_MOCK) return apiRequest(`/access-assignments${q ? `?search=${encodeURIComponent(q)}` : ""}`);
    const assignments = await dbList<TrackedUserAssignment>("access_assignments", initialAssignments);
    const s = q.toLowerCase();
    return assignments.filter((a) => !s || a.name.toLowerCase().includes(s) || a.email.toLowerCase().includes(s));
  },

  async history(): Promise<AssignmentHistoryEntry[]> {
    if (!USE_MOCK) return apiRequest("/access-assignments/history");
    return dbList<AssignmentHistoryEntry>("access_assignment_history", initialHistory);
  },

  async removeViewer(trackedUserId: string, viewerId: string, adminEmail: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/access-assignments/${trackedUserId}/viewers/${viewerId}`, { method: "DELETE" });
      return;
    }
    const assignments = await dbList<TrackedUserAssignment>("access_assignments", initialAssignments);
    const target = assignments.find((a) => a.id === trackedUserId);
    const viewer = target?.viewers.find((v) => v.id === viewerId);
    if (!target || !viewer) return;
    const updated = { ...target, viewers: target.viewers.filter((v) => v.id !== viewerId) };
    await dbSet<TrackedUserAssignment>("access_assignments", trackedUserId, updated);
    await dbSet<AssignmentHistoryEntry>("access_assignment_history", `h${Date.now()}`, {
      id: `h${Date.now()}`,
      action: "removed",
      trackedUser: target.name,
      viewer: viewer.name,
      admin: adminEmail,
      time: "Just now",
    });
  },

  /** All Authorized Viewers that can be assigned (Manage Viewer Access list). */
  async viewers(): Promise<ViewerOption[]> {
    if (!USE_MOCK) return apiRequest("/access-assignments/viewers");
    return dbList<ViewerOption>("viewers", initialViewers);
  },

  /** Replaces a tracked user's viewer set */
  async setViewers(trackedUserId: string, viewerIds: string[], adminEmail: string): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest(`/access-assignments/${trackedUserId}/viewers`, { method: "PUT", body: JSON.stringify({ viewerIds }) });
      return;
    }
    const assignments = await dbList<TrackedUserAssignment>("access_assignments", initialAssignments);
    const viewersList = await dbList<ViewerOption>("viewers", initialViewers);
    const target = assignments.find((a) => a.id === trackedUserId);
    if (!target) throw new Error("Tracked user not found");
    const before = new Set(target.viewers.map((v) => v.id));
    const after = new Set(viewerIds);

    for (const id of viewerIds.filter((x) => !before.has(x))) {
      await dbSet<AssignmentHistoryEntry>("access_assignment_history", `h${Date.now()}-${id}`, {
        id: `h${Date.now()}-${id}`,
        action: "assigned",
        trackedUser: target.name,
        viewer: viewersList.find((v) => v.id === id)?.name ?? id,
        admin: adminEmail,
        time: "Just now",
      });
    }

    const updated = { ...target, viewers: viewersList.filter((v) => after.has(v.id)).map(({ id, name }) => ({ id, name })) };
    await dbSet<TrackedUserAssignment>("access_assignments", trackedUserId, updated);
  },
};

