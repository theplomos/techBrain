import '../errors/failure.dart';

/// Categoría de un curso dentro de una ruta.
///
/// Como el nivel, depende de la ruta y no del curso. No existe la categoría
/// WEB del sistema de diseño porque ningún curso la usa; sus tokens se
/// reutilizan para [fullstack].
enum CourseCategory {
  bases('BASES'),
  frontend('FRONTEND'),
  backend('BACKEND'),
  mobile('MÓVIL'),
  aiAgents('AGENTES IA'),
  fullstack('FULLSTACK');

  const CourseCategory(this.datasetValue);

  /// Valor exacto en el dataset. También es el texto visible del chip.
  final String datasetValue;

  /// Convierte el valor del dataset. La comparación es exacta.
  ///
  /// Lanza [LocalDataFailure] si el valor no coincide.
  static CourseCategory fromDataset(String value) {
    for (final CourseCategory category in CourseCategory.values) {
      if (category.datasetValue == value) return category;
    }
    throw LocalDataFailure(
      message: 'Categoría desconocida en el dataset: "$value".',
    );
  }
}
