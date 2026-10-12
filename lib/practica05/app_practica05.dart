// ============================================================
// PRÁCTICA 05 — Manejo de Eventos e Interactividad en Flutter
// 9 ejercicios propuestos por niveles (básico, intermedio, avanzado)
// (entrypoint: flutter run -t lib/practica05/app_practica05.dart)
// ============================================================

import 'dart:async';

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
      home: const PantallaInicio(),
    );
  }
}

// ---------- Menú principal por niveles ----------

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 05 — Eventos'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _encabezado('Nivel Básico'),
          _item(context, '1. Botón que cambia el color de fondo',
              const Ej1ColorFondo()),
          _item(context, '2. Contador con botones + y -', const Ej2Contador()),
          _item(context, '3. Capturar texto y mostrarlo', const Ej3Texto()),
          _encabezado('Nivel Intermedio'),
          _item(context, '4. Formulario con nombre y edad', const Ej4Formulario()),
          _item(context, '5. Switch (encendido/apagado)', const Ej5Switch()),
          _item(context, '6. Doble clic en un contenedor', const Ej6DobleClic()),
          _encabezado('Nivel Avanzado'),
          _item(context, '7. Lista dinámica (agregar elementos)',
              const Ej7Lista()),
          _item(context, '8. Validación de formulario', const Ej8Validacion()),
          _item(context, '9. Juego: contador de taps', const Ej9Juego()),
        ],
      ),
    );
  }

  Widget _encabezado(String texto) {
    return Container(
      color: Colors.teal.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        texto,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.teal),
      ),
    );
  }

  Widget _item(BuildContext context, String titulo, Widget pantalla) {
    return ListTile(
      title: Text(titulo),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => pantalla),
      ),
    );
  }
}

// ---------- 1. Botón que cambia el color de fondo ----------

class Ej1ColorFondo extends StatefulWidget {
  const Ej1ColorFondo({super.key});

  @override
  State<Ej1ColorFondo> createState() => _Ej1ColorFondoState();
}

class _Ej1ColorFondoState extends State<Ej1ColorFondo> {
  Color _fondo = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('1. Cambiar color de fondo')),
      backgroundColor: _fondo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Toca un botón para cambiar el fondo'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              children: [
                for (final (nombre, color) in [
                  ('Rojo', Colors.red),
                  ('Verde', Colors.green),
                  ('Azul', Colors.blue),
                  ('Amarillo', Colors.amber),
                ])
                  ElevatedButton(
                    onPressed: () => setState(() => _fondo = color),
                    style: ElevatedButton.styleFrom(backgroundColor: color),
                    child: Text(nombre),
                  ),
              ],
            ),
            const SizedBox(height: 16),
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

// ---------- 2. Contador con botones + y - ----------

class Ej2Contador extends StatefulWidget {
  const Ej2Contador({super.key});

  @override
  State<Ej2Contador> createState() => _Ej2ContadorState();
}

class _Ej2ContadorState extends State<Ej2Contador> {
  int _valor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2. Contador + y -')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Valor:', style: TextStyle(fontSize: 22)),
            Text('$_valor',
                style: const TextStyle(
                    fontSize: 72, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'menos',
                  onPressed: () =>
                      setState(() => _valor > 0 ? _valor-- : 0),
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
      ),
    );
  }
}

// ---------- 3. Capturar texto y mostrarlo ----------

class Ej3Texto extends StatefulWidget {
  const Ej3Texto({super.key});

  @override
  State<Ej3Texto> createState() => _Ej3TextoState();
}

