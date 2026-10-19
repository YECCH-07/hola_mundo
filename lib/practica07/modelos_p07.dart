// ============================================================
// PRÁCTICA 07 — Modelo de datos Usuario (guía, sección 4.1)
// Inmutable, con copyWith y conversión a Map para persistencia.
// ============================================================

class Usuario {
  final String nombreCompleto;
  final String email;
  final int edad;
  final bool aceptaTerminos;

  const Usuario({
    required this.nombreCompleto,
    required this.email,
    required this.edad,
    required this.aceptaTerminos,
  });

  /// Clona el objeto cambiando solo los campos indicados (inmutabilidad).
  Usuario copyWith({
    String? nombreCompleto,
    String? email,
    int? edad,
    bool? aceptaTerminos,
  }) {
    return Usuario(
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      email: email ?? this.email,
      edad: edad ?? this.edad,
      aceptaTerminos: aceptaTerminos ?? this.aceptaTerminos,
    );
  }

  /// Conversión a mapa para persistencia o envío como JSON.
  Map<String, dynamic> toMap() {
    return {
      'nombreCompleto': nombreCompleto,
      'email': email,
      'edad': edad,
      'aceptaTerminos': aceptaTerminos,
    };
  }
}
