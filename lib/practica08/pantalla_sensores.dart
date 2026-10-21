// ============================================================
// PRÁCTICA 08.2 — Módulos 3 y 4
// Sensores en tiempo real: acelerómetro, movimiento, giroscopio,
// magnetómetro (brújula), nivel de burbuja, podómetro y linterna.
// ============================================================

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:torch_light/torch_light.dart';

import 'sensores_servicio.dart';

class PantallaSensores extends StatefulWidget {
  const PantallaSensores({super.key});

  @override
  State<PantallaSensores> createState() => _PantallaSensoresState();
}

class _PantallaSensoresState extends State<PantallaSensores> {
  final SensoresServicio _servicio = SensoresServicio();
  final List<StreamSubscription<dynamic>> _suscripciones = [];

  AccelerometerEvent? _aceleracion;
  UserAccelerometerEvent? _movimiento;
  GyroscopeEvent? _giroscopio;
  MagnetometerEvent? _magnetometro;

  Timer? _refresco;
  Timer? _temporizadorAgitado;
  bool _agitado = false;

  int _pasos = 0;
  String _estadoCaminata = 'sin datos';
  bool _podometroIniciado = false;
  String? _podometroMensaje;
  StreamSubscription<StepCount>? _pasosSub;
  StreamSubscription<PedestrianStatus>? _estadoSub;

  bool? _linternaDisponible;
  bool _linternaEncendida = false;
  String? _linternaMensaje;

  @override
  void initState() {
    super.initState();
    _iniciarSensores();
    _comprobarLinterna();
  }

  @override
  void dispose() {
    for (final s in _suscripciones) {
      s.cancel();
    }
    _pasosSub?.cancel();
    _estadoSub?.cancel();
    _refresco?.cancel();
    _temporizadorAgitado?.cancel();
    if (_linternaEncendida) {
      TorchLight.disableTorch().catchError((_) {});
    }
    super.dispose();
  }

