import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rrhh/main.dart';
import 'package:rrhh/providers/talento_provider.dart';

// Estas pruebas cubren la interacción principal del panel y las reglas del estado.
void main() {
  testWidgets('el panel busca colaboradores en tiempo real', (tester) async {
    await tester.pumpWidget(const TalentoApp());

    // La consulta debe reducir la lista sin necesidad de confirmar la búsqueda.
    expect(find.text('Talento SENATI'), findsOneWidget);
    expect(find.text('Colaborador de ejemplo 01'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('talento-search')), '06');
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Colaborador de ejemplo 06'), findsOneWidget);
    expect(find.text('Colaborador de ejemplo 02'), findsNothing);
  });

  testWidgets('la tarjeta abre la ficha profesional', (tester) async {
    await tester.pumpWidget(const TalentoApp());
    await tester.tap(find.byKey(const Key('colaborador-sen-001')));
    await tester.pumpAndSettle();

    // Desplazamos la ficha para comprobar también sus secciones inferiores.
    expect(find.text('Ficha del colaborador'), findsOneWidget);
    expect(find.text('DNI'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Resumen profesional'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Volver al panel'), findsOneWidget);
  });

  testWidgets('el filtro muestra solo el tipo seleccionado', (tester) async {
    await tester.pumpWidget(const TalentoApp());
    await tester.tap(find.widgetWithText(FilterChip, 'TI'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();

    // Solo aparecen perfiles TI; un colaborador de Planta queda excluido.
    expect(find.text('Colaborador de ejemplo 02'), findsOneWidget);
    expect(find.text('Colaborador de ejemplo 01'), findsNothing);
  });

  testWidgets('el formulario muestra validaciones antes de guardar', (
    tester,
  ) async {
    await tester.pumpWidget(const TalentoApp());
    await tester.tap(find.text('Nuevo colaborador'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-colaborador')));
    await tester.pumpAndSettle();

    // El formulario vacío debe mostrar errores y no completar el alta.
    expect(find.text('Ingresa el nombre completo.'), findsOneWidget);
    expect(find.text('El DNI debe tener 8 dígitos.'), findsOneWidget);
    expect(find.text('Ingresa la remuneración.'), findsOneWidget);
    expect(find.text('Agrega un resumen profesional.'), findsOneWidget);
  });

  test('el proveedor filtra y evita DNI duplicados', () {
    final provider = TalentoProvider();

    // Comprueba el filtro del estado y que los DNI existentes no se repitan.
    provider.seleccionarFiltro('Administrativos');
    expect(provider.colaboradoresVisibles, hasLength(1));
    expect(
      provider.colaboradoresVisibles.single.nombre,
      'Colaborador de ejemplo 03',
    );

    expect(provider.existeDni('00000001'), isTrue);
    expect(
      () => provider.agregarColaborador(
        nombre: 'Persona Duplicada',
        dni: '00000001',
        rol: 'Soporte de Sistemas',
        tipo: 'TI',
        remuneracion: 2500,
        resumen: 'Perfil de prueba.',
      ),
      throwsArgumentError,
    );

    provider.agregarColaborador(
      nombre: 'Nuevo perfil de prueba',
      dni: '00000099',
      rol: 'Soporte de Sistemas',
      tipo: 'TI',
      remuneracion: 2800,
      resumen: 'Experiencia en soporte técnico.',
    );
    // Un alta válida queda al inicio y actualiza el total de activos.
    expect(provider.totalActivos, 7);
    expect(provider.colaboradores.first.nombre, 'Nuevo perfil de prueba');

    provider.dispose();
  });
}
