// ============================================================
// Modelo de datos del carrito de compras
// Práctica 02: Map (catálogo y carrito), Set (categorías,
// favoritos) y List (productos, filtros)
// ============================================================

class Producto {
  final String id;
  final String nombre;
  final String emoji;
  final double precio;
  final String categoria;

  const Producto({
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.precio,
    required this.categoria,
  });
}

/// Catálogo como `Map<String, Producto>`: clave única por producto
/// (se accede con catálogo['manzana'], se recorre con .values/.entries).
const Map<String, Producto> catalogo = {
  'manzana': Producto(
      id: 'manzana', nombre: 'Manzana', emoji: '🍎', precio: 2.50, categoria: 'Frutas'),
  'platano': Producto(
      id: 'platano', nombre: 'Plátano', emoji: '🍌', precio: 1.80, categoria: 'Frutas'),
  'uva': Producto(
      id: 'uva', nombre: 'Uva', emoji: '🍇', precio: 5.50, categoria: 'Frutas'),
  'leche': Producto(
      id: 'leche', nombre: 'Leche', emoji: '🥛', precio: 3.90, categoria: 'Lácteos'),
  'queso': Producto(
      id: 'queso', nombre: 'Queso', emoji: '🧀', precio: 8.90, categoria: 'Lácteos'),
  'huevos': Producto(
      id: 'huevos', nombre: 'Huevos', emoji: '🥚', precio: 6.50, categoria: 'Lácteos'),
  'pan': Producto(
      id: 'pan', nombre: 'Pan', emoji: '🍞', precio: 2.20, categoria: 'Panadería'),
  'galletas': Producto(
      id: 'galletas', nombre: 'Galletas', emoji: '🍪', precio: 2.80, categoria: 'Snacks'),
  'cafe': Producto(
      id: 'cafe', nombre: 'Café', emoji: '☕', precio: 12.00, categoria: 'Bebidas'),
  'jugo': Producto(
      id: 'jugo', nombre: 'Jugo', emoji: '🧃', precio: 3.20, categoria: 'Bebidas'),
};

/// Categorías como `Set<String>`: valores únicos generados del catálogo.
Set<String> get categorias =>
    catalogo.values.map((p) => p.categoria).toSet();

/// Lista ordenada de productos (`List<Producto>`).
List<Producto> get productos => catalogo.values.toList();
