import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/communication/session_progress_screen.dart';
import 'package:waytolearn/presentation/widgets/mathematics/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/communication_switch_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/progress_banner.dart';
import 'package:waytolearn/presentation/widgets/mathematics/empty_box_widget.dart';
import 'package:waytolearn/presentation/widgets/mathematics/comunicacion_bottom_bot.dart';

class MathIndexScreenSessions extends StatefulWidget {
  const MathIndexScreenSessions({super.key});

  @override
  State<MathIndexScreenSessions> createState() => _MathIndexScreenSessionsState();
}

class _MathIndexScreenSessionsState extends State<MathIndexScreenSessions> {
  String _currentSession = 'Sesión 1'; // Variable para mostrar la sesión actual
  String _sessionName = 'Nombre de la Sesión'; // Variable para mostrar el nombre de la sesión
  double _subjectProgress = 0.3; // Variable para el progreso de la materia (0.0 a 1.0)
  String _subjectName = 'Matemática'; // Variable para el nombre de la materia
  
  // Variables para EmptyBoxWidget (Sesión 1)
  String _session1Number = 'Sesión 1';
  String _session1Theme = 'Tema de la sesión';
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

          Positioned(
              top: -32,
              left: -17,
              child: HomeIconButton(
                onPressed: () => Navigator.pop(context),
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
            // Sesión 1
            Positioned(
              top: 245 * scale,
              left: 17 * scale,
              child: EmptyBoxWidget(
                scale: scale,
                sessionNumber: _session1Number,
                sessionTheme: _session1Theme,
                progress: _session1Progress,
              ),
            ),
            // Sesión 2
            Positioned(
              top: 245 * scale,
              left: 237 * scale,
              child: EmptyBoxWidget(
                scale: scale,
                sessionNumber: _session2Number,
                sessionTheme: _session2Theme,
                progress: _session2Progress,
                backgroundColor: const Color(0xFF7BF65C),
                sessionNumberColor: const Color(0xFF583C95),
                sessionThemeColor: const Color(0xFF34089B),
                progressBarColor1: const Color(0xFF8A5CF6),
                progressBarColor2: const Color(0xFF7595F7),
                percentageColor: const Color(0xFFFFFFFF),
              ),
            ),
            // Sesión 3
            Positioned(
              top: 245 * scale,
              left: 457 * scale,
              child: EmptyBoxWidget(
                scale: scale,
                sessionNumber: _session3Number,
                sessionTheme: _session3Theme,
                progress: _session3Progress,
                backgroundColor: const Color(0xFF8A5CF6),
                sessionNumberColor: const Color(0xFF5CF6D7),
                sessionThemeColor: const Color(0xFF7BF65C),
                progressBarColor1: const Color(0xFF5CF6D7),
                progressBarColor2: const Color(0xFF7595F7),
                percentageColor: const Color(0xFFFFFFFF),
              ),
            ),
            // Sesión 4
            Positioned(
              top: 245 * scale,
              left: 677 * scale,
              child: EmptyBoxWidget(
                scale: scale,
                sessionNumber: _session4Number,
                sessionTheme: _session4Theme,
                progress: _session4Progress,
                backgroundColor: const Color(0xFF8A5CF6),
                sessionNumberColor: const Color(0xFF5CF6D7),
                sessionThemeColor: const Color(0xFF7BF65C),
                progressBarColor1: const Color(0xFF5CF6D7),
                progressBarColor2: const Color(0xFF7595F7),
                percentageColor: const Color(0xFFFFFFFF),
              ),
            ),
            // Bot de comunicación
            Positioned(
              top: 345 * scale,
              left: 830 * scale,
              child: ComunicacionBottomBot(
                scale: scale,
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
