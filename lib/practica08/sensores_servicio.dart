// ============================================================
// PRÁCTICA 08.2 — Módulos 3 y 4: Sensores del dispositivo
// sensors_plus: acelerómetro, acelerómetro sin gravedad,
// giroscopio y magnetómetro. Cálculos de magnitud, agitamiento,
// inclinación y rumbo de la brújula.
// ============================================================

import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class SensoresServicio {
  /// 50 ms = 20 Hz, como indica la guía.
  static const Duration periodoMuestreo = Duration(milliseconds: 50);

  Stream<AccelerometerEvent> get acelerometro =>
      accelerometerEventStream(samplingPeriod: periodoMuestreo);

  Stream<UserAccelerometerEvent> get movimiento =>
      userAccelerometerEventStream(samplingPeriod: periodoMuestreo);

  Stream<GyroscopeEvent> get giroscopio =>
      gyroscopeEventStream(samplingPeriod: periodoMuestreo);

  Stream<MagnetometerEvent> get magnetometro =>
      magnetometerEventStream(samplingPeriod: periodoMuestreo);

  /// Magnitud total de un vector de aceleración.
  static double magnitud(double x, double y, double z) => magnitud3D(x, y, z);

  static double magnitud3D(double x, double y, double z) {
    return sqrt(x * x + y * y + z * z);
  }

  /// Detecta agitamiento comparando la magnitud con un umbral.
  static bool esAgitamiento(
    UserAccelerometerEvent e, {
    double umbral = 15.0,
  }) {
    return esAgitamientoValores(e.x, e.y, e.z, umbral: umbral);
  }

  static bool esAgitamientoValores(
    double x,
    double y,
    double z, {
    double umbral = 15.0,
  }) {
    return magnitud3D(x, y, z) > umbral;
  }

  /// Inclinación en grados a partir del acelerómetro con gravedad.
  static double inclinacion(AccelerometerEvent e) {
    return inclinacionGrados(e.x, e.y, e.z);
  }

  static double inclinacionGrados(double x, double y, double z) {
    return atan2(y, sqrt(x * x + z * z)) * (180 / pi);
  }

  /// Rumbo (0-360°) a partir del magnetómetro.
  static double rumbo(MagnetometerEvent e) => rumboGrados(e.x, e.y);

  static double rumboGrados(double x, double y) {
    var grados = atan2(y, x) * (180 / pi);
    if (grados < 0) grados += 360;
    return grados;
  }

  /// Calorías aproximadas del podómetro.
  static double caloriasAproximadas(int pasos, {double pesoKg = 70}) {
    return pasos * 0.04 * pesoKg / 70;
  }

  /// Distancia aproximada caminada.
  static double distanciaMetros(int pasos, {double longitudPasoM = 0.75}) {
    return pasos * longitudPasoM;
  }
}
