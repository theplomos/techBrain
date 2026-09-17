#!/bin/bash
set -e

echo "===================================================="
echo "  TechBrain - Script de Compilación para Vercel     "
echo "===================================================="

# 1. Asegurar la presencia de Flutter SDK en el entorno
if ! command -v flutter &> /dev/null; then
  echo "==> Flutter no encontrado en PATH. Preparando SDK en el contenedor..."
  FLUTTER_DIR="$HOME/flutter"
  if [ ! -d "$FLUTTER_DIR" ]; then
    echo "==> Clonando Flutter SDK (canal stable)..."
    git clone https://github.com/flutter/flutter.git --depth 1 -b stable "$FLUTTER_DIR"
  else
    echo "==> Directorio de Flutter ya existente en $FLUTTER_DIR"
  fi
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

echo "==> Verificando versión instalada de Flutter:"
flutter --version

# 2. Navegar al proyecto frontend
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/frontend"

# 3. Instalar dependencias
echo "==> Descargando dependencias de Flutter..."
flutter pub get

# 4. Compilar para la Web
echo "==> Compilando aplicación Flutter Web en modo release..."
flutter build web --release

echo "===================================================="
echo "  Compilación finalizada con éxito: frontend/build/web"
echo "===================================================="
