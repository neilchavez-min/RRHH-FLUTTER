import 'package:flutter/material.dart';

import 'models/colaborador_model.dart';
import 'providers/talento_provider.dart';
import 'screens/details_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TalentoApp());
}

/// Configura el tema global y conserva el proveedor durante toda la sesión.
class TalentoApp extends StatefulWidget {
  const TalentoApp({super.key});

  @override
  State<TalentoApp> createState() => _TalentoAppState();
}

class _TalentoAppState extends State<TalentoApp> {
  late final TalentoProvider _talentoProvider;

  @override
  void initState() {
    super.initState();
    // Se comparte una única instancia entre el panel y el formulario de alta.
    _talentoProvider = TalentoProvider();
  }

  @override
  void dispose() {
    _talentoProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // El color semilla genera la paleta coherente de Material 3.
    const seedColor = Color(0xFF075C52);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'Talento SENATI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7F6),
          foregroundColor: Color(0xFF16332E),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFFE7ECEA)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E8E5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E8E5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: seedColor, width: 1.5),
          ),
        ),
      ),
      home: HomeScreen(provider: _talentoProvider),
      onGenerateRoute: (settings) {
        // La ficha recibe el colaborador seleccionado como argumento de ruta.
        if (settings.name == '/talento/details') {
          final colaborador = settings.arguments;
          if (colaborador is Colaborador) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => DetailsScreen(colaborador: colaborador),
            );
          }
          return MaterialPageRoute<void>(
            builder: (_) => const _RouteErrorScreen(),
          );
        }
        return null;
      },
    );
  }
}

/// Evita un fallo silencioso cuando se abre la ficha sin sus argumentos.
class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ficha no disponible')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_off_outlined, size: 48),
              const SizedBox(height: 12),
              const Text('No se recibieron los datos del colaborador.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Volver al panel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
