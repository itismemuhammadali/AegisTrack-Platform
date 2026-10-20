"use client";

import { Eye, SquarePen, Trash2 } from "lucide-react";
import { ActionMenu } from "@/components/ui/ActionMenu";
import type { Zone } from "@/types/zone";

export type ZoneRowAction = "view" | "edit" | "delete";

/** Row "⋮" menu (Figma 618:510) — same for Admin and Super Admin. */
export function ZoneRowActions({ zone, onAction }: { zone: Zone; onAction: (action: ZoneRowAction, zone: Zone) => void }) {
  return (
    <ActionMenu
      label={`Actions for ${zone.name}`}
      items={[
        { label: "View Details", icon: Eye, onSelect: () => onAction("view", zone) },
        { label: "Edit Zone", icon: SquarePen, onSelect: () => onAction("edit", zone) },
        { label: "Delete Zone", icon: Trash2, danger: true, onSelect: () => onAction("delete", zone) },
      ]}
    />
  );
}
