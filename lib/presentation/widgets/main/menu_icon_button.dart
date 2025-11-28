import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String? iconUrl;

  const MenuIconButton({
    super.key,
    required this.onPressed,
    this.iconUrl = 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Fmenu-icon.svg?alt=media&token=15587218-982a-4272-a7b0-7e30f1df119d',
  });

  @override
  State<MenuIconButton> createState() => _MenuIconButtonState();
}

class _MenuIconButtonState extends State<MenuIconButton> {
  bool _isPressed = false;

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
        width: 95.21,
        height: 106.16,
        child: Stack(
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
            Positioned(
              left: 35,
              top: 50,
              child: AnimatedScale(
                scale: _isPressed ? 2.0 : 1.0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutBack,
                child: SizedBox(
                  width: 39,
                  height: 36,
                  child: SvgPicture.network(
                    widget.iconUrl!,
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