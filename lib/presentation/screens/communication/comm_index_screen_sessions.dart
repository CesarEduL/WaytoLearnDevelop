import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/communication/bear_progress_map_screen.dart';
import 'package:waytolearn/presentation/screens/mathematics/math_index_screen_sessions.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/widgets/communication/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/communication/mathematics_switch_button.dart';
import 'package:waytolearn/presentation/widgets/communication/progress_banner.dart';
import 'package:waytolearn/presentation/widgets/communication/session_box_widget.dart';
import 'package:waytolearn/presentation/widgets/communication/communication_bottom_bot.dart';

class CommIndexScreenSessions extends StatefulWidget {
  const CommIndexScreenSessions({super.key});

  @override
  State<CommIndexScreenSessions> createState() => _CommIndexScreenSessionsState();
}

class _CommIndexScreenSessionsState extends State<CommIndexScreenSessions> {
  String _currentSession = 'Sesión 1'; // Variable para mostrar la sesión actual
  String _sessionName = 'Nombre de la Sesión'; // Variable para mostrar el nombre de la sesión
  double _subjectProgress = 0.5; // Variable para el progreso de la materia (0.0 a 1.0)
  String _subjectName = 'Comunicación'; // Variable para el nombre de la materia
  
  // Variables para SessionBoxWidget (Sesión 1)
  String _session1Number = 'Sesión 1';
  String _session1Theme = 'Letras y sonidos';
  double _session1Progress = 1; // 0.0 a 1.0
  
  // Variables para Sesión 2
  String _session2Number = 'Sesión 2';
  String _session2Theme = 'Palabras y frases';
  double _session2Progress = 0.45; // 45%
  
  // Variables para Sesión 3
  String _session3Number = 'Sesión 3';
  String _session3Theme = 'Cuentos y narraciones';
  double _session3Progress = 0.0; // 0%
  
  // Variables para Sesión 4
  String _session4Number = 'Sesión 4';
  String _session4Theme = 'Expresión oral';
  double _session4Progress = 0.0; // 0%

  // GlobalKeys para detectar posición de cada widget
  final GlobalKey _session1Key = GlobalKey();
  final GlobalKey _session2Key = GlobalKey();
  final GlobalKey _session3Key = GlobalKey();
  final GlobalKey _session4Key = GlobalKey();

