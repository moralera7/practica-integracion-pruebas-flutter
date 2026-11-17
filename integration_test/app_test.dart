import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:practica_integracion_pruebas_flutter/main.dart';
import 'package:practica_integracion_pruebas_flutter/services/tareas_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Flujo completo E2E: Ver estado vacío, crear tarea y verla en la lista',
      (WidgetTester tester) async {
    final fakeRepo = FakeTareasRepository(tareasIniciales: []);

    await tester.pumpWidget(MyApp(repository: fakeRepo));
    await tester.pumpAndSettle();

    // 1. Verificar pantalla inicial vacía
    expect(find.text('No hay tareas registradas'), findsOneWidget);

    // 2. Navegar al formulario
    await tester.tap(find.byKey(const Key('fab_agregar_tarea')));
    await tester.pumpAndSettle();

    // 3. Llenar datos y guardar
    await tester.enterText(
      find.byKey(const Key('input_titulo')),
      'Tarea Integración E2E',
    );
    await tester.enterText(
      find.byKey(const Key('input_descripcion')),
      'Creada desde integration_test',
    );
    await tester.tap(find.byKey(const Key('btn_guardar_tarea')));
    await tester.pumpAndSettle();

    // 4. Verificar que regresó a la pantalla principal y aparece en la lista
    expect(find.text('Tarea Integración E2E'), findsOneWidget);
  });
}
