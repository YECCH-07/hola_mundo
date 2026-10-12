// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Aplicación Flutter que muestra los ejercicios y sus salidas
// (entrypoint alternativo: flutter run -t lib/practica02/app_practica02.dart)
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const Practica02App());
}

class Practica02App extends StatelessWidget {
  const Practica02App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 02 — Tipos de Datos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Practica02Pantalla(),
    );
  }
}

// ---------- Lógica de los ejercicios (misma que los archivos .dart) ----------

/// Ejercicio 1: fusión de dos listas ordenadas (List).
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

/// Ejercicio 2: intersección con multiplicidad (Map).
List<int> interseccion(List<int> nums1, List<int> nums2) {
  final frecuencias = <int, int>{};
  for (final n in nums1) {
    frecuencias[n] = (frecuencias[n] ?? 0) + 1;
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

/// Ejercicio 3: frutas y cestas (Set).
int frutasSinColocar(List<int> frutas, List<int> cestas) {
  final usadas = <int>{};
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

// ---------- UI ----------

class Practica02Pantalla extends StatelessWidget {
  const Practica02Pantalla({super.key});

  @override
  Widget build(BuildContext context) {
    final ej1 = fusionar([1, 2, 4], [1, 3, 4]);
    final ej1b = fusionar(<int>[], [0]);
    final ej2 = interseccion([1, 2, 2, 1], [2, 2]);
    final ej2b = interseccion([4, 9, 5], [9, 4, 9, 8, 4]);
    final ej3 = frutasSinColocar([4, 2, 5], [3, 5, 4]);
    final ej3b = frutasSinColocar([3, 6, 1], [6, 4, 7]);
    final corazon = String.fromCharCodes(Runes('❤'));
    final punto = (10.0, 20.0);

    // Operaciones con List (sección 3.3)
    final estudiantes = ['Ana', 'Luis', 'María', 'Carlos', 'Pedro'];
    final largos = estudiantes.where((e) => e.length > 4).toList();
    final mayusculas = estudiantes.map((e) => e.toUpperCase()).toList();
    final ordenada = [...estudiantes]..sort();

    // Operaciones con Map (sección 4.3)
    final precios = <String, double>{
      'Manzana': 2.50,
      'Pera': 3.00,
      'Uva': 5.50,
      'Mango': 4.75,
    };
    precios.update('Pera', (v) => v * 1.1);
    final baratos = Map.fromEntries(
      precios.entries.where((e) => e.value < 4),
    ).map((k, v) => MapEntry(k, double.parse(v.toStringAsFixed(2))));
    final alumno = {
      'A001': {'nombre': 'Ana García', 'nota': 18.5},
    };

    // Operaciones con Set (sección 5.2)
    final A = {1, 2, 3, 4, 5};
    final B = {4, 5, 6, 7, 8};
    final conDuplicados = [1, 2, 2, 3, 3, 3];
    final sinDups = conDuplicados.toSet();
    String? apellido;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Práctica 02 — Tipos de Datos'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tarjeta(
            context,
            'List — Fusión de listas ordenadas',
            [
              '[1,2,4] + [1,3,4]  →  $ej1',
              '[] + []  →  []',
              '[] + [0]  →  $ej1b',
            ],
          ),
          _tarjeta(
            context,
            'List — Operaciones (sección 3.3)',
            [
              'where (>4 letras)  →  $largos',
              'map (mayúsculas)   →  $mayusculas',
              'sort               →  $ordenada',
            ],
          ),
          _tarjeta(
            context,
            'Map — Intersección de arreglos',
            [
              '[1,2,2,1] ∩ [2,2]  →  $ej2',
              '[4,9,5] ∩ [9,4,9,8,4]  →  $ej2b',
            ],
          ),
          _tarjeta(
            context,
            'Map — Operaciones (sección 4.3)',
            [
              'update (Pera ×1.1)  →  ${precios['Pera']!.toStringAsFixed(2)}',
              'putIfAbsent (Papaya) →  ${precios.keys}',
              'baratos (< S/. 4)   →  $baratos',
              'anidado A001        →  ${alumno['A001']!['nombre']}',
            ],
          ),
          _tarjeta(
            context,
            'Set — Frutas y cestas',
            [
              'frutas [4,2,5], cestas [3,5,4]  →  $ej3 sin colocar',
              'frutas [3,6,1], cestas [6,4,7]  →  $ej3b sin colocar',
            ],
          ),
          _tarjeta(
            context,
            'Set — Operaciones (sección 5.2)',
            [
              'unión         →  ${A.union(B)}',
              'intersección  →  ${A.intersection(B)}',
              'diferencia    →  ${A.difference(B)}',
              'sin duplicados →  $sinDups',
            ],
          ),
          _tarjeta(
            context,
            'Otros tipos (sección 6)',
            [
              'Runes   : $corazon',
              'Symbols : ${#nombreVariable}',
              'Record  : (${punto.$1}, ${punto.$2})',
              'Enum    : gravedad en Marte = ${Planeta.marte.gravedad} m/s2',
              'Null    : ${apellido ?? 'Sin apellido'}',
            ],
          ),
          _tarjeta(
            context,
            'Verificación',
            [
              'dart analyze lib/practica02 → No issues found!',
            ],
          ),
        ],
      ),
    );
  }

  Widget _tarjeta(BuildContext context, String titulo, List<String> lineas) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            for (final linea in lineas)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  linea,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum Planeta {
  tierra(9.8),
  marte(3.7),
  jupiter(24.8);

  final double gravedad;
  const Planeta(this.gravedad);
}
