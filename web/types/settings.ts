export type RetentionPeriod = "7" | "30" | "90" | "180" | "365";
export type ExportFormat = "pdf" | "csv" | "xlsx";

export interface SystemSettings {
  security: { twoFactor: boolean; sessionTimeout: boolean; ipWhitelist: boolean };
  notifications: { failedSync: boolean; newUser: boolean; securityAlerts: boolean; exportCompletion: boolean };
  retention: { logRetentionDays: RetentionPeriod; autoDeleteExportsDays: RetentionPeriod; automaticBackup: boolean };
  exports: { encryptedPdf: boolean; watermark: boolean; defaultFormat: ExportFormat };
}

export interface SystemInfo {
  platformVersion: string;
  databaseStatus: string;
  lastBackup: string;
  storageUsed: string;
  activeSessions: number;
  uptime: string;
}

export const RETENTION_LABELS: Record<RetentionPeriod, string> = {
  "7": "7 Days",
  "30": "30 Days",
  "90": "90 Days",
  "180": "180 Days",
  "365": "1 Year",
};

export const EXPORT_FORMAT_LABELS: Record<ExportFormat, string> = { pdf: "PDF", csv: "CSV", xlsx: "Excel (XLSX)" };
