// ============================================================
// PRÁCTICA 07 — Ejercicio 2
// Inventario de productos (CRUD local dinámico):
// formulario validado arriba y lista dinámica con ListView.builder
// dentro de un Expanded, subtotal y eliminación con setState.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../modelos.dart';
import 'validadores.dart';

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
          // Formulario en la parte superior (con scroll si el teclado
          // reduce el espacio disponible).
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
                              style: Theme.of(context).textTheme.titleMedium
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
          // Lista dinámica en la parte inferior.
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
