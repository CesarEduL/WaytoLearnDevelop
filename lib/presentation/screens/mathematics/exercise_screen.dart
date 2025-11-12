import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/providers/game_provider.dart';
import '../../../core/theme/app_theme.dart';

class ExerciseScreen extends StatefulWidget {
  final String subject;
  final String? difficulty;
  final String? exerciseId;
  final bool isRandom;

  const ExerciseScreen({
    super.key,
    required this.subject,
    this.difficulty,
    this.exerciseId,
    this.isRandom = false,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _userAnswer;
  bool _isAnswerSubmitted = false;
  bool _isCorrect = false;
  String? _feedbackMessage;

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
        actions: [
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars,
                      color: AppTheme.goldColor,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${gameProvider.currentScore}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<UserProvider, GameProvider>(
        builder: (context, userProvider, gameProvider, child) {
          final user = userProvider.currentUser;
          final currentExercise = gameProvider.currentExercise;
          
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (currentExercise == null) {
            return _buildLoadingExercise(context, gameProvider, user);
          }

          return _buildExerciseContent(context, currentExercise, gameProvider, user);
        },
      ),
    );
  }

  Widget _buildLoadingExercise(BuildContext context, GameProvider gameProvider, dynamic user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: _getSubjectColor(),
            strokeWidth: 4,
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando ejercicio...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _loadNextExercise(context, gameProvider, user),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getSubjectColor(),
              foregroundColor: Colors.white,
            ),
            child: const Text('Cargar Ejercicio'),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseContent(BuildContext context, dynamic exercise, GameProvider gameProvider, dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del ejercicio
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildExerciseHeader(exercise),
            ),
          ),

          const SizedBox(height: 24),

          // Contenido del ejercicio
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildExerciseBody(exercise),
            ),
          ),

          const SizedBox(height: 24),

          // Área de respuesta
          if (!_isAnswerSubmitted)
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildAnswerSection(context, exercise, gameProvider, user),
              ),
            ),

          // Resultado de la respuesta
          if (_isAnswerSubmitted)
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildResultSection(context, exercise, gameProvider, user),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseHeader(dynamic exercise) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getSubjectColor(),
              _getSubjectColor().withOpacity(0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getExerciseTypeIcon(exercise.type),
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    exercise.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              exercise.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                _buildExerciseInfoChip(
                  'Nivel ${exercise.level}',
                  Icons.star,
                ),
                const SizedBox(width: 12),
                _buildExerciseInfoChip(
                  exercise.difficultyText,
                  Icons.speed,
                ),
                const SizedBox(width: 12),
                _buildExerciseInfoChip(
                  '${exercise.points} pts',
                  Icons.emoji_events,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseBody(dynamic exercise) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instrucciones:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Aquí se renderizaría el contenido específico del ejercicio
            // Por ahora mostramos un placeholder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getSubjectColor().withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getExerciseTypeIcon(exercise.type),
                    size: 48,
                    color: _getSubjectColor(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getExerciseInstructions(exercise.type),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSection(BuildContext context, dynamic exercise, GameProvider gameProvider, dynamic user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tu Respuesta:',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              onChanged: (value) {
                setState(() {
                  _userAnswer = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Escribe tu respuesta aquí...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _getSubjectColor(),
                    width: 2,
                  ),
                ),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _userAnswer?.isNotEmpty == true
                    ? () => _submitAnswer(context, exercise, gameProvider, user)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getSubjectColor(),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Enviar Respuesta',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection(BuildContext context, dynamic exercise, GameProvider gameProvider, dynamic user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _isCorrect ? AppTheme.accentColor.withOpacity(0.1) : AppTheme.errorColor.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              _isCorrect ? Icons.check_circle : Icons.cancel,
              size: 64,
              color: _isCorrect ? AppTheme.accentColor : AppTheme.errorColor,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              _isCorrect ? '¡Correcto!' : 'Incorrecto',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _isCorrect ? AppTheme.accentColor : AppTheme.errorColor,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              _feedbackMessage ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _loadNextExercise(context, gameProvider, user),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getSubjectColor(),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Siguiente Ejercicio'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _getSubjectColor(),
                      side: BorderSide(color: _getSubjectColor()),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Volver'),
                  ),
                ),
              ],
            ),
          ],
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
        return 'Ejercicio';
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

  String _getExerciseInstructions(dynamic type) {
    switch (type.toString().split('.').last) {
      case 'multipleChoice':
        return 'Selecciona la respuesta correcta de las opciones disponibles.';
      case 'dragAndDrop':
        return 'Arrastra los elementos a sus posiciones correctas.';
      case 'fillInTheBlank':
        return 'Completa los espacios en blanco con la respuesta correcta.';
      case 'trueFalse':
        return 'Indica si la afirmación es verdadera o falsa.';
      case 'matching':
        return 'Empareja los elementos de la columna izquierda con los de la derecha.';
      case 'ordering':
        return 'Ordena los elementos en la secuencia correcta.';
      default:
        return 'Lee cuidadosamente y responde según las instrucciones.';
    }
  }

  Future<void> _submitAnswer(BuildContext context, dynamic exercise, GameProvider gameProvider, dynamic user) async {
    if (_userAnswer?.isEmpty == true) return;

    setState(() {
      _isAnswerSubmitted = true;
    });

    // Procesar la respuesta
    final isCorrect = await gameProvider.processAnswer(_userAnswer!, user);
    
    setState(() {
      _isCorrect = isCorrect;
      _feedbackMessage = isCorrect 
          ? '¡Excelente trabajo! Has respondido correctamente.'
          : 'No es correcto. La respuesta correcta es: ${exercise.content['correctAnswer'] ?? 'No disponible'}';
    });
  }

  Future<void> _loadNextExercise(BuildContext context, GameProvider gameProvider, dynamic user) async {
    setState(() {
      _isAnswerSubmitted = false;
      _userAnswer = null;
      _isCorrect = false;
      _feedbackMessage = null;
    });

    await gameProvider.getNextExercise(user, widget.subject);
  }
}
