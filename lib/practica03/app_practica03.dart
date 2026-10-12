// ============================================================
// PRÁCTICA 03 — Introducción a Flutter en Android Studio
// Ejercicio 2: Tarjeta de perfil | Ejercicio 3: Contador interactivo
// Ejercicio propuesto: Calculadora básica
// (entrypoint: flutter run -t lib/practica03/app_practica03.dart)
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const Practica03App());
}

class Practica03App extends StatelessWidget {
  const Practica03App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 03 — Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PantallaInicio(),
    );
  }
}

// ---------- Pantalla de inicio (menú) ----------

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 03 — Flutter'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _botonMenu(
              context,
              icono: Icons.person,
              texto: 'Tarjeta de Perfil',
              pantalla: const PantallaTarjeta(),
            ),
            const SizedBox(height: 16),
            _botonMenu(
              context,
              icono: Icons.exposure,
              texto: 'Contador Interactivo',
              pantalla: const PantallaContador(),
            ),
            const SizedBox(height: 16),
            _botonMenu(
              context,
              icono: Icons.calculate,
              texto: 'Calculadora',
              pantalla: const PantallaCalculadora(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonMenu(BuildContext context,
      {required IconData icono,
      required String texto,
      required Widget pantalla}) {
    return SizedBox(
      width: 260,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => pantalla),
        ),
        icon: Icon(icono),
        label: Text(texto),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// ---------- Ejercicio 2: Tarjeta de Perfil ----------

class PantallaTarjeta extends StatelessWidget {
  const PantallaTarjeta({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarjeta de Perfil'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar circular
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue.shade200,
                  child: const Icon(Icons.person,
                      size: 70, color: Colors.white),
                ),
                const SizedBox(height: 16),
                // Nombre
                const Text('Ada Lovelace',
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Ingeniería Informática',
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey.shade600)),
                const Divider(height: 32),
                // Fila de estadísticas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _Estadistica(valor: '120', etiqueta: 'Proyectos'),
                    _Estadistica(valor: '4.8', etiqueta: 'Rating'),
                    _Estadistica(valor: '5+', etiqueta: 'Años'),
                  ],
                ),
                const SizedBox(height: 20),
                // Botón de acción
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: const Text('Enviar Mensaje'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget auxiliar para las estadísticas
class _Estadistica extends StatelessWidget {
  final String valor;
  final String etiqueta;
  const _Estadistica({required this.valor, required this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(valor,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue)),
        Text(etiqueta, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

// ---------- Ejercicio 3: Contador interactivo ----------

class PantallaContador extends StatefulWidget {
  const PantallaContador({super.key});

  @override
  State<PantallaContador> createState() => _PantallaContadorState();
}

class _PantallaContadorState extends State<PantallaContador> {
  int _contador = 0;

  void _incrementar() => setState(() => _contador++);
  void _decrementar() =>
      setState(() { if (_contador > 0) _contador--; });
  void _reiniciar() => setState(() => _contador = 0);

  Color get _colorContador {
    if (_contador == 0) return Colors.grey;
    if (_contador < 5) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador Interactivo'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Valor actual:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            // El color cambia según el valor
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: _colorContador,
              ),
              child: Text('$_contador'),
            ),
            const SizedBox(height: 40),
            // Botones de control
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'dec',
                  onPressed: _decrementar,
                  backgroundColor: Colors.red.shade400,
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(width: 20),
                FloatingActionButton.extended(
                  heroTag: 'rst',
                  onPressed: _reiniciar,
                  backgroundColor: Colors.grey.shade600,
                  label: const Text('Reset',
                      style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'inc',
                  onPressed: _incrementar,
                  backgroundColor: Colors.green.shade500,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Ejercicio propuesto: Calculadora ----------

class PantallaCalculadora extends StatefulWidget {
  const PantallaCalculadora({super.key});

  @override
  State<PantallaCalculadora> createState() => _PantallaCalculadoraState();
}

class _PantallaCalculadoraState extends State<PantallaCalculadora> {
  String _display = '0';
  double _operando1 = 0;
  String _operacion = '';
  bool _nuevoNumero = true;

  void _pulsarDigito(String d) {
    setState(() {
      if (_nuevoNumero) {
        _display = d;
        _nuevoNumero = false;
      } else {
        _display += d;
      }
    });
  }

  void _pulsarPunto() {
    setState(() {
      if (_nuevoNumero) {
        _display = '0.';
        _nuevoNumero = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _pulsarOperacion(String op) {
    setState(() {
      _operando1 = double.parse(_display);
      _operacion = op;
      _nuevoNumero = true;
    });
  }

  void _pulsarIgual() {
    setState(() {
      final b = double.parse(_display);
      double resultado;
      switch (_operacion) {
        case '+':
          resultado = _operando1 + b;
        case '-':
          resultado = _operando1 - b;
        case '×':
          resultado = _operando1 * b;
        case '÷':
          resultado = b == 0 ? 0 : _operando1 / b;
        default:
          resultado = b;
      }
      // Mostrar sin decimales si es entero
      _display = resultado == resultado.roundToDouble()
          ? resultado.toInt().toString()
          : resultado.toString();
      _operacion = '';
      _nuevoNumero = true;
    });
  }

  void _pulsarC() {
    setState(() {
      _display = '0';
      _operando1 = 0;
      _operacion = '';
      _nuevoNumero = true;
    });
  }

  void _pulsarBorrar() {
    setState(() {
      if (!_nuevoNumero && _display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else if (!_nuevoNumero) {
        _display = '0';
        _nuevoNumero = true;
      }
    });
  }

  void _pulsarSigno() {
    setState(() {
      final v = double.parse(_display);
      _display = v == 0
          ? '0'
          : v == v.roundToDouble()
              ? (-v).toInt().toString()
              : (-v).toString();
    });
  }

  /// El color del display cambia según el resultado:
  /// positivo (azul), negativo (rojo) o cero (gris).
  Color get _colorDisplay {
    final v = double.tryParse(_display) ?? 0;
    if (v > 0) return Colors.blue;
    if (v < 0) return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    const botones = [
      'C', '÷', '×', '-', //
      '7', '8', '9', '+', //
      '4', '5', '6', '⌫', //
      '1', '2', '3', '=', //
      '0', '.', '±', '%', //
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Display numérico
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _operacion.isEmpty ? ' ' : '$_operando1 $_operacion',
                  style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  _display,
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: _colorDisplay,
                  ),
                ),
              ],
            ),
          ),
          // Teclado
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(12),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                for (final b in botones)
                  _boton(
                    b,
                    color: ['C', '=', '⌫', '%', '±'].contains(b)
                        ? Colors.blue.shade700
                        : Colors.blue.shade100,
                    onTap: () {
                      if (b == 'C') {
                        _pulsarC();
                      } else if (b == '=') {
                        _pulsarIgual();
                      } else if (b == '⌫') {
                        _pulsarBorrar();
                      } else if (b == '±') {
                        _pulsarSigno();
                      } else if (b == '%') {
                        setState(() {
                          _display =
                              (double.parse(_display) / 100).toString();
                        });
                      } else if (b == '.') {
                        _pulsarPunto();
                      } else if ('+-×÷'.contains(b)) {
                        _pulsarOperacion(b);
                      } else {
                        _pulsarDigito(b);
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _boton(String texto,
      {required Color color, required VoidCallback onTap}) {
    final esOperacion = '+-×÷'.contains(texto) || texto == '=';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 28,
            fontWeight: esOperacion ? FontWeight.bold : FontWeight.normal,
            color: color == Colors.blue.shade700
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}
