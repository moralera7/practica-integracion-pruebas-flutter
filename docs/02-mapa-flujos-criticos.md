# 02. Mapa de Flujos Críticos

A continuación se definen los **5 flujos críticos** de la aplicación bajo el formato estándar *"El usuario puede..."*:

1. **Flujo Crítico 1 — Consulta en tiempo real y visualización de estados (Lectura):**  
   *El usuario puede* abrir la aplicación y visualizar en tiempo real el listado de tareas almacenadas en Cloud Firestore ordenadas por fecha de creación, o bien visualizar un mensaje claro de estado vacío cuando aún no existen registros.

2. **Flujo Crítico 2 — Creación validada de una nueva tarea (Escritura y Validación):**  
   *El usuario puede* navegar a la pantalla de formulario, ingresar un título válido (mínimo 3 caracteres) y una descripción opcional, y guardar el registro para que persista inmediatamente en Cloud Firestore y se refleje automáticamente en la pantalla principal.

3. **Flujo Crítico 3 — Prevención de envíos inválidos en el formulario (Flujo Negativo):**  
   *El usuario puede* intentar guardar un formulario vacío o con espacios en blanco y recibir retroalimentación visual inmediata mediante mensajes de validación en los campos sin que se ejecute ninguna llamada innecesaria hacia Firebase.

4. **Flujo Crítico 4 — Consulta de detalle y navegación segura entre pantallas (Navegación):**  
   *El usuario puede* pulsar sobre cualquier tarea de la lista para abrir la pantalla de detalle completo (`DetalleTareaScreen`) y regresar a la pantalla principal mediante el botón o gesto de retroceso sin cierres inesperados ni pérdida de estado.

5. **Flujo Crítico 5 — Actualización de estado y eliminación de registros (Mutación y Borrado):**  
   *El usuario puede* marcar una tarea como completada/pendiente mediante su casilla de verificación o eliminarla definitivamente de la lista, sincronizando el cambio de forma instantánea con la colección `tareas` en Cloud Firestore.
