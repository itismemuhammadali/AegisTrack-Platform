"use client";

import { type ComponentProps, useState } from "react";
import { IconInput } from "./IconInput";

type PasswordInputProps = Omit<ComponentProps<typeof IconInput>, "icon" | "type" | "trailing">;

/** Lock-icon password field with a show/hide toggle. */
export function PasswordInput(props: PasswordInputProps) {
  const [visible, setVisible] = useState(false);

  return (
    <IconInput
      {...props}
      icon="/icons/lock.svg"
      type={visible ? "text" : "password"}
      trailing={
        <button
          type="button"
          onClick={() => setVisible((v) => !v)}
          aria-label={visible ? "Hide password" : "Show password"}
          aria-pressed={visible}
          className="shrink-0 cursor-pointer text-[#9ca3af] transition-colors hover:text-white"
        >
          <svg viewBox="0 0 24 24" className="size-5" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
            <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z" />
            <circle cx="12" cy="12" r="3" />
            {!visible && <path d="M3 3l18 18" />}
          </svg>
        </button>
      }
    />
  );
}
