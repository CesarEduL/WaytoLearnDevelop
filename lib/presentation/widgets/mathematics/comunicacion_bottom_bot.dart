import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComunicacionBottomBot extends StatelessWidget {
  final double scale;
  final VoidCallback? onTap;

  const ComunicacionBottomBot({
    super.key,
    this.scale = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 118.74 * scale,
        height: 106.11 * scale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Círculo con sombra
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 118.74 * scale,
                height: 106.11 * scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF8A5CF6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10 * scale,
                      offset: Offset(0, 4 * scale),
                    ),
                  ],
                ),
              ),
            ),
            // Icono SVG
            Positioned(
              left:-4 * scale,
              top: -8 * scale,
              child: SizedBox(
                width: 91 * scale,
                height: 85 * scale,
                child: SvgPicture.network(
                  'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FMatematica-icon-corner.svg?alt=media&token=6fa2773e-0ce5-4ca0-8031-acdf914760f3',
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
