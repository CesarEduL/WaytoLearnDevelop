import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BearAvatar extends StatelessWidget {
  final double size;
  final bool animated;
  final bool showBook;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const BearAvatar({
    super.key,
    this.size = 80.0,
    this.animated = true,
    this.showBook = true,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bearWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.bearBrown,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Fondo con patrón sutil
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor ?? AppTheme.bearBrown,
                  (backgroundColor ?? AppTheme.bearBrown).withOpacity(0.8),
                ],
              ),
            ),
          ),
          
          // Contenido del osito
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cara del oso
                Icon(
                  Icons.face,
                  color: AppTheme.bearCream,
                  size: size * 0.6,
                ),
                
                if (showBook) ...[
                  SizedBox(height: size * 0.05),
                  // Libro
                  Container(
                    width: size * 0.4,
                    height: size * 0.25,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.secondaryColor.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.book,
                      color: Colors.white,
                      size: size * 0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: bearWidget,
      );
    }

    if (animated) {
      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Transform.rotate(
              angle: value * 0.1,
              child: bearWidget,
            ),
          );
        },
      );
    }

    return bearWidget;
  }
}

class AnimatedBearAvatar extends StatefulWidget {
  final double size;
  final bool showBook;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const AnimatedBearAvatar({
    super.key,
    this.size = 80.0,
    this.showBook = true,
    this.backgroundColor,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedBearAvatar> createState() => _AnimatedBearAvatarState();
}

class _AnimatedBearAvatarState extends State<AnimatedBearAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: BearAvatar(
              size: widget.size,
              animated: false,
              showBook: widget.showBook,
              backgroundColor: widget.backgroundColor,
              onTap: widget.onTap,
            ),
          ),
        );
      },
    );
  }
}

class FloatingBearButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? tooltip;
  final Color? backgroundColor;

  const FloatingBearButton({
    super.key,
    this.onPressed,
    this.icon,
    this.tooltip,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppTheme.primaryColor,
      tooltip: tooltip,
      child: icon != null
          ? Icon(icon, color: Colors.white)
          : const BearAvatar(
              size: 40,
              animated: false,
              showBook: false,
            ),
    );
  }
}
