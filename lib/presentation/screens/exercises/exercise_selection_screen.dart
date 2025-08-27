import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/game_provider.dart';
import '../../../core/theme/app_theme.dart';
import 'exercise_screen.dart';

class ExerciseSelectionScreen extends StatefulWidget {
  final String subject;

  const ExerciseSelectionScreen({
    super.key,
    required this.subject,
  });

  @override
  State<ExerciseSelectionScreen> createState() => _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState extends State<ExerciseSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(_getSubjectTitle()),
        backgroundColor: _getSubjectColor(),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer2<UserProvider, GameProvider>(
        builder: (context, userProvider, gameProvider, child) {
          final user = userProvider.currentUser;
          
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              // Header con información del usuario
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildUserInfoHeader(user, userProvider),
                  ),
                ),
              ),

              // Contenido principal
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Tarjeta de progreso de la materia
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildSubjectProgressCard(user),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Dificultades disponibles
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildDifficultySection(context, gameProvider),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Ejercicios recomendados
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildRecommendedExercises(context, gameProvider),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón de ejercicio aleatorio
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildRandomExerciseButton(context, gameProvider, user),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserInfoHeader(dynamic user, UserProvider userProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getSubjectColor(),
            _getSubjectColor().withOpacity(0.8),
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  _getSubjectIcon(),
                  size: 30,
                  color: _getSubjectColor(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getSubjectTitle(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nivel ${user.getSubjectLevel(widget.subject)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Barra de progreso del nivel
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso del nivel',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(user.levelProgress * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: user.levelProgress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectProgressCard(dynamic user) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: _getSubjectColor(),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Tu Progreso en ${_getSubjectTitle()}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Nivel Actual',
                    '${user.getSubjectLevel(widget.subject)}',
                    Icons.star,
                    _getSubjectColor(),
                  ),
                ),
                Expanded(
                  child: _buildProgressItem(
                    'Puntos Ganados',
                    '${user.totalPoints}',
                    Icons.emoji_events,
                    AppTheme.goldColor,
                  ),
                ),
                Expanded(
                  child: _buildProgressItem(
                    'Experiencia',
                    '${user.experiencePoints}',
                    Icons.flash_on,
                    AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDifficultySection(BuildContext context, GameProvider gameProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona la Dificultad',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: _buildDifficultyCard(
                context,
                'Principiante',
                Icons.sentiment_satisfied,
                AppTheme.accentColor,
                () => _startExerciseWithDifficulty(context, 'beginner'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDifficultyCard(
                context,
                'Intermedio',
                Icons.sentiment_neutral,
                AppTheme.secondaryColor,
                () => _startExerciseWithDifficulty(context, 'intermediate'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDifficultyCard(
                context,
                'Avanzado',
                Icons.sentiment_dissatisfied,
                AppTheme.primaryColor,
                () => _startExerciseWithDifficulty(context, 'advanced'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedExercises(BuildContext context, GameProvider gameProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ejercicios Recomendados',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final user = userProvider.currentUser;
            if (user == null) return const SizedBox.shrink();
            
            final exercises = gameProvider.getExercisesBySubject(widget.subject);
            final userLevel = user.getSubjectLevel(widget.subject);
            
            // Filtrar ejercicios apropiados para el nivel del usuario
            final suitableExercises = exercises
                .where((exercise) => 
                    exercise.level >= userLevel - 1 && 
                    exercise.level <= userLevel + 1)
                .take(3)
                .toList();
            
            if (suitableExercises.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      size: 48,
                      color: AppTheme.textLight,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '¡Completa más ejercicios para obtener recomendaciones personalizadas!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: suitableExercises.map((exercise) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildExerciseCard(context, exercise),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExerciseCard(BuildContext context, dynamic exercise) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getSubjectColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getExerciseTypeIcon(exercise.type),
            color: _getSubjectColor(),
            size: 24,
          ),
        ),
        title: Text(
          exercise.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Nivel ${exercise.level} • ${exercise.difficultyText}',
          style: TextStyle(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getSubjectColor(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${exercise.points} pts',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        onTap: () => _startSpecificExercise(context, exercise),
      ),
    );
  }

  Widget _buildRandomExerciseButton(BuildContext context, GameProvider gameProvider, dynamic user) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () => _startRandomExercise(context, gameProvider, user),
        icon: const Icon(Icons.shuffle),
        label: Text(
          '¡Dame un Ejercicio Aleatorio!',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _getSubjectColor(),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  // Métodos de utilidad
  String _getSubjectTitle() {
    switch (widget.subject) {
      case 'mathematics':
        return 'Matemáticas';
      case 'communication':
        return 'Comunicación';
      default:
        return 'Materia';
    }
  }

  Color _getSubjectColor() {
    switch (widget.subject) {
      case 'mathematics':
        return AppTheme.primaryColor;
      case 'communication':
        return AppTheme.secondaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getSubjectIcon() {
    switch (widget.subject) {
      case 'mathematics':
        return Icons.calculate;
      case 'communication':
        return Icons.chat_bubble;
      default:
        return Icons.school;
    }
  }

  IconData _getExerciseTypeIcon(dynamic type) {
    switch (type.toString().split('.').last) {
      case 'multipleChoice':
        return Icons.check_circle;
      case 'dragAndDrop':
        return Icons.drag_handle;
      case 'fillInTheBlank':
        return Icons.edit;
      case 'trueFalse':
        return Icons.help;
      case 'matching':
        return Icons.compare_arrows;
      case 'ordering':
        return Icons.sort;
      default:
        return Icons.quiz;
    }
  }

  void _startExerciseWithDifficulty(BuildContext context, String difficulty) {
    // Implementar lógica para iniciar ejercicio con dificultad específica
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseScreen(
          subject: widget.subject,
          difficulty: difficulty,
        ),
      ),
    );
  }

  void _startSpecificExercise(BuildContext context, dynamic exercise) {
    // Implementar lógica para iniciar ejercicio específico
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseScreen(
          subject: widget.subject,
          exerciseId: exercise.id,
        ),
      ),
    );
  }

  void _startRandomExercise(BuildContext context, GameProvider gameProvider, dynamic user) {
    // Implementar lógica para ejercicio aleatorio
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseScreen(
          subject: widget.subject,
          isRandom: true,
        ),
      ),
    );
  }
}
