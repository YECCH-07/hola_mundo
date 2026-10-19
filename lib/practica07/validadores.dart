// ============================================================
// PRÁCTICA 07 — Validaciones reutilizables con RegEx
// Guía, sección 3.1: correo electrónico y contraseña segura
// ============================================================

/// Correo con estructura nombre@dominio.com
final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

/// Mínimo 8 caracteres, al menos una mayúscula, una minúscula y un número.
/// Se permiten caracteres especiales (@, #, $, ...) y se excluyen espacios.
final RegExp passwordRegex = RegExp(
  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)\S{8,}$',
);

String? validarCorreo(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo es obligatorio';
  } else if (!emailRegex.hasMatch(value)) {
    return 'Ingrese un formato de correo electrónico válido';
  }
  return null;
}

String? validarContrasena(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  } else if (!passwordRegex.hasMatch(value)) {
    return 'Mínimo 8 caracteres, con mayúscula, minúscula y número (se permiten símbolos como @, #, \$)';
  }
  return null;
}

String? validarNombreCompleto(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre completo es obligatorio';
  }
  if (value.trim().length < 3) {
    return 'Ingrese su nombre completo';
  }
  return null;
}

String? validarEdad(String? value) {
  if (value == null || value.isEmpty) {
    return 'La edad es obligatoria';
  }
  final edad = int.tryParse(value);
  if (edad == null || edad <= 0) {
    return 'Ingrese una edad válida';
  }
  return null;
}

// ---------- Ejercicio 2: inventario de productos ----------

String? validarNombreProducto(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre del producto es obligatorio';
  }
  if (value.trim().length <= 3) {
    return 'El nombre debe tener más de 3 caracteres';
  }
  return null;
}

String? validarCantidad(String? value) {
  if (value == null || value.isEmpty) {
    return 'La cantidad es obligatoria';
  }
  final cantidad = int.tryParse(value);
  if (cantidad == null || cantidad <= 0) {
    return 'La cantidad debe ser mayor a cero';
  }
  return null;
}

String? validarPrecio(String? value) {
  if (value == null || value.isEmpty) {
    return 'El precio es obligatorio';
  }
  final precio = double.tryParse(value.replaceAll(',', '.'));
  if (precio == null || precio <= 0) {
    return 'Ingrese un precio válido mayor que cero';
  }
  return null;
}
