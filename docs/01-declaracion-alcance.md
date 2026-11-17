# 01. Declaración de Alcance del Proyecto

**Proyecto:** Gestor de Tareas con Cloud Firestore (`practica-integracion-pruebas-flutter`)  
**Rama de trabajo:** `semana16-integracion`  
**Fecha:** Noviembre 2026  

## Tabla de Declaración de Alcance

| Módulo / servicio | ¿Aplica? | Observación |
| :--- | :---: | :--- |
| **Autenticación** | ☐ No | El alcance del proyecto se centra en la persistencia reactiva directa en Cloud Firestore sin requerir login previo. |
| **Base de datos (Firestore / Realtime DB)** | ☑ Sí | Se utiliza **Cloud Firestore** (colección `tareas`) para lectura en tiempo real (`StreamBuilder`), creación, actualización de estado y eliminación de documentos. |
| **Almacenamiento (Storage)** | ☐ No | Los documentos de tareas almacenan únicamente metadatos textuales y booleanos; no se adjuntan archivos multimedia. |
| **Notificaciones push (FCM)** | ☐ No | Fuera del alcance funcional de este módulo; se documentan como *No ejecutado* con justificación técnica en la matriz de pruebas. |
| **API REST externa** | ☐ No | Toda la persistencia se realiza de forma nativa mediante el SDK de Cloud Firestore (`cloud_firestore`). |
| **Otros (Analytics, Crashlytics, Remote Config…)** | ☐ No | No requeridos dentro del alcance base de la aplicación. |

## Verificación de Estado Mínimo del Proyecto
- [x] Compila y ejecuta (`flutter run`).
- [x] Tiene al menos 2 pantallas distintas (`ListaTareasScreen`, `FormularioTareaScreen`, `DetalleTareaScreen`).
- [x] Usa al menos 1 servicio de Firebase (`firebase_core` y `cloud_firestore`).
- [x] Repositorio con control de versiones en Git y rama `semana16-integracion`.
