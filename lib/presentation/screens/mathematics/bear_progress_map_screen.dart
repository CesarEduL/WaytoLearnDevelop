import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/core/services/user_service.dart';
import 'package:waytolearn/presentation/screens/communication/comm_index_screen_sessions.dart';
import 'package:waytolearn/presentation/screens/mathematics/story_play_screen.dart';
import 'package:waytolearn/presentation/widgets/mathematics/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/communication_switch_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/mathematics_bottom_bot.dart';
import 'package:waytolearn/presentation/widgets/mathematics/story_path_widget.dart';
import 'package:waytolearn/presentation/screens/mathematics/math_index_screen_sessions.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';


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
    
    final userService = Provider.of<UserService>(context);
    final user = userService.currentUser;
    
    // Obtener progreso real de matemáticas
    // Asumimos que los primeros 7 niveles corresponden a la sesión 1
    // Si el unlocked index es mayor a 6, significa que completó la sesión 1
    int completedStoryIndex = -1;
    if (user != null) {
      final unlocked = user.getHighestUnlockedIndex('mathematics');
      // Ajustar lógica según cómo se manejen las sesiones. 
      // Si este mapa es SOLO para la sesión 1 (niveles 0-6):
      completedStoryIndex = unlocked - 1;
      if (completedStoryIndex > 6) completedStoryIndex = 6;
    }

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
                completedStoryIndex: completedStoryIndex,
                scale: scale,
                onStoryTap: (index) {
                  debugPrint('Tapped story: ${index + 1}');
                  _navigateToStory(index);
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
              child: CommunicationSwitchButton(
                onTap: _openCommunication,
                scale: scale,
              ),
            ),

            // Bot de comunicación
            Positioned(
              top: 345 * scale,
              left: 830 * scale,
              child: MathematicsBottomBot(
                scale: scale,
                onTap: _refreshScreen,
              ),
            ),
          ],
        ),
    );
  }

  Future<void> _navigateToStory(int index) async {
    // Navegar a la pantalla de juego/cuento
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryPlayScreen(storyIndex: index),
      ),
    );
    
    debugPrint('Navegando al cuento $index');
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

  void _refreshScreen() {
    // Recargar la pantalla completamente reemplazándola con una nueva instancia
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const BearProgressMapScreen(),
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