/// Datos que la interfaz necesita para mostrar y consultar un perfil.
class Colaborador {
  const Colaborador({
    required this.id,
    required this.nombre,
    required this.dni,
    required this.rol,
    required this.tipo,
    required this.remuneracion,
    required this.resumen,
  });

  final String id;
  final String nombre;
  final String dni;
  final String rol;
  final String tipo;
  final double remuneracion;
  final String resumen;

  /// Genera el avatar textual con la inicial del nombre y del apellido.
  String get iniciales {
    final partes = nombre.trim().split(RegExp(r'\s+'));
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }
}
