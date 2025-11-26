import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoryNodeWidget extends StatefulWidget {
  final int storyIndex;
  final bool isCompleted;
  final bool isLocked; // Nuevo parámetro
  final bool isHovered;
  final VoidCallback? onTap;
  final Widget? customIcon;
  final double scale;

  const StoryNodeWidget({
    super.key,
    required this.storyIndex,
    required this.isCompleted,
    this.isLocked = false, // Por defecto no bloqueado
    this.isHovered = false,
    this.onTap,
    this.scale = 1.0,
    this.customIcon,
  });

  @override
  State<StoryNodeWidget> createState() => _StoryNodeWidgetState();
}

class _StoryNodeWidgetState extends State<StoryNodeWidget> {
  bool _isPressed = false;

  static const String pendingIconUrl = 
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Ftale-icon-pending.svg?alt=media&token=b06cbb3e-b93f-43bb-86a5-dea7238ade1c';
  
  static const String completeIconUrl = 
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Ftale-icon-complete.svg?alt=media&token=35bc27b7-c4a7-490c-b359-a3dd1b9f6f4e';

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.isHovered && !widget.isLocked ? 1.45 : (_isPressed ? 0.95 : 1.0),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: widget.isLocked ? null : (_) => setState(() => _isPressed = true),
        onTapUp: widget.isLocked ? null : (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: widget.isLocked ? null : () => setState(() => _isPressed = false),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Icono del cuento
            Opacity(
              opacity: widget.isLocked ? 0.3 : 1.0, // Más opaco si está bloqueado
              child: Container(
                width: 70 * widget.scale,
                height: 60 * widget.scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8 * widget.scale),
                ),
                child: widget.customIcon ?? SvgPicture.network(
                  widget.isCompleted ? completeIconUrl : pendingIconUrl,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => const SizedBox.shrink(),
                ),
              ),
            ),
            // Candado si está bloqueado
            if (widget.isLocked)
              Container(
                padding: EdgeInsets.all(8 * widget.scale),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 24 * widget.scale,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
