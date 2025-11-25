import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class StoryPathPainter extends CustomPainter {
  final int completedStoryIndex;
  final double scale;

  StoryPathPainter({
    required this.completedStoryIndex,
    this.scale = 1.0,
  });

  // 15 puntos del camino (P0 - P14)
  static const List<Offset> pathPoints = [
    Offset(130.0, 224.51), // CUENTO 1 - P0
    Offset(130.0, 147.76), // P1
    Offset(130.0, 71), // ESQUINA 1 - P2

    Offset(246, 71), // CUENTO 2 - P3
    Offset(363, 71), // ESQUINA 2 - P4

    Offset(363, 224.51), // CUENTO 3 - P5
    Offset(363, 375), // ESQUINA 3 - P6

    Offset(485.5, 375.0), // CUENTO 4 - P7
    Offset(596.0, 375.0), // ESQUINA 4 - P8

    Offset(596.0, 224.51), // CUENTO 5 - P9
    Offset(596.0, 71), // ESQUINA 5 - P10

    Offset(712.25, 71.0), // CUENTO 6 - P11
    Offset(828.5, 71), // ESQUINA 6 - P12

    Offset(828.5, 146.5), // CUENTO 7 - P13
    Offset(828.5, 222), // P14
  ];

  // Índices de los cuentos reales
  static const List<int> storyPointIndices = [0, 3, 5, 7, 9, 11, 13];

  @override
  void paint(Canvas canvas, Size size) {
    final inactivePaint = Paint()
      ..color = const Color(0xFFCCC2E4)
      ..strokeWidth = 8.0 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final activePaint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..strokeWidth = 8.0 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    _drawStoryPath(canvas, inactivePaint, activePaint);
  }

  void _drawStoryPath(Canvas canvas, Paint inactivePaint, Paint activePaint) {
    for (int i = 0; i < storyPointIndices.length - 1; i++) {
      final startIdx = storyPointIndices[i];
      final endIdx = storyPointIndices[i + 1];

      // Un segmento es "activo" si su índice es menor que el del último cuento completado.
      // Por ejemplo, si completedStoryIndex es 0, el segmento 0 (del cuento 0 al 1) se pinta activo.
      final isActive = i <= completedStoryIndex;
      final paint = isActive ? activePaint : inactivePaint;

      final segmentPath = _createSegmentPath(startIdx, endIdx);

      _drawDashedPath(canvas, segmentPath, paint);
    }
  }

  Path _createSegmentPath(int startIdx, int endIdx) {
    final path = Path();
    final startPoint = Offset(
      pathPoints[startIdx].dx * scale,
      pathPoints[startIdx].dy * scale,
    );
    path.moveTo(startPoint.dx, startPoint.dy);

    const cornerIndices = [2, 4, 6, 8, 10, 12];
    const cornerRadius = 50.0;

    for (int i = startIdx + 1; i <= endIdx; i++) {
      final current = Offset(
        pathPoints[i].dx * scale,
        pathPoints[i].dy * scale,
      );

      if (cornerIndices.contains(i) && i > startIdx && i < endIdx) {
        final prev = Offset(
          pathPoints[i - 1].dx * scale,
          pathPoints[i - 1].dy * scale,
        );

        final next = Offset(
          pathPoints[i + 1].dx * scale,
          pathPoints[i + 1].dy * scale,
        );

        final dx1 = current.dx - prev.dx;
        final dy1 = current.dy - prev.dy;
        final dx2 = next.dx - current.dx;
        final dy2 = next.dy - current.dy;

        final d1 = math.sqrt(dx1 * dx1 + dy1 * dy1);
        final d2 = math.sqrt(dx2 * dx2 + dy2 * dy2);

        final radius = cornerRadius * scale;
        final r1 = math.min(radius / d1, 0.5);
        final r2 = math.min(radius / d2, 0.5);

        final beforeCorner = Offset(
          current.dx - dx1 * r1,
          current.dy - dy1 * r1,
        );

        final afterCorner = Offset(
          current.dx + dx2 * r2,
          current.dy + dy2 * r2,
        );

        path.lineTo(beforeCorner.dx, beforeCorner.dy);

        path.quadraticBezierTo(
          current.dx,
          current.dy,
          afterCorner.dx,
          afterCorner.dy,
        );
      } else {
        path.lineTo(current.dx, current.dy);
      }
    }

    return path;
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dash = 16.0;
    final dashW = dash * scale;
    final dashG = dash * scale;

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;

      while (distance < metric.length) {
        final len = draw ? dashW : dashG;
        final end = (distance + len).clamp(0.0, metric.length);

        if (draw) {
          canvas.drawPath(metric.extractPath(distance, end), paint);
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
