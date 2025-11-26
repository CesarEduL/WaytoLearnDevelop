import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/content_service.dart';
import '../../../../core/services/progress_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/models/interactive_story_model.dart';
import 'story_screen.dart';
import '../../widgets/mathematics/story_path_widget.dart'; // Importar widget compartido
import '../../widgets/mathematics/home_icon_button.dart';
import '../../widgets/communication/communication_bottom_bot.dart'; // Usar bot de comunicación

class ProgressMapScreen extends StatefulWidget {
  final int sessionNumber;
  const ProgressMapScreen({
    super.key,
    required this.sessionNumber,
  });

  @override
  State<ProgressMapScreen> createState() => _ProgressMapScreenState();
}

class _ProgressMapScreenState extends State<ProgressMapScreen> {
  // ✅ URLs desde Firebase Storage
  final Map<String, String> _urls = {
    'home':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FGroup%206.png?alt=media&token=74802f62-e83d-4322-b956-9196b47dc571',
    'bear':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FOSO%20CON%20UN%20LIBRO_%202.png?alt=media&token=ef9324fd-da34-49f3-a52b-7faf3121dc25',
    'settings':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcomunication-icon.png?alt=media&token=28186c74-b7d0-4914-b1e1-1b1f2b7a6bf0',
    'bookButton':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcomunication-icon2.png?alt=media&token=3fca4efc-eab2-44a3-8551-703bf86bc7b2',
    'bookDefault':
        'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2Fcuento-1.png?alt=media&token=153c8fbf-3ef5-4f38-a2b2-fca1bf04c737',
  };

  @override
  void initState() {
    super.initState();
    // Load progress for the current user
    Future.microtask(() {
      final userService = Provider.of<UserService>(context, listen: false);
      final userId = userService.currentUser?.id;
      if (userId != null) {
        Provider.of<ProgressService>(context, listen: false).loadProgress(userId, 'communication');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final progressService = Provider.of<ProgressService>(context);
    final contentService = Provider.of<ContentService>(context);
    
    final subjectId = 'communication';
    final sessionId = 'com_s${widget.sessionNumber}';

    final mediaSize = MediaQuery.of(context).size;
    const designWidth = 912.0;
    final scale = mediaSize.width / designWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<StoryModel>>(
        stream: contentService.getStories(subjectId, sessionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
             return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stories = snapshot.data ?? [];

          // Calculate completed index
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
              // Camino de cuentos usando StoryPathWidget
              Positioned(
                top: 10 * scale,
                left: -20 * scale,
                child: StoryPathWidget(
                  completedStoryIndex: completedStoryIndex,
                  scale: scale,
                  storyIconBuilder: (index, isCompleted, isLocked) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          _urls['bookDefault']!,
                          fit: BoxFit.contain,
                        ),
                        if (isCompleted)
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(Icons.check_circle, color: Colors.green, size: 20),
                          ),
                      ],
                    );
                  },
                  onStoryTap: (index) {
                    if (index < stories.length) {
                       bool isUnlocked = index == 0 || progressService.isStoryCompleted(stories[index - 1].id);
                       if (isUnlocked) {
                         _navigateToStory(stories[index], subjectId, sessionId);
                       } else {
                         ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('¡Completa el cuento anterior para desbloquear este!')),
                         );
                       }
                    }
                  },
                ),
              ),

              // Botón Home
              Positioned(
                top: -32,
                left: -17,
                child: HomeIconButton(
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Botón Configuración (reemplazando switch button de math)
              Positioned(
                top: 14 * scale,
                left: 806 * scale,
                child: GestureDetector(
                  onTap: _onSettingsTap,
                  child: Image.network(_urls['settings']!, width: 90 * scale),
                ),
              ),

              // Botón Libro (extra que tenía communication)
              Positioned(
                bottom: 5 * scale,
                right: 10 * scale,
                child: GestureDetector(
                  onTap: _onBookMenuTap,
                  child: Image.network(_urls['bookButton']!, width: 90 * scale),
                ),
              ),

              // Oso leyendo (Personaje central)
              Positioned(
                left: MediaQuery.of(context).size.width * 0.43,
                top: MediaQuery.of(context).size.height * 0.20,
                child: GestureDetector(
                  onTap: _onBearTap,
                  child: Image.network(_urls['bear']!, width: 120 * scale),
                ),
              ),

              // Bot de comunicación
              Positioned(
                top: 345 * scale,
                left: 830 * scale,
                child: CommunicationBottomBot(scale: scale),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToStory(StoryModel story, String subjectId, String sessionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryScreen(
          story: story, 
          subjectId: subjectId, 
          sessionId: sessionId
        ),
      ),
    );
  }

  void _onBearTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Hola! Soy tu compañero de aprendizaje'),
        backgroundColor: Colors.brown,
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  void _onSettingsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración'),
        backgroundColor: Colors.purple,
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  void _onBookMenuTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menú de libros'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 800),
      ),
    );
  }
}
