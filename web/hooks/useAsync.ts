"use client";

import { type DependencyList, useEffect, useState } from "react";

type AsyncState<T> = { data: T | null; error: Error | null; loading: boolean };

/** Runs `fn` on mount / when deps change; ignores results from stale runs. */
export function useAsync<T>(fn: () => Promise<T>, deps: DependencyList = []) {
  const [state, setState] = useState<AsyncState<T>>({ data: null, error: null, loading: true });

  useEffect(() => {
    let active = true;
    fn().then(
      (data) => active && setState({ data, error: null, loading: false }),
      (error: unknown) =>
        active && setState({ data: null, error: error instanceof Error ? error : new Error(String(error)), loading: false }),
    );
    return () => {
      active = false;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps -- caller controls re-runs via deps
  }, deps);

  return state;
}
