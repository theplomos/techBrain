#!/bin/bash
set -e

echo "===================================================="
echo "  TechBrain - Despliegue Rápido a Vercel            "
echo "===================================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$ROOT_DIR/frontend"

echo "==> Compilando Flutter Web en release..."
flutter build web --release

echo "==> Desplegando frontend/build/web en Vercel..."
cd "$ROOT_DIR/frontend/build/web"

if command -v vercel &> /dev/null; then
  vercel --prod
else
  npx vercel --prod
fi

echo "===================================================="
echo "  Despliegue finalizado exitosamente               "
echo "===================================================="
