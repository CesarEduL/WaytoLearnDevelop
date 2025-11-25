import 'package:flutter/material.dart';

/// Botón animado con efecto de rebote para niños
class AnimatedChildButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;
  final bool isLarge;
  
  const AnimatedChildButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.icon,
    this.isLarge = false,
  });

  @override
  State<AnimatedChildButton> createState() => _AnimatedChildButtonState();
}

class _AnimatedChildButtonState extends State<AnimatedChildButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.isLarge ? 32 : 24,
            vertical: widget.isLarge ? 16 : 12,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.color != null
                  ? [widget.color!, widget.color!.withOpacity(0.8)]
                  : [Colors.blue, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? Colors.blue).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: Colors.white,
                  size: widget.isLarge ? 28 : 24,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.isLarge ? 20 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
