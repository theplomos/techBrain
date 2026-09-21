#!/usr/bin/env bash
#
# Copia los JSON del dataset de DevTalles a assets/data/.
#
# Los originales viven en docs/references/, fuera del paquete Flutter. Se
# copian en lugar de declararlos con '../' para que acaben en
# build/web/assets/ y para que funcionen en iOS y en Android.
#
# Si cambian los originales, ejecuta este script y commitea la copia.
# dataset_values_test.dart falla si la copia se queda atrás.
set -euo pipefail

PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$PACKAGE_DIR/../docs/references"
TARGET_DIR="$PACKAGE_DIR/assets/data"

mkdir -p "$TARGET_DIR"

for file in cursos_devtalles.json rutas_aprendizaje_devtalles.json; do
  cp "$SOURCE_DIR/$file" "$TARGET_DIR/$file"
  echo "copiado: $file"
done
