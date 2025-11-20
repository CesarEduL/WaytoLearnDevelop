import 'package:flutter/material.dart';

class DiagonalStripesPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final double stripeWidth;

  DiagonalStripesPainter({
    required this.color1,
    required this.color2,
    required this.stripeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Calcular cuántas rayas necesitamos para cubrir toda la barra
    final totalStripes = (size.width / stripeWidth).ceil() + (size.height / stripeWidth).ceil() + 2;
    
    for (int i = 0; i < totalStripes; i++) {
      paint.color = i % 2 == 0 ? color1 : color2;
      
      final path = Path();
      final startX = i * stripeWidth;
      
      path.moveTo(startX, 0);
      path.lineTo(startX + stripeWidth, 0);
      path.lineTo(startX + stripeWidth - size.height, size.height);
      path.lineTo(startX - size.height, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
