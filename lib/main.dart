// ============================================================
// DESARROLLO DE SOFTWARE II — LABORATORIO
// App única: Carrito de Compras
// Integra las herramientas de las prácticas 01–06:
//  P01 proyecto Flutter · P02 Map/List/Set en el modelo ·
//  P03 tarjeta de perfil, contadores y calculadora ·
//  P04 widgets y feedback · P05 eventos y validación ·
//  P06 diseño responsivo y accesible
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'modelos.dart';

void main() {
  runApp(const TiendaApp());
}

class TiendaApp extends StatefulWidget {
  const TiendaApp({super.key});

  @override
  State<TiendaApp> createState() => _TiendaAppState();
}

class _TiendaAppState extends State<TiendaApp> {
  // Guía 06: preferencias de accesibilidad
  bool _modoOscuro = false;
  bool _textoGrande = false;
  bool _depuradorSemantico = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrito de Compras',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Guía 06: alternar entre tema claro y oscuro
      themeMode: _modoOscuro ? ThemeMode.dark : ThemeMode.light,
      builder: (context, child) {
        Widget app = child!;
        // Guía 06: texto escalable — se amplía sin bloquear el escalado
        // del sistema y se limita a un máximo razonable (1.0–1.4).
        if (_textoGrande) {
          app = MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.4),
              ),
            ),
            child: app,
          );
        }
        // Guía 06: herramienta de prueba — árbol semántico visible
        if (_depuradorSemantico) {
          app = SemanticsDebugger(child: app);
        }
        return app;
      },
      home: InicioTienda(
        modoOscuro: _modoOscuro,
        textoGrande: _textoGrande,
        depuradorSemantico: _depuradorSemantico,
        onModoOscuro: (v) => setState(() => _modoOscuro = v),
        onTextoGrande: (v) => setState(() => _textoGrande = v),
        onDepuradorSemantico: (v) => setState(() => _depuradorSemantico = v),
      ),
    );
  }
}

// ---------- Raíz: estado compartido y navegación adaptativa ----------

class InicioTienda extends StatefulWidget {
  final bool modoOscuro;
  final bool textoGrande;
  final bool depuradorSemantico;
  final ValueChanged<bool> onModoOscuro;
  final ValueChanged<bool> onTextoGrande;
  final ValueChanged<bool> onDepuradorSemantico;

  const InicioTienda({
    super.key,
    required this.modoOscuro,
    required this.textoGrande,
    required this.depuradorSemantico,
    required this.onModoOscuro,
    required this.onTextoGrande,
    required this.onDepuradorSemantico,
  });

  @override
  State<InicioTienda> createState() => _InicioTiendaState();
}

class _InicioTiendaState extends State<InicioTienda> {
  int _indice = 0;

  /// Carrito: `Map<String, int>` (id del producto → cantidad) — P02 Map
  final Map<String, int> _carrito = {};

  /// Favoritos: `Set<String>` — P02 Set
  final Set<String> _favoritos = {};

  int get _totalArticulos => _carrito.isEmpty
      ? 0
      : _carrito.values.reduce((a, b) => a + b); // P02 reduce

  double get _totalPrecio => _carrito.entries.fold(
        0.0,
        (suma, e) => suma + catalogo[e.key]!.precio * e.value,
      );

  void _agregar(Producto p) {
    setState(() => _carrito[p.id] = (_carrito[p.id] ?? 0) + 1);
  }

  void _quitar(Producto p) {
    setState(() {
      final actual = _carrito[p.id] ?? 0;
      if (actual <= 1) {
        _carrito.remove(p.id);
      } else {
        _carrito[p.id] = actual - 1;
      }
    });
  }

  void _vaciar() {
    setState(() => _carrito.clear());
  }

