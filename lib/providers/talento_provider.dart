import 'package:flutter/foundation.dart';

import '../models/colaborador_model.dart';

class TalentoProvider extends ChangeNotifier {
  TalentoProvider()
    // Copiamos la lista para que las altas no alteren la constante de ejemplo.
    : _colaboradores = List<Colaborador>.of(_colaboradoresIniciales);

  /// Opciones disponibles en los chips y tipos de vínculo.
  static const filtros = [
    'Todos',
    'Planta',
    'Contratados',
    'Administrativos',
    'TI',
  ];

  static const _colaboradoresIniciales = [
    // Los datos de muestra son ficticios y usan DNI de demostración.
    Colaborador(
      id: 'sen-001',
      nombre: 'Colaborador de ejemplo 01',
      dni: '00000001',
      rol: 'Docente de Desarrollo de Software',
      tipo: 'Planta',
      remuneracion: 4800,
      resumen: 'Ingeniera de sistemas con 8 años de experiencia en desarrollo web y formación técnica. Certificada en Scrum y tecnologías cloud.',
    ),
    Colaborador(
      id: 'sen-002',
      nombre: 'Colaborador de ejemplo 02',
      dni: '00000002',
      rol: 'Especialista de Infraestructura TI',
      tipo: 'TI',
      remuneracion: 5200,
      resumen: 'Especialista en redes, administración de servidores y seguridad de infraestructura. Lidera proyectos de continuidad operativa.',
    ),
    Colaborador(
      id: 'sen-003',
      nombre: 'Colaborador de ejemplo 03',
      dni: '00000003',
      rol: 'Analista de Gestión Académica',
      tipo: 'Administrativos',
      remuneracion: 3600,
      resumen: 'Administradora con experiencia en gestión académica, atención al estudiante y optimización de procesos institucionales.',
    ),
    Colaborador(
      id: 'sen-004',
      nombre: 'Colaborador de ejemplo 04',
      dni: '00000004',
      rol: 'Docente de Diseño Digital',
      tipo: 'Contratados',
      remuneracion: 42,
      resumen: 'Diseñador multimedia y docente especializado en experiencia de usuario, identidad visual y herramientas de prototipado.',
    ),
    Colaborador(
      id: 'sen-005',
      nombre: 'Colaborador de ejemplo 05',
      dni: '00000005',
      rol: 'Docente de Gestión Industrial',
      tipo: 'Planta',
      remuneracion: 4500,
      resumen: 'Ingeniera industrial con experiencia en mejora continua, gestión de calidad y capacitación técnica para equipos de producción.',
    ),
    Colaborador(
      id: 'sen-006',
      nombre: 'Colaborador de ejemplo 06',
      dni: '00000006',
      rol: 'Soporte de Sistemas',
      tipo: 'TI',
      remuneracion: 3300,
      resumen: 'Técnico de sistemas con experiencia en soporte a usuarios, mantenimiento de equipos y administración de plataformas educativas.',
    ),
  ];

  // La lista centralizada mantiene consistentes la búsqueda, los filtros y el alta.
  final List<Colaborador> _colaboradores;
  String _filtroActivo = 'Todos';
  String _busqueda = '';

  List<Colaborador> get colaboradores => List.unmodifiable(_colaboradores);
  String get filtroActivo => _filtroActivo;
  String get busqueda => _busqueda;
  int get totalActivos => _colaboradores.length;

  /// Combina el filtro seleccionado y la consulta para producir el directorio.
  List<Colaborador> get colaboradoresVisibles {
    final consulta = _busqueda.trim().toLowerCase();
    return _colaboradores
        .where((colaborador) {
          final coincideFiltro =
              _filtroActivo == 'Todos' || colaborador.tipo == _filtroActivo;
          final coincideBusqueda =
              consulta.isEmpty ||
              colaborador.nombre.toLowerCase().contains(consulta) ||
              colaborador.rol.toLowerCase().contains(consulta);
          return coincideFiltro && coincideBusqueda;
        })
        .toList(growable: false);
  }

  void seleccionarFiltro(String filtro) {
    // Ignora opciones inválidas y evita notificaciones si nada cambió.
    if (!filtros.contains(filtro) || filtro == _filtroActivo) return;
    _filtroActivo = filtro;
    notifyListeners();
  }

  void actualizarBusqueda(String valor) {
    if (valor == _busqueda) return;
    _busqueda = valor;
    notifyListeners();
  }

  /// Comprueba la unicidad del identificador personal antes de guardar.
  bool existeDni(String dni) =>
      _colaboradores.any((colaborador) => colaborador.dni == dni);

  /// Inserta el perfil al inicio del directorio y notifica a sus suscriptores.
  void agregarColaborador({
    required String nombre,
    required String dni,
    required String rol,
    required String tipo,
    required double remuneracion,
    required String resumen,
  }) {
    if (existeDni(dni)) {
      throw ArgumentError('Ya existe un colaborador registrado con ese DNI.');
    }

    _colaboradores.insert(
      0,
      Colaborador(
        id: 'sen-${DateTime.now().microsecondsSinceEpoch}',
        nombre: nombre.trim(),
        dni: dni,
        rol: rol,
        tipo: tipo,
        remuneracion: remuneracion,
        resumen: resumen.trim(),
      ),
    );
    notifyListeners();
  }
}
