# 04. Registro y Gestión de Incidencias (Método de 5 Pasos)

Durante la Fase 3 (Integración incremental) y Fase 4 (Pruebas automatizadas), se identificaron, clasificaron y corrigieron **3 incidencias** siguiendo el método sistemático de 5 pasos (*Reproducir → Leer → Hipótesis → Comprobar → Corregir y proteger*).

---

## Resumen de Incidencias Registradas

| ID | Título de la incidencia | Caso asociado | Severidad | Prioridad | Origen | Estado | Commit de corrección |
| :--- | :--- | :---: | :---: | :---: | :--- | :---: | :--- |
| **INC-001** | El formulario permite guardar tareas cuyo título contiene únicamente espacios en blanco | CP-04 | Media | Alta | Validación / Lógica de UI | **Cerrada (Corregida y Re-probada)** | `fix: INC-001 validar espacios en blanco en titulo de tarea` |
| **INC-002** | Excepción `type 'Null' is not a subtype of type 'String'` al leer documentos sin campo `descripcion` en Firestore | CP-08 / CP-22 | Crítica | Alta | Datos / Deserialización Modelo | **Cerrada (Corregida y Re-probada)** | `fix: INC-002 manejo seguro de nulos en Tarea.fromMap` |
| **INC-003** | Advertencia de análisis estático y riesgo de crash al usar `Navigator.pop(context)` tras `await` sin verificar `mounted` | CP-07 | Media | Media | Navegación / Ciclo de vida asíncrono | **Cerrada (Corregida y Re-probada)** | `fix: INC-003 verificar mounted antes de Navigator.pop asincrono` |

---

## Detalle Técnico y Aplicación del Método de 5 Pasos

### Incidencia INC-001 — Creación de tareas con título compuesto solo por espacios
* **Severidad:** Media | **Prioridad:** Alta | **Origen:** Validación (`lib/models/tarea_model.dart`)
* **1. Reproducir:** En `FormularioTareaScreen`, se ingresaron 4 espacios en blanco (`"    "`) en el campo de título y se pulsó "Guardar Tarea" (CP-04). La tarea se guardó en Firestore con un título visualmente vacío.
* **2. Leer:** Se inspeccionó el validador original que evaluaba únicamente `if (valor == null || valor.isEmpty)`, el cual devuelve `false` cuando la cadena contiene espacios (`"    ".isEmpty == false`).
* **3. Hipótesis:** La ausencia del método `.trim()` antes de evaluar `isEmpty` y la longitud mínima permite que cadenas con espacios pasen la validación del formulario.
* **4. Comprobar:** Se escribió una prueba unitaria en `test/unit/tarea_model_test.dart` pasando `Tarea.validarTitulo('   ')`, confirmando que devolvía `null` (válido) en lugar de un mensaje de error.
* **5. Corregir y proteger:** Se actualizó `Tarea.validarTitulo` para aplicar `valor.trim().isEmpty` y `valor.trim().length < 3`, además de aplicar `.trim()` en `toMap()`. Se re-ejecutó la prueba unitaria y el caso **CP-04**, quedando ambos en estado **Aprobado**.

---

### Incidencia INC-002 — Fallo crítico de deserialización ante campos nulos en Cloud Firestore
* **Severidad:** Crítica | **Prioridad:** Alta | **Origen:** Modelo / Datos (`lib/models/tarea_model.dart`)
* **1. Reproducir:** Al crear un documento de prueba directamente desde Firebase Console omitiendo el campo opcional `descripcion`, la pantalla principal arrojó un error en el `StreamBuilder`.
* **2. Leer:** El stacktrace en consola mostró: `TypeError: null: type 'Null' is not a subtype of type 'String' in Tarea.fromMap`.
* **3. Hipótesis:** El constructor `Tarea.fromMap` realizaba un cast forzado `map['descripcion'] as String`, asumiendo que la clave siempre existiría y nunca sería nula en una base de datos NoSQL sin esquema rígido.
* **4. Comprobar:** Se reprodujo el caso en `test/unit/tarea_model_test.dart` pasando un `Map` con `'descripcion': null`, confirmando el lanzamiento inmediato del `TypeError`.
* **5. Corregir y proteger:** Se modificó `Tarea.fromMap` utilizando operadores *null-aware*: `(map['descripcion'] as String?)?.trim() ?? ''` y `DateTime.tryParse(...) ?? DateTime.now()`. Se ejecutó la prueba de regresión (CP-08 y CP-22) y `flutter test`, pasando satisfactoriamente.

---

### Incidencia INC-003 — Uso inseguro de `BuildContext` después de una operación asíncrona (`await`)
* **Severidad:** Media | **Prioridad:** Media | **Origen:** Ciclo de vida del Widget (`lib/screens/formulario_tarea_screen.dart`)
* **1. Reproducir:** Al ejecutar `flutter analyze` en la Fase 1 y al probar el guardado en redes lentas (CP-07), el analizador reportó la advertencia `use_build_context_synchronously` en la línea `Navigator.pop(context)` posterior a `await widget.repository.agregarTarea(nuevaTarea)`.
* **2. Leer:** La documentación de Flutter advierte que si el usuario presiona "Atrás" mientras el `Future` de Firestore sigue en curso, el widget se desmonta del árbol y llamar a `Navigator.pop(context)` sobre un contexto desmontado produce una excepción no controlada.
* **3. Hipótesis:** Falta verificar la propiedad `mounted` del `State` inmediatamente después del `await` antes de invocar al `Navigator` o al `ScaffoldMessenger`.
* **4. Comprobar:** Se verificó con `flutter analyze` la presencia de la regla infringida en `lib/screens/formulario_tarea_screen.dart`.
* **5. Corregir y proteger:** Se incorporó la guarda `if (!mounted) return;` inmediatamente después del `await` tanto en el bloque `try` como en el `catch`. Al volver a correr `flutter analyze`, el resultado fue `No issues found!`.
