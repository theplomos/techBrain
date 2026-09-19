import '../errors/failure.dart';

/// Nivel de un curso dentro de una ruta.
///
/// El nivel no es una propiedad del curso: sale de la ruta. Un mismo curso
/// puede ser REQUERIDO en una ruta y OPCIONAL en otra.
///
/// El orden de declaración es el orden de fuerza (Requerido > Recomendado >
/// Opcional). Se usa para deduplicar slugs repetidos dentro de una ruta
/// conservando el nivel más fuerte, y para ordenar las columnas.
enum CourseLevel {
  required('REQUERIDO', 'Requerido'),
  recommended('RECOMENDADO', 'Recomendado'),
  optional('OPCIONAL PERO MUY ÚTIL', 'Opcional');

  const CourseLevel(this.datasetValue, this.label);

  /// Valor exacto en `rutas_aprendizaje_devtalles.json`.
  final String datasetValue;

  /// Texto visible en la interfaz.
  final String label;

  /// Convierte el valor del dataset.
  ///
  /// La comparación es exacta: no se normalizan mayúsculas ni tildes, para
  /// que un cambio en el dataset se note en vez de pasar desapercibido.
  ///
  /// Lanza [LocalDataFailure] si el valor no coincide.
  static CourseLevel fromDataset(String value) {
    for (final CourseLevel level in CourseLevel.values) {
      if (level.datasetValue == value) return level;
    }
    throw LocalDataFailure(
      message: 'Nivel desconocido en el dataset: "$value".',
    );
  }
}
