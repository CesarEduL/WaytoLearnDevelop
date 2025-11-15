import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/communication/session_progress_screen.dart';

class MathIndexScreenSessions extends StatefulWidget {
  const MathIndexScreenSessions({super.key});

  @override
  State<MathIndexScreenSessions> createState() => _MathIndexScreenSessionsState();
}

class _MathIndexScreenSessionsState extends State<MathIndexScreenSessions> {
  static final Future<String> _homeIconFuture = Future.value(
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fhome-icon.svg?alt=media&token=38f6113e-7be1-4f7d-8490-c08f8a83abfa',
  );
  static final Future<String> _communicationIconFuture = Future.value(
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Fcomunication-icon-switch.svg?alt=media&token=b014d9af-ee54-4e4b-bdc9-6f077ca4226a',
  );
  static final Future<String> _rewardPendingIconFuture = Future.value(
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Frewards-icon.svg?alt=media&token=fb7b9088-1531-41fa-954c-1e3dd3c10f5b',
  );
  static final Future<String> _rewardCompletedIconFuture = Future.value(
    'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/mathematics_resources%2Frewards-icon-close.svg?alt=media&token=0455898e-4f65-48ea-869a-ecdbbd04e5dd',
  );

  bool _homeIconPressed = false;
  String _currentSession = 'Sesión 1'; // Variable para mostrar la sesión actual
  String _sessionName = 'Nombre de la Sesión'; // Variable para mostrar el nombre de la sesión
  double _subjectProgress = 0.45; // Variable para el progreso de la materia (0.0 a 1.0)
  String _subjectName = 'Matemática'; // Variable para el nombre de la materia
  
