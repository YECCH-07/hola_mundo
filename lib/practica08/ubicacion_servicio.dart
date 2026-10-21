// ============================================================
// PRÁCTICA 08.1 — Módulo 1: GPS y Servicios de Ubicación
// Servicio que envuelve geolocator y geocoding:
// permisos, posición puntual, Stream continuo, distancia,
// geocodificación directa e inversa.
// ============================================================

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Error de ubicación con un mensaje listo para mostrar al usuario.
class UbicacionExcepcion implements Exception {
  final String mensaje;

  const UbicacionExcepcion(this.mensaje);

  @override
  String toString() => mensaje;
}

class UbicacionServicio {
  /// La versión 5 de geocoding expone la API como instancia.
  final Geocoding _geocoding = Geocoding();

  /// Precisión alta: seguimiento fino cada 10 metros.
  static const LocationSettings altaPrecision = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  /// Bajo consumo: precisión baja y actualizaciones cada 50 metros.
  static const LocationSettings bajoConsumo = LocationSettings(
    accuracy: LocationAccuracy.low,
    distanceFilter: 50,
  );

  /// Comprueba GPS encendido y permisos; lanza [UbicacionExcepcion]
  /// cuando el usuario deniega el acceso de forma temporal o permanente.
  Future<void> verificarPermisos() async {
    final servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw const UbicacionExcepcion(
        'El servicio de GPS está desactivado. Actívalo en los ajustes del dispositivo.',
      );
    }

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        throw const UbicacionExcepcion(
          'Permiso de ubicación denegado. Vuelve a intentarlo.',
        );
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      throw const UbicacionExcepcion(
        'Permiso denegado permanentemente. Actívalo en Ajustes > Permisos.',
      );
    }
  }

  /// Abre los ajustes de la app (para el caso deniedForever).
  Future<void> abrirAjustes() => Geolocator.openAppSettings();

  Future<void> abrirAjustesUbicacion() => Geolocator.openLocationSettings();

  /// Posición puntual con precisión alta y límite de 15 segundos.
  Future<Position> obtenerPosicion() async {
    await verificarPermisos();
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  /// Flujo continuo de posiciones (rastreo de ruta).
  Stream<Position> rastrearPosicion({bool ahorroBateria = false}) {
    return Geolocator.getPositionStream(
      locationSettings: ahorroBateria ? bajoConsumo : altaPrecision,
    );
  }

  /// Distancia en metros entre dos posiciones.
  double calcularDistancia(Position a, Position b) {
    return Geolocator.distanceBetween(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    );
  }

  /// Geocodificación inversa: coordenadas -> dirección legible.
  Future<String> coordenadasADireccion(double lat, double lng) async {
    final placemarks = await _geocoding.placemarkFromCoordinates(lat, lng);
    if (placemarks.isEmpty) return 'Dirección desconocida';

    final p = placemarks.first;
    final partes = <String>[
      if (p.street != null && p.street!.trim().isNotEmpty) p.street!,
      if (p.locality != null && p.locality!.trim().isNotEmpty) p.locality!,
      if (p.administrativeArea != null &&
          p.administrativeArea!.trim().isNotEmpty)
        p.administrativeArea!,
      if (p.country != null && p.country!.trim().isNotEmpty) p.country!,
    ];
    return partes.isEmpty ? 'Dirección desconocida' : partes.join(', ');
  }

  /// Geocodificación directa: dirección -> coordenadas.
  Future<Location?> direccionACoordenadas(String direccion) async {
    final locations = await _geocoding.locationFromAddress(direccion);
    return locations.isNotEmpty ? locations.first : null;
  }
}
