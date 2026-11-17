import 'package:flutter_test/flutter_test.dart';
import 'package:practica_integracion_pruebas_flutter/models/tarea_model.dart';

void main() {
  group('Pruebas Unitarias - Modelo Tarea y Validadores', () {
    test('validarTitulo retorna error si el título es vacío o solo espacios (INC-001)', () {
      expect(Tarea.validarTitulo(''), 'El título de la tarea es obligatorio');
      expect(Tarea.validarTitulo('   '), 'El título de la tarea es obligatorio');
      expect(Tarea.validarTitulo(null), 'El título de la tarea es obligatorio');
    });

    test('validarTitulo retorna error si tiene menos de 3 caracteres', () {
      expect(
        Tarea.validarTitulo('ab'),
        'El título debe tener al menos 3 caracteres',
      );
    });

    test('validarTitulo retorna null cuando el título es válido', () {
      expect(Tarea.validarTitulo('Estudiar Flutter'), isNull);
    });

    test('Tarea.fromMap mapea correctamente y tolera campos nulos (INC-002)', () {
      final map = {
        'titulo': '  Revisar Firestore  ',
        'descripcion': null,
        'completada': true,
      };

      final tarea = Tarea.fromMap(map, 'doc-123');

      expect(tarea.id, 'doc-123');
      expect(tarea.titulo, 'Revisar Firestore');
      expect(tarea.descripcion, '');
      expect(tarea.completada, isTrue);
    });

    test('Tarea.toMap serializa correctamente los datos limpios', () {
      final tarea = Tarea(
        id: '10',
        titulo: ' Prueba Unitaria ',
        descripcion: ' Descripción de prueba ',
        completada: false,
      );

      final map = tarea.toMap();

      expect(map['titulo'], 'Prueba Unitaria');
      expect(map['descripcion'], 'Descripción de prueba');
      expect(map['completada'], isFalse);
      expect(map['fechaCreacion'], isNotNull);
    });
  });
}