  String get _progressPercentage => '${(_subjectProgress * 100).toInt()}%';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const designWidth = 912.0;
    final scale = mediaSize.width / designWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [

            Positioned( //icono-home
              top: -32,
              left: -17,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _homeIconPressed = true),
                onTapUp: (_) {
                  setState(() => _homeIconPressed = false);
                  Navigator.pop(context);
                },
                onTapCancel: () => setState(() => _homeIconPressed = false),
                child: SizedBox(
                  width: 100.21,
                  height: 111.16,
                  child: FutureBuilder<String>(
                    future: _homeIconFuture,
                    builder: (context, snapshot) {
                      final isIconReady =
                          snapshot.connectionState == ConnectionState.done && snapshot.hasData;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Círculo de fondo
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF8397BE),
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                          ),
                          if (isIconReady)
                            Positioned(
                              left: 40,
                              top: 57,
                              child: AnimatedScale(
                                scale: _homeIconPressed ? 2.0 : 1.0,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeOutBack,
                                child: SizedBox(
                                  width: 29,
                                  height: 26,
                                  child: SvgPicture.network(
                                    snapshot.data!,
                                    fit: BoxFit.contain,
                                    placeholderBuilder: (context) => const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            ),
                          if (!isIconReady)
                            Positioned(
                              left: 35,
                              top: 43,
                              child: AnimatedScale(
                                scale: _homeIconPressed ? 1.3 : 1.0,
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.easeOutBack,
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Icon(
                                    Icons.home,
                                    size: 20,
                                    color: Color(0xFFEC4899),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned( //icono-communication-switch
              top: 14 * scale,
              left: 806 * scale,
              child: SizedBox(
                width: 83.33 * scale,
                height: 40 * scale,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CF6D7),
                          borderRadius: BorderRadius.circular(16.1 * scale),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x8000C7AF),
                              offset: Offset(0, 3.22 * scale),
                              blurRadius: 3.22 * scale,
                            ),
                            BoxShadow(
                              color: const Color(0x4D00C7AF),
                              offset: Offset(0, 3.22 * scale),
                              blurRadius: 3.22 * scale,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: (862 - 856) * scale,
                      top: (27 - 24) * scale,
                      child: GestureDetector(
                        onTap: _openCommunication,
                        child: SizedBox(
                          width: 36 * scale,
                          height: 33 * scale,
                          child: FutureBuilder<String>(
                            future: _communicationIconFuture,
                            builder: (context, snapshot) {
                              final isReady = snapshot.connectionState == ConnectionState.done && snapshot.hasData;
                              return Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9C74F2),
                                  borderRadius: BorderRadius.circular(20 * scale),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x66000000),
                                      offset: Offset(0, 4 * scale),
                                      blurRadius: 6 * scale,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: isReady
                                    ? SvgPicture.network(
                                        snapshot.data!,
                                        fit: BoxFit.contain,
                                        placeholderBuilder: (context) => const SizedBox.shrink(),
                                      )
                                    : Icon(
                                        Icons.chat_bubble,
                                        size: 18 * scale,
                                        color: Colors.white,
                                      ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned( //banner-progress-general
              top: 105 * scale,
              left: 17 * scale,
              child: SizedBox(
                width: 872 * scale,
                height: 121 * scale,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFF5CF6D7),
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
                            color: Color(0xFF080118),
                          ),
                        ),
                        SizedBox(height: 1 * scale),
                        Text(
                          _currentSession,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 32 * scale,
                            color: const Color(0xFFF65CC8),
                            height: 0.9,
                          ),
                        ),
                        SizedBox(height: 1 * scale),
                        Text(
                          _sessionName,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15 * scale,
                            color: const Color(0xFF080118),
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
                                    painter: _DiagonalStripesPainter(
                                      color1: const Color(0xFF8A5CF6),
                                      color2: const Color(0xFF7595F7),
                                      stripeWidth: 40 * scale,
                                    ),
                                  ),
                                  // Barra de progreso blanca
                                  FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: _subjectProgress,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFFFFF),
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
                  ],
                ),
              ),
            ),
              ),
            ),
            Positioned( // Matemática
              top: 116 * scale,
              left: 787 * scale,
              child: Text(
                _subjectName,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14 * scale,
                  color: const Color(0xFF08011B),
                ),
              ),
            ),
            Positioned( // Porcentaje
              top: 131 * scale,
              left: 799 * scale,
              child: Text(
                _progressPercentage,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 32 * scale,
                  color: const Color(0xFF8A5CF6),
                ),
              ),
            ),
            Positioned( // Icono del cofre
              top: (_subjectProgress >= 1.0 ? 187 : 177) * scale,
              left: (_subjectProgress >= 1.0 ? 839 : 839) * scale,
              child: SizedBox(
                width: (_subjectProgress >= 1.0 ? 36 : 47) * scale,
                height: (_subjectProgress >= 1.0 ? 33 : 52) * scale,
                child: FutureBuilder<String>(
                  future: _subjectProgress >= 1.0 ? _rewardCompletedIconFuture : _rewardPendingIconFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return SvgPicture.network(
                        snapshot.data!,
                        fit: BoxFit.contain,
                        placeholderBuilder: (context) => const SizedBox.shrink(),
                      );
                    }
                    return Icon(
                      _subjectProgress >= 1.0 ? Icons.card_giftcard : Icons.card_giftcard_outlined,
                      size: (_subjectProgress >= 1.0 ? 33 : 47) * scale,
                      color: const Color(0xFF8A5CF6),
                    );
                  },
                ),
              ),
            ),

          ],
        ),
    );
  }

  Future<void> _openCommunication() async {
    await OrientationService().setLandscapeOnly();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SessionProgressScreen(),
      ),
    );
  }
}

class _DiagonalStripesPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final double stripeWidth;

  _DiagonalStripesPainter({
    required this.color1,
    required this.color2,
    required this.stripeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Calcular cuántas rayas necesitamos para cubrir toda la barra
    final totalStripes = (size.width / stripeWidth).ceil() + (size.height / stripeWidth).ceil() + 2;
    
    for (int i = 0; i < totalStripes; i++) {
      paint.color = i % 2 == 0 ? color1 : color2;
      
      final path = Path();
      final startX = i * stripeWidth;
      
      path.moveTo(startX, 0);
      path.lineTo(startX + stripeWidth, 0);
      path.lineTo(startX + stripeWidth - size.height, size.height);
      path.lineTo(startX - size.height, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
