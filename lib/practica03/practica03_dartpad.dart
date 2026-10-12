// ============================================================
// PRÁCTICA 03 — Introducción a Flutter en Android Studio
// Ejercicio propuesto: Calculadora básica (versión DartPad)
// StatefulWidget + GridView; el display cambia de color:
// positivo (azul), negativo (rojo), cero (gris).
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PantallaCalculadora(),
    );
  }
}

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
        centerTitle: true,
      ),
      body: Column(
        children: [
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
                      } else if (b == '±') {
                        setState(() {
                          final v = double.parse(_display);
                          _display = v == 0 ? '0' : (-v).toString();
                        });
                      } else if (b == '%') {
                        setState(() {
                          _display = (double.parse(_display) / 100).toString();
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
