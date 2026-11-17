import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tarea_model.dart';

/// Interfaz base del repositorio para permitir inyección de dependencias y Fakes en pruebas
abstract class TareasRepository {
  Stream<List<Tarea>> obtenerTareasStream();
  Future<void> agregarTarea(Tarea tarea);
  Future<void> actualizarEstadoTarea(String id, bool completada);
  Future<void> eliminarTarea(String id);
}

/// Implementación real conectada a Cloud Firestore
class FirestoreTareasRepository implements TareasRepository {
  final FirebaseFirestore _firestore;
  final String _coleccion = 'tareas';

  FirestoreTareasRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Tarea>> obtenerTareasStream() {
    return _firestore
        .collection(_coleccion)
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Tarea.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> agregarTarea(Tarea tarea) async {
    await _firestore.collection(_coleccion).add(tarea.toMap());
  }

  @override
  Future<void> actualizarEstadoTarea(String id, bool completada) async {
    await _firestore
        .collection(_coleccion)
        .doc(id)
        .update({'completada': completada});
  }

  @override
  Future<void> eliminarTarea(String id) async {
    await _firestore.collection(_coleccion).doc(id).delete();
  }
}

/// Implementación Fake en memoria para pruebas de Widgets y ejecución sin credenciales
class FakeTareasRepository implements TareasRepository {
  final List<Tarea> _tareas = [];
  final StreamController<List<Tarea>> _controller =
      StreamController<List<Tarea>>.broadcast();

  FakeTareasRepository({List<Tarea>? tareasIniciales}) {
    if (tareasIniciales != null) {
      _tareas.addAll(tareasIniciales);
    }
    _emitir();
  }

  void _emitir() {
    if (!_controller.isClosed) {
      _controller.add(List.unmodifiable(_tareas));
    }
  }

  @override
  Stream<List<Tarea>> obtenerTareasStream() async* {
    yield List.unmodifiable(_tareas);
    yield* _controller.stream;
  }

  @override
  Future<void> agregarTarea(Tarea tarea) async {
    final nueva = tarea.copyWith(
      id: tarea.id.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : tarea.id,
    );
    _tareas.insert(0, nueva);
    _emitir();
  }

  @override
  Future<void> actualizarEstadoTarea(String id, bool completada) async {
    final index = _tareas.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tareas[index] = _tareas[index].copyWith(completada: completada);
      _emitir();
    }
  }

  @override
  Future<void> eliminarTarea(String id) async {
    _tareas.removeWhere((t) => t.id == id);
    _emitir();
  }

  void dispose() {
    _controller.close();
  }
}
