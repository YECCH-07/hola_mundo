// ============================================================
// PRÁCTICA 06 — Diseño Responsivo y Accesible en Flutter
// Demostración: LayoutBuilder, MediaQuery, FractionallySizedBox,
// Flex/Expanded, grid adaptable, navegación adaptativa,
// touch targets, Semantics, MergeSemantics y anuncios
// (entrypoint: flutter run -t lib/practica06/app_practica06.dart)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

void main() {
  runApp(const Practica06App());
}

class Practica06App extends StatelessWidget {
  const Practica06App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 06 — Responsivo y Accesible',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const PantallaInicio(),
    );
  }
}

// ---------- Breakpoints centralizados (guía, sección 2) ----------

class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1440;

  static bool isMobile(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width < mobile;

  static bool isTablet(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    return w >= mobile && w < desktop;
  }

  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width >= desktop;
}

// ---------- Menú principal ----------

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final opciones = [
      (Icons.aspect_ratio, '1. LayoutBuilder', const PantallaLayoutBuilder()),
      (Icons.info_outline, '2. MediaQuery', const PantallaMediaQuery()),
      (Icons.zoom_out_map, '3. Tamaños proporcionales',
          const PantallaProporcional()),
      (Icons.grid_view, '4. Grid adaptable', const PantallaGrid()),
      (Icons.navigation, '5. Navegación adaptativa',
          const PantallaAdaptativa()),
      (Icons.accessibility, '6. Accesibilidad y semántica',
          const PantallaAccesible()),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 06 — Responsivo y Accesible'),
        backgroundColor: Colors.deepOrange.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          for (final (icono, titulo, pantalla) in opciones)
            ListTile(
              leading: Icon(icono, color: Colors.deepOrange),
              title: Text(titulo),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => pantalla),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------- 1. LayoutBuilder ----------

class PantallaLayoutBuilder extends StatelessWidget {
  const PantallaLayoutBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1. LayoutBuilder')),
      body: LayoutBuilder(
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
                  'Ancho disponible: ${constraints.maxWidth.toStringAsFixed(0)} px '
                  '→ ${esAncho ? "Row (ancho)" : "Column (móvil)"}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              // Mismo contenido, distinto layout según el espacio
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
      ),
    );
  }

  Widget _tarjeta(Color color, IconData icono, String texto) {
    return Container(
      width: 160,
      height: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 40),
          const SizedBox(height: 6),
          Text(texto,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---------- 2. MediaQuery ----------

class PantallaMediaQuery extends StatelessWidget {
  const PantallaMediaQuery({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final orientacion = MediaQuery.orientationOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return Scaffold(
      appBar: AppBar(title: const Text('2. MediaQuery')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dato('Ancho de pantalla', '${size.width.toStringAsFixed(0)} px'),
            _dato('Alto de pantalla', '${size.height.toStringAsFixed(0)} px'),
            _dato('Orientación',
                orientacion == Orientation.landscape ? 'Landscape' : 'Portrait'),
            _dato('Escala de texto', '${textScale.toStringAsFixed(2)}x'),
            _dato('¿Es móvil?', '${Breakpoints.isMobile(context)}'),
            _dato('¿Es tablet?', '${Breakpoints.isTablet(context)}'),
            _dato('¿Es desktop?', '${Breakpoints.isDesktop(context)}'),
            const SizedBox(height: 12),
            const Text('Gira el dispositivo para ver los cambios',
                style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _dato(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$etiqueta: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(valor, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// ---------- 3. FractionallySizedBox y Flex ----------

class PantallaProporcional extends StatelessWidget {
  const PantallaProporcional({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3. Tamaños proporcionales')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('FractionallySizedBox (80% del ancho)'),
            const SizedBox(height: 8),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Continuar'),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Expanded con flex 2 : 1'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Buscar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- 4. Grid adaptable ----------

class PantallaGrid extends StatelessWidget {
  const PantallaGrid({super.key});

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
    return Scaffold(
      appBar: AppBar(title: const Text('4. Grid adaptable')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200, // ancho máximo por celda → columnas dinámicas
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
                Text(emoji, style: const TextStyle(fontSize: 44)),
                const SizedBox(height: 6),
                Text(nombre,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------- 5. Navegación adaptativa ----------

class PantallaAdaptativa extends StatefulWidget {
  const PantallaAdaptativa({super.key});

  @override
  State<PantallaAdaptativa> createState() => _PantallaAdaptativaState();
}

class _PantallaAdaptativaState extends State<PantallaAdaptativa> {
  int _indice = 0;

  static const _paginas = [
    _PaginaSimple(Icons.home, 'Inicio'),
    _PaginaSimple(Icons.shopping_cart, 'Productos'),
    _PaginaSimple(Icons.person, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    final esAncho = ancho >= 600; // breakpoint de navegación
    return Scaffold(
      appBar: AppBar(
        title: Text('5. Navegación adaptativa ($ancho px)'),
      ),
      body: Row(
        children: [
          if (esAncho)
            NavigationRail(
              selectedIndex: _indice,
              onDestinationSelected: (i) => setState(() => _indice = i),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Inicio')),
                NavigationRailDestination(
                    icon: Icon(Icons.shopping_cart),
                    label: Text('Productos')),
                NavigationRailDestination(
                    icon: Icon(Icons.person), label: Text('Perfil')),
              ],
            ),
          Expanded(child: _paginas[_indice]),
        ],
      ),
      bottomNavigationBar: esAncho
          ? null
          : BottomNavigationBar(
              currentIndex: _indice,
              onTap: (i) => setState(() => _indice = i),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart), label: 'Productos'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Perfil'),
              ],
            ),
    );
  }
}

class _PaginaSimple extends StatelessWidget {
  final IconData icono;
  final String titulo;
  const _PaginaSimple(this.icono, this.titulo);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, size: 80, color: Colors.deepOrange),
          const SizedBox(height: 12),
          Text(titulo,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---------- 6. Accesibilidad y semántica ----------

class PantallaAccesible extends StatefulWidget {
  const PantallaAccesible({super.key});

  @override
  State<PantallaAccesible> createState() => _PantallaAccesibleState();
}

class _PantallaAccesibleState extends State<PantallaAccesible> {
  bool _recordar = false;
  bool _debugger = false;

  @override
  Widget build(BuildContext context) {
    final contenido = ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Touch targets de 48×48 px',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            // Ícono 24px dentro de un área de toque de 48px con etiqueta semántica
            Semantics(
              label: 'Agregar al carrito',
              hint: 'Doble toque para agregar',
              button: true,
              child: SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: () {
                    SemanticsService.sendAnnouncement(
                        View.of(context),
                        'Producto añadido al carrito',
                        TextDirection.ltr);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto añadido al carrito'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('IconButton 24px en área de toque 48px'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('MergeSemantics (checkbox + texto)',
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
        const Text(
            'El lector de pantalla lee: "Recordar contraseña, casilla de verificación"'),
        const SizedBox(height: 24),
        const Text('ExcludeSemantics (decorativos)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            const ExcludeSemantics(
              child: Icon(Icons.star, color: Colors.amber),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Calificación: 4.5 de 5 (la estrella no se lee)'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Semantics(
          liveRegion: true,
          child: Text(_recordar ? 'Contraseña recordada' : ''),
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Mostrar árbol semántico (SemanticsDebugger)'),
          value: _debugger,
          onChanged: (v) => setState(() => _debugger = v),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('6. Accesibilidad y semántica')),
      body: _debugger ? SemanticsDebugger(child: contenido) : contenido,
    );
  }
}
