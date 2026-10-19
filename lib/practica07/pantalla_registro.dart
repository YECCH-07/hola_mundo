// ============================================================
// PRÁCTICA 07 — Ejercicio 1
// Sistema de registro y autenticación avanzado:
// Form + GlobalKey<FormState>, RegEx de correo y contraseña,
// confirmación en tiempo real con TextEditingController,
// visibilidad de contraseña y aceptación de términos.
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'modelos_p07.dart';
import 'validadores.dart';

class PantallaRegistro extends StatefulWidget {
  final Usuario? usuarioInicial;

  /// Entrega el usuario creado junto con su contraseña para que el
  /// inicio de sesión pueda autenticarlo.
  final void Function(Usuario, String) onRegistrado;

  const PantallaRegistro({
    super.key,
    this.usuarioInicial,
    required this.onRegistrado,
  });

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _edad = TextEditingController();
  final _contrasena = TextEditingController();
  final _confirmar = TextEditingController();

  bool _obscurecer = true;
  bool _aceptaTerminos = false;
  Usuario? _registrado;

  @override
  void initState() {
    super.initState();
    final u = widget.usuarioInicial;
    if (u != null) {
      _nombre.text = u.nombreCompleto;
      _correo.text = u.email;
      _edad.text = '${u.edad}';
      _aceptaTerminos = u.aceptaTerminos;
    }
  }

  @override
  void dispose() {
    // P07: liberar los controladores para evitar fugas de memoria
    _nombre.dispose();
    _correo.dispose();
    _edad.dispose();
    _contrasena.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  void _enviar() {
    // Si la validación falla no se ejecuta ninguna acción.
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final usuario = Usuario(
      nombreCompleto: _nombre.text.trim(),
      email: _correo.text.trim(),
      edad: int.parse(_edad.text),
      aceptaTerminos: _aceptaTerminos,
    );
    widget.onRegistrado(usuario, _contrasena.text);
    setState(() => _registrado = usuario);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Registro exitoso para ${usuario.email}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final editando = widget.usuarioInicial != null;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: Text(editando ? 'Editar cuenta' : 'Crear cuenta'),
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
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      editando ? 'Datos de la cuenta' : 'Registro de usuario',
                      style: tema.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Formulario con GlobalKey, expresiones regulares y '
                      'verificación en tiempo real',
                      style: TextStyle(fontSize: 12.5),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nombre,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: validarNombreCompleto,
                    ),
                    const SizedBox(height: 12),
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
                      controller: _edad,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Edad',
                        prefixIcon: Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: validarEdad,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contrasena,
                      obscureText: _obscurecer,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        helperText: 'Mínimo 8 caracteres: mayúscula, minúscula y número',
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _confirmar,
                      obscureText: _obscurecer,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar contraseña',
                        prefixIcon: Icon(Icons.lock_reset),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Confirme su contraseña';
                        }
                        if (v != _contrasena.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    // Verificación en tiempo real con los controladores.
                    AnimatedBuilder(
                      animation: Listenable.merge([_contrasena, _confirmar]),
                      builder: (context, _) {
                        if (_confirmar.text.isEmpty) {
                          return const Text(
                            'La confirmación se verifica en tiempo real',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          );
                        }
                        final coincide = _confirmar.text == _contrasena.text;
                        return Text(
                          coincide
                              ? '✓ Las contraseñas coinciden'
                              : '✗ Las contraseñas no coinciden',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: coincide
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _CampoTerminos(
                      valorInicial: _aceptaTerminos,
                      onChanged: (v) => setState(() => _aceptaTerminos = v),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: _enviar,
                        icon: const Icon(Icons.how_to_reg),
                        label: Text(
                          editando ? 'Guardar cambios' : 'Registrarme',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_registrado != null) ...[
            const SizedBox(height: 12),
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green.shade700),
                title: const Text('Cuenta registrada'),
                subtitle: Text(
                  '${_registrado!.nombreCompleto} · '
                  '${_registrado!.email} · ${_registrado!.edad} años',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Equivalente a un CheckboxFormField: el checkbox participa en la
/// validación del Form y muestra su error debajo del texto.
class _CampoTerminos extends FormField<bool> {
  _CampoTerminos({
    required bool valorInicial,
    required ValueChanged<bool> onChanged,
  }) : super(
         initialValue: valorInicial,
         validator: (v) =>
             (v ?? false) ? null : 'Debe aceptar los términos y condiciones',
         builder: (field) {
           final marcado = field.value ?? false;
           final colorError = Theme.of(field.context).colorScheme.error;
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 children: [
                   Checkbox(
                     value: marcado,
                     onChanged: (v) {
                       field.didChange(v ?? false);
                       onChanged(v ?? false);
                     },
                   ),
                   const Expanded(
                     child: Text('Acepto los términos y condiciones'),
                   ),
                 ],
               ),
               if (field.hasError)
                 Padding(
                   padding: const EdgeInsets.only(left: 12),
                   child: Text(
                     field.errorText!,
                     style: TextStyle(color: colorError, fontSize: 12),
                   ),
                 ),
             ],
           );
         },
       );
}
