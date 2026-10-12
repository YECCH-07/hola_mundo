// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Ejercicio 3: Frutas y cestas
// Guía: sección 5.3 "Ejercicio propuesto con conjuntos"
// ============================================================
// ignore_for_file: avoid_print

/// Coloca cada tipo de fruta en la cesta disponible más a la izquierda
/// con capacidad suficiente. Cada cesta admite un solo tipo de fruta.
/// Devuelve cuántos tipos de fruta quedan sin colocar.
int frutasSinColocar(List<int> frutas, List<int> cestas) {
  final usadas = <int>{}; // Set: índices de cestas ya ocupadas
  int sinColocar = 0;

  for (final fruta in frutas) {
    var colocada = false;
    for (var j = 0; j < cestas.length; j++) {
      // La cesta debe estar libre y tener capacidad suficiente
      if (!usadas.contains(j) && cestas[j] >= fruta) {
        usadas.add(j); // ocupa la cesta (una cesta = un tipo de fruta)
        colocada = true;
        break;
      }
    }
    if (!colocada) sinColocar++;
  }
  return sinColocar;
}

void main() {
  final ejemplos = [
    ([4, 2, 5], [3, 5, 4]), // Ejemplo 1 -> 1 tipo sin colocar
    ([3, 6, 1], [6, 4, 7]), // Ejemplo 2 -> 0 tipos sin colocar
  ];

  print('EJERCICIO 3 — Frutas y cestas\n');
  for (final (frutas, cestas) in ejemplos) {
    print('frutas = $frutas, cestas = $cestas');
    print('Tipos de fruta sin colocar: '
        '${frutasSinColocar(frutas, cestas)}\n');
  }
}
