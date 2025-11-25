import 'package:flutter/material.dart';

/// Tarjeta moderna con sombra y bordes redondeados para niños
class ModernChildCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  final double borderRadius;
  final EdgeInsets? padding;
  
  const ModernChildCard({
    super.key,
    required this.child,
    this.onTap,
    this.gradient,
    this.color,
    this.borderRadius = 20,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? (color ?? Colors.white) : null,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
