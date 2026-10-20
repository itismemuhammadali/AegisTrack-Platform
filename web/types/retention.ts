export interface RetentionPolicy {
  id: string;
  name: string;
  description: string;
  retentionDays: number;
  /** Compliance-mode policies cannot go below this many days. */
  minRetentionDays: number;
  autoDelete: boolean;
  archiveFirst: boolean;
  complianceMode: boolean;
  appliesTo: string[];
}

export interface ComplianceStandard {
  name: string;
  active: boolean;
}

export interface ArchiveSetting {
  label: string;
  description: string;
  status: string;
  active: boolean;
}

export interface RetentionOverview {
  standards: ComplianceStandard[];
  policies: RetentionPolicy[];
  archive: ArchiveSetting[];
}

export type RetentionPolicyPatch = Pick<RetentionPolicy, "id" | "retentionDays" | "autoDelete" | "archiveFirst" | "complianceMode">;

/** 365 → "1 year", 180 → "6 months", 45 → "45 days". */
export function formatRetention(days: number) {
  if (days >= 365 && days % 365 === 0) {
    const y = days / 365;
    return `${y} year${y === 1 ? "" : "s"}`;
  }
  if (days >= 30 && days % 30 === 0) {
    const m = days / 30;
    return `${m} month${m === 1 ? "" : "s"}`;
  }
  return `${days} day${days === 1 ? "" : "s"}`;
}
