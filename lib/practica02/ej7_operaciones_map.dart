// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Sección 4.3 y 4.4: Ejemplos prácticos con Map
// ============================================================
// ignore_for_file: avoid_print

void main() {
  // Inventario de una tienda
  Map<String, double> precios = {
    'Manzana': 2.50,
    'Pera': 3.00,
    'Uva': 5.50,
  };

  // Acceder a un valor
  print('Precio de la manzana: ${precios['Manzana']}');

  // Agregar nuevo producto
  precios['Mango'] = 4.75;
  print('Map: $precios');

  // Actualizar precio con update
  precios.update('Pera', (v) => v * 1.1);
  print('Pera con 10% de aumento: ${precios['Pera']!.toStringAsFixed(2)}');

  // Agregar solo si la clave no existe (putIfAbsent)
  precios.putIfAbsent('Papaya', () => 6.20);
  precios.putIfAbsent('Mango', () => 9.99); // ya existe: no lo agrega
  print('putIfAbsent: ${precios.keys}');

  // Iterar sobre el mapa (forEach)
  print('\nInventario:');
  precios.forEach((producto, precio) {
    print('$producto: S/. ${precio.toStringAsFixed(2)}');
  });

  // Filtrar productos baratos (entries + where)
  var baratos = Map.fromEntries(
    precios.entries.where((e) => e.value < 4),
  );
  print('\nProductos económicos (< S/. 4): $baratos');

  // Maps anidados (estructura JSON-like)
  Map<String, Map<String, dynamic>> estudiantes = {
    'A001': {
      'nombre': 'Ana García',
      'edad': 22,
      'nota': 18.5,
    },
    'A002': {
      'nombre': 'Luis Pérez',
      'edad': 24,
      'nota': 16.0,
    },
  };
  print('\nMap anidado:');
  print('A001 nombre: ${estudiantes['A001']!['nombre']}');
  print('A002 nota: ${estudiantes['A002']!['nota']}');
}
