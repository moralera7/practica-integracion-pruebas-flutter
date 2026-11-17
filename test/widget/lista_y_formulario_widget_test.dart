import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:practica_integracion_pruebas_flutter/models/tarea_model.dart';
import 'package:practica_integracion_pruebas_flutter/services/tareas_repository.dart';
import 'package:practica_integracion_pruebas_flutter/screens/lista_tareas_screen.dart';
import 'package:practica_integracion_pruebas_flutter/screens/formulario_tarea_screen.dart';

void main() {
  group('Pruebas de Widget con FakeTareasRepository', () {
    testWidgets('Muestra mensaje de estado vacio cuando no hay tareas',
        (WidgetTester tester) async {
      final fakeRepo = FakeTareasRepository(tareasIniciales: []);

      await tester.pumpWidget(
        MaterialApp(
          home: ListaTareasScreen(repository: fakeRepo),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byKey(const Key('empty_state_text')), findsOneWidget);
      expect(find.text('No hay tareas registradas'), findsOneWidget);
      fakeRepo.dispose();
    });

    testWidgets('Muestra la lista de tareas cuando el repositorio contiene datos',
        (WidgetTester tester) async {
      final fakeRepo = FakeTareasRepository(
        tareasIniciales: [
          Tarea(
            id: 't1',
            titulo: 'Tarea de prueba widget',
            descripcion: 'Detalle de prueba',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ListaTareasScreen(repository: fakeRepo),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Tarea de prueba widget'), findsOneWidget);
      expect(find.text('Detalle de prueba'), findsOneWidget);
      fakeRepo.dispose();
    });

    testWidgets('Formulario muestra error de validacion si se intenta guardar vacio',
        (WidgetTester tester) async {
      final fakeRepo = FakeTareasRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: FormularioTareaScreen(repository: fakeRepo),
        ),
      );

      await tester.tap(find.byKey(const Key('btn_guardar_tarea')));
      await tester.pump();

      expect(
        find.text('El título de la tarea es obligatorio'),
        findsOneWidget,
      );
      fakeRepo.dispose();
    });
  });
}
