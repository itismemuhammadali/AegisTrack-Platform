"use client";

import { Eye } from "lucide-react";
import { ActionMenu } from "@/components/ui/ActionMenu";
import type { CaseRecord } from "@/types/case";

/** Row "⋮" menu (Figma 613:29960) — same for Admin and Super Admin. */
export function CaseRowActions({ record, onOpen }: { record: CaseRecord; onOpen: (record: CaseRecord) => void }) {
  return <ActionMenu label={`Actions for ${record.number}`} width="w-[174px]" items={[{ label: "Open Case", icon: Eye, onSelect: () => onOpen(record) }]} />;
}
