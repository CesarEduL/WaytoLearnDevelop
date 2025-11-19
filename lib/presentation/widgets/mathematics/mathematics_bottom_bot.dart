import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MathematicsBottomBot extends StatefulWidget {
  final double scale;
  final VoidCallback? onTap;

  const MathematicsBottomBot({
    super.key,
    this.scale = 1.0,
    this.onTap,
  });

  @override
  State<MathematicsBottomBot> createState() => _MathematicsBottomBotState();
}

class _MathematicsBottomBotState extends State<MathematicsBottomBot> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: 118.74 * widget.scale,
        height: 106.11 * widget.scale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Círculo con sombra
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 118.74 * widget.scale,
                height: 106.11 * widget.scale,
                decoration: BoxDecoration(
                  color: const Color(0xFF8A5CF6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10 * widget.scale,
                      offset: Offset(0, 4 * widget.scale),
                    ),
                  ],
                ),
              ),
            ),
            // Icono SVG con animación
            Positioned(
              left:-4 * widget.scale,
              top: -8 * widget.scale,
              child: AnimatedScale(
                scale: _isPressed ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                child: SizedBox(
                  width: 91 * widget.scale,
                  height: 85 * widget.scale,
                  child: SvgPicture.network(
                    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FMatematica-icon-corner.svg?alt=media&token=6fa2773e-0ce5-4ca0-8031-acdf914760f3',
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
