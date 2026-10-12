// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Sección 3.3: Ejemplo práctico con List (operaciones)
// ============================================================
// ignore_for_file: avoid_print

void main() {
  List<String> estudiantes = ['Ana', 'Luis', 'María', 'Carlos'];

  // Agregar elemento
  estudiantes.add('Pedro');
  print('Lista: $estudiantes');

  // Recorrer con forEach
  print('\nRecorrido con forEach:');
  // ignore: avoid_function_literals_in_foreach_calls
  estudiantes.forEach((e) => print('Estudiante: $e'));

  // Filtrar nombres con más de 4 letras (where)
  var largos = estudiantes.where((e) => e.length > 4).toList();
  print('\nNombres con más de 4 letras: $largos');

  // Transformar a mayúsculas (map)
  var mayusculas = estudiantes.map((e) => e.toUpperCase()).toList();
  print('En mayúsculas: $mayusculas');

  // Reducir a un solo valor (reduce)
  var totalLetras =
      estudiantes.reduce((acc, e) => '$acc + $e');
  print('reduce: $totalLetras');

  // Ordenar (sort)
  estudiantes.sort();
  print('\nLista ordenada: $estudiantes');
}
