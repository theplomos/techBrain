import 'package:flutter/widgets.dart';

/// Iniciales de [name] para un avatar: la primera letra de la primera y de la
/// última palabra, en mayúsculas.
///
/// Devuelve una cadena vacía si [name] no tiene ninguna palabra. Trabaja por
/// grafemas para no partir emojis ni letras compuestas.
String initialsOf(String name) {
  final List<String> words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return '';

  String firstOf(String word) => word.characters.first.toUpperCase();

  if (words.length == 1) return firstOf(words.first);
  return '${firstOf(words.first)}${firstOf(words.last)}';
}
