import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'diagonal_stripes_painter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'diagonal_stripes_painter.dart';

class SessionBoxWidget extends StatefulWidget {
  final double scale;
  final String sessionNumber;
  final String sessionTheme;
  final double progress; // 0.0 - 1.0
  final VoidCallback? onTap;
  final bool isHovered;
  
  // Colores personalizables
  final Color? backgroundColor;
  final Color? sessionNumberColor;
  final Color? sessionThemeColor;
  final Color? progressBarColor1;
  final Color? progressBarColor2;
  final Color? progressOverlayColor;
  final Color? percentageColor;

  const SessionBoxWidget({
    super.key,
    this.scale = 1.0,
    this.sessionNumber = 'Sesión 1',
    this.sessionTheme = 'Tema de la sesión',
    this.progress = 0.0,
    this.onTap,
    this.isHovered = false,
    this.backgroundColor,
    this.sessionNumberColor,
    this.sessionThemeColor,
    this.progressBarColor1,
    this.progressBarColor2,
    this.progressOverlayColor,
    this.percentageColor,
  });

  @override
  State<SessionBoxWidget> createState() => _SessionBoxWidgetState();
}

class _SessionBoxWidgetState extends State<SessionBoxWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
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

  String get _progressPercentage => '${(widget.progress * 100).toInt()}%';
  
  String get _iconUrl {
    if (widget.progress >= 1.0) {
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_complete.svg?alt=media&token=8e5f60dd-a9ce-43f7-b49c-de7e1d744a23';
    } else if (widget.progress > 0.0) {
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_course.svg?alt=media&token=46d0b8ce-570e-4ff1-9c5d-a77b3b1002f1';
    } else {
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_pending.svg?alt=media&token=85d9d812-3196-4fd3-8166-8302d3c57baa';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colores pastel brillantes por defecto si no se pasan
    final bgColor = widget.backgroundColor ?? const Color(0xFFFFE082); // Amarillo pastel
    final themeColor = widget.sessionThemeColor ?? const Color(0xFFE91E63); // Rosa fuerte
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: (widget.isHovered ? 1.05 : 1.0) * _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) {
              _controller.reverse();
              widget.onTap?.call();
            },
            onTapCancel: () => _controller.reverse(),
            child: Container(
              width: 207 * widget.scale,
              height: 125 * widget.scale, // Altura fija pero con contenido flexible
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(24 * widget.scale),
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.6),
                    blurRadius: widget.isHovered ? 15 : 8,
                    offset: Offset(0, widget.isHovered ? 8 : 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 0,
                    offset: const Offset(0, 0),
                    spreadRadius: 2, // Borde interior blanco brillante
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24 * widget.scale),
                child: Stack(
                  children: [
                    // --- Decoraciones de Fondo ---
                    Positioned(
                      top: -10 * widget.scale,
                      right: -10 * widget.scale,
                      child: Icon(Icons.cloud, color: Colors.white.withOpacity(0.3), size: 60 * widget.scale),
                    ),
                    Positioned(
                      bottom: 10 * widget.scale,
                      left: 10 * widget.scale,
                      child: Icon(Icons.star_rounded, color: Colors.white.withOpacity(0.3), size: 30 * widget.scale),
                    ),
                    Positioned(
                      top: 40 * widget.scale,
                      left: -5 * widget.scale,
                      child: Icon(Icons.circle, color: Colors.white.withOpacity(0.2), size: 15 * widget.scale),
                    ),

                    // --- Contenido Principal ---
                    Padding(
                      padding: EdgeInsets.all(12 * widget.scale),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye espacio para evitar overflow
                        children: [
                          // Header: Número de sesión y Icono de estado
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10 * widget.scale, vertical: 4 * widget.scale),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12 * widget.scale),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: Text(
                                  widget.sessionNumber,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10 * widget.scale,
                                    color: widget.sessionNumberColor ?? Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(4 * widget.scale),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.network(
                                  _iconUrl,
                                  width: 18 * widget.scale,
                                  height: 18 * widget.scale,
                                ),
                              ),
                            ],
                          ),
                          
                          // Título del Tema (Flexible para evitar overflow)
                          Flexible(
                            child: Center(
                              child: Text(
                                widget.sessionTheme,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15 * widget.scale,
                                  color: themeColor,
                                  height: 1.1,
                                  shadows: [
                                    Shadow(color: Colors.white.withOpacity(0.8), offset: const Offset(1, 1), blurRadius: 0),
                                  ]
                                ),
                              ),
                            ),
                          ),

                          // Barra de Progreso y Porcentaje
                          Column(
                            children: [
                              Container(
                                height: 14 * widget.scale,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7 * widget.scale),
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5 * widget.scale),
                                  child: Stack(
                                    children: [
                                      // Fondo rayado
                                      CustomPaint(
                                        size: Size.infinite,
                                        painter: DiagonalStripesPainter(
                                          color1: widget.progressBarColor1 ?? const Color(0xFFFFB74D),
                                          color2: widget.progressBarColor2 ?? const Color(0xFFFF9800),
                                          stripeWidth: 10 * widget.scale,
                                        ),
                                      ),
                                      // Overlay blanco para la parte no completada (invertido visualmente)
                                      // O mejor: dibujamos el progreso encima de un fondo gris claro
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 4 * widget.scale),
                              // Porcentaje debajo de la barra
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Completado: $_progressPercentage',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10 * widget.scale,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Overlay de progreso (Máscara)
                    // Para simplificar y evitar overflow visual, usamos la barra de arriba como "full" 
                    // y ponemos un container blanco encima que se reduce según el progreso.
                    Positioned(
                      left: 14 * widget.scale, // padding + border
                      bottom: 22 * widget.scale, // Ajuste manual para coincidir con la barra
                      child: IgnorePointer(
                        child: Container(
                          width: (183 * widget.scale) * (1.0 - widget.progress.clamp(0.0, 1.0)), // Ancho inverso
                          height: 10 * widget.scale,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5 * widget.scale),
                              bottomRight: Radius.circular(5 * widget.scale),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

