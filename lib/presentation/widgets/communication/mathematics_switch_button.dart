import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MathematicsSwitchButton extends StatelessWidget {
  final VoidCallback onTap;
  final double scale;
  final String? iconUrl;

  const MathematicsSwitchButton({
    super.key,
    required this.onTap,
    this.scale = 1.0,
    this.iconUrl = 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fcomunication-icon-switch.svg?alt=media&token=c6ed5e8a-0f15-4777-8277-3a0a6105fb57',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 83.33 * scale,
      height: 40 * scale,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF8A5CF6),
                borderRadius: BorderRadius.circular(16.1 * scale),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x8000C7AF),
                    offset: Offset(0, 3.22 * scale),
                    blurRadius: 3.22 * scale,
                  ),
                  BoxShadow(
                    color: const Color(0x4D00C7AF),
                    offset: Offset(0, 3.22 * scale),
                    blurRadius: 3.22 * scale,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 33 * scale,
            top: 3 * scale,
            child: GestureDetector(
              onTap: onTap,
              child: Stack(
                children: [
                  // Destello detrás del icono
                  Positioned(
                    top: -4 * scale,
                    left: -2 * scale,
                    child: Container(
                      width: 52 * scale,
                      height: 52 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Icono
                  SizedBox(
                    width: 46 * scale,
                    height: 43 * scale,
                    child: SvgPicture.network(
                      iconUrl!,
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
