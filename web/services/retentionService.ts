import type { RetentionOverview, RetentionPolicy, RetentionPolicyPatch } from "@/types/retention";
import { apiRequest } from "./apiClient";
import { dbList, dbSet } from "@/lib/db";

const USE_MOCK = !process.env.NEXT_PUBLIC_API_BASE_URL;

const initialPolicies: RetentionPolicy[] = [
  { id: "gps", name: "GPS Tracking Logs", description: "Location tracking data and movement logs", retentionDays: 365, minRetentionDays: 90, autoDelete: true, archiveFirst: true, complianceMode: false, appliesTo: ["Tracked Users"] },
  { id: "auth", name: "Authentication Logs", description: "Login attempts, MFA events, session records", retentionDays: 730, minRetentionDays: 365, autoDelete: false, archiveFirst: true, complianceMode: true, appliesTo: ["All Users"] },
  { id: "exports", name: "Export Records", description: "History of all data export activities", retentionDays: 180, minRetentionDays: 30, autoDelete: true, archiveFirst: false, complianceMode: false, appliesTo: ["Admin", "Authorized Viewer"] },
  { id: "security", name: "Security Events", description: "Suspicious activity, failed logins, VPN detections", retentionDays: 1095, minRetentionDays: 365, autoDelete: false, archiveFirst: true, complianceMode: true, appliesTo: ["All Users"] },
];

export const retentionService = {
  async get(): Promise<RetentionOverview> {
    if (!USE_MOCK) return apiRequest("/retention-rules");
    const policies = await dbList<RetentionPolicy>("retention_policies", initialPolicies);
    return {
      standards: [
        { name: "GDPR", active: true },
        { name: "SOC 2 Type II", active: true },
        { name: "HIPAA", active: false },
        { name: "ISO 27001", active: true },
      ],
      policies: policies.map((p) => ({ ...p })),
      archive: [
        { label: "Archive Location", description: "Encrypted cold storage — AES-256", status: "Active", active: true },
        { label: "Archive Encryption", description: "Military-grade encryption at rest", status: "Enabled", active: true },
        { label: "Legal Hold", description: "Pause deletion for legal proceedings", status: "Inactive", active: false },
        { label: "Deletion Notifications", description: "Alert admins before auto-deletion", status: "Enabled", active: true },
      ],
    };
  },

  /** Saves every edited policy in one request ("Save Rules"). */
  async save(patches: RetentionPolicyPatch[]): Promise<void> {
    if (!USE_MOCK) {
      await apiRequest("/retention-rules", { method: "PUT", body: JSON.stringify({ policies: patches }) });
      return;
    }
    const currentList = await dbList<RetentionPolicy>("retention_policies", initialPolicies);
    for (const p of patches) {
      const current = currentList.find((x) => x.id === p.id);
      if (current && p.complianceMode && p.retentionDays < current.minRetentionDays) {
        throw new Error(`${current.name} can't be shorter than ${current.minRetentionDays} days in compliance mode`);
      }
      await dbSet<RetentionPolicy>("retention_policies", p.id, p);
    }
  },
};