  // Estados de hover
  bool _session1Hovered = false;
  bool _session2Hovered = false;
  bool _session3Hovered = false;
  bool _session4Hovered = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
        children: [
          Listener(
            behavior: HitTestBehavior.deferToChild,
            onPointerMove: (event) => _handlePointerMove(event.position),
            onPointerUp: (_) => _resetAllHovers(),
            onPointerCancel: (_) => _resetAllHovers(),
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [

          Positioned(
              top: -32,
              left: -17,
              child: HomeIconButton(
                onPressed: _goToDashboard,
              ),
            ),
            Positioned(
              top: 14 * scale,
              left: 806 * scale,
              child: MathematicsSwitchButton(
                onTap: _openMathematics,
                scale: scale,
              ),
            ),
            Positioned(
              top: 105 * scale,
              left: 17 * scale,
              child: ProgressBanner(
                currentSession: _currentSession,
                sessionName: _sessionName,
                subjectProgress: _subjectProgress,
                subjectName: _subjectName,
                scale: scale,
              ),
            ),
            // Sesión 1
            Positioned(
              top: 245 * scale,
              left: 17 * scale,
              child: SessionBoxWidget(
                key: _session1Key,
                scale: scale,
                sessionNumber: _session1Number,
                sessionTheme: _session1Theme,
                progress: _session1Progress,
                isHovered: _session1Hovered,
                backgroundColor: const Color(0xFF8A5CF6), // Amarillo naranja
                sessionNumberColor: const Color(0xFF5CF6D7),
                sessionThemeColor: const Color(0xFFC8F65C),
                progressBarColor1: const Color(0xFFFF8C42),
                progressBarColor2: const Color(0xFFFFB84D),
                percentageColor: const Color(0xFFFFFFFF),
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 2
            Positioned(
              top: 245 * scale,
              left: 237 * scale,
              child: SessionBoxWidget(
                key: _session2Key,
                scale: scale,
                sessionNumber: _session2Number,
                sessionTheme: _session2Theme,
                progress: _session2Progress,
                isHovered: _session2Hovered,
                backgroundColor: const Color(0xFF7BF65C), // Amarillo naranja
                sessionNumberColor: const Color(0xFF583C95),
                sessionThemeColor: const Color(0xFF34089B),
                progressBarColor1: const Color(0xFF8A5CF6),
                progressBarColor2: const Color(0xFF7595F7),
                percentageColor: const Color(0xFFFFFFFF),
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 3
            Positioned(
              top: 245 * scale,
              left: 457 * scale,
              child: SessionBoxWidget(
                key: _session3Key,
                scale: scale,
                sessionNumber: _session3Number,
                sessionTheme: _session3Theme,
                progress: _session3Progress,
                isHovered: _session3Hovered,
                backgroundColor: const Color(0xFF5CF6D7), // Naranja
                sessionNumberColor: const Color(0xFF080118),
                sessionThemeColor: const Color(0xFFF65CC8),
                progressBarColor1: const Color(0xFF8A5CF6),
                progressBarColor2: const Color(0xFF7595F7),
                percentageColor: const Color(0xFFFFFFFF),
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 4
            Positioned(
              top: 245 * scale,
              left: 677 * scale,
              child: SessionBoxWidget(
                key: _session4Key,
                scale: scale,
                sessionNumber: _session4Number,
                sessionTheme: _session4Theme,
                progress: _session4Progress,
                isHovered: _session4Hovered,
                backgroundColor: const Color(0xFF5CF6D7), // Naranja
                sessionNumberColor: const Color(0xFF080118),
                sessionThemeColor: const Color(0xFFF65CC8),
                progressBarColor1: const Color(0xFF8A5CF6),
                progressBarColor2: const Color(0xFF7595F7),
                percentageColor: const Color(0xFFFFFFFF),
                onTap: () => _openBearProgressMap(),
              ),
            ),

              ],
            ),
          ),
          // Bot de comunicación (fuera del Listener para que responda al tap)
          Positioned(
            top: 345 * (MediaQuery.of(context).size.width / 912.0),
            left: 830 * (MediaQuery.of(context).size.width / 912.0),
            child: CommunicationBottomBot(
              scale: MediaQuery.of(context).size.width / 912.0,
              onTap: _refreshScreen,
            ),
          ),
        ],
      ),
    );
  }

  void _handlePointerMove(Offset globalPosition) {
    bool session1Inside = _isPointerInside(_session1Key, globalPosition);
    bool session2Inside = _isPointerInside(_session2Key, globalPosition);
    bool session3Inside = _isPointerInside(_session3Key, globalPosition);
    bool session4Inside = _isPointerInside(_session4Key, globalPosition);

    if (_session1Hovered != session1Inside ||
        _session2Hovered != session2Inside ||
        _session3Hovered != session3Inside ||
        _session4Hovered != session4Inside) {
      setState(() {
        _session1Hovered = session1Inside;
        _session2Hovered = session2Inside;
        _session3Hovered = session3Inside;
        _session4Hovered = session4Inside;
      });
    }
  }

  bool _isPointerInside(GlobalKey key, Offset globalPosition) {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;

    final Offset localPosition = box.globalToLocal(globalPosition);
    return box.paintBounds.contains(localPosition);
  }

  void _resetAllHovers() {
    setState(() {
      _session1Hovered = false;
      _session2Hovered = false;
      _session3Hovered = false;
      _session4Hovered = false;
    });
  }

  void _refreshScreen() {
    // Recargar la pantalla completamente reemplazándola con una nueva instancia
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const CommIndexScreenSessions(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _goToDashboard() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const DashboardScreen(),
      ),
    );
  }

  Future<void> _openMathematics() async {
    await OrientationService().setLandscapeOnly();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MathIndexScreenSessions(),
      ),
    );
  }

  Future<void> _openBearProgressMap() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BearProgressMapScreen(),
      ),
    );
  }
}
