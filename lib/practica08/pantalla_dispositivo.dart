// ============================================================
// PRÁCTICA 08 — Pantalla "Dispositivo"
// Agrupa los módulos de las prácticas 08.1 y 08.2:
// Ubicación (GPS), Cámara (fotos/video) y Sensores.
// ============================================================

import 'package:flutter/material.dart';

import 'pantalla_camara.dart';
import 'pantalla_sensores.dart';
import 'pantalla_ubicacion.dart';

class PantallaDispositivo extends StatelessWidget {
  const PantallaDispositivo({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          title: const Text('Dispositivo · Práctica 08'),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.map_outlined), text: 'Ubicación'),
              Tab(icon: Icon(Icons.photo_camera_outlined), text: 'Cámara'),
              Tab(icon: Icon(Icons.sensors), text: 'Sensores'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PantallaUbicacion(),
            PantallaCamara(),
            PantallaSensores(),
          ],
        ),
      ),
    );
  }
}
