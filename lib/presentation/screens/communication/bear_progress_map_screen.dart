import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/screens/mathematics/math_index_screen_sessions.dart';
import 'package:provider/provider.dart';
import 'package:waytolearn/core/services/user_service.dart';
import 'package:waytolearn/core/services/session_service.dart';
import 'package:waytolearn/presentation/screens/communication/story_detail_screen.dart';

import 'package:waytolearn/presentation/widgets/communication/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/communication/mathematics_switch_button.dart';
import 'package:waytolearn/presentation/widgets/communication/communication_bottom_bot.dart';
import 'package:waytolearn/presentation/widgets/communication/story_path_widget.dart';

class BearProgressMapScreen extends StatefulWidget {
  final String? sessionId;
  
  const BearProgressMapScreen({super.key, this.sessionId});

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
          // Consumir datos del usuario para mostrar progreso real
          Positioned(
            top: 10 * scale,
            left: -20 * scale,
            child: Consumer<UserService>(
              builder: (context, userService, child) {
                final user = userService.currentUser;
                int completedIndex = -1; // -1 significa ninguno completado (solo el 0 desbloqueado)
                
                if (user != null) {
                  // Obtenemos el índice desbloqueado (0-6)
                  // Si desbloqueado es 0, completado es -1 (ninguno)
                  // Si desbloqueado es 1, completado es 0 (el primero)
                  // La lógica visual del widget espera "completedStoryIndex"
                  final unlocked = user.getHighestUnlockedIndex('communication');
                  completedIndex = unlocked - 1;
                }

                return StoryPathWidget(
                  completedStoryIndex: completedIndex,
                  scale: scale,
                  onStoryTap: (index) {
                    // Lógica de desbloqueo:
                    // 1. Si el usuario es null (no logueado), permitimos SOLO el primero (índice 0).
                    // 2. Si el usuario existe, verificamos su progreso real.
                    
                    bool isUnlocked = false;
                    
                    if (user == null) {
                      isUnlocked = index == 0;
                    } else {
                      isUnlocked = user.isStoryUnlocked('communication', index);
                    }

                    if (isUnlocked) {
                      _navigateToStory(index);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Completa los cuentos anteriores para desbloquear este!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
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
