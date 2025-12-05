import 'package:flutter/material.dart';

class BackIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;

  const BackIconButton({
    super.key,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF8397BE),
  });

  @override
  State<BackIconButton> createState() => _BackIconButtonState();
}

class _BackIconButtonState extends State<BackIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-0.3, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Círculo de fondo
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
            Positioned(
              left: 40,
              top: 57,
              child: AnimatedScale(
                scale: _isPressed ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 29,
                    color: Colors.white,
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