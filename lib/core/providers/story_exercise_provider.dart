import 'package:flutter/material.dart';
import '../models/story_exercise_model.dart';
import '../services/story_exercise_service.dart';

class StoryExerciseProvider extends ChangeNotifier {
  final StoryExerciseService _service = StoryExerciseService();
  
  List<StoryExercise> _exercises = [];
  StoryExercise? _currentExercise;
  List<StoryExercise> _storyPath = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentScore = 0;
  int _totalScore = 0;

  // Getters
  List<StoryExercise> get exercises => _exercises;
  StoryExercise? get currentExercise => _currentExercise;
  List<StoryExercise> get storyPath => _storyPath;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentScore => _currentScore;
  int get totalScore => _totalScore;
  bool get hasCurrentExercise => _currentExercise != null;

  // Cargar todos los ejercicios de cuentos
  Future<void> loadAllStoryExercises() async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getAllStoryExercises();
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios: $e');
      _setLoading(false);
    }
  }

  // Cargar ejercicios por nivel
  Future<void> loadStoryExercisesByLevel(int level) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getStoryExercisesByLevel(level);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios por nivel: $e');
      _setLoading(false);
    }
  }

  // Cargar ejercicios por título de cuento
  Future<void> loadStoryExercisesByTitle(String storyTitle) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getStoryExercisesByTitle(storyTitle);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios por título: $e');
      _setLoading(false);
    }
  }

  // Iniciar un nuevo cuento
  Future<void> startStory(String exerciseId) async {
    try {
      _setLoading(true);
      _clearError();
      
      final exercise = await _service.getStoryExerciseById(exerciseId);
      if (exercise != null) {
        _currentExercise = exercise;
        _storyPath = [exercise];
        _currentScore = 0;
        _totalScore = 0;
        _setLoading(false);
      } else {
        _setError('No se encontró el ejercicio');
        _setLoading(false);
      }
    } catch (e) {
      _setError('Error al iniciar cuento: $e');
      _setLoading(false);
    }
  }

  // Continuar con la siguiente parte de la historia
  Future<void> continueStory(String optionKey) async {
    if (_currentExercise == null) return;

    try {
      _setLoading(true);
      _clearError();

      final option = _currentExercise!.options[optionKey];
      if (option?.subStoryId != null) {
        final nextExercise = await _service.getNextStoryPart(option!.subStoryId!);
        if (nextExercise != null) {
          _currentExercise = nextExercise;
          _storyPath.add(nextExercise);
          
          // Sumar puntaje si es un final
          if (nextExercise.isFinal && nextExercise.score != null) {
            _currentScore += nextExercise.score!;
            _totalScore += nextExercise.score!;
          }
          
          _setLoading(false);
        } else {
          _setError('No se encontró la siguiente parte de la historia');
          _setLoading(false);
        }
      } else {
        // Opción sin continuación (final de rama)
        _setLoading(false);
      }
    } catch (e) {
      _setError('Error al continuar historia: $e');
      _setLoading(false);
    }
  }

  // Reiniciar el cuento actual
  void resetCurrentStory() {
    if (_storyPath.isNotEmpty) {
      _currentExercise = _storyPath.first;
      _storyPath = [_storyPath.first];
      _currentScore = 0;
      _totalScore = 0;
      notifyListeners();
    }
  }

  // Finalizar el cuento actual
  void finishCurrentStory() {
    _currentExercise = null;
    _storyPath.clear();
    notifyListeners();
  }

  // Obtener opciones disponibles para el ejercicio actual
  List<MapEntry<String, StoryOption>> getCurrentOptions() {
    if (_currentExercise == null) return [];
    return _currentExercise!.options.entries.toList();
  }

  // Verificar si el ejercicio actual es final
  bool get isCurrentExerciseFinal => _currentExercise?.isFinal ?? false;

  // Verificar si el ejercicio actual tiene opciones de continuación
  bool get hasNextOptions => _currentExercise?.hasNextOptions ?? false;

  // Obtener el progreso del cuento (porcentaje de nodos visitados)
  double get storyProgress {
    if (_storyPath.isEmpty) return 0.0;
    // Esto es una aproximación simple, podrías implementar una lógica más compleja
    return (_storyPath.length / 5.0).clamp(0.0, 1.0); // Asumiendo ~5 nodos por cuento
  }

  // Obtener ejercicios aleatorios para práctica
  Future<void> loadRandomStoryExercises({int limit = 5}) async {
    try {
      _setLoading(true);
      _clearError();
      
      _exercises = await _service.getRandomStoryExercises(limit: limit);
      _setLoading(false);
    } catch (e) {
      _setError('Error al cargar ejercicios aleatorios: $e');
      _setLoading(false);
    }
  }

  // Crear un nuevo ejercicio de cuento
  Future<void> createStoryExercise(StoryExercise exercise) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _service.createStoryExercise(exercise);
      await loadAllStoryExercises(); // Recargar la lista
      _setLoading(false);
    } catch (e) {
      _setError('Error al crear ejercicio: $e');
      _setLoading(false);
    }
  }

  // Actualizar un ejercicio existente
  Future<void> updateStoryExercise(String id, StoryExercise exercise) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _service.updateStoryExercise(id, exercise);
      await loadAllStoryExercises(); // Recargar la lista
      _setLoading(false);
    } catch (e) {
      _setError('Error al actualizar ejercicio: $e');
      _setLoading(false);
    }
  }

  // Eliminar un ejercicio
  Future<void> deleteStoryExercise(String id) async {
    try {
      _setLoading(true);
      _clearError();
      
      await _service.deleteStoryExercise(id);
      await loadAllStoryExercises(); // Recargar la lista
      _setLoading(false);
    } catch (e) {
      _setError('Error al eliminar ejercicio: $e');
      _setLoading(false);
    }
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
}
