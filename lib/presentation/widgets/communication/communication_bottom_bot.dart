import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommunicationBottomBot extends StatefulWidget {
  final double scale;
  final VoidCallback? onTap;

  const CommunicationBottomBot({
    super.key,
    this.scale = 1.0,
    this.onTap,
  });

  @override
  State<CommunicationBottomBot> createState() => _CommunicationBottomBotState();
}

class _CommunicationBottomBotState extends State<CommunicationBottomBot> {
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
            // Círculo con sombra - Color naranja para comunicación
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 118.74 * widget.scale,
                height: 106.11 * widget.scale,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C42), // Naranja comunicación
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
              left: 15 * widget.scale,
              top: 0 * widget.scale,
              child: AnimatedScale(
                scale: _isPressed ? 1.15 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutBack,
                child: SizedBox(
                  width: 65 * widget.scale,
                  height: 85 * widget.scale,
                  child: SvgPicture.network(
                    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fcomunication-icon-corner.svg?alt=media&token=b5be0be0-bac1-4d34-bb5a-b940cc176bc0',
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
