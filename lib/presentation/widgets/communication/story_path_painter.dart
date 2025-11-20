import 'package:flutter/material.dart';
import 'dart:math' as math;

class StoryPathPainter extends CustomPainter {
  final int completedStoryIndex;
  final double scale;

  StoryPathPainter({
    required this.completedStoryIndex,
    this.scale = 1.0,
  });

  // 16 puntos del camino - eliminados duplicados para redondeo correcto
  static const List<Offset> pathPoints = [
    // primera recta sube
    Offset(130.0, 224.51),    // CUENTO 1 - P0
    Offset(130.0, 147.76),    // P1
    Offset(130.0, 71),        // ESQUINA 1 - P2
    // segunda recta derecha
    Offset(246, 71),          // CUENTO 2 - P3
    Offset(363, 71),          // ESQUINA 2 - P4
    // tercera recta baja
    Offset(363, 224.51),      // CUENTO 3 - P5
    Offset(363, 375),         // ESQUINA 3 - P6
    // cuarta recta derecha 
    Offset(485.5, 375.0),     // CUENTO 4 - P7
    Offset(596.0, 375.0),     // ESQUINA 4 - P8
    // quinta recta sube
    Offset(596.0, 224.51),    // CUENTO 5 - P9
    Offset(596.0, 71),        // ESQUINA 5 - P10
    // sexta recta derecha
    Offset(712.25, 71.0),     // CUENTO 6 - P11
    Offset(828.5, 71),        // ESQUINA 6 - P12
    // séptima recta baja
    Offset(828.5, 146.5),     // CUENTO 7 - P13
    Offset(828.5, 222),       // P14
  ];

  // Índices de los puntos donde se ubican los cuentos (0-indexed)
  // Cuentos en: P0, P3, P5, P7, P9, P11, P13
  static const List<int> storyPointIndices = [0, 3, 5, 7, 9, 11, 14];

  @override
  void paint(Canvas canvas, Size size) {
    // Configuración igual a la imagen: Dash 16, Gap 16, Join redondeado
    // Colores de comunicación
    final inactivePaint = Paint()
      ..color = const Color(0xFFFFDDB3) // Naranja claro inactivo
      ..strokeWidth = 8.0 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = const Color(0xFFFF8C42) // Naranja activo para comunicación
      ..strokeWidth = 8.0 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Dibujar el camino completo
    _drawStoryPath(canvas, inactivePaint, activePaint);
  }

  void _drawStoryPath(Canvas canvas, Paint inactivePaint, Paint activePaint) {
    // Dibujar segmentos según progreso
    for (int i = 0; i < storyPointIndices.length - 1; i++) {
      final startIdx = storyPointIndices[i];
      final endIdx = storyPointIndices[i + 1];
      
      // Determinar si este segmento está completado
      final isActive = i < completedStoryIndex;
      final paint = isActive ? activePaint : inactivePaint;
      
      // Crear path para este segmento con curvas
      final segmentPath = _createSegmentPath(startIdx, endIdx);
      
      // Dibujar segmento con patrón dashed
      _drawDashedPath(canvas, segmentPath, paint);
    }
  }

  Path _createSegmentPath(int startIdx, int endIdx) {
    final path = Path();
    final startPoint = Offset(pathPoints[startIdx].dx * scale, pathPoints[startIdx].dy * scale);
    path.moveTo(startPoint.dx, startPoint.dy);
    
    // Índices de las 6 esquinas (ahora sin duplicados)
    // P2: (130,71), P4: (363,71), P6: (363,375), P8: (596,375), P10: (596,71), P12: (828.5,71)
    const cornerIndices = [2, 4, 6, 8, 10, 12];
    const cornerRadius = 50.0; // Radio de redondeo más grande y visible
    
    for (int i = startIdx + 1; i <= endIdx; i++) {
      final currentPoint = Offset(pathPoints[i].dx * scale, pathPoints[i].dy * scale);
      
      // Si este punto es una esquina, aplicar curva Bezier
      if (cornerIndices.contains(i) && i > startIdx && i < endIdx) {
        final prevPoint = Offset(pathPoints[i - 1].dx * scale, pathPoints[i - 1].dy * scale);
        final nextPoint = Offset(pathPoints[i + 1].dx * scale, pathPoints[i + 1].dy * scale);
        
        // Calcular vectores de dirección
        final dx1 = currentPoint.dx - prevPoint.dx;
        final dy1 = currentPoint.dy - prevPoint.dy;
        final distance1 = math.sqrt(dx1 * dx1 + dy1 * dy1);
        
        final dx2 = nextPoint.dx - currentPoint.dx;
        final dy2 = nextPoint.dy - currentPoint.dy;
        final distance2 = math.sqrt(dx2 * dx2 + dy2 * dy2);
        
        // Calcular puntos de control para la curva
        final radius = cornerRadius * scale;
        final ratio1 = math.min(radius / distance1, 0.5);
        final ratio2 = math.min(radius / distance2, 0.5);
        
        // Punto antes de la esquina
        final beforeCorner = Offset(
          currentPoint.dx - dx1 * ratio1,
          currentPoint.dy - dy1 * ratio1,
        );
        
        // Punto después de la esquina
        final afterCorner = Offset(
          currentPoint.dx + dx2 * ratio2,
          currentPoint.dy + dy2 * ratio2,
        );
        
        // Dibujar línea hasta antes de la esquina
        path.lineTo(beforeCorner.dx, beforeCorner.dy);
        
        // Aplicar curva Bezier cuadrática con el punto de esquina como control
        path.quadraticBezierTo(
          currentPoint.dx,
          currentPoint.dy,
          afterCorner.dx,
          afterCorner.dy,
        );
      } else {
        // Línea recta normal
        path.lineTo(currentPoint.dx, currentPoint.dy);
      }
    }
    
    return path;
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const double dashWidth = 16.0;
    const double dashSpace = 16.0;
    
    final scaledDashWidth = dashWidth * scale;
    final scaledDashSpace = dashSpace * scale;
    
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      
      while (distance < metric.length) {
        final double length = draw ? scaledDashWidth : scaledDashSpace;
        final double end = (distance + length).clamp(0.0, metric.length);
        
        if (draw) {
          final extractPath = metric.extractPath(distance, end);
          canvas.drawPath(extractPath, paint);
        }
        
        distance = end;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant StoryPathPainter oldDelegate) {
    return oldDelegate.completedStoryIndex != completedStoryIndex ||
           oldDelegate.scale != scale;
  }
}
