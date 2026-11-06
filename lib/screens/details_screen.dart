import 'package:flutter/material.dart';

import '../models/colaborador_model.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.colaborador});

  final Colaborador colaborador;

  @override
  Widget build(BuildContext context) {
    final color = _colorPorTipo(colaborador.tipo);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha del colaborador'),
        leading: IconButton(
          tooltip: 'Volver',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 28),
              // Secciones independientes para facilitar la lectura de la ficha.
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        Hero(
                          tag: colaborador.id,
                          child: CircleAvatar(
                            radius: 42,
                            backgroundColor: color.withValues(alpha: 0.13),
                            child: Text(
                              colaborador.iniciales,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w800,
                                fontSize: 23,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          colaborador.nombre,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFF17352F),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          colaborador.rol,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: const Color(0xFF71807B)),
                        ),
                        const SizedBox(height: 14),
                        Chip(
                          avatar: Icon(
                            Icons.verified_rounded,
                            size: 17,
                            color: color,
                          ),
                          label: Text(colaborador.tipo),
                          backgroundColor: color.withValues(alpha: 0.10),
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _PanelRemuneracion(colaborador: colaborador),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _TituloSeccion(
                          icono: Icons.badge_outlined,
                          titulo: 'Datos del colaborador',
                        ),
                        const SizedBox(height: 18),
                        _DatoFicha(etiqueta: 'DNI', valor: colaborador.dni),
                        const SizedBox(height: 14),
                        _DatoFicha(
                          etiqueta: 'Área o especialidad',
                          valor: colaborador.rol,
                        ),
                        const SizedBox(height: 14),
                        const _DatoFicha(etiqueta: 'Estado', valor: 'Activo'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _TituloSeccion(
                          icono: Icons.workspace_premium_outlined,
                          titulo: 'Resumen profesional',
                        ),
                        const SizedBox(height: 14),
                        Text(
                          colaborador.resumen,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                height: 1.6,
                                color: const Color(0xFF586963),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Volver al panel'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelRemuneracion extends StatelessWidget {
  const _PanelRemuneracion({required this.colaborador});

  final Colaborador colaborador;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F4EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD2EADF)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF167A62),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Remuneración',
                  style: TextStyle(
                    color: Color(0xFF557369),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  // El vínculo por horas se distingue del sueldo mensual.
                  '${_formatoSoles(colaborador.remuneracion)} ${colaborador.tipo == 'Contratados' ? '/ hora' : '/ mes'}',
                  style: const TextStyle(
                    color: Color(0xFF145D48),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.circle, color: Color(0xFF2EAA70), size: 11),
              SizedBox(height: 5),
              Text(
                'Activo',
                style: TextStyle(
                  color: Color(0xFF176B4A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  const _TituloSeccion({required this.icono, required this.titulo});

  final IconData icono;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, color: const Color(0xFF075C52), size: 21),
        const SizedBox(width: 9),
        Text(
          titulo,
          style: const TextStyle(
            color: Color(0xFF17352F),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DatoFicha extends StatelessWidget {
  const _DatoFicha({required this.etiqueta, required this.valor});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            color: Color(0xFF82908B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          valor,
          style: const TextStyle(
            color: Color(0xFF334640),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

Color _colorPorTipo(String tipo) {
  // Mantiene el mismo código visual por tipo que se usa en el directorio.
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
  // Presenta la remuneración con separador de miles y dos decimales.
  final entero = partes.first.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
  return 'S/ $entero.${partes.last}';
}
