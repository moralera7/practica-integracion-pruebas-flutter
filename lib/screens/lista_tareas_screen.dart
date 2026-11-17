import 'package:flutter/material.dart';
import '../models/tarea_model.dart';
import '../services/tareas_repository.dart';
import 'formulario_tarea_screen.dart';
import 'detalle_tarea_screen.dart';

class ListaTareasScreen extends StatelessWidget {
  final TareasRepository repository;

  const ListaTareasScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas - Semana 16'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Tarea>>(
        stream: repository.obtenerTareasStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar datos: ${snapshot.error}',
                key: const Key('error_state_text'),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tareas = snapshot.data ?? [];

          if (tareas.isEmpty) {
            return const Center(
              child: Text(
                'No hay tareas registradas',
                key: Key('empty_state_text'),
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: tareas.length,
            itemBuilder: (context, index) {
              final tarea = tareas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Checkbox(
                    key: Key('checkbox_${tarea.id}'),
                    value: tarea.completada,
                    onChanged: (valor) {
                      if (valor != null) {
                        repository.actualizarEstadoTarea(tarea.id, valor);
                      }
                    },
                  ),
                  title: Text(
                    tarea.titulo,
                    style: TextStyle(
                      decoration: tarea.completada
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    tarea.descripcion,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    key: Key('delete_${tarea.id}'),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => repository.eliminarTarea(tarea.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalleTareaScreen(tarea: tarea),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('fab_agregar_tarea'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FormularioTareaScreen(repository: repository),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
