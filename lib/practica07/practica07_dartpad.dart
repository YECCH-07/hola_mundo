// ============================================================
// PRÁCTICA 07 — Formularios y manejo de datos (versión DartPad)
// Versión autocontenida de la práctica: incluye los modelos,
// los validadores con expresiones regulares y las dos pantallas.
// Ejercicio 1: registro y autenticación avanzado.
// Ejercicio 2: inventario CRUD local.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const Practica07App());

// ============================================================
// MODELOS
// ============================================================

class Usuario {
  final String nombreCompleto;
  final String email;
  final int edad;
  final bool aceptaTerminos;

  const Usuario({
    required this.nombreCompleto,
    required this.email,
    required this.edad,
    required this.aceptaTerminos,
  });

  Usuario copyWith({
    String? nombreCompleto,
    String? email,
    int? edad,
    bool? aceptaTerminos,
  }) {
    return Usuario(
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      email: email ?? this.email,
      edad: edad ?? this.edad,
      aceptaTerminos: aceptaTerminos ?? this.aceptaTerminos,
    );
  }

  Map<String, dynamic> toMap() => {
        'nombreCompleto': nombreCompleto,
        'email': email,
        'edad': edad,
        'aceptaTerminos': aceptaTerminos,
      };
}

class Producto {
  final String id;
  final String nombre;
  final String emoji;
  final double precio;
  final String categoria;
  final int cantidad;

  const Producto({
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.precio,
    required this.categoria,
    this.cantidad = 0,
  });
}

// ============================================================
// VALIDADORES CON EXPRESIONES REGULARES
// ============================================================

final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

final RegExp passwordRegex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');

String? validarCorreo(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo es obligatorio';
  } else if (!emailRegex.hasMatch(value)) {
    return 'Ingrese un formato de correo electrónico válido';
  }
  return null;
}

String? validarContrasena(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  } else if (!passwordRegex.hasMatch(value)) {
    return 'Debe tener mínimo 8 caracteres, incluir mayúscula, minúscula y número';
  }
  return null;
}

String? validarNombreCompleto(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre completo es obligatorio';
  }
  if (value.trim().length < 3) {
    return 'Ingrese su nombre completo';
  }
  return null;
}

String? validarEdad(String? value) {
  if (value == null || value.isEmpty) {
    return 'La edad es obligatoria';
  }
  final edad = int.tryParse(value);
  if (edad == null || edad <= 0) {
    return 'Ingrese una edad válida';
  }
  return null;
}

String? validarNombreProducto(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre del producto es obligatorio';
  }
  if (value.trim().length <= 3) {
    return 'El nombre debe tener más de 3 caracteres';
  }
  return null;
}

String? validarCantidad(String? value) {
  if (value == null || value.isEmpty) {
    return 'La cantidad es obligatoria';
  }
  final cantidad = int.tryParse(value);
  if (cantidad == null || cantidad <= 0) {
    return 'La cantidad debe ser mayor a cero';
  }
  return null;
}

String? validarPrecio(String? value) {
  if (value == null || value.isEmpty) {
    return 'El precio es obligatorio';
  }
  final precio = double.tryParse(value.replaceAll(',', '.'));
  if (precio == null || precio <= 0) {
    return 'Ingrese un precio válido mayor que cero';
  }
  return null;
}

// ============================================================
// APLICACIÓN
// ============================================================

class Practica07App extends StatelessWidget {
  const Practica07App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Práctica 07',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indice = 0;

  Usuario? _usuario;
  final List<Producto> _inventario = [];

  void _registrarUsuario(Usuario u) => setState(() => _usuario = u);

  void _agregarAlInventario(Producto p) => setState(() => _inventario.add(p));

  void _eliminarDelInventario(Producto p) {
    setState(() => _inventario.removeWhere((x) => x.id == p.id));
  }

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      PantallaRegistro(usuarioInicial: _usuario, onRegistrado: _registrarUsuario),
      PantallaInventario(
        productos: _inventario,
        onAgregar: _agregarAlInventario,
        onEliminar: _eliminarDelInventario,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _indice, children: pantallas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _indice = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1),
            label: 'Registro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventario',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EJERCICIO 1 — REGISTRO Y AUTENTICACIÓN AVANZADO
// ============================================================

class PantallaRegistro extends StatefulWidget {
  final Usuario? usuarioInicial;
  final void Function(Usuario) onRegistrado;

