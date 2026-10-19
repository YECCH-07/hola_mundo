import 'package:flutter_test/flutter_test.dart';
import 'package:hola_mundo/main.dart';

void main() {
  testWidgets('La app inicia con el acceso al sistema', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TiendaApp());
    expect(find.text('Acceso al sistema'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Crear cuenta'), findsOneWidget);
  });
}
