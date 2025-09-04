import 'package:flutter/material.dart';
import '../models/math_exercise_model.dart';
import '../services/math_exercise_service.dart';

class MathExerciseProvider extends ChangeNotifier {
  final MathExerciseService _service = MathExerciseService();
  
  List<MathExercise> _exercises = [];
  MathExercise? _currentExercise;
  List<MathExercise> _completedExercises = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentScore = 0;
  int _totalScore = 0;
  int _correctAnswers = 0;
  int _totalAttempts = 0;

  // Getters
  List<MathExercise> get exercises => _exercises;
  MathExercise? get currentExercise => _currentExercise;
  List<MathExercise> get completedExercises => _completedExercises;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentScore => _currentScore;
  int get totalScore => _totalScore;
  int get correctAnswers => _correctAnswers;
  int get totalAttempts => _totalAttempts;
  bool get hasCurrentExercise => _currentExercise != null;
  double get accuracyRate => _totalAttempts > 0 ? _correctAnswers / _totalAttempts : 0.0;

  // Cargar todos los ejercicios de matemáticas
  Future<void> loadAllMathExercises() async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getAllMathExercises();
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios: $e');
      _setLoading(false);
    }
  }

  // Cargar ejercicios por tipo
  Future<void> loadMathExercisesByType(MathExerciseType type) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getMathExercisesByType(type);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios por tipo: $e');
      _setLoading(false);
    }
  }

  // Cargar ejercicios por nivel
  Future<void> loadMathExercisesByLevel(int level) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getMathExercisesByLevel(level);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios por nivel: $e');
      _setLoading(false);
    }
  }

  // Cargar ejercicios por tipo y nivel
  Future<void> loadMathExercisesByTypeAndLevel(MathExerciseType type, int level) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getMathExercisesByTypeAndLevel(type, level);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios por tipo y nivel: $e');
      _setLoading(false);
    }
  }

  // Cargar ejercicios específicos por tipo
  Future<void> loadAdditionExercises({int? level}) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getAdditionExercises(level: level);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios de suma: $e');
      _setLoading(false);
    }
  }

  Future<void> loadSubtractionExercises({int? level}) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getSubtractionExercises(level: level);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios de resta: $e');
      _setLoading(false);
    }
  }

  Future<void> loadMultiplicationExercises({int? level}) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getMultiplicationExercises(level: level);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios de multiplicación: $e');
      _setLoading(false);
    }
  }

  Future<void> loadCountingExercises({int? level}) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getCountingExercises(level: level);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios de conteo: $e');
      _setLoading(false);
    }
  }

  // Iniciar un ejercicio específico
  Future<void> startExercise(String exerciseId) async {
    try {
      _setLoading(true);
      _clearError();
      
      final exercise = await _service.getMathExerciseById(exerciseId);
      if (exercise != null) {
        _currentExercise = exercise;
        _setLoading(false);
      } else {
        _setError('No se encontró el ejercicio');
        _setLoading(false);
      }
    } catch (e) {
      _setError('Error al iniciar ejercicio: $e');
      _setLoading(false);
    }
  }

  // Obtener un ejercicio aleatorio del tipo actual
  Future<void> getRandomExercise({
    MathExerciseType? type,
    int? level,
  }) async {
    try {
      _setLoading(true);
      _clearError();
      
      final exercises = await _service.getRandomMathExercises(
        limit: 1,
        type: type,
        level: level,
      );
      
      if (exercises.isNotEmpty) {
        _currentExercise = exercises.first;
      } else {
        _setError('No se encontraron ejercicios disponibles');
      }
      
      _setLoading(false);
    } catch (e) {
      _setError('Error al obtener ejercicio aleatorio: $e');
      _setLoading(false);
    }
  }

  // Verificar respuesta del ejercicio actual
  bool checkAnswer(String selectedAnswer) {
    if (_currentExercise == null) return false;
    
    final isCorrect = _service.checkAnswer(_currentExercise!, selectedAnswer);
    _totalAttempts++;
    
    if (isCorrect) {
      _correctAnswers++;
      _currentScore += _currentExercise!.score;
      _totalScore += _currentExercise!.score;
    }
    
    notifyListeners();
    return isCorrect;
  }

  // Completar el ejercicio actual
  void completeCurrentExercise() {
    if (_currentExercise != null) {
      _completedExercises.add(_currentExercise!);
      _currentExercise = null;
      notifyListeners();
    }
  }

  // Reiniciar estadísticas de la sesión
  void resetSessionStats() {
    _currentScore = 0;
    _correctAnswers = 0;
    _totalAttempts = 0;
    _completedExercises.clear();
    notifyListeners();
  }

  // Obtener ejercicios por rango de puntaje
  Future<void> loadExercisesByScoreRange(int minScore, int maxScore) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getMathExercisesByScoreRange(minScore, maxScore);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios por rango de puntaje: $e');
      _setLoading(false);
    }
  }

  // Crear un nuevo ejercicio
  Future<void> createMathExercise(MathExercise exercise) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _service.createMathExercise(exercise);
      await loadAllMathExercises(); // Recargar la lista
      _setLoading(false);
    } catch (e) {
      _setError('Error al crear ejercicio: $e');
      _setLoading(false);
    }
  }

  // Actualizar un ejercicio existente
  Future<void> updateMathExercise(String id, MathExercise exercise) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _service.updateMathExercise(id, exercise);
      await loadAllMathExercises(); // Recargar la lista
      _setLoading(false);
    } catch (e) {
      _setError('Error al actualizar ejercicio: $e');
      _setLoading(false);
    }
  }

  // Eliminar un ejercicio
  Future<void> deleteMathExercise(String id) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _service.deleteMathExercise(id);
      await loadAllMathExercises(); // Recargar la lista
      _setLoading(false);
    } catch (e) {
      _setError('Error al eliminar ejercicio: $e');
      _setLoading(false);
    }
  }

  // Obtener opciones del ejercicio actual
  List<MathOption> getCurrentOptions() {
    return _currentExercise?.options ?? [];
  }

  // Verificar si el ejercicio actual tiene imagen
  bool get hasCurrentExerciseImage => _currentExercise?.hasImage ?? false;

  // Verificar si el ejercicio actual tiene pista
  bool get hasCurrentExerciseHint => _currentExercise?.hasHint ?? false;

  // Verificar si el ejercicio actual tiene solución
  bool get hasCurrentExerciseSolution => _currentExercise?.hasSolution ?? false;

  // Obtener el tipo de ejercicio actual
  MathExerciseType? get currentExerciseType => _currentExercise?.type;

  // Obtener el nivel del ejercicio actual
  int get currentExerciseLevel => _currentExercise?.level ?? 1;

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
}
