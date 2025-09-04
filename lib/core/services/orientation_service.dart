import 'package:flutter/services.dart';

class OrientationService {
  static final OrientationService _instance = OrientationService._internal();
  factory OrientationService() => _instance;
  OrientationService._internal();

  /// Configura la orientación de la aplicación
  Future<void> setOrientation(List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  /// Configura la aplicación para orientación vertical (portrait)
  Future<void> setPortraitOnly() async {
    await setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Configura la aplicación para orientación horizontal (landscape)
  Future<void> setLandscapeOnly() async {
    await setOrientation([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Configura la aplicación para orientación horizontal con transición suave
  Future<void> setLandscapeOnlyWithDelay() async {
    // Pequeño delay para permitir que la UI se renderice
    await Future.delayed(const Duration(milliseconds: 100));
    await setLandscapeOnly();
  }

  /// Permite todas las orientaciones
  Future<void> setAllOrientations() async {
    await setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Configura la aplicación para orientación horizontal con preferencia por landscapeLeft
  Future<void> setLandscapeLeft() async {
    await setOrientation([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /// Configura la aplicación para orientación horizontal con preferencia por landscapeRight
  Future<void> setLandscapeRight() async {
    await setOrientation([
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Restaura la orientación por defecto (todas las orientaciones)
  Future<void> resetOrientation() async {
    await setAllOrientations();
  }

  /// Cambia automáticamente a landscape si está en portrait
  Future<void> autoRotateToLandscape() async {
    // Cambiar automáticamente a landscape
    await setLandscapeOnlyWithDelay();
  }
}