  const PantallaRegistro({
    super.key,
    this.usuarioInicial,
    required this.onRegistrado,
  });

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _edad = TextEditingController();
  final _contrasena = TextEditingController();
  final _confirmar = TextEditingController();

  bool _obscurecer = true;
  bool _aceptaTerminos = false;
  Usuario? _registrado;

  @override
  void initState() {
    super.initState();
    final u = widget.usuarioInicial;
    if (u != null) {
      _nombre.text = u.nombreCompleto;
      _correo.text = u.email;
      _edad.text = '${u.edad}';
      _aceptaTerminos = u.aceptaTerminos;
    }
  }

  @override
  void dispose() {
    // Liberar los controladores para evitar fugas de memoria.
    _nombre.dispose();
    _correo.dispose();
    _edad.dispose();
    _contrasena.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  void _enviar() {
    // Si la validación falla no se ejecuta ninguna acción.
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final usuario = Usuario(
      nombreCompleto: _nombre.text.trim(),
      email: _correo.text.trim(),
      edad: int.parse(_edad.text),
      aceptaTerminos: _aceptaTerminos,
    );
    widget.onRegistrado(usuario);
    setState(() => _registrado = usuario);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Registro exitoso para ${usuario.email}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final editando = widget.usuarioInicial != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: Text(editando ? 'Editar cuenta' : 'Crear cuenta'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      editando ? 'Datos de la cuenta' : 'Registro de usuario',
                      style: tema.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Formulario con GlobalKey, expresiones regulares y '
                      'verificación en tiempo real',
                      style: TextStyle(fontSize: 12.5),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nombre,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: validarNombreCompleto,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _correo,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'nombre@dominio.com',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: validarCorreo,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _edad,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Edad',
                        prefixIcon: Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: validarEdad,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contrasena,
                      obscureText: _obscurecer,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        helperText:
                            'Mínimo 8 caracteres: mayúscula, minúscula y número',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _obscurecer
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          icon: Icon(
                            _obscurecer
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () =>
                              setState(() => _obscurecer = !_obscurecer),
                        ),
                      ),
                      validator: validarContrasena,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmar,
                      obscureText: _obscurecer,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña',
                        prefixIcon: Icon(Icons.lock_reset),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Confirme su contraseña';
                        }
                        if (v != _contrasena.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    AnimatedBuilder(
                      animation: Listenable.merge([_contrasena, _confirmar]),
                      builder: (context, _) {
                        if (_confirmar.text.isEmpty) {
                          return const Text(
                            'La confirmación se verifica en tiempo real',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          );
                        }
                        final coincide = _confirmar.text == _contrasena.text;
                        return Text(
                          coincide
                              ? '✓ Las contraseñas coinciden'
                              : '✗ Las contraseñas no coinciden',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: coincide
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _CampoTerminos(
                      valorInicial: _aceptaTerminos,
                      onChanged: (v) => setState(() => _aceptaTerminos = v),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: _enviar,
                        icon: const Icon(Icons.how_to_reg),
                        label: Text(
                          editando ? 'Guardar cambios' : 'Registrarme',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_registrado != null) ...[
            const SizedBox(height: 12),
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green.shade700),
                title: const Text('Cuenta registrada'),
                subtitle: Text(
                  '${_registrado!.nombreCompleto} · '
                  '${_registrado!.email} · ${_registrado!.edad} años',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Checkbox que participa en la validación del Form.
class _CampoTerminos extends FormField<bool> {
  _CampoTerminos({
    required bool valorInicial,
    required ValueChanged<bool> onChanged,
  }) : super(
          initialValue: valorInicial,
          validator: (v) =>
              (v ?? false) ? null : 'Debe aceptar los términos y condiciones',
          builder: (field) {
            final marcado = field.value ?? false;
            final colorError = Theme.of(field.context).colorScheme.error;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: marcado,
                      onChanged: (v) {
                        field.didChange(v ?? false);
                        onChanged(v ?? false);
                      },
                    ),
                    const Expanded(
                      child: Text('Acepto los términos y condiciones'),
                    ),
                  ],
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(color: colorError, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}

// ============================================================
// EJERCICIO 2 — INVENTARIO CRUD LOCAL
// ============================================================

class PantallaInventario extends StatefulWidget {
  final List<Producto> productos;
  final void Function(Producto) onAgregar;
  final void Function(Producto) onEliminar;

  const PantallaInventario({
    super.key,
    required this.productos,
    required this.onAgregar,
    required this.onEliminar,
  });

  @override
  State<PantallaInventario> createState() => _PantallaInventarioState();
}

class _PantallaInventarioState extends State<PantallaInventario> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _cantidad = TextEditingController();
  final _precio = TextEditingController();
  String? _categoria;

  static const _categorias = ['Electrónica', 'Hogar', 'Alimentos', 'Ropa'];

  @override
  void dispose() {
    _nombre.dispose();
    _cantidad.dispose();
    _precio.dispose();
    super.dispose();
  }

  String _emojiDe(String categoria) {
    switch (categoria) {
      case 'Electrónica':
        return '🔌';
      case 'Hogar':
        return '🏠';
      case 'Alimentos':
        return '🍎';
      case 'Ropa':
        return '👕';
      default:
        return '📦';
    }
  }

  void _agregarProducto() {
    if (!_formKey.currentState!.validate()) return;

    final producto = Producto(
      id: 'inv_${DateTime.now().microsecondsSinceEpoch}',
      nombre: _nombre.text.trim(),
      emoji: _emojiDe(_categoria!),
      precio: double.parse(_precio.text.replaceAll(',', '.')),
      categoria: _categoria!,
      cantidad: int.parse(_cantidad.text),
    );
    widget.onAgregar(producto);

    _formKey.currentState!.reset();
    _nombre.clear();
    _cantidad.clear();
    _precio.clear();
    setState(() => _categoria = null);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${producto.nombre} agregado al inventario'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  double get _totalInventario =>
      widget.productos.fold(0.0, (suma, p) => suma + p.precio * p.cantidad);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Inventario'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.inventory_2, color: Colors.teal),
                            const SizedBox(width: 8),
                            Text(
                              'Nuevo producto',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _nombre,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del producto',
                            prefixIcon: Icon(Icons.label_outline),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          validator: validarNombreProducto,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _cantidad,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Cantidad',
                                  prefixIcon: Icon(Icons.numbers),
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                validator: validarCantidad,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: _precio,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Precio unit.',
                                  prefixText: 'S/. ',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                validator: validarPrecio,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          initialValue: _categoria,
                          decoration: const InputDecoration(
                            labelText: 'Categoría',
                            prefixIcon: Icon(Icons.category_outlined),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            for (final c in _categorias)
                              DropdownMenuItem(value: c, child: Text(c)),
                          ],
                          onChanged: (v) => setState(() => _categoria = v),
                          validator: (v) =>
                              v == null ? 'Seleccione una categoría' : null,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 46,
                          child: FilledButton.icon(
                            onPressed: _agregarProducto,
                            icon: const Icon(Icons.add_box),
                            label: const Text('Agregar Producto'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                Text(
                  'Productos registrados (${widget.productos.length})',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  'Total: S/. ${_totalInventario.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: widget.productos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 56,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        const Text('Aún no hay productos registrados'),
                        const Text(
                          'Completa el formulario para agregar el primero',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    itemCount: widget.productos.length,
                    itemBuilder: (context, i) {
                      final p = widget.productos[i];
                      return Card(
                        child: ListTile(
                          leading: ExcludeSemantics(
                            child: Text(
                              p.emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          title: Text(
                            p.nombre,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${p.categoria} · Stock: ${p.cantidad} · '
                            'S/. ${p.precio.toStringAsFixed(2)} c/u',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'S/. ${(p.precio * p.cantidad).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                tooltip: 'Eliminar ${p.nombre}',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () => widget.onEliminar(p),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
