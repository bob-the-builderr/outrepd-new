/**
 * Calculate Wilks-inspired bodyweight multiplier
 * Based on powerlifting formula - lighter lifters have higher relative strength
 */
export function getWilksMultiplier(bodyweightKg) {
  if (!bodyweightKg || bodyweightKg <= 0) {
    return 1.0; // No multiplier if bodyweight not set
  }

  // Wilks-inspired formula (simplified)
  // Real Wilks uses complex coefficients, this is an approximation
  const a = -216.0475144;
  const b = 16.2606339;
  const c = -0.002388645;
  const d = -0.00113732;
  const e = 7.01863e-6;
  const f = -1.291e-8;

  const bw = Math.max(40, Math.min(bodyweightKg, 200)); // Clamp between 40-200kg

  const denominator =
    a +
    b * bw +
    c * bw * bw +
    d * bw * bw * bw +
    e * bw * bw * bw * bw +
    f * bw * bw * bw * bw * bw;

  const multiplier = 500 / denominator;

  // Normalize so 75kg = ~1.0x
  const normalized = multiplier / 1.03;

  // Clamp result between 0.85 and 1.25 for safety
  return Math.max(0.85, Math.min(1.25, normalized));
}

/**
 * Get equipment type multiplier
 */
export function getEquipmentMultiplier(equipmentType) {
  const multipliers = {
    dumbbell: 1.15,
    barbell: 1.0,
    cable: 0.85,
    machine: 0.85,
  };

  return multipliers[equipmentType?.toLowerCase()] || 1.0;
}

/**
 * Get height-based multiplier for ranked matches
 * Taller lifters get a bonus (mechanical disadvantage), shorter get a penalty (mechanical advantage)
 * Reference: 170cm = 1.0x, ±3.3% per 10cm, clamped to ±10%
 * Returns null if height is not set (should block ranked matches)
 */
export function getHeightMultiplier(heightCm) {
  if (!heightCm || heightCm <= 0) {
    return null; // null = required but missing
  }

  const h = Math.max(140, Math.min(heightCm, 220));
  const multiplier = 1.0 + ((h - 170) / 10) * 0.033;
  return Math.max(0.9, Math.min(1.1, multiplier));
}

/**
 * Calculate final volume with all multipliers applied (client-side preview)
 * Note: Backend will recalculate with user's bodyweight and height on save
 */
export function calculateModifiedVolume(
  weightKg,
  reps,
  equipmentType,
  repQuality,
) {
  const baseVolume = weightKg * reps;
  const equipmentMult = getEquipmentMultiplier(equipmentType);
  const qualityMult = repQuality || 1.0;

  // For client-side preview, we don't apply Wilks or height multiplier
  // Backend will apply them when saving with user's stats
  return baseVolume * equipmentMult * qualityMult;
}
