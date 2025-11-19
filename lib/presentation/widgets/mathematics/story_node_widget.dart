import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoryNodeWidget extends StatefulWidget {
  final int storyIndex;
  final bool isCompleted;
  final bool isHovered;
  final VoidCallback? onTap;
  final double scale;

  const StoryNodeWidget({
    super.key,
    required this.storyIndex,
    required this.isCompleted,
    this.isHovered = false,
    this.onTap,
    this.scale = 1.0,
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
      scale: widget.isHovered ? 1.45 : (_isPressed ? 0.95 : 1.0),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          width: 70 * widget.scale,
          height: 60 * widget.scale,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8 * widget.scale),
          ),
          child: SvgPicture.network(
            widget.isCompleted ? completeIconUrl : pendingIconUrl,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
