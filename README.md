# WayToLearn

## Visión General
waytolearn es una aplicación móvil basada en Flutter diseñada para el aprendizaje interactivo. Este proyecto utiliza las capacidades multiplataforma de Flutter, integra Firebase para servicios backend y incluye diversos activos para enriquecer la experiencia de aprendizaje.

## Estructura del Proyecto
```
waytolearn/
├── .env
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   └── pages/
│       └── pagina02.dart
├── android/
│   ├── build.gradle
│   ├── app/
│   │   ├── build.gradle
│   │   ├── google-services.json
│   │   └── src/main/AndroidManifest.xml
│   └── ...
├── assets/
│   ├── images/
│   │   ├── baymaxface.png
│   └── icons/
└── build/
```

## Instrucciones de Configuración
1. Asegúrate de tener instalado Flutter (SDK >= 3.3.4 < 4.0.0) y Android Studio.
2. Clona el repositorio: `git clone <repository-url>`.
3. Navega al directorio del proyecto: `cd <project-directory>`.
4. Instala las dependencias: `flutter pub get`.
5. Configura `local.properties` con la ruta de tu SDK de Android si es necesario.
6. Configura Firebase agregando `google-services.json` al directorio `android/app`.
7. Crea un archivo `.env` en el directorio raíz con variables de entorno (e.g., claves API).
8. Ejecuta la aplicación: `flutter run`.

## Dependencias
- **Flutter**: Marco principal (SDK: flutter).
- **cupertino_icons**: ^1.0.6 para íconos de estilo iOS.
- **Firebase**:
  - `firebase_core`: ^2.24.2 para inicialización de Firebase.
  - `firebase_auth`: ^4.15.3 para autenticación.
  - `cloud_firestore`: ^4.13.6 para la base de datos Firestore.
  - `firebase_storage`: ^11.5.6 para almacenamiento en la nube.
- **flutter_dotenv**: ^5.1.0 para gestionar variables de entorno.
- **Dependencias de Desarrollo**:
  - `flutter_test`: SDK para pruebas.
  - `flutter_lints`: ^3.0.0 para reglas de linting.

## Activos
- Imágenes: Almacenadas en `assets/images/`.
- Íconos: Almacenados en `assets/icons/`.
- Archivo de entorno: `.env` para configuración.

## Características
- Módulos de aprendizaje interactivo.
- Autenticación y almacenamiento de datos impulsados por Firebase.
- Activos personalizados para una interfaz de usuario rica.

## Contribuyendo
Haz un fork del repositorio y envía pull requests. Sigue el estilo de código existente y actualiza `.gitignore` si se necesitan ignorar nuevos tipos de archivos.

## Versión
1.0.0+1