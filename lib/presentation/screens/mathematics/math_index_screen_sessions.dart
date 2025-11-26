import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:waytolearn/core/models/interactive_story_model.dart';
import 'package:waytolearn/core/services/content_service.dart';
import 'package:waytolearn/core/services/progress_service.dart';
import 'package:waytolearn/core/services/user_service.dart';
import 'package:waytolearn/core/services/orientation_service.dart';
import 'package:waytolearn/presentation/screens/communication/comm_index_screen_sessions.dart';
import 'package:waytolearn/presentation/screens/mathematics/bear_progress_map_screen.dart';
import 'package:waytolearn/presentation/screens/main/dashboard_screen.dart';
import 'package:waytolearn/presentation/widgets/mathematics/home_icon_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/communication_switch_button.dart';
import 'package:waytolearn/presentation/widgets/mathematics/progress_banner.dart';
import 'package:waytolearn/presentation/widgets/communication/session_box_widget.dart';
import 'package:waytolearn/presentation/widgets/mathematics/mathematics_bottom_bot.dart';

class MathIndexScreenSessions extends StatefulWidget {
  const MathIndexScreenSessions({super.key});

  @override
  State<MathIndexScreenSessions> createState() => _MathIndexScreenSessionsState();
}

class _MathIndexScreenSessionsState extends State<MathIndexScreenSessions> with TickerProviderStateMixin {
  // GlobalKeys para detectar posición de cada widget (para hover)
  final List<GlobalKey> _sessionKeys = List.generate(4, (_) => GlobalKey());
  
