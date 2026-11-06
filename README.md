# Talento SENATI

Aplicación multiplataforma de gestión de colaboradores desarrollada con Flutter y
Material Design 3. Permite consultar perfiles, buscar por nombre o especialidad,
filtrar por tipo de vínculo, registrar colaboradores y revisar su ficha profesional.

## Funcionalidades

- Panel con el total de colaboradores activos y un resumen del equipo.
- Búsqueda reactiva por nombre y especialidad.
- Filtros para Todos, Planta, Contratados, Administrativos y TI.
- Tarjetas de perfil con iniciales, rol, tipo de vínculo y remuneración en soles.
- Formulario inferior adaptable al teclado, con validación de campos obligatorios,
  DNI peruano de 8 dígitos, DNI único y monto positivo de hasta dos decimales.
- Ficha detallada con resumen profesional, estado y remuneración.
- Navegación a la ruta `/talento/details` con transición Hero entre avatar y ficha.
- Diseño adaptable a móvil, tablet, escritorio y web.

## Tecnologías y decisiones

- **Flutter / Dart:** una sola base de código para Android, iOS, web, Windows,
  macOS y Linux.
- **Material 3:** tema con paleta verde institucional, superficies claras, tarjetas
  redondeadas, chips, indicadores y botones accesibles.
- **ChangeNotifier:** mantiene la lista y los criterios de búsqueda en un estado
  centralizado; `AnimatedBuilder` actualiza el panel cuando se modifica.
- **Navegación Flutter:** la ficha se abre en `/talento/details` y recibe el objeto
  del colaborador como argumento.
- **Datos de demostración en memoria:** el alta y los cambios se conservan durante
  la sesión de la aplicación. No hay conexión a un servidor ni persistencia local.

## Estructura del proyecto

```text
lib/
├── main.dart                         # Arranque, tema, estado compartido y ruta
├── models/
│   └── colaborador_model.dart        # Modelo del colaborador
├── providers/
│   └── talento_provider.dart         # Estado, filtros, búsqueda y altas
├── screens/
│   ├── home_screen.dart              # Panel y directorio
│   └── details_screen.dart           # Ficha profesional
└── widgets/
    └── registro_modal.dart           # Formulario de alta y validaciones
```

### Cómo se construyó

1. Se definió `Colaborador` con identificador, nombre, DNI, rol, vínculo,
   remuneración y resumen profesional.
2. `TalentoProvider` centraliza los datos iniciales y las operaciones del
   directorio. La búsqueda y el filtro se aplican sobre la lista, y cada cambio
   notifica a la interfaz mediante `ChangeNotifier`.
3. `HomeScreen` presenta el resumen, los chips y el listado; sus tarjetas abren
   la ficha mediante la ruta nombrada. El FAB despliega el formulario.
4. `RegistroModal` valida cada campo antes de llamar al proveedor. El DNI debe
   tener ocho dígitos y no estar registrado; la remuneración debe ser numérica,
   positiva y tener como máximo dos decimales.
5. `DetailsScreen` organiza los datos personales, el estado laboral, el monto y
   el resumen profesional; el botón de retorno vuelve a la pantalla anterior.
6. El tema global aplica Material 3 y limita el ancho del contenido para conservar
   una lectura cómoda en pantallas grandes.

## Requisitos

- Flutter SDK compatible con `environment.sdk` en `pubspec.yaml`.
- Dart incluido con Flutter.
- Un emulador, dispositivo o navegador soportado por Flutter.

## Ejecutar

Desde la raíz del proyecto:

```bash
flutter pub get
flutter run
```

Para elegir un destino concreto, consulta primero los dispositivos disponibles:

```bash
flutter devices
flutter run -d <id-del-dispositivo>
```

Para ejecutar la versión web:

```bash
flutter run -d chrome
```

## Verificación

```bash
flutter analyze
flutter test
```

## Alcance actual y siguientes pasos

Esta versión es una demostración funcional de interfaz y lógica local. Los
colaboradores de ejemplo no representan personal real. Antes de usarla en un
entorno institucional, se recomienda integrar autenticación, permisos por rol,
una API con base de datos, persistencia, auditoría y políticas de protección de
datos personales.
