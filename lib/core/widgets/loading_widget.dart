import 'package:flutter/material.dart';
import 'package:waytolearn/core/theme/app_theme.dart';

class LoadingWidget extends StatefulWidget {
  final double size;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.size = 50.0,
    this.color,
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: (widget.color ?? AppTheme.primaryColor).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.auto_stories, // Icono de libro
              color: widget.color ?? AppTheme.primaryColor,
              size: widget.size * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
