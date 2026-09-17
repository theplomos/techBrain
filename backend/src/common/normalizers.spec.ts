import { describe, expect, it } from '@jest/globals';
import { normalizeEmail, trimString } from './normalizers';

describe('normalizers', () => {
  it('normalizes an email', () => {
    expect(normalizeEmail('  USER@Example.COM ')).toBe('user@example.com');
  });

  it('trims a string without changing non-string values', () => {
    expect(trimString('  TechBrain  ')).toBe('TechBrain');
    expect(trimString(42)).toBe(42);
  });
});
