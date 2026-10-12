// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Sección 5.2: Operaciones de conjuntos (Set)
// ============================================================
// ignore_for_file: avoid_print

void main() {
  Set<int> A = {1, 2, 3, 4, 5};
  Set<int> B = {4, 5, 6, 7, 8};

  print('A = $A');
  print('B = $B');

  // Unión
  print('\nUnión:          ${A.union(B)}');

  // Intersección
  print('Intersección:   ${A.intersection(B)}');

  // Diferencia
  print('Diferencia A-B: ${A.difference(B)}');

  // Subconjunto (containsAll)
  Set<int> C = {1, 2};
  print('¿C es subconjunto de A? ${A.containsAll(C)}');

  // Agregar elemento (ignorado si ya existe)
  A.add(6);
  A.addAll({7, 8});
  print('\nA después de add(6) y addAll({7, 8}): $A');

  // Sin duplicados automáticamente
  final conDuplicados = [1, 2, 2, 3, 3, 3];
  Set<int> sinDups = conDuplicados.toSet();
  print('Set elimina duplicados: $sinDups');
}
