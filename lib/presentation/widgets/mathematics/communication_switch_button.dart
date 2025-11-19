import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommunicationSwitchButton extends StatelessWidget {
  final VoidCallback onTap;
  final double scale;
  final String? iconUrl;

  const CommunicationSwitchButton({
    super.key,
    required this.onTap,
    this.scale = 1.0,
    this.iconUrl = 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fcomunication-icon-switch.svg?alt=media&token=b014d9af-ee54-4e4b-bdc9-6f077ca4226a',
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
                color: const Color(0xFF5CF6D7),
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
            left: 6 * scale,
            top: 3 * scale,
            child: GestureDetector(
              onTap: onTap,
              child: SizedBox(
                width: 36 * scale,
                height: 33 * scale,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C74F2),
                    borderRadius: BorderRadius.circular(20 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x66000000),
                        offset: Offset(0, 4 * scale),
                        blurRadius: 6 * scale,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.network(
                    iconUrl!,
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
