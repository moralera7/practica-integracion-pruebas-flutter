class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  final bool completada;
  final DateTime fechaCreacion;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.completada = false,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  /// Validador de negocio para el formulario y pruebas unitarias (INC-001 corregida)
  static String? validarTitulo(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'El título de la tarea es obligatorio';
    }
    if (valor.trim().length < 3) {
      return 'El título debe tener al menos 3 caracteres';
    }
    return null;
  }

  /// Convierte un Mapa (JSON/Firestore) en una instancia de Tarea (INC-002 corregida)
  factory Tarea.fromMap(Map<String, dynamic> map, String documentId) {
    return Tarea(
      id: documentId,
      titulo: (map['titulo'] as String?)?.trim() ?? 'Sin título',
      descripcion: (map['descripcion'] as String?)?.trim() ?? '',
      completada: map['completada'] as bool? ?? false,
      fechaCreacion: map['fechaCreacion'] != null
          ? DateTime.tryParse(map['fechaCreacion'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Convierte la instancia de Tarea a un Mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo.trim(),
      'descripcion': descripcion.trim(),
      'completada': completada,
      'fechaCreacion': fechaCreacion.toIso8601String(),
    };
  }

  Tarea copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    bool? completada,
    DateTime? fechaCreacion,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      completada: completada ?? this.completada,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