  void _iniciarSensores() {
    // Las suscripciones solo guardan la última lectura; un temporizador
    // refresca la interfaz a 10 Hz para no reconstruir 4 veces por evento.
    _suscripciones.add(
      _servicio.acelerometro.listen(
        (e) => _aceleracion = e,
        onError: (_) {},
      ),
    );
    _suscripciones.add(
      _servicio.movimiento.listen((e) {
        _movimiento = e;
        if (SensoresServicio.esAgitamiento(e)) {
          _temporizadorAgitado?.cancel();
          if (!_agitado && mounted) setState(() => _agitado = true);
          _temporizadorAgitado = Timer(const Duration(seconds: 1), () {
            if (mounted) setState(() => _agitado = false);
          });
        }
      }, onError: (_) {}),
    );
    _suscripciones.add(
      _servicio.giroscopio.listen(
        (e) => _giroscopio = e,
        onError: (_) {},
      ),
    );
    _suscripciones.add(
      _servicio.magnetometro.listen(
        (e) => _magnetometro = e,
        onError: (_) {},
      ),
    );

    _refresco = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _iniciarPodometro() async {
    setState(() => _podometroIniciado = true);
    try {
      final estado = await Permission.activityRecognition.request();
      if (!mounted) return;
      if (!estado.isGranted) {
        setState(() {
          _podometroMensaje =
              'Permiso de actividad física denegado. Actívalo en Ajustes.';
        });
        return;
      }

      setState(() => _podometroMensaje = null);
      _pasosSub = Pedometer.stepCountStream.listen(
        (evento) {
          if (mounted) setState(() => _pasos = evento.steps);
        },
        onError: (e) {
          if (mounted) {
            setState(() => _podometroMensaje = 'Podómetro no disponible: $e');
          }
        },
      );
      _estadoSub = Pedometer.pedestrianStatusStream.listen(
        (evento) {
          if (mounted) setState(() => _estadoCaminata = evento.status);
        },
        onError: (_) {},
      );
    } catch (e) {
      if (mounted) {
        setState(() => _podometroMensaje = 'Podómetro no disponible: $e');
      }
    }
  }

  Future<void> _comprobarLinterna() async {
    try {
      final disponible = await TorchLight.isTorchAvailable();
      if (mounted) setState(() => _linternaDisponible = disponible);
    } catch (_) {
      if (mounted) setState(() => _linternaDisponible = false);
    }
  }

  Future<void> _alternarLinterna(bool encender) async {
    try {
      if (encender) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
      if (mounted) {
        setState(() {
          _linternaEncendida = encender;
          _linternaMensaje = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _linternaEncendida = false;
          _linternaMensaje = 'Linterna no disponible en este dispositivo';
        });
      }
    }
  }

  String _fmt(double? valor) => valor == null ? '—' : valor.toStringAsFixed(2);

  double? get _inclinacion {
    final a = _aceleracion;
    return a == null ? null : SensoresServicio.inclinacion(a);
  }

  double? get _rumbo {
    final m = _magnetometro;
    return m == null ? null : SensoresServicio.rumbo(m);
  }

  @override
  Widget build(BuildContext context) {
    final inclinacion = _inclinacion;
    final rumbo = _rumbo;
    final plano = _aceleracion != null &&
        (_aceleracion!.x / 9.8).abs() < 0.1 &&
        (_aceleracion!.y / 9.8).abs() < 0.1;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _agitado ? Colors.red.shade100 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: _agitado
              ? ListTile(
                  leading: Icon(Icons.vibration, color: Colors.red.shade800),
                  title: Text(
                    'AGITAMIENTO DETECTADO',
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'La magnitud del acelerómetro superó el umbral de 15 m/s²',
                  ),
                )
              : const SizedBox.shrink(),
        ),

        Row(
          children: [
            Expanded(
              child: _tarjetaNivel(context, plano),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _tarjetaBrujula(context, rumbo),
            ),
          ],
        ),
        const SizedBox(height: 8),

        _tarjetaSensor(
          titulo: 'Acelerómetro (con gravedad)',
          icono: Icons.speed,
          x: _aceleracion?.x,
          y: _aceleracion?.y,
          z: _aceleracion?.z,
          unidad: 'm/s²',
        ),
        _tarjetaSensor(
          titulo: 'Movimiento (sin gravedad)',
          icono: Icons.vibration,
          x: _movimiento?.x,
          y: _movimiento?.y,
          z: _movimiento?.z,
          unidad: 'm/s²',
        ),
        _tarjetaSensor(
          titulo: 'Giroscopio (rad/s)',
          icono: Icons.threed_rotation,
          x: _giroscopio?.x,
          y: _giroscopio?.y,
          z: _giroscopio?.z,
          unidad: 'rad/s',
        ),
        _tarjetaSensor(
          titulo: 'Magnetómetro (µT)',
          icono: Icons.explore,
          x: _magnetometro?.x,
          y: _magnetometro?.y,
          z: _magnetometro?.z,
          unidad: 'µT',
        ),

        Card(
          child: ListTile(
            leading: const Icon(Icons.straighten, color: Colors.teal),
            title: const Text('Inclinación'),
            subtitle: Text(
              inclinacion == null
                  ? 'Esperando acelerómetro…'
                  : '${inclinacion.toStringAsFixed(1)}° '
                        '(0° = plano, 90° = vertical)',
            ),
          ),
        ),

        _tarjetaPodometro(),
        _tarjetaLinterna(),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Muestreo: ${SensoresServicio.periodoMuestreo.inMilliseconds} ms '
            '(20 Hz) · sensors_plus 7 · pedometer · torch_light',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _tarjetaNivel(BuildContext context, bool plano) {
    final a = _aceleracion;
    final nx = a == null ? 0.0 : (a.x / 9.8).clamp(-1.0, 1.0);
    final ny = a == null ? 0.0 : (a.y / 9.8).clamp(-1.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.crop_square, size: 18, color: Colors.teal),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Nivel de burbuja',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 120,
              child: Center(
                child: CustomPaint(
                  size: const Size(116, 116),
                  painter: _NivelPainter(nx: nx, ny: ny, plano: plano),
                ),
              ),
            ),
            Text(
              plano ? 'Nivelado' : 'Inclinado',
              style: TextStyle(
                color: plano ? Colors.green.shade700 : Colors.orange.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaBrujula(BuildContext context, double? rumbo) {
    final grados = rumbo ?? 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Row(
              children: [
                Icon(Icons.explore, size: 18, color: Colors.teal),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Brújula',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 120,
              child: Center(
                child: Transform.rotate(
                  angle: -grados * pi / 180,
                  child: Icon(
                    Icons.navigation,
                    size: 80,
                    color: rumbo == null ? Colors.grey : Colors.red,
                  ),
                ),
              ),
            ),
            Text(
              rumbo == null
                  ? 'Sin magnetómetro'
                  : 'Rumbo: ${grados.toStringAsFixed(0)}°',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaSensor({
    required String titulo,
    required IconData icono,
    required double? x,
    required double? y,
    required double? z,
    required String unidad,
  }) {
    final magnitud = (x != null && y != null && z != null)
        ? SensoresServicio.magnitud3D(x, y, z)
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icono, color: Colors.teal, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (magnitud != null)
                  Text(
                    '|v| ${magnitud.toStringAsFixed(2)} $unidad',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _eje('X', x, unidad),
                _eje('Y', y, unidad),
                _eje('Z', z, unidad),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _eje(String etiqueta, double? valor, String unidad) {
    return Expanded(
      child: Column(
        children: [
          Text(
            etiqueta,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _fmt(valor),
            style: const TextStyle(fontSize: 18, fontFamily: 'monospace'),
          ),
          Text(unidad, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _tarjetaPodometro() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.directions_walk, color: Colors.teal, size: 20),
                SizedBox(width: 8),
                Text(
                  'Podómetro',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (!_podometroIniciado) ...[
              Text(
                'El podómetro usa el sensor TYPE_STEP_COUNTER y requiere '
                'el permiso ACTIVITY_RECOGNITION.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: _iniciarPodometro,
                icon: const Icon(Icons.directions_walk),
                label: const Text('Activar podómetro'),
              ),
            ] else if (_podometroMensaje != null)
              Text(
                _podometroMensaje!,
                style: TextStyle(color: Colors.orange.shade900),
              )
            else ...[
              Row(
                children: [
                  _dato('Pasos', '$_pasos'),
                  _dato('Estado', _estadoCaminata),
                  _dato(
                    'Distancia',
                    '${SensoresServicio.distanciaMetros(_pasos).toStringAsFixed(1)} m',
                  ),
                  _dato(
                    'Calorías',
                    SensoresServicio.caloriasAproximadas(
                      _pasos,
                    ).toStringAsFixed(1),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Permiso ACTIVITY_RECOGNITION · sensor TYPE_STEP_COUNTER',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _dato(String etiqueta, String valor) {
    return Expanded(
      child: Column(
        children: [
          Text(etiqueta, style: Theme.of(context).textTheme.bodySmall),
          Text(
            valor,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _tarjetaLinterna() {
    final disponible = _linternaDisponible;
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: Icon(
              _linternaEncendida ? Icons.flashlight_on : Icons.flashlight_off,
              color: Colors.teal,
            ),
            title: const Text('Linterna'),
            subtitle: Text(
              _linternaMensaje ??
                  (disponible == null
                      ? 'Comprobando disponibilidad…'
                      : disponible
                      ? 'Flash de la cámara disponible'
                      : 'No disponible en este dispositivo'),
            ),
            value: _linternaEncendida,
            onChanged: disponible == true ? _alternarLinterna : null,
          ),
        ],
      ),
    );
  }
}

/// Dibuja el nivel de burbuja: círculo, cruz central y burbuja móvil.
class _NivelPainter extends CustomPainter {
  final double nx;
  final double ny;
  final bool plano;

  _NivelPainter({required this.nx, required this.ny, required this.plano});

  @override
  void paint(Canvas canvas, Size size) {
    final centro = Offset(size.width / 2, size.height / 2);
    final radio = size.width / 2 - 6;

    canvas.drawCircle(
      centro,
      radio,
      Paint()
        ..color = Colors.grey.shade400
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final cruz = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(centro.dx - 10, centro.dy),
      Offset(centro.dx + 10, centro.dy),
      cruz,
    );
    canvas.drawLine(
      Offset(centro.dx, centro.dy - 10),
      Offset(centro.dx, centro.dy + 10),
      cruz,
    );

    final burbuja = Offset(
      centro.dx + nx.clamp(-1.0, 1.0) * radio * 0.75,
      centro.dy - ny.clamp(-1.0, 1.0) * radio * 0.75,
    );
    canvas.drawCircle(
      burbuja,
      14,
      Paint()..color = plano ? Colors.green : Colors.red.shade400,
    );
  }

  @override
  bool shouldRepaint(_NivelPainter oldDelegate) {
    return nx != oldDelegate.nx ||
        ny != oldDelegate.ny ||
        plano != oldDelegate.plano;
  }
}
