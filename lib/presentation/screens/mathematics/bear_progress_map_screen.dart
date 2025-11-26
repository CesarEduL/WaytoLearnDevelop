import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/core/services/user_service.dart';
import 'package:waytolearn/core/services/content_service.dart';
import 'package:waytolearn/core/services/progress_service.dart';
import 'package:waytolearn/core/models/interactive_story_model.dart';
import 'package:waytolearn/presentation/screens/communication/comm_index_screen_sessions.dart';
import 'package:waytolearn/presentation/screens/communication/story_screen.dart';
import 'package:waytolearn/presentation/widgets/mathematics/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/communication_switch_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/mathematics_bottom_bot.dart';
import 'package:waytolearn/presentation/widgets/mathematics/story_path_widget.dart';
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
    // Load progress
    Future.microtask(() {
      final userService = Provider.of<UserService>(context, listen: false);
      final userId = userService.currentUser?.id;
      if (userId != null) {
        Provider.of<ProgressService>(context, listen: false).loadProgress(userId, 'math');
      }
    });
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
    
    final contentService = Provider.of<ContentService>(context);
    final progressService = Provider.of<ProgressService>(context);

    // Hardcoded for now, as per Communication screen
    final subjectId = 'math';
    final sessionId = 'math_s1';

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<StoryModel>>(
        stream: contentService.getStories(subjectId, sessionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final stories = snapshot.data ?? [];
          
          // Calculate completed index based on ProgressService
          int completedStoryIndex = -1;
          for (int i = 0; i < stories.length; i++) {
            if (progressService.isStoryCompleted(stories[i].id)) {
              completedStoryIndex = i;
            } else {
              break; 
            }
          }

          return Stack(
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
                      if (index < stories.length) {
                         // Check if unlocked
                         bool isUnlocked = index == 0 || progressService.isStoryCompleted(stories[index - 1].id);
                         if (isUnlocked) {
                           _navigateToStory(stories[index], subjectId, sessionId);
                         } else {
                           ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('¡Completa el nivel anterior!')),
                           );
                         }
                      } else {
                        debugPrint('Story index $index out of bounds');
                      }
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
            );
        }
      ),
    );
  }

  Future<void> _navigateToStory(StoryModel story, String subjectId, String sessionId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryScreen(
          story: story,
          subjectId: subjectId,
          sessionId: sessionId,
        ),
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

  void _refreshScreen() {
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