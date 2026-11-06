Convocatoria de Proyecto TI: Desarrollo del Sistema Modular
"Talento SENATI" (Gestión y Control de Recursos Humanos)
El área de Recursos Humanos de la institución educativa SENATI requiere modernizar
y centralizar el flujo de información de su personal docente y administrativo. Tomando
como base el éxito del sistema de inventario de hardware, se solicita el diseño e
implementación de una aplicación web/móvil multiplataforma orientada a la gestión
visual, registro ágil y consulta de perfiles profesionales del personal de TI.
La aplicación debe mantener la filosofía de arquitectura modular, diseño limpio
(Material Design 3) y reactividad en tiempo real, superando las capacidades de
filtrado y control del proyecto anterior.
Módulos y Vistas Obligatorias
1. Panel Principal de Colaboradores (Dashboard / Home)
• Encabezado Institucional: Título "Talento SENATI", barra de búsqueda
predictiva por nombre o especialidad, e indicador del total de personal activo.
• Filtrado Horizontal por Estados/Roles: Sistema dinámico empleando
FilterChip interactivos: Todos, Planta (Tiempo Completo), Contratados,
Administrativos y TI.
• Lista Dinámica Avanzada (ListView.builder): Tarjetas visuales (Card) que
muestren la foto/avatar del colaborador, nombre completo, tag visual con su rol
actual, tarifa por hora o sueldo base formateado en moneda local (S/.), y un
indicador visual (Hero animation) hacia la ficha técnica.
• Botón Flotante de Acción (FAB): Ubicado en la esquina inferior derecha con
la etiqueta + Nuevo Colaborador para desplegar el formulario.
2. Formulario de Alta y Contratación (Modal / Dialog)
Ventana emergente estructurada (showModalBottomSheet con soporte para scroll)
para ingresar nuevos perfiles al estado global, incluyendo íconos guía y validaciones
estrictas:
• Datos Personales: Nombre completo y DNI (Texto con validación de
longitud).
• ┠ Rol o Especialidad: Menú desplegable (DropdownButtonFormField)
indexado por áreas académicas.
• Asignación Económica: Campo numérico con máscara de ejemplo (Ej. S/
3,500.00) e ícono financiero.
• Resumen Profesional / CV: Cuadro de texto multilínea para experiencia
clave o certificaciones activas.
• Botón de Guardado Reactivo: Botón destacado "Dar de Alta Colaborador"
que valida que no existan campos vacíos ni duplicados antes de inyectar el
dato en la lista principal.
3. Ficha del Colaborador (Ruta: /#/talento/details)
Pantalla de visualización profunda que recibe los argumentos de la ruta SPA:
• Contenedor principal con el resumen profesional estructurado.
• Bloque de Estado Destacado: Contenedor de color verde brillante que
indica la remuneración del colaborador y su etiqueta de estado laboral en
tiempo real (ej. "Activo - Con Carga Horaria Disponible").
• Retorno Seguro: Botón inferior estandarizado "Volver al Panel" que
regresa al usuario a la vista anterior limpiando la pila de navegación
(Navigator.pop).
 Objetivos de Aprendizaje y Mejora Tecnológica
• UI/UX de Alto Impacto: Dominar el uso de widgets avanzados y transiciones
fluidas para datos sensibles de personal.
• Persistencia y Optimización de Estado: Implementar reactividad eficiente de
tal forma que al filtrar por rol o buscar un docente, la interfaz responda en
milisegundos sin re-renderizados innecesarios.
• Validaciones Complejas de Negocio: Asegurar que el formulario capture
datos limpios (formatos de sueldo correctos y campos obligatorios validados).
 Estructura del Código Modular (Arquitectura Recomendada)
Para asegurar que el proyecto sea verdaderamente modular en Flutter, se propone
organizar los archivos de la siguiente manera:
lib/
│
├── main.dart # Punto de entrada y configuración de MultiProvider
├── models/
│ └── colaborador_model.dart # Molde de datos (Id, Nombre, DNI, Rol, Sueldo, CV)
├── providers/
│ └── talento_provider.dart # Lógica de negocio (Lista, filtros activos, añadir colaborador)
└── screens/
 ├── home_screen.dart # Panel Principal (Dashboard, Chips, ListView, FAB)
 ├── details_screen.dart # Ficha del Colaborador (Argumentos y bloque destacado)
 └── widgets/
 └── registro_modal.dart# Formulario emergente (showModalBottomSheet)
  Rúbrica de Evaluación: Proyecto "Talento SENATI"
Esta matriz está diseñada para calificar el desempeño de los estudiantes en base a los
criterios técnicos solicitados:
Criterio de
Evaluación Excelente (5 pts) Bueno (3-4 pts) Deficiente (0-2 pts)
Interfaz UI/UX
(Material
Design 3)
Interfaz limpia, uso
correcto de Card,
ListTile, avatars,
FilterChip y
animaciones uniformes.
Interfaz funcional
pero con ligeros
problemas de
alineación o
espaciado en los
widgets.
Interfaz
desorganizada, no
sigue los lineamientos
de Material Design ni
usa los widgets
pedidos.
Lógica de
Filtros y
Búsqueda
El filtrado por
FilterChips y la barra de
búsqueda funcionan en
tiempo real sin congelar
la UI.
Los filtros funcionan
pero la barra de
búsqueda tiene
retrasos o requiere
acciones extra.
Los filtros no
actualizan la lista en
tiempo real o causan
errores en el
renderizado.
Formularios y
Validaciones
Validaciones estrictas
en DNI, sueldo y
campos vacíos. Uso
correcto de máscaras e
íconos visuales.
El formulario guarda
datos, pero carece
de algunas
validaciones críticas
(permite campos
vacíos).
No valida los datos de
entrada o la app se
cae al ingresar
formatos incorrectos
(ej. letras en precio).
Navegación
SPA y Estado
Enrutamiento limpio a
/#/talento/details
pasando argumentos
mediante el estado
global de Provider.
La navegación
funciona pero el
paso de argumentos
se hace de forma
rígida o acoplada.
No hay paso de
argumentos entre
pantallas o rompe el
stack de navegación al
regresar