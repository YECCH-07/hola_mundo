// Prueba básica de la aplicación Carrito de Compras.

import 'package:flutter_test/flutter_test.dart';

import 'package:hola_mundo/main.dart';

void main() {
  testWidgets('La tienda muestra su catálogo', (WidgetTester tester) async {
    await tester.pumpWidget(const TiendaApp());

    expect(find.text('Carrito de Compras'), findsOneWidget);
    expect(find.text('Manzana'), findsOneWidget);
  });
}
