import 'package:flutter/material.dart';

import '../models/colaborador_model.dart';
import '../providers/talento_provider.dart';
import '../widgets/registro_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.provider});

  final TalentoProvider provider;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _mostrarRegistro() async {
    // El resultado true indica que el formulario completó el alta correctamente.
    final agregado = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegistroModal(provider: widget.provider),
    );
    if (agregado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Colaborador dado de alta correctamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarRegistro,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Nuevo colaborador'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            // Reconstruye el contenido cuando el proveedor notifica un cambio.
            child: AnimatedBuilder(
              animation: widget.provider,
              builder: (context, _) {
                final colaboradores = widget.provider.colaboradoresVisibles;
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _Encabezado(
                            totalActivos: widget.provider.totalActivos,
                          ),
                          const SizedBox(height: 24),
                          _ResumenPanel(
                            totalActivos: widget.provider.totalActivos,
                            colaboradores: widget.provider.colaboradores,
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Directorio de talento',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF17352F),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Encuentra perfiles por nombre o especialidad.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF70807B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            key: const Key('talento-search'),
                            // Cada tecla actualiza la búsqueda en el estado compartido.
                            onChanged: widget.provider.actualizarBusqueda,
                            textInputAction: TextInputAction.search,
                            decoration: const InputDecoration(
                              hintText: 'Buscar colaborador o especialidad',
                              prefixIcon: Icon(Icons.search_rounded),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _Filtros(
                            filtroActivo: widget.provider.filtroActivo,
                            onSeleccionar: widget.provider.seleccionarFiltro,
                          ),
                          const SizedBox(height: 18),
                          if (colaboradores.isEmpty)
                            const _EstadoVacio()
                          else
                            ...colaboradores.map(
                              (colaborador) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _TarjetaColaborador(
                                  colaborador: colaborador,
                                ),
                              ),
                            ),
                          const SizedBox(height: 64),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _Encabezado extends StatelessWidget {
  const _Encabezado({required this.totalActivos});

  final int totalActivos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF075C52),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.hub_rounded, color: Colors.white, size: 25),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Talento SENATI',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: const Color(0xFF17352F),
                ),
              ),
              Text(
                'GESTIÓN DE PERSONAS',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.15,
                  color: const Color(0xFF73837E),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F4EE),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Color(0xFF1F9D68)),
              const SizedBox(width: 7),
              Text(
                '$totalActivos activos',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF176B4A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResumenPanel extends StatelessWidget {
  const _ResumenPanel({
    required this.totalActivos,
    required this.colaboradores,
  });

  final int totalActivos;
  final List<Colaborador> colaboradores;

  @override
  Widget build(BuildContext context) {
    final personasPlanta = colaboradores
        .where((persona) => persona.tipo == 'Planta')
        .length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF075C52), Color(0xFF0B7967)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22075C52),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personas que impulsan\nel futuro técnico',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1.13,
                            letterSpacing: -0.6,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Un espacio para conectar talento y oportunidades.',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xFFD4EEE7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFFB5E4D6),
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 9,
            children: [
              _IndicadorResumen(
                icono: Icons.groups_2_outlined,
                valor: '$totalActivos',
                etiqueta: 'colaboradores',
              ),
              _IndicadorResumen(
                icono: Icons.workspace_premium_outlined,
                valor: '$personasPlanta',
                etiqueta: 'en planta',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IndicadorResumen extends StatelessWidget {
  const _IndicadorResumen({
    required this.icono,
    required this.valor,
    required this.etiqueta,
  });

  final IconData icono;
  final String valor;
  final String etiqueta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.17)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: const Color(0xFFD4EEE7), size: 20),
          const SizedBox(width: 9),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            etiqueta,
            style: const TextStyle(color: Color(0xFFD4EEE7), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _Filtros extends StatelessWidget {
  const _Filtros({required this.filtroActivo, required this.onSeleccionar});

  final String filtroActivo;
  final ValueChanged<String> onSeleccionar;

  @override
  Widget build(BuildContext context) {
    // El desplazamiento horizontal conserva todos los chips en pantallas pequeñas.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TalentoProvider.filtros.map((filtro) {
          final seleccionado = filtro == filtroActivo;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filtro),
              selected: seleccionado,
              showCheckmark: false,
              onSelected: (_) => onSeleccionar(filtro),
              selectedColor: const Color(0xFFDCEFEA),
              backgroundColor: Colors.white,
              side: BorderSide(
                color: seleccionado
                    ? const Color(0xFF75B8A7)
                    : const Color(0xFFE1E8E5),
              ),
              labelStyle: TextStyle(
                color: seleccionado
                    ? const Color(0xFF075C52)
                    : const Color(0xFF586963),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TarjetaColaborador extends StatelessWidget {
  const _TarjetaColaborador({required this.colaborador});

  final Colaborador colaborador;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorPorTipo(colaborador.tipo);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('colaborador-${colaborador.id}'),
        // Se envía el perfil completo a la ruta de detalle.
        onTap: () =>
            Navigator.of(context)
                .pushNamed('/talento/details', arguments: colaborador),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Hero(
                // La misma etiqueta en ambas pantallas anima el avatar entre rutas.
                tag: colaborador.id,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: color.withValues(alpha: 0.13),
                  child: Text(
                    colaborador.iniciales,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      colaborador.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF17352F),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      colaborador.rol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF71807B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _EtiquetaTipo(tipo: colaborador.tipo, color: color),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatoSoles(colaborador.remuneracion),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF17352F),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    colaborador.tipo == 'Contratados' ? 'por hora' : 'mensual',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF82908B),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF9AA7A2)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EtiquetaTipo extends StatelessWidget {
  const _EtiquetaTipo({required this.tipo, required this.color});

  final String tipo;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        tipo,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  const _EstadoVacio();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 34),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7ECEA)),
      ),
      child: const Column(
        children: [
          Icon(Icons.person_search_rounded, size: 38, color: Color(0xFF8A9993)),
          SizedBox(height: 10),
          Text(
            'No encontramos colaboradores',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Prueba con otro nombre, especialidad o filtro.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF71807B)),
          ),
        ],
      ),
    );
  }
}

Color _colorPorTipo(String tipo) {
  switch (tipo) {
    case 'Planta':
      return const Color(0xFF167A62);
    case 'Contratados':
      return const Color(0xFF996A17);
    case 'Administrativos':
      return const Color(0xFF5E63A5);
    default:
      return const Color(0xFF3575A4);
  }
}

String _formatoSoles(double cantidad) {
  final partes = cantidad.toStringAsFixed(2).split('.');
  // Agrupa los millares y conserva siempre dos decimales en soles.
  final entero = partes.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
  return 'S/ $entero.${partes.last}';
}
