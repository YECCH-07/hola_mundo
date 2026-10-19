// ============================================================
// PRÁCTICA 07 — Inicio de sesión del sistema
// El registro forma parte del flujo de acceso: desde aquí se
// crea la cuenta y luego se autentica con correo y contraseña.
// ============================================================

import 'package:flutter/material.dart';

import 'modelos_p07.dart';
import 'pantalla_registro.dart';
import 'validadores.dart';

class PantallaLogin extends StatefulWidget {
  /// Cuenta registrada en el dispositivo (null si aún no existe).
  final Usuario? cuenta;

  /// Contraseña de la cuenta registrada.
  final String? contrasenaCuenta;

  /// Se ejecuta al autenticarse correctamente.
  final void Function(Usuario) onIngresar;

  /// Se ejecuta al crear una cuenta desde el registro.
  final void Function(Usuario, String) onRegistrar;

  const PantallaLogin({
    super.key,
    required this.cuenta,
    required this.contrasenaCuenta,
    required this.onIngresar,
    required this.onRegistrar,
  });

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();

  bool _obscurecer = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _correo.text = widget.cuenta?.email ?? '';
  }

  @override
  void didUpdateWidget(covariant PantallaLogin oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Al volver del registro, deja el correo de la cuenta creada.
    if (oldWidget.cuenta == null && widget.cuenta != null) {
      _correo.text = widget.cuenta!.email;
    }
  }

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _ingresar() {
    if (!_formKey.currentState!.validate()) return;

    final cuenta = widget.cuenta;
    if (cuenta == null) {
      setState(
        () => _error = 'Aún no hay una cuenta registrada. Crea una primero.',
      );
      return;
    }
    if (_correo.text.trim() != cuenta.email ||
        _contrasena.text != widget.contrasenaCuenta) {
      setState(() => _error = 'Correo o contraseña incorrectos');
      return;
    }

    setState(() => _error = null);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Bienvenido, ${cuenta.nombreCompleto}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
    widget.onIngresar(cuenta);
  }

  void _abrirRegistro() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PantallaRegistro(
          usuarioInicial: widget.cuenta,
          onRegistrado: (usuario, contrasena) {
            widget.onRegistrar(usuario, contrasena);
            setState(() {
              _correo.text = usuario.email;
              _contrasena.clear();
              _error = null;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final hayCuenta = widget.cuenta != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Acceso al sistema'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_outline, color: Colors.teal.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Iniciar sesión',
                          style: tema.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Ingresa con tu cuenta para usar el carrito de compras',
                      style: TextStyle(fontSize: 12.5),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _correo,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        hintText: 'nombre@dominio.com',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: validarCorreo,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contrasena,
                      obscureText: _obscurecer,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _obscurecer
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          icon: Icon(
                            _obscurecer
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () =>
                              setState(() => _obscurecer = !_obscurecer),
                        ),
                      ),
                      validator: validarContrasena,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: tema.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: _ingresar,
                        icon: const Icon(Icons.login),
                        label: const Text('Ingresar'),
                      ),
                    ),
                    if (!hayCuenta) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 46,
                        child: OutlinedButton.icon(
                          onPressed: _abrirRegistro,
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text('Crear cuenta'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Estado del acceso: cuenta disponible en el dispositivo.
          Card(
            color: hayCuenta
                ? Colors.green.shade50
                : tema.colorScheme.secondaryContainer,
            child: ListTile(
              leading: Icon(
                hayCuenta ? Icons.verified_user : Icons.info_outline,
                color: hayCuenta ? Colors.green.shade700 : Colors.teal,
              ),
              title: Text(
                hayCuenta ? 'Cuenta registrada' : 'Aún no hay cuentas',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                hayCuenta
                    ? 'Inicia sesión como ${widget.cuenta!.email}'
                    : 'El registro es parte del acceso: crea una cuenta '
                          'para ingresar al sistema.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
