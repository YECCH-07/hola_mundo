// ============================================================
// PRÁCTICA 06 — Diseño Responsivo y Accesible en Flutter
// Versión DartPad: LayoutBuilder, MediaQuery, grid adaptable
// y accesibilidad (Semantics)
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const Practica06App());
}

class Practica06App extends StatelessWidget {
  const Practica06App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 06',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const Vitrina(),
    );
  }
}

class Vitrina extends StatelessWidget {
  const Vitrina({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Práctica 06 — Responsivo y Accesible'),
          backgroundColor: Colors.deepOrange.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Layout'),
              Tab(text: 'Grid'),
              Tab(text: 'Semántica'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DemoLayout(),
            DemoGrid(),
            DemoSemantica(),
          ],
        ),
      ),
    );
  }
}

// 1. LayoutBuilder: layout según el espacio disponible
class DemoLayout extends StatelessWidget {
  const DemoLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final esAncho = constraints.maxWidth > 600;
        final tarjetas = [
          _tarjeta(Colors.red.shade200, Icons.phone_android, 'Móvil'),
          _tarjeta(Colors.green.shade200, Icons.tablet, 'Tablet'),
          _tarjeta(Colors.blue.shade200, Icons.desktop_windows, 'Desktop'),
        ];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Ancho: ${constraints.maxWidth.toStringAsFixed(0)} px → '
                '${esAncho ? "Row (ancho)" : "Column (móvil)"}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: esAncho
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: tarjetas,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: tarjetas,
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _tarjeta(Color color, IconData icono, String texto) {
    return Container(
      width: 130,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 32),
          const SizedBox(height: 4),
          Text(texto,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 2. Grid adaptable con columnas dinámicas
class DemoGrid extends StatelessWidget {
  const DemoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const productos = [
      ('Manzana', '🍎', Colors.red),
      ('Plátano', '🍌', Colors.amber),
      ('Uva', '🍇', Colors.purple),
      ('Sandía', '🍉', Colors.green),
      ('Naranja', '🍊', Colors.orange),
      ('Fresa', '🍓', Colors.pink),
      ('Kiwi', '🥝', Colors.lightGreen),
      ('Mango', '🥭', Colors.yellow),
    ];
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // columnas dinámicas según el ancho
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: productos.length,
      itemBuilder: (ctx, i) {
        final (nombre, emoji, color) = productos[i];
        return Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 4),
              Text(nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
}

// 3. Accesibilidad: Semantics, MergeSemantics, touch targets
class DemoSemantica extends StatefulWidget {
  const DemoSemantica({super.key});

  @override
  State<DemoSemantica> createState() => _DemoSemanticaState();
}

class _DemoSemanticaState extends State<DemoSemantica> {
  bool _recordar = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Touch target 48px con etiqueta semántica',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Semantics(
              label: 'Agregar al carrito',
              hint: 'Doble toque para agregar',
              button: true,
              child: SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto añadido al carrito'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('Icono 24px en área de 48px'),
          ],
        ),
        const SizedBox(height: 24),
        const Text('MergeSemantics',
            style: TextStyle(fontWeight: FontWeight.bold)),
        MergeSemantics(
          child: Row(
            children: [
              Checkbox(
                value: _recordar,
                onChanged: (v) => setState(() => _recordar = v ?? false),
              ),
              const Text('Recordar contraseña'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('ExcludeSemantics (decorativos)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: const [
            ExcludeSemantics(child: Icon(Icons.star, color: Colors.amber)),
            SizedBox(width: 8),
            Text('Calificación: 4.5 de 5'),
          ],
        ),
      ],
    );
  }
}
