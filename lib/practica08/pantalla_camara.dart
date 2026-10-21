// ============================================================
// PRÁCTICA 08.1 — Módulo 2: Cámara, fotos y video
// image_picker: captura desde la cámara, selección desde la
// galería y grabación de video, con manejo de permisos.
// ============================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PantallaCamara extends StatefulWidget {
  const PantallaCamara({super.key});

  @override
  State<PantallaCamara> createState() => _PantallaCamaraState();
}

class _PantallaCamaraState extends State<PantallaCamara> {
  final ImagePicker _picker = ImagePicker();

  String? _fotoRuta;
  String? _videoRuta;
  String? _error;
  bool _ocupado = false;

  Future<bool> _pedirPermiso(Permission permiso, String nombre) async {
    final estado = await permiso.request();
    if (estado.isGranted) return true;
    if (!mounted) return false;
    setState(() {
      _error = estado.isPermanentlyDenied
          ? 'Permiso de $nombre denegado permanentemente. Actívalo en Ajustes.'
          : 'Permiso de $nombre denegado.';
    });
    return false;
  }

  Future<void> _obtenerImagen(ImageSource fuente) async {
    setState(() {
      _ocupado = true;
      _error = null;
    });

    try {
      if (fuente == ImageSource.camera) {
        if (!await _pedirPermiso(Permission.camera, 'cámara')) return;
      }

      final XFile? archivo = await _picker.pickImage(
        source: fuente,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (archivo == null) return;

      if (mounted) setState(() => _fotoRuta = archivo.path);
    } catch (e) {
      if (mounted) setState(() => _error = 'No se pudo obtener la imagen: $e');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  Future<void> _grabarVideo() async {
    setState(() {
      _ocupado = true;
      _error = null;
    });

    try {
      if (!await _pedirPermiso(Permission.camera, 'cámara')) return;
      if (!await _pedirPermiso(Permission.microphone, 'micrófono')) return;

      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );
      if (video == null) return;

      if (mounted) setState(() => _videoRuta = video.path);
    } catch (e) {
      if (mounted) setState(() => _error = 'No se pudo grabar el video: $e');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  void _limpiar() {
    setState(() {
      _fotoRuta = null;
      _videoRuta = null;
      _error = null;
    });
  }

  String _tamano(String ruta) {
    try {
      final bytes = File(ruta).lengthSync();
      if (bytes >= 1024 * 1024) {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
      }
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } catch (_) {
      return 'tamaño desconocido';
    }
  }

  String _nombre(String ruta) => ruta.split(Platform.pathSeparator).last;

  @override
  Widget build(BuildContext context) {
    final foto = _fotoRuta;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: foto == null
                ? Container(
                    color: Colors.teal.shade50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 64,
                          color: Colors.teal.shade700,
                        ),
                        const SizedBox(height: 8),
                        const Text('Sin fotografía todavía'),
                        const SizedBox(height: 4),
                        Text(
                          'Toma una foto o elige una de la galería',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )
                : Image.file(
                    File(foto),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Center(
                      child: Text('No se pudo mostrar la imagen'),
                    ),
                  ),
          ),
        ),

        if (foto != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.image, color: Colors.teal),
              title: Text(_nombre(foto)),
              subtitle: Text(
                '${_tamano(foto)} · capturada con image_picker',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

        if (_videoRuta != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.videocam, color: Colors.teal),
              title: Text(_nombre(_videoRuta!)),
              subtitle: Text('Video grabado · ${_tamano(_videoRuta!)}'),
              trailing: IconButton(
                tooltip: 'Quitar video',
                onPressed: () => setState(() => _videoRuta = null),
                icon: const Icon(Icons.close),
              ),
            ),
          ),

        if (_error != null)
          Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: const Icon(Icons.error_outline, color: Colors.red),
              title: Text(_error!),
              trailing: IconButton(
                tooltip: 'Abrir ajustes',
                onPressed: () => openAppSettings(),
                icon: const Icon(Icons.settings),
              ),
            ),
          ),

        const SizedBox(height: 4),
        FilledButton.icon(
          onPressed: _ocupado ? null : () => _obtenerImagen(ImageSource.camera),
          icon: const Icon(Icons.photo_camera),
          label: const Text('Tomar foto'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _ocupado ? null : () => _obtenerImagen(ImageSource.gallery),
          icon: const Icon(Icons.photo_library),
          label: const Text('Elegir de la galería'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _ocupado ? null : _grabarVideo,
          icon: const Icon(Icons.videocam),
          label: const Text('Grabar video (máx. 30 s)'),
        ),
        if (_ocupado)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (foto != null || _videoRuta != null)
          TextButton.icon(
            onPressed: _limpiar,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Limpiar capturas'),
          ),

        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cámara y galería',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'La guía usa image_picker para delegar la captura a la '
                  'aplicación de cámara del sistema. Los permisos CAMERA y '
                  'RECORD_AUDIO se solicitan antes de abrir la cámara; la '
                  'galería usa el selector del sistema. En el emulador la '
                  'cámara virtual puede tardar en iniciar.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
