import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? iconUrl;

  const HomeIconButton({
    super.key,
    required this.onPressed,
    this.iconUrl = 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fhome-icon.svg?alt=media&token=38f6113e-7be1-4f7d-8490-c08f8a83abfa',
  });

  @override
  State<HomeIconButton> createState() => _HomeIconButtonState();
}

class _HomeIconButtonState extends State<HomeIconButton> {
  bool _isPressed = false;
  late final Future<String> _iconFuture;

  @override
  void initState() {
    super.initState();
    _iconFuture = Future.value(widget.iconUrl!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        width: 100.21,
        height: 111.16,
        child: FutureBuilder<String>(
          future: _iconFuture,
          builder: (context, snapshot) {
            final isIconReady =
                snapshot.connectionState == ConnectionState.done && snapshot.hasData;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Círculo de fondo
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF8397BE),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
                if (isIconReady)
                  Positioned(
                    left: 40,
                    top: 57,
                    child: AnimatedScale(
                      scale: _isPressed ? 2.0 : 1.0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutBack,
                      child: SizedBox(
                        width: 29,
                        height: 26,
                        child: SvgPicture.network(
                          snapshot.data!,
                          fit: BoxFit.contain,
                          placeholderBuilder: (context) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                if (!isIconReady)
                  Positioned(
                    left: 35,
                    top: 43,
                    child: AnimatedScale(
                      scale: _isPressed ? 1.3 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOutBack,
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.home,
                          size: 20,
                          color: Color(0xFFEC4899),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
