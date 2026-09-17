export function normalizeEmail(value: unknown): unknown {
  return typeof value === 'string' ? value.trim().toLowerCase() : value;
}

export function trimString(value: unknown): unknown {
  return typeof value === 'string' ? value.trim() : value;
}