  @override
  Widget build(BuildContext context) {
    final esAncho = MediaQuery.sizeOf(context).width >= 600; // P06 breakpoint

    final pantallas = [
      PantallaTienda(
        favoritos: _favoritos,
        onAgregar: _agregar,
        onFavorito: (p) => setState(() {
          _favoritos.contains(p.id)
              ? _favoritos.remove(p.id)
              : _favoritos.add(p.id);
        }),
      ),
      PantallaCarrito(
        carrito: _carrito,
        totalArticulos: _totalArticulos,
        totalPrecio: _totalPrecio,
        onQuitar: _quitar,
        onAgregar: _agregar,
        onVaciar: _vaciar,
      ),
      const PantallaCalculadora(),
      PantallaPerfil(
        modoOscuro: widget.modoOscuro,
        textoGrande: widget.textoGrande,
        depuradorSemantico: widget.depuradorSemantico,
        onModoOscuro: widget.onModoOscuro,
        onTextoGrande: widget.onTextoGrande,
        onDepuradorSemantico: widget.onDepuradorSemantico,
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          // P06: NavigationRail en pantallas anchas
          if (esAncho)
            NavigationRail(
              selectedIndex: _indice,
              onDestinationSelected: (i) => setState(() => _indice = i),
              labelType: NavigationRailLabelType.all,
              destinations: [
                const NavigationRailDestination(
                    icon: Icon(Icons.storefront), label: Text('Tienda')),
                NavigationRailDestination(
                    icon: Badge(
                        label: Text('$_totalArticulos'),
                        isLabelVisible: _totalArticulos > 0,
                        child: const Icon(Icons.shopping_cart)),
                    label: const Text('Carrito')),
                const NavigationRailDestination(
                    icon: Icon(Icons.calculate), label: Text('Calculadora')),
                const NavigationRailDestination(
                    icon: Icon(Icons.person), label: Text('Perfil')),
              ],
            ),
          Expanded(child: pantallas[_indice]),
        ],
      ),
      // P06: BottomNavigationBar en móvil — colores del tema para
      // mantener contraste suficiente en modo claro y oscuro
      bottomNavigationBar: esAncho
          ? null
          : BottomNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor:
                  Theme.of(context).colorScheme.onSurfaceVariant,
              currentIndex: _indice,
              onTap: (i) => setState(() => _indice = i),
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.storefront), label: 'Tienda'),
                BottomNavigationBarItem(
                  icon: Badge(
                      label: Text('$_totalArticulos'),
                      isLabelVisible: _totalArticulos > 0,
                      child: const Icon(Icons.shopping_cart)),
                  label: 'Carrito',
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.calculate), label: 'Calculadora'),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Perfil'),
              ],
            ),
    );
  }
}

// ---------- Tienda: catálogo con chips, grid adaptable y eventos ----------

class PantallaTienda extends StatefulWidget {
  final Set<String> favoritos;
  final void Function(Producto) onAgregar;
  final void Function(Producto) onFavorito;

  const PantallaTienda({
    super.key,
    required this.favoritos,
    required this.onAgregar,
    required this.onFavorito,
  });

  @override
  State<PantallaTienda> createState() => _PantallaTiendaState();
}

class _PantallaTiendaState extends State<PantallaTienda> {
  String _categoria = 'Todas';

