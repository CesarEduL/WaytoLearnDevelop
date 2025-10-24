import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressMapScreen extends StatelessWidget {
  const ProgressMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Camino curvo
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: _PathPainter(),
          ),

          // Íconos sobre el camino
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                // Coordenadas aproximadas del recorrido
                final points = [
                  Offset(w * 0.15, h * 0.25),
                  Offset(w * 0.3, h * 0.45),
                  Offset(w * 0.45, h * 0.65),
                  Offset(w * 0.6, h * 0.5),
                  Offset(w * 0.75, h * 0.3),
                  Offset(w * 0.9, h * 0.5),
                ];

                return Stack(
                  children: [
                    for (final p in points)
                      Positioned(
                        left: p.dx - 25,
                        top: p.dy - 25,
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: Colors.grey.shade400,
                          size: 50,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Botón Home (arriba izquierda)
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.orange, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Botón Configuración (arriba derecha)
          Positioned(
            top: 30,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.settings, color: Colors.white),
            ),
          ),

          // Botón Libro (abajo derecha)
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {},
              child: const Icon(Icons.menu_book, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Dibuja el camino curvo punteado
class _PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();

    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5,
        size.width * 0.4, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.5,
        size.width * 0.7, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.5,
        size.width * 0.95, size.height * 0.4);

    // Dibuja línea discontinua
    final dashWidth = 10.0;
    final dashSpace = 8.0;
    double distance = 0.0;

    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        final extractPath = metric.extractPath(distance, nextDistance);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
