import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'diagonal_stripes_painter.dart';

class SessionBoxWidget extends StatelessWidget {
  final double scale;
  final String sessionNumber;
  final String sessionTheme;
  final double progress; // 0.0 - 1.0
  final VoidCallback? onTap;
  final bool isHovered; // Controlado desde el padre
  
  // Colores personalizables - defaults para comunicación
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

  String get _progressPercentage => '${(progress * 100).toInt()}%';
  
  // URLs de los iconos según el estado - versiones de comunicación
  String get _iconUrl {
    if (progress >= 1.0) {
      // Completado
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_complete.svg?alt=media&token=8e5f60dd-a9ce-43f7-b49c-de7e1d744a23';
    } else if (progress > 0.0) {
      // En curso
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_course.svg?alt=media&token=46d0b8ce-570e-4ff1-9c5d-a77b3b1002f1';
    } else {
      // Pendiente
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_pending.svg?alt=media&token=85d9d812-3196-4fd3-8166-8302d3c57baa';
    }
  }
  
  // Dimensiones del icono según el estado
  double get _iconWidth {
    if (progress >= 1.0) return 18.77;
    return 20.0;
  }
  
  double get _iconHeight {
    if (progress >= 1.0) return 18.5;
    return 19.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isHovered ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 207 * scale,
          height: 89.03 * scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor ?? const Color(0xFFFFC75C), // Naranja cálido por defecto
              borderRadius: BorderRadius.circular(8 * scale),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Número de la sesión
                Positioned(
                  left: 4 * scale,
                  top: 5.03 * scale,
                  child: Text(
                    sessionNumber,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 10 * scale,
                      color: sessionNumberColor ?? const Color(0xFF080118),
                    ),
                  ),
                ),
                // Tema de la sesión
                Positioned(
                  left: 3 * scale,
                  top: 19.03 * scale,
                  child: SizedBox(
                    width: 200 * scale,
                    child: Text(
                      sessionTheme,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * scale,
                        color: sessionThemeColor ?? const Color(0xFFFF6B9D), // Rosa coral por defecto
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Barra de progreso
                Positioned(
                  left: 4 * scale,
                  top: 55.03 * scale,
                  child: SizedBox(
                    width: 185 * scale,
                    height: 9 * scale,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.5 * scale),
                      child: Stack(
                        children: [
                          // Fondo con rayas diagonales
                          CustomPaint(
                            size: Size(175 * scale, 9 * scale),
                            painter: DiagonalStripesPainter(
                              color1: progressBarColor1 ?? const Color(0xFFFF8C42), // Naranja
                              color2: progressBarColor2 ?? const Color(0xFFFFB84D), // Amarillo naranja
                              stripeWidth: 20 * scale,
                            ),
                          ),
                          // Barra de progreso overlay
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: progressOverlayColor ?? const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(4.5 * scale),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Porcentaje de avance
                Positioned(
                  left: 7 * scale,
                  top: 65.03 * scale,
                  child: Text(
                    _progressPercentage,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 11 * scale,
                      color: percentageColor ?? const Color(0xFFFF8C42),
                    ),
                  ),
                ),
                // Icono de estado (completado/en curso/pendiente)
                Positioned(
                  left: 182 * scale,
                  top: 50.03 * scale,
                  child: SizedBox(
                    width: _iconWidth * scale,
                    height: _iconHeight * scale,
                    child: SvgPicture.network(
                      _iconUrl,
                      fit: BoxFit.contain,
                      placeholderBuilder: (context) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
