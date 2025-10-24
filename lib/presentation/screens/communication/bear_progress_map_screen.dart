import 'package:flutter/material.dart';
import 'dart:math' as math;

class BearProgressMapScreen extends StatelessWidget {
  const BearProgressMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Dibuja el camino curvo punteado
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: _PathPainter(),
          ),

          // Íconos del camino
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                // Coordenadas del camino
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
                          color: Colors.purple.shade400,
                          size: 50,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Imagen del osito en el centro
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/bear_book.png', // ⚠️ agrega esta imagen en tu carpeta assets
                  height: 130,
                ),
              ],
            ),
          ),

          // Botón Home (arriba izquierda)
          Positioned(
            top: 25,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              radius: 25,
              child: IconButton(
                icon: const Icon(Icons.home, color: Colors.orange, size: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          // Botón Configuración (arriba derecha)
          Positioned(
            top: 25,
            right: 15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.settings, color: Colors.white, size: 24),
            ),
          ),

          // Botón Libro (abajo derecha)
          Positioned(
            bottom: 25,
            right: 15,
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

// Dibuja la línea curva discontinua
class _PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Trayectoria en forma de "S" doble
    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.55,
        size.width * 0.4, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.55,
        size.width * 0.7, size.height * 0.35);
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.55,
        size.width * 0.95, size.height * 0.4);

    // Dibujo punteado
    const dashWidth = 14.0;
    const dashSpace = 10.0;
    double distance = 0.0;

    for (final metric in path.computeMetrics()) {
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
