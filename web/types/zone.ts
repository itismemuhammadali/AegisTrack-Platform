export type ZoneType = "allowed" | "restricted" | "checkin";
export type ZoneStatus = "active" | "inactive";

export interface Zone {
  id: string;
  name: string;
  latitude: number;
  longitude: number;
  type: ZoneType;
  assignedUsers: number;
  status: ZoneStatus;
  lastActivity: string;
  description?: string;
}

export type ZoneActivityKind = "entry" | "exit" | "check-in";

export interface ZoneActivity {
  id: string;
  kind: ZoneActivityKind;
  label: string;
  time: string;
}

export interface ZoneDetail extends Zone {
  assignedUserNames: string[];
  activity: ZoneActivity[];
}

export interface ZoneInput {
  name: string;
  type: ZoneType;
  description: string;
  assignedUserNames: string[];
}

export interface ZoneStats {
  totalZones: number;
  activeAlerts: number;
  usersAssigned: number;
}

export interface ZoneListQuery {
  search?: string;
  type?: ZoneType | "all";
  status?: ZoneStatus | "all";
}

export const ZONE_TYPE_LABELS: Record<ZoneType, string> = {
  allowed: "Allowed Area",
  restricted: "Restricted Area",
  checkin: "Required Check-in",
};

export const ZONE_STATUS_LABELS: Record<ZoneStatus, string> = {
  active: "Active",
  inactive: "Inactive",
};

/** 40.7128, -74.006 → "40.7128° N, 74.0060° W" */
export function formatCoordinates(lat: number, lng: number) {
  return `${Math.abs(lat).toFixed(4)}° ${lat >= 0 ? "N" : "S"}, ${Math.abs(lng).toFixed(4)}° ${lng >= 0 ? "E" : "W"}`;
}
