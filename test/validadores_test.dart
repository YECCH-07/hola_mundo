import 'package:flutter_test/flutter_test.dart';
import 'package:hola_mundo/practica07/validadores.dart';

void main() {
  group('validarContrasena', () {
    test('acepta contraseñas con caracteres especiales', () {
      expect(validarContrasena('Segura@2026'), isNull);
      expect(validarContrasena('Clave#2026!'), isNull);
      expect(validarContrasena('Clave\$2026'), isNull);
      expect(validarContrasena('Clave%2026.'), isNull);
    });

    test('sigue exigiendo mayúscula, minúscula y número', () {
      expect(validarContrasena('segura@2026'), isNotNull);
      expect(validarContrasena('SEGURA@2026'), isNotNull);
      expect(validarContrasena('Segura@clave'), isNotNull);
    });

    test('exige al menos 8 caracteres', () {
      expect(validarContrasena('Aa@1'), isNotNull);
      expect(validarContrasena('Aa@12345'), isNull);
    });
  });
}
