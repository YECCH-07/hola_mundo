// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Ejercicio 2: Intersección de dos arreglos
// Guía: sección 4.5 "Ejercicio propuesto con Maps"
// ============================================================
// ignore_for_file: avoid_print

/// Devuelve la intersección de nums1 y nums2 con multiplicidad:
/// cada elemento aparece tantas veces como aparece en ambos arreglos.
List<int> interseccion(List<int> nums1, List<int> nums2) {
  // Conteo de frecuencias de nums1 usando un Map
  final frecuencias = <int, int>{};
  for (final n in nums1) {
    frecuencias[n] = (frecuencias[n] ?? 0) + 1; // null coalescing
  }

  final resultado = <int>[];
  for (final n in nums2) {
    final veces = frecuencias[n] ?? 0;
    if (veces > 0) {
      resultado.add(n);
      frecuencias[n] = veces - 1; // consume una aparición
    }
  }
  return resultado;
}

void main() {
  final ejemplos = [
    ([1, 2, 2, 1], [2, 2]), //       Ejemplo 1 -> [2, 2]
    ([4, 9, 5], [9, 4, 9, 8, 4]), // Ejemplo 2 -> [4, 9] (o [9, 4])
  ];

  print('EJERCICIO 2 — Intersección de dos arreglos\n');
  for (final (nums1, nums2) in ejemplos) {
    print('nums1 = $nums1, nums2 = $nums2');
    print('Intersección: ${interseccion(nums1, nums2)}\n');
  }
}
