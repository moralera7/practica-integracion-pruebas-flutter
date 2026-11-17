# Práctica de Integración y Pruebas en Flutter (Semana 16)

Repositorio oficial de entrega para la práctica de integración incremental, ejecución de pruebas funcionales/automatizadas y gestión de incidencias en Flutter con **Cloud Firestore**.

## 1. Descripción del Proyecto
Aplicación móvil desarrollada en **Flutter** para la gestión de tareas en tiempo real respaldada por **Cloud Firestore**. Implementa una arquitectura desacoplada mediante el patrón Repositorio (`TareasRepository`), permitiendo alternar de manera transparente entre `FirestoreTareasRepository` (producción) y `FakeTareasRepository` (pruebas automatizadas de widgets e integración sin dependencia de red).

### Pantallas integradas:
1. **`ListaTareasScreen`**: Visualización reactiva en tiempo real mediante `StreamBuilder`, manejo de estado vacío, marcado de tareas completadas y eliminación.
2. **`FormularioTareaScreen`**: Creación de nuevas tareas con validación de reglas de negocio (`Tarea.validarTitulo`) y manejo seguro del ciclo de vida asíncrono (`mounted`).
3. **`DetalleTareaScreen`**: Visualización detallada del estado y descripción de la tarea seleccionada.

---

## 2. Estructura del Repositorio

```text
practica-integracion-pruebas-flutter/
│
├── README.md
├── pubspec.yaml
├── analysis_options.yaml
│
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── tarea_model.dart
│   ├── services/
│   │   └── tareas_repository.dart
│   └── screens/
│       ├── lista_tareas_screen.dart
│       ├── formulario_tarea_screen.dart
│       └── detalle_tarea_screen.dart
│
├── test/
│   ├── unit/
│   │   └── tarea_model_test.dart
│   └── widget/
│       └── lista_y_formulario_widget_test.dart
│
├── integration_test/
│   └── app_test.dart
│
└── docs/
    ├── 01-declaracion-alcance.md
    ├── 02-mapa-flujos-criticos.md
    ├── 03-plantilla-pruebas.md
    ├── 04-registro-incidencias.md
    ├── 05-reflexion-final.md
    └── evidencias/
        ├── capturas-aplicacion/
        ├── firebase/
        ├── notificaciones-fcm/
        └── pruebas-y-analisis/
```

---

## 3. Instrucciones para Ejecutar el Proyecto

### Prerrequisitos
- Flutter SDK `>=3.0.0` instalado y configurado.
- Emulador Android/iOS o dispositivo físico conectado.
- Proyecto configurado en Firebase Console con **Cloud Firestore** habilitado (nota: por seguridad y requisito de la guía, `google-services.json` está excluido en `.gitignore`).

### Pasos de ejecución
1. Clonar el repositorio y cambiar a la rama de integración:
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd practica-integracion-pruebas-flutter
   git checkout semana16-integracion
   ```
2. Instalar las dependencias:
   ```bash
   flutter pub get
   ```
3. *(Opcional para conexión a su propia instancia de Firebase)* Colocar su archivo `google-services.json` en `android/app/` (no subir al repositorio). Si se ejecuta sin dicho archivo, la aplicación inicia automáticamente en modo seguro con `FakeTareasRepository` para facilitar la revisión del docente.
4. Ejecutar la aplicación:
   ```bash
   flutter run
   ```

---

## 4. Ejecución de Análisis Estático y Pruebas Automatizadas

- **Análisis estático de código (`0 errores / 0 advertencias`):**
  ```bash
  flutter analyze
  ```
- **Pruebas unitarias y de widget (`8 tests en verde`):**
  ```bash
  flutter test
  ```
- **Pruebas de integración E2E (con emulador encendido):**
  ```bash
  flutter test integration_test/app_test.dart
  ```

---

## 5. Índice de Atestados y Documentación (`docs/`)
1. [01. Declaración de Alcance](docs/01-declaracion-alcance.md)
2. [02. Mapa de Flujos Críticos](docs/02-mapa-flujos-criticos.md)
3. [03. Plantilla de Pruebas (12 casos ejecutados)](docs/03-plantilla-pruebas.md)
4. [04. Registro de Incidencias (3 incidencias resueltas con método de 5 pasos)](docs/04-registro-incidencias.md)
5. [05. Reflexión Técnica Final](docs/05-reflexion-final.md)
6. [Evidencias de Ejecución y Salidas de Consola](docs/evidencias/)
