import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/tarea_model.dart';
import 'services/tareas_repository.dart';
import 'screens/lista_tareas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  TareasRepository repository;

  try {
    await Firebase.initializeApp();
    repository = FirestoreTareasRepository();
  } catch (e) {
    // Fallback controlado en caso de correr sin google-services.json en entorno local de evaluación
    debugPrint('Aviso: Ejecutando con FakeTareasRepository ($e)');
    repository = FakeTareasRepository(
      tareasIniciales: [
        Tarea(
          id: '1',
          titulo: 'Configurar proyecto en Firebase Console',
          descripcion: 'Verificar reglas e índices de Cloud Firestore',
          completada: true,
        ),
        Tarea(
          id: '2',
          titulo: 'Ejecutar flutter test y flutter analyze',
          descripcion: 'Capturar evidencias para la entrega de la Semana 16',
          completada: false,
        ),
      ],
    );
  }

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TareasRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Práctica Integración Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: ListaTareasScreen(repository: repository),
    );
  }
}