  // Estados de hover
  List<bool> _sessionHovers = List.generate(4, (_) => false);

  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _entryController, curve: Curves.easeOut);
    
    _entryController.forward();

    // Cargar progreso al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const designWidth = 912.0;
    final scale = mediaSize.width / designWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- Fondo Decorativo Premium ---
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFB2DFDB), // Teal 200
                  Color(0xFFE0F2F1), // Teal 50
                  Color(0xFFFFF9C4), // Yellow 100
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          // Elementos flotantes animados (simplificados estáticos por ahora, pero con mejor color)
          Positioned(
            top: 40 * scale,
            right: 80 * scale,
            child: Icon(Icons.change_history, color: Colors.indigo.withOpacity(0.1), size: 100 * scale),
          ),
          Positioned(
            bottom: 60 * scale,
            left: 40 * scale,
            child: Icon(Icons.crop_square, color: Colors.teal.withOpacity(0.1), size: 120 * scale),
          ),
          Positioned(
            top: 150 * scale,
            left: 220 * scale,
            child: Icon(Icons.circle_outlined, color: Colors.orange.withOpacity(0.1), size: 50 * scale),
          ),

          // Contenido Principal con StreamBuilder para datos reales
          StreamBuilder<List<SubjectModel>>(
            stream: Provider.of<ContentService>(context, listen: false).getSubjects(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final subjects = snapshot.data!;
              final mathSubject = subjects.firstWhere(
                (s) => s.id == 'math', 
                orElse: () => SubjectModel(id: 'math', name: 'Matemática', sessions: [])
              );

              return Consumer<ProgressService>(
                builder: (context, progressService, child) {
                  // Calcular progreso general de la materia
                  int totalStoriesSubject = 0;
                  int completedStoriesSubject = 0;

                  for (var session in mathSubject.sessions) {
                    totalStoriesSubject += session.stories.length;
                    for (var story in session.stories) {
                      if (progressService.isStoryCompleted(story.id)) {
                        completedStoriesSubject++;
                      }
                    }
                  }

                  double subjectProgress = totalStoriesSubject > 0 
                      ? completedStoriesSubject / totalStoriesSubject 
                      : 0.0;

                  // Sesión actual (la primera incompleta o la última)
                  String currentSessionName = 'Sesión 1';
                  String currentSessionTitle = 'Inicio';
                  
                  for (var session in mathSubject.sessions) {
                    bool isSessionComplete = session.stories.every((s) => progressService.isStoryCompleted(s.id));
                    if (!isSessionComplete) {
                      currentSessionName = session.name; // Asumiendo que name es "Sesión X"
                      // FIX: session.name instead of session.title
                      currentSessionTitle = session.name.isNotEmpty ? session.name : 'Aprendizaje';
                      break;
                    }
                  }

                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Listener(
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
                            child: HomeIconButton(onPressed: _goToDashboard),
                          ),
                          Positioned(
                            top: 14 * scale,
                            left: 806 * scale,
                            child: CommunicationSwitchButton(
                              onTap: _openCommunication,
                              scale: scale,
                            ),
                          ),
                          
                          // Banner de Progreso General
                          Positioned(
                            top: 105 * scale,
                            left: 17 * scale,
                            child: ProgressBanner(
                              currentSession: currentSessionName,
                              sessionName: currentSessionTitle,
                              subjectProgress: subjectProgress,
                              subjectName: mathSubject.name,
                              scale: scale,
                            ),
                          ),

                          // Tarjetas de Sesiones (Mapeadas dinámicamente hasta 4)
                          ...List.generate(4, (index) {
                            if (index >= mathSubject.sessions.length) return const SizedBox.shrink();
                            
                            final session = mathSubject.sessions[index];
                            
                            // Calcular progreso de la sesión
                            int totalStories = session.stories.length;
                            int completedStories = session.stories.where((s) => progressService.isStoryCompleted(s.id)).length;
                            double sessionProgress = totalStories > 0 ? completedStories / totalStories : 0.0;

                            // Posiciones fijas según el diseño original
                            final double leftPos = 17 * scale + (index * 220 * scale);
                            
                            // Colores por índice para mantener el diseño visual
                            final colors = _getSessionColors(index);

                            return Positioned(
                              top: 245 * scale,
                              left: leftPos,
                              child: SessionBoxWidget(
                                key: _sessionKeys[index],
                                scale: scale,
                                sessionNumber: 'Sesión ${index + 1}',
                                // FIX: session.name instead of session.title
                                sessionTheme: session.name.isNotEmpty ? session.name : 'Tema ${index + 1}',
                                progress: sessionProgress,
                                isHovered: _sessionHovers[index],
                                backgroundColor: colors['bg']!,
                                sessionNumberColor: colors['number']!,
                                sessionThemeColor: colors['theme']!,
                                progressBarColor1: colors['bar1']!,
                                progressBarColor2: colors['bar2']!,
                                percentageColor: colors['percent']!,
                                onTap: () => _openBearProgressMap(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // Bot de matemáticas
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

  Map<String, Color> _getSessionColors(int index) {
    switch (index) {
      case 0: // Verde Esmeralda
        return {
          'bg': const Color(0xFF4DB6AC),
          'number': const Color(0xFF004D40),
          'theme': Colors.white,
          'bar1': const Color(0xFF80CBC4),
          'bar2': const Color(0xFF26A69A),
          'percent': Colors.white,
        };
      case 1: // Azul Cielo
        return {
          'bg': const Color(0xFF4FC3F7),
          'number': const Color(0xFF01579B),
          'theme': Colors.white,
          'bar1': const Color(0xFF81D4FA),
          'bar2': const Color(0xFF29B6F6),
          'percent': Colors.white,
        };
      case 2: // Indigo
        return {
          'bg': const Color(0xFF7986CB),
          'number': const Color(0xFF1A237E),
          'theme': Colors.white,
          'bar1': const Color(0xFF9FA8DA),
          'bar2': const Color(0xFF5C6BC0),
          'percent': Colors.white,
        };
      case 3: // Lima
        return {
          'bg': const Color(0xFFDCE775),
          'number': const Color(0xFF827717),
          'theme': const Color(0xFF33691E),
          'bar1': const Color(0xFFE6EE9C),
          'bar2': const Color(0xFFC0CA33),
          'percent': const Color(0xFF33691E),
        };
      default:
        return {
          'bg': Colors.grey,
          'number': Colors.black,
          'theme': Colors.white,
          'bar1': Colors.grey[300]!,
          'bar2': Colors.grey[600]!,
          'percent': Colors.white,
        };
    }
  }

  void _handlePointerMove(Offset globalPosition) {
    for (int i = 0; i < 4; i++) {
      bool isInside = _isPointerInside(_sessionKeys[i], globalPosition);
      if (_sessionHovers[i] != isInside) {
        setState(() {
          _sessionHovers[i] = isInside;
        });
      }
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
      _sessionHovers = List.filled(4, false);
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
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  Future<void> _openCommunication() async {
    await OrientationService().setLandscapeOnly();
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CommIndexScreenSessions()),
    );
  }

  Future<void> _openBearProgressMap() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BearProgressMapScreen()),
    );
  }
}
