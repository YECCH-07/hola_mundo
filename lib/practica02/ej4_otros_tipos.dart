// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Sección 6: Otros tipos de datos en Dart
// Runes, Symbols, Records, Enums y Null Safety
// ============================================================
// ignore_for_file: avoid_print

/// 6.1 Runes: puntos de código Unicode
void demoRunes() {
  final corazon = Runes('\u2764');
  print('Runes   : ${String.fromCharCodes(corazon)}');
}

/// 6.1 Symbols: identificadores
void demoSymbols() {
  final sym = #nombreVariable;
  print('Symbols : $sym');
}

/// 6.2 Records (Dart 3.0+)
void demoRecords() {
  // Record con campos posicionales
  final punto = (10.0, 20.0);
  print('Record posicional: (${punto.$1}, ${punto.$2})');

  // Record con campos nombrados
  final persona = (nombre: 'Ana', edad: 25);
  print('Record nombrado  : ${persona.nombre}, ${persona.edad}');

  // Función que retorna múltiples valores
  (String, int) obtenerInfo() => ('Dart', 3);
  final (lenguaje, version) = obtenerInfo(); // destructuración
  print('Función record   : $lenguaje v$version');
}

/// 6.3 Enumeraciones
enum Direccion { norte, sur, este, oeste }

enum Planeta {
  tierra(9.8),
  marte(3.7),
  jupiter(24.8);

  final double gravedad;
  const Planeta(this.gravedad);
}

void demoEnums() {
  final dir = Direccion.norte;
  print('Enum básico      : ${dir.name}');
  print('Enum con datos   : gravedad en Marte = '
      '${Planeta.marte.gravedad} m/s2');
}

/// 6.4 Null Safety
void demoNullSafety([String? apellido]) {
  // Variable NO nullable (nunca puede ser null)
  final String nombre = 'Dart';

  // Acceso seguro (?.): devuelve null sin lanzar error
  print('Acceso seguro    : ${apellido?.toUpperCase()}');

  // Operador de coalescencia (??)
  print('Coalescencia     : ${apellido ?? 'Sin apellido'}');

  // Asignación condicional (??=): asigna solo si era null
  apellido ??= 'García';
  print('Condicional ??=  : $nombre $apellido');
}

void main() {
  print('SECCIÓN 6 — Otros tipos de datos en Dart\n');
  demoRunes();
  demoSymbols();
  demoRecords();
  demoEnums();
  demoNullSafety();
}
