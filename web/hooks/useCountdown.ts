"use client";

import { useCallback, useEffect, useState } from "react";

/** Counts down once per second from `initial`; `restart(n)` starts over. */
export function useCountdown(initial: number) {
  const [seconds, setSeconds] = useState(initial);

  useEffect(() => {
    if (seconds <= 0) return;
    const t = setTimeout(() => setSeconds((s) => s - 1), 1000);
    return () => clearTimeout(t);
  }, [seconds]);

  const restart = useCallback((n: number) => setSeconds(n), []);
  return { seconds, restart };
}
