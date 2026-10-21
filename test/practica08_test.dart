import 'package:flutter_test/flutter_test.dart';
import 'package:hola_mundo/practica08/sensores_servicio.dart';

void main() {
  group('SensoresServicio', () {
    test('calcula la magnitud de un vector 3-4-0', () {
      expect(SensoresServicio.magnitud3D(3, 4, 0), closeTo(5, 0.0001));
    });

    test('detecta agitamiento por encima del umbral', () {
      expect(
        SensoresServicio.esAgitamientoValores(10, 10, 10),
        isTrue,
      );
      expect(
        SensoresServicio.esAgitamientoValores(1, 1, 1),
        isFalse,
      );
    });

    test('inclinación: plano 0°, vertical 90°', () {
      expect(
        SensoresServicio.inclinacionGrados(0, 0, 9.8),
        closeTo(0, 0.001),
      );
      expect(
        SensoresServicio.inclinacionGrados(0, 9.8, 0),
        closeTo(90, 0.001),
      );
    });

    test('el rumbo siempre queda entre 0 y 360 grados', () {
      final rumbo = SensoresServicio.rumboGrados(0, -10);
      expect(rumbo, greaterThanOrEqualTo(0));
      expect(rumbo, lessThan(360));
    });

    test('podómetro: distancia y calorías aproximadas', () {
      expect(SensoresServicio.distanciaMetros(1000), closeTo(750, 0.001));
      expect(
        SensoresServicio.caloriasAproximadas(1000),
        closeTo(40, 0.001),
      );
    });
  });
}
