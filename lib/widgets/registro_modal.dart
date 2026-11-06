import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/talento_provider.dart';

class RegistroModal extends StatefulWidget {
  const RegistroModal({super.key, required this.provider});

  final TalentoProvider provider;

  @override
  State<RegistroModal> createState() => _RegistroModalState();
}

class _RegistroModalState extends State<RegistroModal> {
  // Opciones controladas para mantener consistentes roles y tipos del directorio.
  static const _especialidades = [
    'Docente de Desarrollo de Software',
    'Docente de Diseño Digital',
    'Docente de Gestión Industrial',
    'Docente de Electricidad Industrial',
    'Especialista de Infraestructura TI',
    'Soporte de Sistemas',
    'Analista de Gestión Académica',
    'Administrativo de Recursos Humanos',
  ];

  static const _tipos = ['Planta', 'Contratados', 'Administrativos', 'TI'];

  final _formKey = GlobalKey<FormState>();
  // Los controladores permiten leer los campos y se liberan al cerrar el modal.
  final _nombreController = TextEditingController();
  final _dniController = TextEditingController();
  final _remuneracionController = TextEditingController();
  final _resumenController = TextEditingController();
  String? _especialidad;
  String _tipo = 'Planta';
  String? _error;
  bool _guardando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _dniController.dispose();
    _remuneracionController.dispose();
    _resumenController.dispose();
    super.dispose();
  }

  void _guardar() {
    setState(() {
      _error = null;
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });
    try {
      // Solo se convierte el monto después de validar su formato en el formulario.
      widget.provider.agregarColaborador(
        nombre: _nombreController.text.trim(),
        dni: _dniController.text,
        rol: _especialidad!,
        tipo: _tipo,
        remuneracion: double.parse(
          _remuneracionController.text.replaceAll(',', ''),
        ),
        resumen: _resumenController.text.trim(),
      );
      // Devolvemos un resultado para que el panel confirme el alta al usuario.
      Navigator.of(context).pop(true);
    } on ArgumentError catch (error) {
      setState(() {
        _error = error.message.toString();
        _guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(
        // Reserva espacio para el teclado virtual y mantiene visible el formulario.
        maxHeight:
            MediaQuery.sizeOf(context).height * 0.92 -
            MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FBFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuevo colaborador',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF17352F),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Completa los datos para darlo de alta.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF71807B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Cerrar',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE7ECEA)),
          Flexible(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  22,
                  18,
                  22,
                  22 + MediaQuery.viewInsetsOf(context).bottom,
                ),
                children: [
                  TextFormField(
                    controller: _nombreController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Ingresa el nombre completo.'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    key: const Key('dni-input'),
                    controller: _dniController,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(8),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'DNI',
                      hintText: '8 dígitos',
                      counterText: '',
                      prefixIcon: Icon(Icons.fingerprint_rounded),
                    ),
                    validator: (value) {
                      final dni = value?.trim() ?? '';
                      // La longitud y la unicidad se comprueban antes del alta.
                      if (dni.length != 8) {
                        return 'El DNI debe tener 8 dígitos.';
                      }
                      if (widget.provider.existeDni(dni)) {
                        return 'Ya existe un colaborador con este DNI.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _especialidad,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Rol o especialidad',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    items: _especialidades
                        .map(
                          (especialidad) => DropdownMenuItem(
                            value: especialidad,
                            child: Text(
                              especialidad,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      _especialidad = value;
                    }),
                    validator: (value) => value == null
                        ? 'Selecciona un rol o especialidad.'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _tipo,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de vínculo',
                      prefixIcon: Icon(Icons.work_outline_rounded),
                    ),
                    items: _tipos
                        .map(
                          (tipo) =>
                              DropdownMenuItem(value: tipo, child: Text(tipo)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _tipo = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _remuneracionController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Remuneración',
                      hintText: '3,500.00',
                      prefixText: 'S/ ',
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    validator: (value) {
                      final texto = value?.trim() ?? '';
                      if (texto.isEmpty) return 'Ingresa la remuneración.';
                      final normalizado = texto.replaceAll(',', '');
                      final monto = double.tryParse(normalizado);
                      if (monto == null || monto <= 0) {
                        return 'Ingresa un monto válido mayor que cero.';
                      }
                      if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(normalizado)) {
                        return 'Usa hasta dos decimales (ej. 3500.00).';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _resumenController,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Resumen profesional',
                      hintText: 'Experiencia, certificaciones o fortalezas...',
                      alignLabelWithHint: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 52),
                        child: Icon(Icons.description_outlined),
                      ),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Agrega un resumen profesional.'
                        : null,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _error!,
                      style: const TextStyle(
                        color: Color(0xFFB3261E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    key: const Key('save-colaborador'),
                    onPressed: _guardando ? null : _guardar,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: Text(
                      _guardando ? 'Guardando...' : 'Dar de alta colaborador',
                    ),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
