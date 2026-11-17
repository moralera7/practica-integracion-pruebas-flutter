import 'package:flutter/material.dart';
import '../models/tarea_model.dart';
import '../services/tareas_repository.dart';

class FormularioTareaScreen extends StatefulWidget {
  final TareasRepository repository;

  const FormularioTareaScreen({super.key, required this.repository});

  @override
  State<FormularioTareaScreen> createState() => _FormularioTareaScreenState();
}

class _FormularioTareaScreenState extends State<FormularioTareaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  bool _guardando = false;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardarTarea() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _guardando = true);

    try {
      final nuevaTarea = Tarea(
        id: '',
        titulo: _tituloController.text,
        descripcion: _descripcionController.text,
      );

      await widget.repository.agregarTarea(nuevaTarea);

      // Corrección INC-003: Verificar mounted antes de usar BuildContext tras un await
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar la tarea: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _guardando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('input_titulo'),
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título de la tarea',
                  border: OutlineInputBorder(),
                ),
                validator: Tarea.validarTitulo,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('input_descripcion'),
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('btn_guardar_tarea'),
                onPressed: _guardando ? null : _guardarTarea,
                child: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Guardar Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
