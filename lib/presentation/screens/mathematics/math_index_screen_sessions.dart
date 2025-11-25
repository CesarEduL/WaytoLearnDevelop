import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/communication/comm_index_screen_sessions.dart';
import 'package:waytolearn/presentation/screens/mathematics/bear_progress_map_screen.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/widgets/mathematics/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/communication_switch_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/progress_banner.dart';
import 'package:waytolearn/presentation/widgets/communication/session_box_widget.dart'; // Reutilizando el widget mejorado
import 'package:waytolearn/presentation/widgets/mathematics/mathematics_bottom_bot.dart';

class MathIndexScreenSessions extends StatefulWidget {
  const MathIndexScreenSessions({super.key});

  @override
  State<MathIndexScreenSessions> createState() => _MathIndexScreenSessionsState();
}

class _MathIndexScreenSessionsState extends State<MathIndexScreenSessions> {
  String _currentSession = 'Sesión 1'; // Variable para mostrar la sesión actual
  String _sessionName = 'Nombre de la Sesión'; // Variable para mostrar el nombre de la sesión
  double _subjectProgress = 0.5; // Variable para el progreso de la materia (0.0 a 1.0)
  String _subjectName = 'Matemática'; // Variable para el nombre de la materia
  
  // Variables para Sesión 1
  String _session1Number = 'Sesión 1';
  String _session1Theme = 'Números y Conteo';
  double _session1Progress = 1; // 0.0 a 1.0
  
  // Variables para Sesión 2
  String _session2Number = 'Sesión 2';
  String _session2Theme = 'Operaciones básicas';
  double _session2Progress = 0.45; // 45%
  
  // Variables para Sesión 3
  String _session3Number = 'Sesión 3';
  String _session3Theme = 'Formas y figuras';
  double _session3Progress = 0.0; // 0%
  
  // Variables para Sesión 4
  String _session4Number = 'Sesión 4';
  String _session4Theme = 'Medidas y comparaciones';
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
      backgroundColor: const Color(0xFFE8F5E9), // Fondo verde muy suave
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
                  Color(0xFFE0F2F1), // Teal muy suave
                  Color(0xFFE8F5E9), // Verde muy suave
                  Color(0xFFFFFDE7), // Amarillo muy suave
                ],
              ),
            ),
          ),
          
          // Elementos flotantes (Figuras Geométricas para Matemáticas)
          Positioned(
            top: 40 * scale,
            right: 80 * scale,
            child: Icon(Icons.change_history, color: Colors.blue.withOpacity(0.2), size: 100 * scale), // Triángulo
          ),
          Positioned(
            bottom: 60 * scale,
            left: 40 * scale,
            child: Icon(Icons.crop_square, color: Colors.green.withOpacity(0.2), size: 120 * scale), // Cuadrado
          ),
          Positioned(
            top: 150 * scale,
            left: 220 * scale,
            child: Icon(Icons.circle_outlined, color: Colors.orange.withOpacity(0.2), size: 50 * scale), // Círculo
          ),
          Positioned(
            bottom: 100 * scale,
            right: 200 * scale,
            child: Icon(Icons.star_border_rounded, color: Colors.purple.withOpacity(0.2), size: 60 * scale), // Estrella
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
              child: CommunicationSwitchButton(
                onTap: _openCommunication,
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
            // Sesión 1 - Verde Esmeralda
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
                backgroundColor: const Color(0xFF4DB6AC), // Teal 300
                sessionNumberColor: const Color(0xFF004D40),
                sessionThemeColor: Colors.white,
                progressBarColor1: const Color(0xFF80CBC4),
                progressBarColor2: const Color(0xFF26A69A),
                percentageColor: Colors.white,
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 2 - Azul Cielo
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
                backgroundColor: const Color(0xFF4FC3F7), // Light Blue 300
                sessionNumberColor: const Color(0xFF01579B),
                sessionThemeColor: Colors.white,
                progressBarColor1: const Color(0xFF81D4FA),
                progressBarColor2: const Color(0xFF29B6F6),
                percentageColor: Colors.white,
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 3 - Indigo
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
                backgroundColor: const Color(0xFF7986CB), // Indigo 300
                sessionNumberColor: const Color(0xFF1A237E),
                sessionThemeColor: Colors.white,
                progressBarColor1: const Color(0xFF9FA8DA),
                progressBarColor2: const Color(0xFF5C6BC0),
                percentageColor: Colors.white,
                onTap: () => _openBearProgressMap(),
              ),
            ),
            // Sesión 4 - Lima/Verde Claro
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
                backgroundColor: const Color(0xFFDCE775), // Lime 300
                sessionNumberColor: const Color(0xFF827717),
                sessionThemeColor: const Color(0xFF33691E), // Texto oscuro para contraste
                progressBarColor1: const Color(0xFFE6EE9C),
                progressBarColor2: const Color(0xFFC0CA33),
                percentageColor: const Color(0xFF33691E),
                onTap: () => _openBearProgressMap(),
              ),
            ),

              ],
            ),
          ),
          // Bot de matemáticas
          Positioned(
            top: 345 * (MediaQuery.of(context).size.width / 912.0),
            left: 830 * (MediaQuery.of(context).size.width / 912.0),
            child: MathematicsBottomBot(
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
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MathIndexScreenSessions(),
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

  Future<void> _openCommunication() async {
    await OrientationService().setLandscapeOnly();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CommIndexScreenSessions(),
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
