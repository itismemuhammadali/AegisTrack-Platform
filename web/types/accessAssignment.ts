export interface AssignedViewer {
  id: string;
  name: string;
}

/** An Authorized Viewer who can be assigned to tracked users. */
export interface ViewerOption {
  id: string;
  name: string;
  email: string;
  avatarUrl?: string;
}

export interface TrackedUserAssignment {
  id: string;
  name: string;
  email: string;
  avatarUrl?: string;
  viewers: AssignedViewer[];
}

export type AssignmentAction = "assigned" | "removed";

export interface AssignmentHistoryEntry {
  id: string;
  action: AssignmentAction;
  trackedUser: string;
  viewer: string;
  admin: string;
  time: string;
}
