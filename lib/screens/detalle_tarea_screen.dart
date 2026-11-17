import 'package:flutter/material.dart';
import '../models/tarea_model.dart';

class DetalleTareaScreen extends StatelessWidget {
  final Tarea tarea;

  const DetalleTareaScreen({super.key, required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tarea.titulo,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Estado: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text(
                        tarea.completada ? 'Completada' : 'Pendiente',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Descripción:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  tarea.descripcion.isEmpty
                      ? 'Sin descripción detallada.'
                      : tarea.descripcion,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
