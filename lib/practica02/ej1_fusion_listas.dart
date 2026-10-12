// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Ejercicio 1: Fusión de dos listas enlazadas ordenadas
// Guía: sección 3.3 "Ejercicio propuesto con List"
// ============================================================
// ignore_for_file: avoid_print

/// Nodo de una lista enlazada simple.
class Nodo {
  final int valor;
  Nodo? siguiente;

  Nodo(this.valor, [this.siguiente]);
}

/// Construye una lista enlazada a partir de una `List<int>`.
Nodo? deLista(List<int> valores) {
  Nodo? cabeza;
  Nodo? actual;
  for (final v in valores) {
    final nodo = Nodo(v);
    if (cabeza == null) {
      cabeza = nodo;
    } else {
      actual!.siguiente = nodo;
    }
    actual = nodo;
  }
  return cabeza;
}

/// Convierte una lista enlazada en una `List<int>` (para imprimir).
List<int> aLista(Nodo? cabeza) {
  final resultado = <int>[];
  var actual = cabeza;
  while (actual != null) {
    resultado.add(actual.valor);
    actual = actual.siguiente;
  }
  return resultado;
}

/// Fusiona dos listas enlazadas ordenadas en una sola lista ordenada.
/// Recorre ambas con dos punteros y va enlazando el nodo de menor valor.
Nodo? fusionar(Nodo? lista1, Nodo? lista2) {
  final centinela = Nodo(0); // nodo auxiliar para simplificar el enlace
  var cola = centinela;
  var a = lista1;
  var b = lista2;

  while (a != null && b != null) {
    if (a.valor <= b.valor) {
      cola.siguiente = a;
      a = a.siguiente;
    } else {
      cola.siguiente = b;
      b = b.siguiente;
    }
    cola = cola.siguiente!;
  }

  // El resto de la lista que aún tenga elementos
  cola.siguiente = a ?? b;
  return centinela.siguiente;
}

void main() {
  final ejemplos = [
    ([1, 2, 4], [1, 3, 4]), // Ejemplo 1 -> [1, 1, 2, 3, 4, 4]
    (<int>[], <int>[]), //     Ejemplo 2 -> []
    (<int>[], [0]), //         Ejemplo 3 -> [0]
  ];

  print('EJERCICIO 1 — Fusión de listas enlazadas ordenadas\n');
  for (final (l1, l2) in ejemplos) {
    final resultado = fusionar(deLista(l1), deLista(l2));
    print('lista1 = $l1, lista2 = $l2');
    print('Resultado: ${aLista(resultado)}\n');
  }
}
