import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'diagonal_stripes_painter.dart';

class EmptyBoxWidget extends StatefulWidget {
  final double scale;
  final String sessionNumber;
  final String sessionTheme;
  final double progress; // 0.0 - 1.0
  final VoidCallback? onTap;
  
  // Colores personalizables
  final Color? backgroundColor;
  final Color? sessionNumberColor;
  final Color? sessionThemeColor;
  final Color? progressBarColor1;
  final Color? progressBarColor2;
  final Color? progressOverlayColor;
  final Color? percentageColor;

  const EmptyBoxWidget({
    super.key,
    this.scale = 1.0,
    this.sessionNumber = 'Sesión 1',
    this.sessionTheme = 'Tema de la sesión',
    this.progress = 0.0,
    this.onTap,
    this.backgroundColor,
    this.sessionNumberColor,
    this.sessionThemeColor,
    this.progressBarColor1,
    this.progressBarColor2,
    this.progressOverlayColor,
    this.percentageColor,
  });

  @override
  State<EmptyBoxWidget> createState() => _EmptyBoxWidgetState();
}

class _EmptyBoxWidgetState extends State<EmptyBoxWidget> {
  bool _isHovered = false;

  String get _progressPercentage => '${(widget.progress * 100).toInt()}%';
  
  // URLs de los iconos según el estado
  String get _iconUrl {
    if (widget.progress >= 1.0) {
      // Completado
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_complete.svg?alt=media&token=8e5f60dd-a9ce-43f7-b49c-de7e1d744a23';
    } else if (widget.progress > 0.0) {
      // En curso
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_course.svg?alt=media&token=46d0b8ce-570e-4ff1-9c5d-a77b3b1002f1';
    } else {
      // Pendiente
      return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2FIcon_Sessions_pending.svg?alt=media&token=85d9d812-3196-4fd3-8166-8302d3c57baa';
    }
  }
  
  // Dimensiones del icono según el estado
  double get _iconWidth {
    if (widget.progress >= 1.0) return 18.77;
    return 20.0;
  }
  
  double get _iconHeight {
    if (widget.progress >= 1.0) return 18.5;
    return 19.0;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _isHovered = true),
      onPointerMove: (event) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final localPosition = box.globalToLocal(event.position);
          final isInside = box.paintBounds.contains(localPosition);
          if (_isHovered != isInside) {
            setState(() => _isHovered = isInside);
          }
        }
      },
      onPointerUp: (_) => setState(() => _isHovered = false),
      onPointerCancel: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: SizedBox(
            width: 207 * widget.scale,
            height: 89.03 * widget.scale,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? const Color(0xFF5CF6D7),
              borderRadius: BorderRadius.circular(8 * widget.scale),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Número de la sesión
                Positioned(
                  left: 4 * widget.scale,
                  top: 5.03 * widget.scale,
                  child: Text(
                    widget.sessionNumber,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 10 * widget.scale,
                      color: widget.sessionNumberColor ?? const Color(0xFF080118),
                    ),
                  ),
                ),
                // Tema de la sesión
                Positioned(
                  left: 3 * widget.scale,
                  top: 19.03 * widget.scale,
                  child: SizedBox(
                    width: 200 * widget.scale,
                    child: Text(
                      widget.sessionTheme,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14 * widget.scale,
                        color: widget.sessionThemeColor ?? const Color(0xFFF65CC8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                // Barra de progreso
                Positioned(
                  left: 4 * widget.scale,
                  top: 55.03 * widget.scale,
                  child: SizedBox(
                    width: 185 * widget.scale,
                    height: 9 * widget.scale,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.5 * widget.scale),
                      child: Stack(
                        children: [
                          // Fondo con rayas diagonales
                          CustomPaint(
                            size: Size(175 * widget.scale, 9 * widget.scale),
                            painter: DiagonalStripesPainter(
                              color1: widget.progressBarColor1 ?? const Color(0xFF8A5CF6),
                              color2: widget.progressBarColor2 ?? const Color(0xFF7595F7),
                              stripeWidth: 20 * widget.scale,
                            ),
                          ),
                          // Barra de progreso overlay
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: widget.progress.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.progressOverlayColor ?? const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(4.5 * widget.scale),
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
                  left: 7 * widget.scale,
                  top: 65.03 * widget.scale,
                  child: Text(
                    _progressPercentage,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 11 * widget.scale,
                      color: widget.percentageColor ?? const Color(0xFF8A5CF6),
                    ),
                  ),
                ),
                // Icono de estado (completado/en curso/pendiente)
                Positioned(
                  left: 182 * widget.scale,
                  top: 50.03 * widget.scale,
                  child: SizedBox(
                    width: _iconWidth * widget.scale,
                    height: _iconHeight * widget.scale,
                    child: FutureBuilder<String>(
                      future: Future.value(_iconUrl),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          return SvgPicture.network(
                            snapshot.data!,
                            fit: BoxFit.contain,
                            placeholderBuilder: (context) => const SizedBox.shrink(),
                          );
                        }
                        // Fallback icon mientras carga
                        return Icon(
                          widget.progress >= 1.0
                              ? Icons.check_circle
                              : widget.progress > 0.0
                                  ? Icons.pending
                                  : Icons.lock,
                          size: _iconWidth * widget.scale,
                          color: const Color(0xFF8A5CF6),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
