// ============================================================
// PRÁCTICA 08.1 — Módulo 1: GPS y Servicios de Ubicación
// Pantalla con mapa OpenStreetMap (flutter_map), marcador de la
// posición actual, rastreo continuo con polilínea, búsqueda por
// dirección, geocodificación inversa, distancia y geocerca.
// ============================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'ubicacion_servicio.dart';

class PantallaUbicacion extends StatefulWidget {
  const PantallaUbicacion({super.key});

  @override
  State<PantallaUbicacion> createState() => _PantallaUbicacionState();
}

class _PantallaUbicacionState extends State<PantallaUbicacion> {
  final UbicacionServicio _servicio = UbicacionServicio();
  final MapController _mapa = MapController();
  final TextEditingController _busqueda = TextEditingController();

  // Cusco como centro inicial mientras llega la primera posición.
  LatLng _centro = const LatLng(-13.5320, -71.9675);

  Position? _posicion;
  final List<LatLng> _ruta = [];
  LatLng? _puntoReferencia;
  LatLng? _puntoBuscado;

  bool _cargando = true;
  bool _buscando = false;
  bool _mapaListo = false;
  String _direccion = '';
  String? _error;

  // Rastreo continuo.
  StreamSubscription<Position>? _suscripcion;
  bool _rastreando = false;
  bool _ahorroBateria = false;

