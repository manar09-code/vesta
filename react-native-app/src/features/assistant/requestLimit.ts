/** 20 requests per day and 1 request per 3 seconds (VST-87). */
export const dailyLimit = 20;
export const minGapMs = 3000;

export type LimiterState = { day: string; count: number; lastAt: number };

export type LimitDecision =
  | { allowed: true; next: LimiterState }
  | { allowed: false; reason: 'tooFast' | 'dailyLimit' };

export function dayKeyOf(date: Date): string {
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${date.getFullYear()}-${month}-${day}`;
}

export function checkLimit(
  state: LimiterState | null,
  now: Date,
): LimitDecision {
  const day = dayKeyOf(now);
  const current: LimiterState =
    state !== null && state.day === day ? state : { day, count: 0, lastAt: 0 };
  if (current.count >= dailyLimit) {
    return { allowed: false, reason: 'dailyLimit' };
  }
  if (now.getTime() - current.lastAt < minGapMs) {
    return { allowed: false, reason: 'tooFast' };
  }
  return {
    allowed: true,
    next: { day, count: current.count + 1, lastAt: now.getTime() },
  };
}