  @override
  Widget build(BuildContext context) {
    // P02: filtrar con where + Set de categorías
    final visibles = _categoria == 'Todas'
        ? productos
        : productos.where((p) => p.categoria == _categoria).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Carrito de Compras'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // P04: FilterChip por categoría (P05: evento onSelected)
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              children: [
                for (final c in ['Todas', ...categorias])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(c),
                      selected: _categoria == c,
                      selectedColor: Colors.teal.shade100,
                      checkmarkColor: Colors.teal,
                      onSelected: (_) =>
                          setState(() => _categoria = c),
                    ),
                  ),
              ],
            ),
          ),
          // P06: grid adaptable (columnas dinámicas según el ancho)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                childAspectRatio: 0.86,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: visibles.length,
              itemBuilder: (ctx, i) => _TarjetaProducto(
                producto: visibles[i],
                esFavorito: widget.favoritos.contains(visibles[i].id),
                onAgregar: widget.onAgregar,
                onFavorito: widget.onFavorito,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaProducto extends StatelessWidget {
  final Producto producto;
  final bool esFavorito;
  final void Function(Producto) onAgregar;
  final void Function(Producto) onFavorito;

  const _TarjetaProducto({
    required this.producto,
    required this.esFavorito,
    required this.onAgregar,
    required this.onFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // P05 Ej6: doble toque para marcar favorito
            GestureDetector(
              onDoubleTap: () => onFavorito(producto),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // P06: ExcludeSemantics para el emoji decorativo
                      ExcludeSemantics(
                        child: Text(producto.emoji,
                            style: const TextStyle(fontSize: 40)),
                      ),
                      // P04: icono de favorito (P05: evento onPressed)
                      Semantics(
                        label: esFavorito
                            ? 'Quitar ${producto.nombre} de favoritos'
                            : 'Agregar ${producto.nombre} a favoritos',
                        button: true,
                        child: SizedBox(
                          width: 48, // P06: touch target de 48 px
                          height: 48,
                          child: IconButton(
                            onPressed: () => onFavorito(producto),
                            icon: Icon(
                              esFavorito
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: esFavorito ? Colors.red : Colors.grey,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'S/. ${producto.precio.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            // P05: evento add-to-cart + P06: anuncio semántico
            Semantics(
              label: 'Agregar ${producto.nombre} al carrito',
              button: true,
              child: SizedBox(
                width: double.infinity,
                height: 44, // P06: touch target mínimo 44 px
                child: ElevatedButton(
                  onPressed: () {
                    onAgregar(producto);
                    // P06: anuncio dinámico para lectores de pantalla
                    SemanticsService.sendAnnouncement(
                      View.of(context),
                      '${producto.nombre} añadido al carrito',
                      TextDirection.ltr,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${producto.nombre} añadido al carrito'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('Agregar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Carrito: lista, contadores, total y validación ----------

class PantallaCarrito extends StatefulWidget {
  final Map<String, int> carrito;
  final int totalArticulos;
  final double totalPrecio;
  final void Function(Producto) onQuitar;
  final void Function(Producto) onAgregar;
  final VoidCallback onVaciar;

  const PantallaCarrito({
    super.key,
    required this.carrito,
    required this.totalArticulos,
    required this.totalPrecio,
    required this.onQuitar,
    required this.onAgregar,
    required this.onVaciar,
  });

  @override
  State<PantallaCarrito> createState() => _PantallaCarritoState();
}

class _PantallaCarritoState extends State<PantallaCarrito> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    super.dispose();
  }

  void _finalizar() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('¡Compra realizada!'),
          content: Text(
              'Gracias ${_nombre.text}, tu pedido de '
              'S/. ${widget.totalPrecio.toStringAsFixed(2)} llegará pronto.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onVaciar();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: Text('Carrito (${widget.totalArticulos})'),
        centerTitle: true,
        actions: [
          if (widget.carrito.isNotEmpty)
            IconButton(
              tooltip: 'Vaciar carrito',
              onPressed: () => widget.onVaciar(),
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: widget.carrito.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Tu carrito está vacío'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // P02: recorrer el Map con entries
                for (final e in widget.carrito.entries)
                  _FilaCarrito(
                    producto: catalogo[e.key]!,
                    cantidad: e.value,
                    onQuitar: widget.onQuitar,
                    onAgregar: widget.onAgregar,
                  ),
                const Divider(height: 24),
                // P02: total con reduce/fold + P06: liveRegion
                Semantics(
                  liveRegion: true,
                  child: Text(
                    'Total (${widget.totalArticulos} artículos): '
                    'S/. ${widget.totalPrecio.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                // P05 Ej8: formulario con validación
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nombre,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'El nombre es obligatorio'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _correo,
                        decoration: const InputDecoration(
                          labelText: 'Correo',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'El correo es obligatorio';
                          }
                          if (!v.contains('@')) {
                            return 'Correo no válido (falta @)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        onPressed: _finalizar,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Finalizar compra'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _FilaCarrito extends StatelessWidget {
  final Producto producto;
  final int cantidad;
  final void Function(Producto) onQuitar;
  final void Function(Producto) onAgregar;

  const _FilaCarrito({
    required this.producto,
    required this.cantidad,
    required this.onQuitar,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: ExcludeSemantics(
          child: Text(producto.emoji, style: const TextStyle(fontSize: 28)),
        ),
        title: Text(producto.nombre),
        subtitle: Text('S/. ${(producto.precio * cantidad).toStringAsFixed(2)}'),
        // P03 contador + P05 eventos + P06 touch targets
        // P06: MergeSemantics — el lector lee el grupo como una unidad
        trailing: MergeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Semantics(
              label: 'Quitar ${producto.nombre}',
              button: true,
              child: SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: () => onQuitar(producto),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
              ),
            ),
            Text('$cantidad',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Semantics(
              label: 'Agregar ${producto.nombre}',
              button: true,
              child: SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: () => onAgregar(producto),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

// ---------- Calculadora (Práctica 03) ----------

class PantallaCalculadora extends StatefulWidget {
  const PantallaCalculadora({super.key});

  @override
  State<PantallaCalculadora> createState() => _PantallaCalculadoraState();
}

class _PantallaCalculadoraState extends State<PantallaCalculadora> {
  String _display = '0';
  double _operando1 = 0;
  String _operacion = '';
  bool _nuevoNumero = true;

  void _pulsarDigito(String d) {
    setState(() {
      _display = _nuevoNumero ? d : _display + d;
      _nuevoNumero = false;
    });
  }

  void _pulsarOperacion(String op) {
    setState(() {
      _operando1 = double.parse(_display);
      _operacion = op;
      _nuevoNumero = true;
    });
  }

  void _pulsarIgual() {
    setState(() {
      final b = double.parse(_display);
      double resultado;
      switch (_operacion) {
        case '+':
          resultado = _operando1 + b;
        case '-':
          resultado = _operando1 - b;
        case '×':
          resultado = _operando1 * b;
        case '÷':
          resultado = b == 0 ? 0 : _operando1 / b;
        default:
          resultado = b;
      }
      _display = resultado == resultado.roundToDouble()
          ? resultado.toInt().toString()
          : resultado.toString();
      _operacion = '';
      _nuevoNumero = true;
    });
  }

  void _pulsarC() {
    setState(() {
      _display = '0';
      _operando1 = 0;
      _operacion = '';
      _nuevoNumero = true;
    });
  }

  /// El color del display cambia según el resultado:
  /// positivo (azul), negativo (rojo) o cero (gris).
  Color get _colorDisplay {
    final v = double.tryParse(_display) ?? 0;
    if (v > 0) return Colors.blue;
    if (v < 0) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    const botones = [
      'C', '÷', '×', '-', //
      '7', '8', '9', '+', //
      '4', '5', '6', '⌫', //
      '1', '2', '3', '=', //
      '0', '.', '±', '%', //
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Calculadora'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Semantics(
              label: 'Resultado',
              liveRegion: true,
              child: Text(
                _display,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: _colorDisplay,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(12),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                for (final b in botones)
                  Material(
                    color: ['C', '=', '⌫', '%', '±'].contains(b)
                        ? Colors.teal.shade700
                        : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        if (b == 'C') {
                          _pulsarC();
                        } else if (b == '=') {
                          _pulsarIgual();
                        } else if (b == '⌫') {
                          setState(() {
                            if (!_nuevoNumero && _display.length > 1) {
                              _display =
                                  _display.substring(0, _display.length - 1);
                            } else if (!_nuevoNumero) {
                              _display = '0';
                              _nuevoNumero = true;
                            }
                          });
                        } else if (b == '±') {
                          setState(() {
                            final v = double.parse(_display);
                            _display = v == 0 ? '0' : (-v).toString();
                          });
                        } else if (b == '%') {
                          setState(() {
                            _display =
                                (double.parse(_display) / 100).toString();
                          });
                        } else if (b == '.') {
                          setState(() {
                            if (_nuevoNumero) {
                              _display = '0.';
                              _nuevoNumero = false;
                            } else if (!_display.contains('.')) {
                              _display += '.';
                            }
                          });
                        } else if ('+-×÷'.contains(b)) {
                          _pulsarOperacion(b);
                        } else {
                          _pulsarDigito(b);
                        }
                      },
                      child: Center(
                        child: Text(
                          b,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: ['C', '=', '⌫', '%', '±'].contains(b)
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Perfil (Práctica 03: tarjeta de perfil + Guía 06: accesibilidad) ----------

class PantallaPerfil extends StatelessWidget {
  final bool modoOscuro;
  final bool textoGrande;
  final bool depuradorSemantico;
  final ValueChanged<bool> onModoOscuro;
  final ValueChanged<bool> onTextoGrande;
  final ValueChanged<bool> onDepuradorSemantico;

  const PantallaPerfil({
    super.key,
    required this.modoOscuro,
    required this.textoGrande,
    required this.depuradorSemantico,
    required this.onModoOscuro,
    required this.onTextoGrande,
    required this.onDepuradorSemantico,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.teal.shade200,
                    child: const Icon(Icons.person,
                        size: 70, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text('Yeison Emerson Ccoscco Chahua',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Ingeniería Informática',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant)),
                  const Divider(height: 32),
                  // P06: LayoutBuilder — las estadísticas se adaptan
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final estadisticas = [
                        const _Estadistica(valor: '6', etiqueta: 'Prácticas'),
                        const _Estadistica(
                            valor: '100%', etiqueta: 'Entregas'),
                        const _Estadistica(
                            valor: '184193', etiqueta: 'Código'),
                      ];
                      return constraints.maxWidth > 300
                          ? Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: estadisticas,
                            )
                          : Column(children: estadisticas);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message),
                    label: const Text('Enviar Mensaje'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Guía 06: configuración de accesibilidad
          Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.accessibility_new, color: Colors.teal),
                  title: Text('Accesibilidad (Guía 06)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('Modo oscuro'),
                  subtitle: const Text('Alterna entre tema claro y oscuro'),
                  value: modoOscuro,
                  onChanged: onModoOscuro,
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.text_increase),
                  title: const Text('Texto grande'),
                  subtitle: const Text(
                      'Amplía el texto sin bloquear el escalado del sistema'),
                  value: textoGrande,
                  onChanged: onTextoGrande,
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.visibility),
                  title: const Text('Árbol semántico'),
                  subtitle: const Text(
                      'SemanticsDebugger: muestra las etiquetas para lectores de pantalla'),
                  value: depuradorSemantico,
                  onChanged: onDepuradorSemantico,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Estadistica extends StatelessWidget {
  final String valor;
  final String etiqueta;
  const _Estadistica({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(valor,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal)),
        Text(etiqueta, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}
