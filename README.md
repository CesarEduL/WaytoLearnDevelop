## WaytoLearn

Aplicación Flutter para aprendizaje infantil (matemáticas y comunicación) con autenticación de Google y Firebase.

### Requisitos
- Flutter 3.x y Dart 3.x
- Android Studio o VS Code
- Proyecto en Firebase

### Instalación rápida
```bash
git clone <repo>
cd waytolearn
flutter pub get
```

### Variables de entorno (.env)
Crea un archivo `.env` en la raíz con:
```bash
FIREBASE_API_KEY=
FIREBASE_APP_ID=
FIREBASE_MESSAGING_SENDER_ID=
FIREBASE_PROJECT_ID=
FIREBASE_DATABASE_URL=
FIREBASE_STORAGE_BUCKET=
# OAuth 2.0 Client ID (tipo Web)
FIREBASE_WEB_CLIENT_ID=
```
El código usa estas variables en `lib/firebase_options.dart` y para `GoogleSignIn`.

### Configuración Firebase (Android)
- Paquete actual de la app: `com.example.waytolearn` (ver `android/app/build.gradle`).
- Pasos:
  1) En Firebase Console agrega la app Android con ese paquete.
  2) Añade huellas digitales (debug/release) del keystore:
     - Windows (PowerShell):
       ```bash
       keytool -list -v -alias androiddebugkey -keystore "$env:USERPROFILE\.android\debug.keystore" -storepass android -keypass android
       ```
     - Copia SHA‑1 (y SHA‑256) y pégalas en Firebase > Configuración del proyecto > Tu app Android.
  3) Habilita el proveedor Google en Authentication.
  4) En Google Cloud Console crea (o usa) un "OAuth client ID" de tipo Web y colócalo en `FIREBASE_WEB_CLIENT_ID`.
  5) Descarga y coloca `android/app/google-services.json`.

### Ejecutar
```bash
flutter clean
flutter pub get
flutter run -d android
```

### Solución rápida a errores comunes
- ApiException:10 o `sign_in_failed`:
  - Paquete en Firebase debe ser `com.example.waytolearn`.
  - Agrega SHA‑1/SHA‑256 y vuelve a descargar `google-services.json`.
  - Asegura `FIREBASE_WEB_CLIENT_ID` (cliente OAuth Web) y Google habilitado en Authentication.
  - Reinstala tras `flutter clean && flutter pub get`.
- PackageId distinto (p.ej. `com.waylearn.waytolearn`):
  - Actualiza `applicationId`, paquete Kotlin y vuelve a generar `google-services.json` para ese paquete.
- Permisos/red:
  - `INTERNET` ya está definido en `android/app/src/main/AndroidManifest.xml`.

### Estructura mínima
- `lib/main.dart`: arranque
- `lib/core/services/user_service.dart`: login con Google/Firebase
- `lib/presentation/screens/auth/login_screen.dart`: UI de login (botón nativo)
- `lib/firebase_options.dart`: configuración Firebase (lee `.env`)