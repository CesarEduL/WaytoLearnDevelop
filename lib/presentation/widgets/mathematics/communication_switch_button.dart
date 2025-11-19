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
    final communicationIconFuture = Future.value(iconUrl!);

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
                child: FutureBuilder<String>(
                  future: communicationIconFuture,
                  builder: (context, snapshot) {
                    final isReady = snapshot.connectionState == ConnectionState.done && snapshot.hasData;
                    return Container(
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
                      child: isReady
                          ? SvgPicture.network(
                              snapshot.data!,
                              fit: BoxFit.contain,
                              placeholderBuilder: (context) => const SizedBox.shrink(),
                            )
                          : Icon(
                              Icons.chat_bubble,
                              size: 18 * scale,
                              color: Colors.white,
                            ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
