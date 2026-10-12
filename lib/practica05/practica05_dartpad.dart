// ============================================================
// PRÁCTICA 05 — Manejo de Eventos e Interactividad en Flutter
// Versión DartPad: color de fondo, contador, switch y gestos
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const Practica05App());
}

class Practica05App extends StatelessWidget {
  const Practica05App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 05 — Eventos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const VitrinaEventos(),
    );
  }
}

class VitrinaEventos extends StatelessWidget {
  const VitrinaEventos({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Práctica 05 — Eventos'),
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Color'),
              Tab(text: 'Contador'),
              Tab(text: 'Switch'),
              Tab(text: 'Gestos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EjColorFondo(),
            EjContador(),
            EjSwitch(),
            EjGestos(),
          ],
        ),
      ),
    );
  }
}

// 1. Botón que cambia el color de fondo
class EjColorFondo extends StatefulWidget {
  const EjColorFondo({super.key});

  @override
  State<EjColorFondo> createState() => _EjColorFondoState();
}

class _EjColorFondoState extends State<EjColorFondo> {
  Color _fondo = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _fondo,
      child: Center(
        child: Wrap(
          spacing: 12,
          children: [
            for (final (nombre, color) in [
              ('Rojo', Colors.red),
              ('Verde', Colors.green),
              ('Azul', Colors.blue),
            ])
              ElevatedButton(
                onPressed: () => setState(() => _fondo = color),
                style: ElevatedButton.styleFrom(backgroundColor: color),
                child: Text(nombre),
              ),
            OutlinedButton(
              onPressed: () => setState(() => _fondo = Colors.white),
              child: const Text('Restablecer'),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. Contador con botones + y -
class EjContador extends StatefulWidget {
  const EjContador({super.key});

  @override
  State<EjContador> createState() => _EjContadorState();
}

class _EjContadorState extends State<EjContador> {
  int _valor = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$_valor',
              style:
                  const TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: 'menos',
                onPressed: () => setState(() => _valor > 0 ? _valor-- : 0),
                backgroundColor: Colors.red.shade400,
                child: const Icon(Icons.remove, color: Colors.white),
              ),
              const SizedBox(width: 24),
              FloatingActionButton(
                heroTag: 'mas',
                onPressed: () => setState(() => _valor++),
                backgroundColor: Colors.teal.shade500,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 5. Switch (encendido/apagado)
class EjSwitch extends StatefulWidget {
  const EjSwitch({super.key});

  @override
  State<EjSwitch> createState() => _EjSwitchState();
}

class _EjSwitchState extends State<EjSwitch> {
  bool _encendido = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _encendido ? Icons.lightbulb : Icons.lightbulb_outline,
            size: 120,
            color: _encendido ? Colors.amber : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(_encendido ? 'Encendido' : 'Apagado',
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Switch(
            value: _encendido,
            activeThumbColor: Colors.teal,
            onChanged: (v) => setState(() => _encendido = v),
          ),
        ],
      ),
    );
  }
}

// 6. Gestos: tap, doble tap y presión larga
class EjGestos extends StatefulWidget {
  const EjGestos({super.key});

  @override
  State<EjGestos> createState() => _EjGestosState();
}

class _EjGestosState extends State<EjGestos> {
  String _mensaje = 'Toca, doble-toca o mantén presionado';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => setState(() => _mensaje = 'Tap detectado'),
            onDoubleTap: () =>
                setState(() => _mensaje = '¡Doble tap detectado!'),
            onLongPress: () =>
                setState(() => _mensaje = 'Presión larga detectada'),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text('Gestos',
                    style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(_mensaje, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
