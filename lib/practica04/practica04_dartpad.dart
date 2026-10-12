// ============================================================
// PRÁCTICA 04 — Guía Práctica de Widgets en Flutter
// Versión DartPad: Texto/Container, Botones, Campo de texto,
// Feedback (SnackBar y AlertDialog) y Chips
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
      home: const Vitrina(),
    );
  }
}

class Vitrina extends StatelessWidget {
  const Vitrina({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Práctica 04 — Widgets'),
          backgroundColor: Colors.indigo.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Texto'),
              Tab(text: 'Botones'),
              Tab(text: 'Campo'),
              Tab(text: 'Feedback'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DemoTexYContainer(),
            DemoBotones(),
            DemoCampo(),
            DemoFeedback(),
          ],
        ),
      ),
    );
  }
}

// ---------- Texto y Container ----------

class DemoTexYContainer extends StatelessWidget {
  const DemoTexYContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Text con estilos',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo)),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo, width: 2),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 8, offset: Offset(2, 4)),
              ],
            ),
            child: const Text('Container con padding,\nmargin, borde y sombra',
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

// ---------- Botones ----------

class DemoBotones extends StatelessWidget {
  const DemoBotones({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
          FloatingActionButton.extended(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('FloatingActionButton'),
          ),
        ],
      ),
    );
  }
}

// ---------- Campo de texto ----------

class DemoCampo extends StatefulWidget {
  const DemoCampo({super.key});

  @override
  State<DemoCampo> createState() => _DemoCampoState();
}

class _DemoCampoState extends State<DemoCampo> {
  String _texto = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
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
    );
  }
}

// ---------- Feedback (SnackBar, AlertDialog, Chips) ----------

class DemoFeedback extends StatelessWidget {
  const DemoFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
            onPressed: () => showDialog(
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
            ),
            child: const Text('Mostrar AlertDialog'),
          ),
          const SizedBox(height: 32),
          const CircularProgressIndicator(color: Colors.indigo),
          const SizedBox(height: 24),
          SizedBox(
            width: 280,
            child: LinearProgressIndicator(
              value: 0.65,
              backgroundColor: Colors.indigo.shade100,
            ),
          ),
          const SizedBox(height: 16),
          const Chip(
            label: Text('Flutter'),
            avatar: CircleAvatar(child: Text('F')),
          ),
        ],
      ),
    );
  }
}
