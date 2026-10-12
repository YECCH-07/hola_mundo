// ============================================================
// PRÁCTICA 02 — Tipos de Datos: Map, List, Set y más
// Sección 2: Tipos de datos primitivos
// ============================================================
// ignore_for_file: avoid_print

void main() {
  print('SECCIÓN 2 — Tipos de datos primitivos\n');

  // Tipos numéricos
  int entero = 100;
  double decimal = 3.14159;
  num numero = 42; // puede ser int o double
  print('int    : $entero');
  print('double : $decimal');
  print('num    : $numero');

  // Cadenas de texto
  String saludo = 'Hola, Dart!';
  String interpolado = 'El valor es: $entero';
  String multilinea = '''
    Esta es una cadena
    en múltiples líneas
  ''';
  print('String : $saludo');
  print('Interpolación: $interpolado');
  print('Multilínea:');
  print(multilinea);

  // Booleanos
  bool esDart = true;
  bool esPython = false;
  print('bool   : esDart = $esDart, esPython = $esPython');

  // var (inferencia de tipos) y dynamic
  var n = 10; //          int inferido en compilación
  dynamic x = 'hola'; //  puede cambiar de tipo en ejecución
  x = 42;
  print('var    : n = $n');
  print('dynamic: x = $x');

  // Null safety
  int? edadNula; //       el ? indica que puede ser null (vale null por defecto)
  String nombre = 'Ana'; // nunca puede ser null
  print('null   : edadNula = $edadNula, nombre = $nombre');
}
