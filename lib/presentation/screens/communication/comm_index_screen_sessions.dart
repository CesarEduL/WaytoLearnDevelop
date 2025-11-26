import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/communication/progress_map_screen.dart';
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
      backgroundColor: const Color(0xFFF0F4F8), // Fondo base suave
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- Fondo Decorativo ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0F7FA), // Cyan muy suave
                  Color(0xFFF3E5F5), // Púrpura muy suave
                  Color(0xFFFFF3E0), // Naranja muy suave
                ],
              ),
            ),
          ),
          
          // Elementos flotantes (Nubes y Estrellas)
          Positioned(
            top: 50 * scale,
            right: 100 * scale,
            child: Icon(Icons.cloud, color: Colors.white.withOpacity(0.6), size: 120 * scale),
          ),
          Positioned(
            bottom: 80 * scale,
            left: 50 * scale,
            child: Icon(Icons.cloud, color: Colors.white.withOpacity(0.4), size: 150 * scale),
          ),
          Positioned(
            top: 150 * scale,
            left: 200 * scale,
            child: Icon(Icons.star_rounded, color: const Color(0xFFFFD54F).withOpacity(0.3), size: 40 * scale),
          ),
          Positioned(
            bottom: 120 * scale,
            right: 250 * scale,
            child: Icon(Icons.star_rounded, color: const Color(0xFF4FC3F7).withOpacity(0.3), size: 50 * scale),
          ),
          Positioned(
            top: 80 * scale,
            left: 50 * scale,
            child: Icon(Icons.circle, color: const Color(0xFFFF8A65).withOpacity(0.2), size: 20 * scale),
          ),

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
            // Sesión 1 - Púrpura Pastel
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
                backgroundColor: const Color(0xFFB39DDB), // Deep Purple 200
                sessionNumberColor: const Color(0xFF4527A0),
                sessionThemeColor: Colors.white,
                progressBarColor1: const Color(0xFF9575CD),
                progressBarColor2: const Color(0xFF7E57C2),
                percentageColor: Colors.white,
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 2 - Verde Pastel
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
                backgroundColor: const Color(0xFFA5D6A7), // Green 200
                sessionNumberColor: const Color(0xFF1B5E20),
                sessionThemeColor: Colors.white,
                progressBarColor1: const Color(0xFF81C784),
                progressBarColor2: const Color(0xFF66BB6A),
                percentageColor: Colors.white,
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 3 - Azul Pastel
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
                backgroundColor: const Color(0xFF90CAF9), // Blue 200
                sessionNumberColor: const Color(0xFF0D47A1),
                sessionThemeColor: Colors.white,
                progressBarColor1: const Color(0xFF64B5F6),
                progressBarColor2: const Color(0xFF42A5F5),
                percentageColor: Colors.white,
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 4 - Naranja Pastel
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
                backgroundColor: const Color(0xFFFFCC80), // Orange 200
                sessionNumberColor: const Color(0xFFE65100),
                sessionThemeColor: Colors.white,
                progressBarColor1: const Color(0xFFFFB74D),
                progressBarColor2: const Color(0xFFFFA726),
                percentageColor: Colors.white,
                onTap: () => _openBearProgressMap(),
              ),
            ),
            
            // Botón flotante inferior (CommunicationBottomBot)
            Positioned(
              top: 345 * scale,
              left: 830 * scale,
              child: CommunicationBottomBot(scale: scale),
            ),
              ],
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
        builder: (_) => const ProgressMapScreen(sessionNumber: 1),
      ),
    );
  }
}
