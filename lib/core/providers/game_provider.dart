import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_model.dart';
import '../models/user_model.dart';

class GameProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ExerciseModel> _availableExercises = [];
  ExerciseModel? _currentExercise;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentScore = 0;
  int _streak = 0;
  bool _isGameActive = false;

  // Getters
  List<ExerciseModel> get availableExercises => _availableExercises;
  ExerciseModel? get currentExercise => _currentExercise;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentScore => _currentScore;
  int get streak => _streak;
  bool get isGameActive => _isGameActive;

  // Inicializar el provider
  Future<void> initialize() async {
    await loadExercises();
  }

  // Cargar ejercicios disponibles
  Future<void> loadExercises() async {
    try {
      _setLoading(true);
      _clearError();

      final querySnapshot = await _firestore
          .collection('exercises')
          .where('isActive', isEqualTo: true)
          .orderBy('level')
          .get();

      _availableExercises = querySnapshot.docs
          .map((doc) => ExerciseModel.fromMap(doc.data(), doc.id))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Error al cargar ejercicios: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Iniciar un nuevo juego
  void startGame() {
    _currentScore = 0;
    _streak = 0;
    _isGameActive = true;
    notifyListeners();
  }

  // Finalizar el juego
  void endGame() {
    _isGameActive = false;
    _currentExercise = null;
    notifyListeners();
  }

  // Obtener siguiente ejercicio basado en IA
  Future<ExerciseModel?> getNextExercise(UserModel user, String subject) async {
    try {
      final userLevel = user.getSubjectLevel(subject);
      final userDifficulty = _calculateUserDifficulty(user, subject);
      
      // Filtrar ejercicios por materia y nivel apropiado
      final suitableExercises = _availableExercises
          .where((exercise) => 
              exercise.subject.toString().split('.').last == subject &&
              exercise.isActive &&
              _isExerciseSuitable(exercise, userLevel, userDifficulty))
          .toList();

      if (suitableExercises.isEmpty) {
        return null;
      }

      // Usar algoritmo de IA para seleccionar el mejor ejercicio
      final selectedExercise = _selectBestExercise(suitableExercises, user, subject);
      
      _currentExercise = selectedExercise;
      notifyListeners();
      
      return selectedExercise;
    } catch (e) {
      _setError('Error al obtener ejercicio: $e');
      return null;
    }
  }

  // Calcular dificultad del usuario basada en su rendimiento
  Difficulty _calculateUserDifficulty(UserModel user, String subject) {
    final userLevel = user.getSubjectLevel(subject);
    final progress = user.progress[subject] ?? {};
    
    // Analizar historial de respuestas correctas
    final correctAnswers = progress['correctAnswers'] ?? 0;
    final totalAnswers = progress['totalAnswers'] ?? 1;
    final accuracy = correctAnswers / totalAnswers;
    
    // Analizar streak actual
    final currentStreak = progress['currentStreak'] ?? 0;
    
    // Calcular dificultad basada en precisión y streak
    if (accuracy > 0.8 && currentStreak > 3) {
      return Difficulty.advanced;
    } else if (accuracy > 0.6 && currentStreak > 1) {
      return Difficulty.intermediate;
    } else {
      return Difficulty.beginner;
    }
  }

  // Verificar si un ejercicio es apropiado para el usuario
  bool _isExerciseSuitable(ExerciseModel exercise, int userLevel, Difficulty userDifficulty) {
    // Verificar nivel del ejercicio vs nivel del usuario
    if (exercise.level > userLevel + 2) return false;
    if (exercise.level < userLevel - 3) return false;
    
    // Verificar dificultad
    if (userDifficulty == Difficulty.beginner && exercise.difficulty == Difficulty.advanced) {
      return false;
    }
    
    return true;
  }

  // Seleccionar el mejor ejercicio usando IA
  ExerciseModel _selectBestExercise(
    List<ExerciseModel> suitableExercises, 
    UserModel user, 
    String subject
  ) {
    // Implementar algoritmo de selección inteligente
    // Por ahora, seleccionar aleatoriamente entre los apropiados
    suitableExercises.shuffle();
    
    // Priorizar ejercicios que el usuario no ha hecho recientemente
    final userProgress = user.progress[subject] ?? {};
    final recentExercises = userProgress['recentExercises'] ?? <String>[];
    
    // Filtrar ejercicios no recientes
    final nonRecentExercises = suitableExercises
        .where((exercise) => !recentExercises.contains(exercise.id))
        .toList();
    
    if (nonRecentExercises.isNotEmpty) {
      return nonRecentExercises.first;
    }
    
    // Si todos son recientes, seleccionar uno aleatorio
    return suitableExercises.first;
  }

  // Procesar respuesta del usuario
  Future<bool> processAnswer(String answer, UserModel user) async {
    if (_currentExercise == null) return false;

    try {
      final isCorrect = _checkAnswer(answer);
      
      // Actualizar puntuación y streak
      if (isCorrect) {
        _currentScore += _currentExercise!.getAdjustedPoints(user.currentLevel);
        _streak++;
        
        // Bonus por streak
        if (_streak >= 3) {
          _currentScore += 5; // Bonus por racha
        }
      } else {
        _streak = 0;
      }

      // Actualizar progreso del usuario
      await _updateUserProgress(user, isCorrect);
      
      // Actualizar historial de ejercicios recientes
      await _updateRecentExercises(user);
      
      notifyListeners();
      return isCorrect;
    } catch (e) {
      _setError('Error al procesar respuesta: $e');
      return false;
    }
  }

  // Verificar si la respuesta es correcta
  bool _checkAnswer(String userAnswer) {
    if (_currentExercise == null) return false;
    
    final correctAnswer = _currentExercise!.content['correctAnswer'];
    if (correctAnswer == null) return false;
    
    // Comparar respuestas (case-insensitive)
    return userAnswer.toLowerCase().trim() == correctAnswer.toString().toLowerCase().trim();
  }

  // Actualizar progreso del usuario
  Future<void> _updateUserProgress(UserModel user, bool isCorrect) async {
    try {
      final subject = _currentExercise!.subject.toString().split('.').last;
      final progress = user.progress[subject] ?? {};
      
      final updatedProgress = Map<String, dynamic>.from(progress);
      updatedProgress['totalAnswers'] = (updatedProgress['totalAnswers'] ?? 0) + 1;
      
      if (isCorrect) {
        updatedProgress['correctAnswers'] = (updatedProgress['correctAnswers'] ?? 0) + 1;
        updatedProgress['currentStreak'] = (updatedProgress['currentStreak'] ?? 0) + 1;
      } else {
        updatedProgress['currentStreak'] = 0;
      }
      
      // Calcular precisión
      final accuracy = updatedProgress['correctAnswers'] / updatedProgress['totalAnswers'];
      updatedProgress['accuracy'] = accuracy;
      
      // Actualizar en Firestore
      await _firestore
          .collection('users')
          .doc(user.id)
          .update({
        'progress.$subject': updatedProgress,
      });
      
    } catch (e) {
      print('Error al actualizar progreso: $e');
    }
  }

  // Actualizar ejercicios recientes
  Future<void> _updateRecentExercises(UserModel user) async {
    try {
      final subject = _currentExercise!.subject.toString().split('.').last;
      final progress = user.progress[subject] ?? {};
      final recentExercises = List<String>.from(progress['recentExercises'] ?? []);
      
      // Agregar ejercicio actual al inicio
      recentExercises.insert(0, _currentExercise!.id);
      
      // Mantener solo los últimos 10 ejercicios
      if (recentExercises.length > 10) {
        recentExercises.removeRange(10, recentExercises.length);
      }
      
      // Actualizar en Firestore
      await _firestore
          .collection('users')
          .doc(user.id)
          .update({
        'progress.$subject.recentExercises': recentExercises,
      });
      
    } catch (e) {
      print('Error al actualizar ejercicios recientes: $e');
    }
  }

  // Obtener ejercicios por materia
  List<ExerciseModel> getExercisesBySubject(String subject) {
    return _availableExercises
        .where((exercise) => 
            exercise.subject.toString().split('.').last == subject)
        .toList();
  }

  // Obtener ejercicios por nivel
  List<ExerciseModel> getExercisesByLevel(int level) {
    return _availableExercises
        .where((exercise) => exercise.level == level)
        .toList();
  }

  // Obtener ejercicios por dificultad
  List<ExerciseModel> getExercisesByDifficulty(Difficulty difficulty) {
    return _availableExercises
        .where((exercise) => exercise.difficulty == difficulty)
        .toList();
  }

  // Reiniciar estado del juego
  void resetGame() {
    _currentScore = 0;
    _streak = 0;
    _isGameActive = false;
    _currentExercise = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // --- MÉTODOS DE PROGRESO DE CUENTOS (NUEVO) ---

  /// Desbloquea el siguiente cuento para una materia
  Future<void> unlockNextStory(String subject, String currentStoryId) async {
    try {
      // 1. Obtener usuario actual
      // Nota: Necesitamos el ID del usuario. En una app real, esto vendría del AuthProvider
      // o se pasaría como argumento. Asumiremos que se pasa o se obtiene de alguna forma.
      // Por ahora, usaremos un método auxiliar para actualizar Firestore directamente
      // si tenemos el ID del usuario en el estado (que no lo tenemos explícitamente aquí,
      // pero asumiremos que se pasa el userId o se obtiene del contexto).
      
      // SOLUCIÓN: Este método debería llamarse desde la UI pasando el userId,
      // o el GameProvider debería tener acceso al UserProvider.
      // Para simplificar, actualizaremos el método para recibir userId.
    } catch (e) {
      _setError('Error al desbloquear siguiente cuento: $e');
    }
  }

  /// Desbloquea el siguiente cuento para una materia
  Future<void> unlockNextStoryForUser(String userId, String subject, int currentStoryIndex) async {
    try {
      // 1. Referencia al documento del usuario
      final userRef = _firestore.collection('users').doc(userId);
      
      // 2. Obtener datos actuales
      final userDoc = await userRef.get();
      if (!userDoc.exists) return;
      
      final userData = userDoc.data()!;
      final progress = Map<String, dynamic>.from(userData['progress'] ?? {});
      final subjectProgress = Map<String, dynamic>.from(progress[subject] ?? {});
      
      // 3. Marcar cuento actual como completado
      List<String> completed = List<String>.from(subjectProgress['completedStories'] ?? []);
      String currentStoryId = "STORY_$currentStoryIndex";
      if (!completed.contains(currentStoryId)) {
        completed.add(currentStoryId);
        subjectProgress['completedStories'] = completed;
      }

      // 4. Calcular nuevo índice desbloqueado
      int currentUnlocked = subjectProgress['highestUnlockedIndex'] ?? 0;
      
      // Si completamos el último desbloqueado, avanzamos
      if (currentStoryIndex == currentUnlocked) {
        int nextIndex = currentUnlocked + 1;
        // Límite de 7 cuentos (índices 0 a 6), así que el máximo unlocked puede ser 7
        if (nextIndex > UserModel.maxStoriesPerModule) {
          nextIndex = UserModel.maxStoriesPerModule; 
        }
        
        subjectProgress['highestUnlockedIndex'] = nextIndex;
      }
      
      progress[subject] = subjectProgress;
      
      // 5. Guardar en Firestore
      await userRef.update({'progress': progress});
      
      // Notificar si es necesario (aunque esto actualiza Firestore, el stream del usuario debería recibir el cambio)
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error unlocking story: $e');
      _setError('Error al guardar progreso: $e');
    }
  }

  /// Verifica si un cuento está desbloqueado (Helper local)
  bool isStoryUnlocked(int storyIndex, int highestUnlockedIndex) {
    return storyIndex <= highestUnlockedIndex;
  }

  // --- STUB PARA IA (NUEVO) ---
  
  /// Genera el contenido del siguiente cuento usando IA
  Future<Map<String, dynamic>?> generateNextStoryWithAI(String subject, int level) async {
    // TODO: Implementar llamada a Gemini API
    // 1. Construir prompt: "Crea un cuento para un niño de nivel $level sobre $subject..."
    // 2. Llamar a Cloud Function o API directa
    // 3. Parsear respuesta JSON
    return null;
  }

  @override
  void dispose() {
    _availableExercises.clear();
    super.dispose();
  }
}
