import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'diagonal_stripes_painter.dart';

class ProgressBanner extends StatelessWidget {
  final String currentSession;
  final String sessionName;
  final double subjectProgress;
  final String subjectName;
  final double scale;
  final String? rewardPendingIconUrl;
  final String? rewardCompletedIconUrl;
  
  // Colores personalizables - defaults para comunicación
  final Color? backgroundColor;
  final Color? headerTextColor;
  final Color? sessionNumberColor;
  final Color? sessionNameColor;
  final Color? subjectNameColor;
  final Color? percentageColor;
  final Color? progressBarColor1;
  final Color? progressBarColor2;
  final Color? progressOverlayColor;

  const ProgressBanner({
    super.key,
    required this.currentSession,
    required this.sessionName,
    required this.subjectProgress,
    required this.subjectName,
    this.scale = 1.0,
    this.rewardPendingIconUrl = 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Frewards-comm-icon.svg?alt=media&token=139ebeb4-14ec-4b68-abc5-0b6f148673a9',
    this.rewardCompletedIconUrl = 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Frewards-comm-icon-close.svg?alt=media&token=d6c310a2-8ed5-4029-8df9-9ed662d7a3da',
    this.backgroundColor,
    this.headerTextColor,
    this.sessionNumberColor,
    this.sessionNameColor,
    this.subjectNameColor,
    this.percentageColor,
    this.progressBarColor1,
    this.progressBarColor2,
    this.progressOverlayColor,
  });

  String get _progressPercentage => '${(subjectProgress * 100).toInt()}%';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 872 * scale,
      height: 121 * scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF8A5CF6), // Naranja cálido por defecto
          borderRadius: BorderRadius.circular(8 * scale),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16 * scale,
            vertical: 8 * scale,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aprendizaje en Curso',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300,
                      fontSize: 14 * scale,
                      color: headerTextColor ?? const Color(0xFF5CF6D7),
                    ),
                  ),
                  SizedBox(height: 1 * scale),
                  Text(
                    currentSession,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 32 * scale,
                      color: sessionNumberColor ?? const Color(0xFFC8F65C), // Rosa coral por defecto
                      height: 0.9,
                    ),
                  ),
                  SizedBox(height: 1 * scale),
                  Text(
                    sessionName,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 15 * scale,
                      color: sessionNameColor ?? const Color(0xFFFFFFFF),
                    ),
                  ),
                  SizedBox(height: 2 * scale),
                  Padding(
                    padding: EdgeInsets.only(left: 1 * scale),
                    child: SizedBox(
                      width: 829 * scale,
                      height: 18.14 * scale,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9 * scale),
                        child: Stack(
                          children: [
                            // Fondo con rayas diagonales alternadas
                            CustomPaint(
                              size: Size(829 * scale, 18.14 * scale),
                              painter: DiagonalStripesPainter(
                                color1: progressBarColor1 ?? const Color(0xFFFF8C42), // Naranja
                                color2: progressBarColor2 ?? const Color(0xFFFFB84D), // Amarillo naranja
                                stripeWidth: 40 * scale,
                              ),
                            ),
                            // Barra de progreso overlay
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: subjectProgress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: progressOverlayColor ?? const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(9 * scale),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Contenido del lado derecho
              Positioned(
                top: -2 * scale,
                right: 18 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      subjectName,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14 * scale,
                        color: subjectNameColor ?? const Color(0xFFC8F65C),
                      ),
                    ),
                    Text(
                      _progressPercentage,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 32 * scale,
                        color: percentageColor ?? const Color(0xFFFFFFFF), // Naranja por defecto
                      ),
                    ),
                  ],
                ),
              ),
              // Icono del cofre
              Positioned(
                bottom: (subjectProgress >= 1.0 ? 2 : -8) * scale,
                right: (subjectProgress >= 1.0 ? 0 : 0) * scale,
                child: SizedBox(
                  width: (subjectProgress >= 1.0 ? 36 : 47) * scale,
                  height: (subjectProgress >= 1.0 ? 33 : 52) * scale,
                  child: SvgPicture.network(
                    subjectProgress >= 1.0 ? rewardCompletedIconUrl! : rewardPendingIconUrl!,
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
