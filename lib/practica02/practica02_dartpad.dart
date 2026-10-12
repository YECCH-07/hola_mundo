// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más (Dart)
// Versión para DartPad (un solo archivo ejecutable)
// ignore_for_file: avoid_print
// ============================================================

/// Ejercicio 1 (sección 3.3): fusión de dos listas enlazadas ordenadas (List).
List<int> fusionar(List<int> a, List<int> b) {
  final resultado = <int>[];
  int i = 0, j = 0;
  while (i < a.length && j < b.length) {
    resultado.add(a[i] <= b[j] ? a[i++] : b[j++]);
  }
  resultado.addAll(a.sublist(i));
  resultado.addAll(b.sublist(j));
  return resultado;
}

/// Ejercicio 2 (sección 4.5): intersección de dos arreglos con multiplicidad (Map).
List<int> interseccion(List<int> nums1, List<int> nums2) {
  final frecuencias = <int, int>{};
  for (final n in nums1) {
    frecuencias[n] = (frecuencias[n] ?? 0) + 1; // null coalescing
  }
  final resultado = <int>[];
  for (final n in nums2) {
    final veces = frecuencias[n] ?? 0;
    if (veces > 0) {
      resultado.add(n);
      frecuencias[n] = veces - 1;
    }
  }
  return resultado;
}

/// Ejercicio 3 (sección 5.3): frutas y cestas (Set).
int frutasSinColocar(List<int> frutas, List<int> cestas) {
  final usadas = <int>{}; // Set: índices de cestas ya ocupadas
  int sinColocar = 0;
  for (final fruta in frutas) {
    var colocada = false;
    for (var j = 0; j < cestas.length; j++) {
      if (!usadas.contains(j) && cestas[j] >= fruta) {
        usadas.add(j);
        colocada = true;
        break;
      }
    }
    if (!colocada) sinColocar++;
  }
  return sinColocar;
}

/// Sección 6.3: enumeración con propiedades.
enum Planeta {
  tierra(9.8),
  marte(3.7),
  jupiter(24.8);

  final double gravedad;
  const Planeta(this.gravedad);
}

void main() {
  print('PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más\n');

  // ---------- Sección 2: tipos de datos primitivos ----------
  print('=== Sección 2: tipos primitivos ===');
  int entero = 100;
  double decimal = 3.14159;
  num numero = 42;
  String saludo = 'Hola, Dart!';
  String interpolado = 'El valor es: $entero';
  bool esDart = true;
  var n = 10; //        inferencia de tipo en compilación
  dynamic x = 'hola'; // puede cambiar de tipo en ejecución
  x = 42;
  int? edadNula; //      el ? indica que puede ser null
  print('int: $entero | double: $decimal | num: $numero');
  print('String: $saludo | $interpolado');
  print('bool: esDart = $esDart | var: n = $n | dynamic: x = $x');
  print('null safety: edadNula = $edadNula');

  // ---------- Ejercicio 1: List ----------
  print('\n=== Ejercicio 1: fusión de listas (List) ===');
  print('fusionar([1,2,4], [1,3,4]) = ${fusionar([1, 2, 4], [1, 3, 4])}');
  print('fusionar([], [])        = ${fusionar(<int>[], <int>[])}');
  print('fusionar([], [0])       = ${fusionar(<int>[], [0])}');

  // ---------- Ejercicio 2: Map ----------
  print('\n=== Ejercicio 2: intersección de arreglos (Map) ===');
  print('interseccion([1,2,2,1], [2,2])      = '
      '${interseccion([1, 2, 2, 1], [2, 2])}');
  print('interseccion([4,9,5], [9,4,9,8,4])  = '
      '${interseccion([4, 9, 5], [9, 4, 9, 8, 4])}');

  // ---------- Ejercicio 3: Set ----------
  print('\n=== Ejercicio 3: frutas y cestas (Set) ===');
  print('frutasSinColocar([4,2,5], [3,5,4]) = '
      '${frutasSinColocar([4, 2, 5], [3, 5, 4])}');
  print('frutasSinColocar([3,6,1], [6,4,7]) = '
      '${frutasSinColocar([3, 6, 1], [6, 4, 7])}');

  // ---------- Sección 6: otros tipos ----------
  print('\n=== Sección 6: otros tipos de datos ===');
  final corazon = Runes('❤');
  print('Runes   : ${String.fromCharCodes(corazon)}');
  final sym = #nombreVariable;
  print('Symbols : $sym');
  final punto = (10.0, 20.0);
  final persona = (nombre: 'Ana', edad: 25);
  print('Records : (${punto.$1}, ${punto.$2}) y ${persona.nombre}, '
      '${persona.edad}');
  print('Enums   : gravedad en Marte = ${Planeta.marte.gravedad} m/s2');
  demoNullSafety();
}

/// Sección 6.4: Null Safety (acceso seguro ?., coalescencia ?? y ??=).
void demoNullSafety([String? apellido]) {
  print('Null    : ${apellido?.toUpperCase()} | '
      '${apellido ?? 'Sin apellido'}');
  apellido ??= 'García';
  print('??=     : $apellido');
}
