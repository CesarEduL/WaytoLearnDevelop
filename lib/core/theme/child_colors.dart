import 'package:flutter/material.dart';

/// Paleta de colores infantiles para WaytoLearn
class ChildColors {
  // Colores principales
  static const Color blueSky = Color(0xFF4FC3F7);
  static const Color purpleMagic = Color(0xFF9C27B0);
  static const Color greenHappy = Color(0xFF66BB6A);
  static const Color yellowSun = Color(0xFFFFEB3B);
  static const Color pinkSweet = Color(0xFFEC407A);
  static const Color orangeEnergy = Color(0xFFFF9800);
  
  // Colores de estado
  static const Color locked = Color(0xFF9E9E9E);
  static const Color current = Color(0xFF2196F3);
  static const Color completed = Color(0xFF7B1FA2);
  
  // Colores de fondo
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  
  // Gradientes
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF4FC3F7), Color(0xFF2196F3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Método para obtener gradiente por índice de sesión
  static LinearGradient getSessionGradient(int index) {
    switch (index % 4) {
      case 0:
        return blueGradient;
      case 1:
        return purpleGradient;
      case 2:
        return greenGradient;
      case 3:
        return orangeGradient;
      default:
        return blueGradient;
    }
  }
  
  // Método para obtener color por índice de sesión
  static Color getSessionColor(int index) {
    switch (index % 4) {
      case 0:
        return blueSky;
      case 1:
        return purpleMagic;
      case 2:
        return greenHappy;
      case 3:
        return orangeEnergy;
      default:
        return blueSky;
    }
  }
}
