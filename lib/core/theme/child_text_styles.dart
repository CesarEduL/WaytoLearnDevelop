import 'package:flutter/material.dart';
import 'child_colors.dart';

/// Estilos de texto para niños - grandes y legibles
class ChildTextStyles {
  // Títulos principales
  static const TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    height: 1.2,
  );
  
  static const TextStyle titleWhite = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.2,
  );
  
  // Subtítulos
  static const TextStyle subtitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    height: 1.3,
  );
  
  static const TextStyle subtitleWhite = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.3,
  );
  
  // Texto de cuerpo
  static const TextStyle body = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
    height: 1.5,
  );
  
  static const TextStyle bodyWhite = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: Colors.white,
    height: 1.5,
  );
  
  // Texto pequeño
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
    height: 1.4,
  );
  
  static const TextStyle captionWhite = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white70,
    height: 1.4,
  );
  
  // Botones
  static const TextStyle button = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 0.5,
  );
  
  // Números grandes
  static const TextStyle bigNumber = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: ChildColors.blueSky,
  );
}
