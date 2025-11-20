import 'package:flutter/material.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/widgets/communication/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/communication/mathematics_switch_button.dart';
import 'package:waytolearn/presentation/widgets/communication/communication_bottom_bot.dart';
import 'package:waytolearn/presentation/widgets/communication/story_path_widget.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/presentation/screens/mathematics/math_index_screen_sessions.dart';

class BearProgressMapScreen extends StatefulWidget {
  const BearProgressMapScreen({super.key});

  @override
  State<BearProgressMapScreen> createState() => _BearProgressMapScreenState();
}

class _BearProgressMapScreenState extends State<BearProgressMapScreen> {
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
          // Camino de cuentos - contenido principal centrado
          Positioned(
              top: 10 * scale,
              left: -20 * scale,
              child: StoryPathWidget(
                completedStoryIndex: 0, // Ejemplo: 3 cuentos completados
                scale: scale,
                onStoryTap: (index) {
                  debugPrint('Tapped story: ${index + 1}');
                  // TODO: Navegar a la pantalla del cuento
                },
              ),
            ),
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

            // Bot de comunicación
            Positioned(
              top: 345 * scale,
              left: 830 * scale,
              child: CommunicationBottomBot(
                scale: scale,
                onTap: _refreshScreen,
              ),
            ),
          ],
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

  void _refreshScreen() {
    // Recargar la pantalla completamente reemplazándola con una nueva instancia
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
}
