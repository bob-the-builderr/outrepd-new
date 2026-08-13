/**
 * Score System - converts volume to user-facing score
 * Keeps the match-deciding formula hidden from users
 */

/**
 * Convert volume (kg) to display score.
 * Square root scaling creates a non-linear, non-obvious mapping
 * so users cannot reverse-engineer the exact formula.
 *
 * Examples:
 *   500 kg  → 223 pts
 *   1000 kg → 316 pts
 *   2000 kg → 447 pts
 *   5000 kg → 707 pts
 */
export function volumeToScore(volumeKg) {
  if (!volumeKg || volumeKg <= 0) return 0;
  return Math.floor(Math.sqrt(volumeKg * 100));
}

/**
 * Format score as a string with "pts" label.
 */
export function formatScore(volumeKg) {
  return `${volumeToScore(volumeKg)} pts`;
}