  // Geocerca circular.
  bool _geocercaActiva = false;
  LatLng? _centroGeocerca;
  double _radioGeocerca = 100;
  bool? _dentroGeocerca;
  double? _distanciaGeocerca;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _inicializar());
  }

  @override
  void dispose() {
    _suscripcion?.cancel();
    _busqueda.dispose();
    _mapa.dispose();
    super.dispose();
  }

  // ---------- Permisos y posición ----------

  Future<void> _inicializar() async {
    if (mounted) {
      setState(() {
        _cargando = true;
        _error = null;
      });
    }
    try {
      final pos = await _servicio.obtenerPosicion();
      if (!mounted) return;
      _actualizarPosicion(pos, moverMapa: true, geocodificar: true);
    } on UbicacionExcepcion catch (e) {
      if (mounted) setState(() => _error = e.mensaje);
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'No se pudo obtener la ubicación: $e');
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _actualizarPosicion(
    Position pos, {
    bool moverMapa = false,
    bool geocodificar = false,
  }) {
    final punto = LatLng(pos.latitude, pos.longitude);
    if (!mounted) return;

    setState(() {
      _posicion = pos;
      _centro = punto;
      if (_rastreando) {
        _ruta.add(punto);
        // Evita que la ruta crezca sin límite en sesiones largas.
        if (_ruta.length > 600) _ruta.removeAt(0);
      }
      _evaluarGeocerca(pos);
    });

    if (moverMapa) _moverMapa(punto);
    if (geocodificar) _actualizarDireccion(pos);
  }

  Future<void> _actualizarDireccion(Position pos) async {
    try {
      final direccion = await _servicio.coordenadasADireccion(
        pos.latitude,
        pos.longitude,
      );
      if (mounted) setState(() => _direccion = direccion);
    } catch (_) {
      if (mounted) setState(() => _direccion = 'Dirección no disponible');
    }
  }

  void _moverMapa(LatLng punto, {double? zoom}) {
    if (!_mapaListo) return;
    try {
      _mapa.move(punto, zoom ?? _mapa.camera.zoom);
    } catch (_) {
      // El mapa aún no está montado; se reintenta en onMapReady.
    }
  }

  // ---------- Rastreo continuo ----------

  void _toggleRastreo() {
    if (_rastreando) {
      _suscripcion?.cancel();
      setState(() => _rastreando = false);
      return;
    }

    final actual = _posicion;
    if (actual == null) {
      _inicializar();
      return;
    }

    setState(() {
      _rastreando = true;
      _ruta
        ..clear()
        ..add(LatLng(actual.latitude, actual.longitude));
    });

    _suscripcion = _servicio
        .rastrearPosicion(ahorroBateria: _ahorroBateria)
        .listen(
          (pos) => _actualizarPosicion(pos, moverMapa: true),
          onError: (e) {
            if (!mounted) return;
            setState(() => _rastreando = false);
            _mostrar('Error de rastreo: $e');
          },
        );
  }

  void _cambiarAhorro(bool valor) {
    setState(() => _ahorroBateria = valor);
    if (_rastreando) {
      _suscripcion?.cancel();
      _suscripcion = _servicio
          .rastrearPosicion(ahorroBateria: valor)
          .listen((pos) => _actualizarPosicion(pos, moverMapa: true));
    }
  }

  // ---------- Geocodificación directa ----------

  Future<void> _buscarDireccion() async {
    final texto = _busqueda.text.trim();
    if (texto.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() => _buscando = true);
    try {
      final lugar = await _servicio.direccionACoordenadas(texto);
      if (!mounted) return;
      if (lugar == null) {
        _mostrar('No se encontró la dirección "$texto"');
        return;
      }
      final punto = LatLng(lugar.latitude, lugar.longitude);
      setState(() {
        _puntoBuscado = punto;
        _puntoReferencia = punto;
      });
      _moverMapa(punto, zoom: 16);
      _mostrar('Dirección encontrada: ${lugar.latitude.toStringAsFixed(5)}, '
          '${lugar.longitude.toStringAsFixed(5)}');
    } catch (e) {
      if (mounted) _mostrar('Geocodificación no disponible: $e');
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  // ---------- Puntos y geocerca ----------

  void _fijarReferencia(LatLng punto) {
    setState(() => _puntoReferencia = punto);
    final pos = _posicion;
    if (pos == null) return;
    final metros = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      punto.latitude,
      punto.longitude,
    );
    _mostrar('Punto fijado a ${_formatearDistancia(metros)} de tu posición');
  }

  void _usarComoGeocerca() {
    final centro = _puntoReferencia ?? _puntoActual;
    if (centro == null) {
      _mostrar('Primero fija un punto o espera la ubicación actual');
      return;
    }
    setState(() {
      _centroGeocerca = centro;
      _geocercaActiva = true;
      _dentroGeocerca = null;
      _distanciaGeocerca = null;
    });
    _evaluarGeocerca(_posicion);
    _mostrar('Geocerca de ${_radioGeocerca.toStringAsFixed(0)} m activada');
  }

  void _toggleGeocerca(bool activa) {
    if (activa) {
      _usarComoGeocerca();
    } else {
      setState(() {
        _geocercaActiva = false;
        _dentroGeocerca = null;
      });
    }
  }

  void _cambiarRadio(double? radio) {
    if (radio == null) return;
    setState(() => _radioGeocerca = radio);
    _evaluarGeocerca(_posicion);
  }

  void _evaluarGeocerca(Position? pos) {
    if (!_geocercaActiva || _centroGeocerca == null || pos == null) return;
    final distancia = Geolocator.distanceBetween(
      _centroGeocerca!.latitude,
      _centroGeocerca!.longitude,
      pos.latitude,
      pos.longitude,
    );
    final dentro = distancia <= _radioGeocerca;
    final cambio = _dentroGeocerca != dentro;
    _dentroGeocerca = dentro;
    _distanciaGeocerca = distancia;

    if (cambio) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _mostrar(
          dentro
              ? 'Entraste a la geocerca (${_formatearDistancia(distancia)})'
              : 'Saliste de la geocerca (${_formatearDistancia(distancia)})',
        );
      });
    }
  }

  LatLng? get _puntoActual {
    final pos = _posicion;
    return pos == null ? null : LatLng(pos.latitude, pos.longitude);
  }

  double? get _distanciaReferencia {
    final pos = _posicion;
    final ref = _puntoReferencia;
    if (pos == null || ref == null) return null;
    return Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      ref.latitude,
      ref.longitude,
    );
  }

  String _formatearDistancia(double metros) {
    if (metros >= 1000) {
      return '${(metros / 1000).toStringAsFixed(2)} km';
    }
    return '${metros.toStringAsFixed(1)} m';
  }

  void _irAMiUbicacion() {
    final punto = _puntoActual;
    if (punto == null) {
      _inicializar();
    } else {
      _moverMapa(punto, zoom: 17);
    }
  }

  void _limpiarRuta() {
    setState(() {
      _ruta.clear();
      _puntoBuscado = null;
      _puntoReferencia = null;
      _dentroGeocerca = null;
      _distanciaGeocerca = null;
    });
  }

  void _mostrar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ---------- Interfaz ----------

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapa,
          options: MapOptions(
            initialCenter: _centro,
            initialZoom: 15,
            onMapReady: () {
              _mapaListo = true;
              final punto = _puntoActual;
              if (punto != null) _moverMapa(punto, zoom: 16);
            },
            onLongPress: (_, punto) => _fijarReferencia(punto),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.hola_mundo',
              maxZoom: 19,
            ),
            if (_geocercaActiva && _centroGeocerca != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _centroGeocerca!,
                    radius: _radioGeocerca,
                    useRadiusInMeter: true,
                    color: Colors.teal.withValues(alpha: 0.18),
                    borderColor: Colors.teal.shade700,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
            if (_ruta.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: List<LatLng>.from(_ruta),
                    strokeWidth: 5,
                    color: Colors.teal.shade700,
                    borderStrokeWidth: 1.5,
                    borderColor: Colors.white,
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                if (_puntoActual != null)
                  Marker(
                    point: _puntoActual!,
                    width: 34,
                    height: 34,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 6),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                if (_puntoReferencia != null && _puntoBuscado == null)
                  Marker(
                    point: _puntoReferencia!,
                    width: 44,
                    height: 44,
                    child: const Icon(
                      Icons.place,
                      color: Colors.orange,
                      size: 42,
                    ),
                  ),
                if (_puntoBuscado != null)
                  Marker(
                    point: _puntoBuscado!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.flag,
                      color: Colors.red,
                      size: 38,
                    ),
                  ),
              ],
            ),
          ],
        ),

        // Tarjeta de estado de la ubicación.
        Positioned(
          top: 8,
          left: 8,
          right: 8,
          child: _tarjetaUbicacion(),
        ),

        // Controles inferiores sobre el mapa.
        Positioned(
          left: 8,
          right: 8,
          bottom: 8,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 265),
            child: SingleChildScrollView(child: _panelControles()),
          ),
        ),
      ],
    );
  }

  Widget _tarjetaUbicacion() {
    final pos = _posicion;
    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(
              pos == null ? Icons.location_searching : Icons.my_location,
              color: Colors.teal.shade700,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pos == null
                        ? 'Obteniendo ubicación…'
                        : (_direccion.isEmpty
                              ? 'Ubicación actual'
                              : _direccion),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    pos == null
                        ? 'Activa el GPS y concede el permiso'
                        : '${pos.latitude.toStringAsFixed(6)}, '
                              '${pos.longitude.toStringAsFixed(6)} · '
                              '±${pos.accuracy.toStringAsFixed(0)} m',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (_cargando)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              IconButton(
                tooltip: 'Actualizar ubicación',
                onPressed: _inicializar,
                icon: const Icon(Icons.refresh),
              ),
          ],
        ),
      ),
    );
  }

  Widget _panelControles() {
    final distancia = _distanciaReferencia;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _error!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: _inicializar,
                          child: const Text('Reintentar'),
                        ),
                        TextButton(
                          onPressed: () => _servicio.abrirAjustes(),
                          child: const Text('Abrir ajustes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            TextField(
              controller: _busqueda,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscarDireccion(),
              decoration: InputDecoration(
                isDense: true,
                labelText: 'Buscar dirección',
                hintText: 'Ej. Plaza de Armas, Cusco',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _buscando
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        tooltip: 'Buscar',
                        onPressed: _buscarDireccion,
                        icon: const Icon(Icons.arrow_forward),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.gps_fixed, size: 20, color: Colors.teal),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _ahorroBateria ? 'Precisión: ahorro (50 m)' : 'Precisión: alta (10 m)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Switch(
                  value: _ahorroBateria,
                  onChanged: _cambiarAhorro,
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _toggleRastreo,
                    icon: Icon(_rastreando ? Icons.stop : Icons.route),
                    label: Text(_rastreando ? 'Detener ruta' : 'Rastrear ruta'),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton.filledTonal(
                  tooltip: 'Mi ubicación',
                  onPressed: _irAMiUbicacion,
                  icon: const Icon(Icons.my_location),
                ),
                IconButton.filledTonal(
                  tooltip: 'Limpiar ruta y puntos',
                  onPressed: _limpiarRuta,
                  icon: const Icon(Icons.layers_clear),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                Switch(
                  value: _geocercaActiva,
                  onChanged: _toggleGeocerca,
                ),
                const Icon(Icons.fence, size: 20, color: Colors.teal),
                const SizedBox(width: 4),
                const Text('Geocerca'),
                const Spacer(),
                DropdownButton<double>(
                  value: _radioGeocerca,
                  isDense: true,
                  underline: const SizedBox.shrink(),
                  items: const [50.0, 100.0, 200.0, 500.0]
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text('${r.toStringAsFixed(0)} m'),
                        ),
                      )
                      .toList(),
                  onChanged: _cambiarRadio,
                ),
              ],
            ),

            if (_geocercaActiva)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      _dentroGeocerca == true
                          ? Icons.check_circle
                          : Icons.error_outline,
                      color: _dentroGeocerca == true
                          ? Colors.green
                          : Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _dentroGeocerca == null
                            ? 'Esperando una lectura de GPS…'
                            : _dentroGeocerca!
                            ? 'Dentro de la zona · '
                                  '${_formatearDistancia(_distanciaGeocerca ?? 0)} al centro'
                            : 'Fuera de la zona · '
                                  '${_formatearDistancia(_distanciaGeocerca ?? 0)} al centro',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

            if (distancia != null)
              Row(
                children: [
                  const Icon(Icons.straighten, size: 18, color: Colors.teal),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Distancia al punto fijado: ${_formatearDistancia(distancia)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: _usarComoGeocerca,
                    child: const Text('Usar geocerca'),
                  ),
                ],
              ),

            Text(
              'Mantén presionado el mapa para fijar un punto. '
              'Mapa: © OpenStreetMap contributors.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
