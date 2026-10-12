// ============================================================
// PRÁCTICA 04 — Guía Práctica de Widgets en Flutter
// Aplicación vitrina: demuestra los widgets de la guía
// (entrypoint: flutter run -t lib/practica04/app_practica04.dart)
// ============================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const Practica04App());
}

class Practica04App extends StatelessWidget {
  const Practica04App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica 04 — Widgets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PantallaInicio(),
    );
  }
}

// ---------- Menú principal ----------

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    final opciones = [
      (Icons.text_fields, 'Texto y Container', const PantallaTexto()),
      (Icons.view_week, 'Row y Column', const PantallaLayout()),
      (Icons.smart_button, 'Botones', const PantallaBotones()),
      (Icons.input, 'Campo de texto', const PantallaCampo()),
      (Icons.list, 'Listas y Grid', const PantallaListas()),
      (Icons.image, 'Imágenes', const PantallaImagen()),
      (Icons.notifications, 'Feedback', const PantallaFeedback()),
      (Icons.label, 'Chips', const PantallaChips()),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Práctica 04 — Widgets'),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          for (final (icono, titulo, pantalla) in opciones)
            ListTile(
              leading: Icon(icono, color: Colors.indigo),
              title: Text(titulo),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => pantalla),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------- 1. Texto y Container ----------

class PantallaTexto extends StatelessWidget {
  const PantallaTexto({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Texto y Container')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Text con estilos',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo)),
            const Text('italic y subrayado',
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline)),
            const SizedBox(height: 24),
            // Container: padding, margin, color, borde redondeado y sombra
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.indigo, width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 4)),
                ],
              ),
              child: const Text('Container con padding,\nmargin, borde y sombra',
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- 2. Row y Column ----------

class PantallaLayout extends StatelessWidget {
  const PantallaLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Row y Column')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Row (horizontal)'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _caja(Colors.red, Icons.favorite, 'Rojo'),
                _caja(Colors.green, Icons.eco, 'Verde'),
                _caja(Colors.blue, Icons.water_drop, 'Azul'),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Column (vertical)'),
            const SizedBox(height: 8),
            Column(
              children: [
                _fila('Elemento 1'),
                _fila('Elemento 2'),
                _fila('Elemento 3'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _caja(Color color, IconData icono, String texto) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icono, color: color, size: 40),
        ),
        const SizedBox(height: 4),
        Text(texto),
      ],
    );
  }

  Widget _fila(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(texto, textAlign: TextAlign.center),
      ),
    );
  }
}

// ---------- 3. Botones ----------

class PantallaBotones extends StatelessWidget {
  const PantallaBotones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Botones')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('ElevatedButton')),
            const SizedBox(height: 12),
            FilledButton(onPressed: () {}, child: const Text('FilledButton')),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: () {}, child: const Text('OutlinedButton')),
            const SizedBox(height: 12),
            TextButton(onPressed: () {}, child: const Text('TextButton')),
            const SizedBox(height: 12),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite, color: Colors.red),
              iconSize: 32,
            ),
            const SizedBox(height: 12),
            FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('FloatingActionButton'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- 4. Campo de texto ----------

class PantallaCampo extends StatefulWidget {
  const PantallaCampo({super.key});

  @override
  State<PantallaCampo> createState() => _PantallaCampoState();
}

class _PantallaCampoState extends State<PantallaCampo> {
  final TextEditingController _controlador = TextEditingController();
  String _texto = '';

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campo de texto')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextField con onChanged
              TextField(
                controller: _controlador,
                onChanged: (texto) => setState(() => _texto = texto),
                decoration: const InputDecoration(
                  labelText: 'Escribe algo',
                  hintText: 'Tu texto aquí...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _texto.isEmpty ? 'Esperando texto...' : 'Has escrito: "$_texto"',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- 5. Listas y Grid ----------

class PantallaListas extends StatelessWidget {
  const PantallaListas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Listas y Grid')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('ListView (scroll vertical)',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (_, i) => ListTile(
                leading: Icon(Icons.circle, color: Colors.indigo.shade300),
                title: Text('Elemento de lista ${i + 1}'),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('GridView (cuadrícula)',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(8),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                for (final color in [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                ])
                  Container(
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- 6. Imágenes ----------

class PantallaImagen extends StatelessWidget {
  const PantallaImagen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Imágenes')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset desde assets/images/
            Image.asset(
              'assets/images/demo_flutter.png',
              width: 320,
            ),
            const SizedBox(height: 16),
            // Imagen con esquinas redondeadas (ClipRRect)
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/images/demo_flutter.png',
                width: 220,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- 7. Feedback ----------

class PantallaFeedback extends StatelessWidget {
  const PantallaFeedback({super.key});

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Estás seguro de continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡SnackBar mostrado!'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              ),
              child: const Text('Mostrar SnackBar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _mostrarDialogo(context),
              child: const Text('Mostrar AlertDialog'),
            ),
            const SizedBox(height: 32),
            // Indicadores de progreso
            const CircularProgressIndicator(color: Colors.indigo),
            const SizedBox(height: 24),
            SizedBox(
              width: 280,
              child: LinearProgressIndicator(
                value: 0.65,
                backgroundColor: Colors.indigo.shade100,
              ),
            ),
            const SizedBox(height: 8),
            const Text('LinearProgressIndicator al 65%'),
          ],
        ),
      ),
    );
  }
}

// ---------- 8. Chips ----------

class PantallaChips extends StatefulWidget {
  const PantallaChips({super.key});

  @override
  State<PantallaChips> createState() => _PantallaChipsState();
}

class _PantallaChipsState extends State<PantallaChips> {
  bool _favorito = false;
  String _tamano = 'Mediano';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chips')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chip básico
            const Chip(
              label: Text('Flutter'),
              avatar: CircleAvatar(child: Text('F')),
            ),
            const SizedBox(height: 16),
            // FilterChip (seleccionable)
            FilterChip(
              label: const Text('Favorito'),
              selected: _favorito,
              selectedColor: Colors.indigo.shade100,
              checkmarkColor: Colors.indigo,
              onSelected: (v) => setState(() => _favorito = v),
            ),
            const SizedBox(height: 16),
            // ChoiceChip (una opción entre varias)
            Wrap(
              spacing: 8,
              children: [
                for (final t in ['Pequeño', 'Mediano', 'Grande'])
                  ChoiceChip(
                    label: Text(t),
                    selected: _tamano == t,
                    selectedColor: Colors.indigo.shade100,
                    onSelected: (_) => setState(() => _tamano = t),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Selección: $_tamano'),
          ],
        ),
      ),
    );
  }
}
