import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/screens/mathematics/math_index_screen_sessions.dart';
import 'package:waytolearn/presentation/screens/communication/story_detail_screen.dart';

import 'package:waytolearn/presentation/widgets/communication/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/communication/mathematics_switch_button.dart';
import 'package:waytolearn/presentation/widgets/communication/communication_bottom_bot.dart';
import 'package:waytolearn/presentation/widgets/communication/story_path_widget.dart';

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

    // Al entrar al mapa, forzamos Horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // --- AQUÍ ESTÁ LA CORRECCIÓN DE LA NAVEGACIÓN ---
  void _navigateToStory(int index) async {
    final storyId = "C${(index + 1).toString().padLeft(2, '0')}";

    // 1. Antes de irnos, ordenamos VERTICAL para el cuento
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (!mounted) return;

    // 2. Navegamos al cuento
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryDetailScreen(storyId: storyId),
      ),
    );

    // 3. Cuando el usuario regrese (Navigator.pop), el código sigue aquí:
    // Ordenamos HORIZONTAL de nuevo para el mapa
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // ¡YA NO HAY CÓDIGO DE ORIENTACIÓN AQUÍ! (Eso evitara el rebote)

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
            top: 10 * scale,
            left: -20 * scale,
            child: StoryPathWidget(
              completedStoryIndex: 0,
              scale: scale,
              onStoryTap: _navigateToStory, // Usa la función corregida
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
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
    await OrientationService().setPortraitOnly();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MathIndexScreenSessions()),
    );
  }

  void _refreshScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const BearProgressMapScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> _goToDashboard() async {
    await OrientationService().setPortraitOnly();
    if (!mounted) return;
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }
}
