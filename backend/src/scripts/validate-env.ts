import { parse } from 'dotenv';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import { envValidationSchema } from '../config/env.validation';

const requestedPath = process.argv[2];

if (!requestedPath) {
  throw new Error('Uso: npm run env:validate -- <ruta-del-archivo-env>');
}

const environmentPath = resolve(process.cwd(), requestedPath);
const environment = parse(readFileSync(environmentPath));
const { error } = envValidationSchema.validate(environment, {
  abortEarly: false,
  allowUnknown: true,
});

if (error) {
  throw new Error(`Configuración inválida:\n${error.message}`);
}

console.log(`Configuración válida: ${environmentPath}`);
