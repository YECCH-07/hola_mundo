// Prueba básica de la aplicación Hola Mundo.

import 'package:flutter_test/flutter_test.dart';

import 'package:hola_mundo/main.dart';

void main() {
  testWidgets('Muestra Hola Mundo', (WidgetTester tester) async {
    // Construye la aplicación y dibuja un frame.
    await tester.pumpWidget(const HolaMundoApp());

    // Verifica que el texto Hola Mundo esté en pantalla.
    expect(find.text('¡Hola Mundo!'), findsOneWidget);
  });
}