class _Ej3TextoState extends State<Ej3Texto> {
  String _texto = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3. Capturar texto')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (v) => setState(() => _texto = v),
              decoration: const InputDecoration(
                labelText: 'Escribe un texto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _texto.isEmpty ? 'Aquí se mostrará tu texto' : _texto,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- 4. Formulario con nombre y edad ----------

class Ej4Formulario extends StatefulWidget {
  const Ej4Formulario({super.key});

  @override
  State<Ej4Formulario> createState() => _Ej4FormularioState();
}

class _Ej4FormularioState extends State<Ej4Formulario> {
  final _nombre = TextEditingController();
  final _edad = TextEditingController();
  String _resultado = '';

  @override
  void dispose() {
    _nombre.dispose();
    _edad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('4. Formulario nombre y edad')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _edad,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() {
                _resultado =
                    'Hola ${_nombre.text}, tienes ${_edad.text} años';
              }),
              child: const Text('Mostrar saludo'),
            ),
            const SizedBox(height: 24),
            Text(
              _resultado,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- 5. Switch (encendido/apagado) ----------

class Ej5Switch extends StatefulWidget {
  const Ej5Switch({super.key});

  @override
  State<Ej5Switch> createState() => _Ej5SwitchState();
}

class _Ej5SwitchState extends State<Ej5Switch> {
  bool _encendido = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('5. Switch')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _encendido ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 120,
              color: _encendido ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              _encendido ? 'Encendido' : 'Apagado',
              style: const TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Switch(
              value: _encendido,
              activeThumbColor: Colors.teal,
              onChanged: (v) => setState(() => _encendido = v),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- 6. Doble clic en un contenedor ----------

class Ej6DobleClic extends StatefulWidget {
  const Ej6DobleClic({super.key});

  @override
  State<Ej6DobleClic> createState() => _Ej6DobleClicState();
}

class _Ej6DobleClicState extends State<Ej6DobleClic> {
  String _mensaje = 'Toca, doble-toca o mantén presionado';
  Color _color = Colors.teal.shade100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('6. Doble clic')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () =>
                  setState(() => _mensaje = 'Tap detectado'),
              onDoubleTap: () => setState(() {
                _mensaje = '¡Doble tap detectado!';
                _color = Colors.orange.shade200;
              }),
              onLongPress: () => setState(() {
                _mensaje = 'Presión larga detectada';
                _color = Colors.red.shade200;
              }),
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text('Gestos',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(_mensaje, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// ---------- 7. Lista dinámica ----------

class Ej7Lista extends StatefulWidget {
  const Ej7Lista({super.key});

  @override
  State<Ej7Lista> createState() => _Ej7ListaState();
}

class _Ej7ListaState extends State<Ej7Lista> {
  final _controlador = TextEditingController();
  final List<String> _elementos = [];

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _agregar() {
    if (_controlador.text.trim().isNotEmpty) {
      setState(() => _elementos.add(_controlador.text.trim()));
      _controlador.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7. Lista dinámica')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controlador,
                    decoration: const InputDecoration(
                      labelText: 'Nuevo elemento',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _agregar,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _elementos.isEmpty
                ? const Center(child: Text('La lista está vacía'))
                : ListView.builder(
                    itemCount: _elementos.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.check_circle,
                          color: Colors.teal),
                      title: Text(_elementos[i]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            setState(() => _elementos.removeAt(i)),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------- 8. Validación de formulario ----------

class Ej8Validacion extends StatefulWidget {
  const Ej8Validacion({super.key});

  @override
  State<Ej8Validacion> createState() => _Ej8ValidacionState();
}

class _Ej8ValidacionState extends State<Ej8Validacion> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  String _mensaje = '';

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('8. Validación de formulario')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _correo,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'El correo es obligatorio';
                  if (!v.contains('@')) return 'Correo no válido (falta @)';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _mensaje = _formKey.currentState!.validate()
                        ? '¡Formulario válido!'
                        : 'Corrige los errores';
                  });
                },
                child: const Text('Validar'),
              ),
              const SizedBox(height: 16),
              Text(_mensaje,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- 9. Juego: contador de taps ----------

class Ej9Juego extends StatefulWidget {
  const Ej9Juego({super.key});

  @override
  State<Ej9Juego> createState() => _Ej9JuegoState();
}

class _Ej9JuegoState extends State<Ej9Juego> {
  int _taps = 0;
  int _segundos = 10;
  bool _jugando = false;
  Timer? _timer;

  void _iniciar() {
    setState(() {
      _taps = 0;
      _segundos = 10;
      _jugando = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _segundos--;
        if (_segundos == 0) {
          _jugando = false;
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('9. Juego: contador de taps')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _jugando ? 'Tiempo: $_segundos s' : 'Toca "Iniciar" para jugar',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _jugando ? () => setState(() => _taps++) : null,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: _jugando ? Colors.teal.shade200 : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$_taps',
                    style: const TextStyle(
                        fontSize: 64, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (!_jugando)
              Column(
                children: [
                  if (_segundos == 0)
                    Text('¡Hiciste $_taps taps en 10 segundos!',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _iniciar,
                    child: const Text('Iniciar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
