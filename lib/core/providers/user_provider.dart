import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getters de utilidad
  int get currentLevel => _currentUser?.currentLevel ?? 1;
  int get totalPoints => _currentUser?.totalPoints ?? 0;
  int get experiencePoints => _currentUser?.experiencePoints ?? 0;
  double get levelProgress => _currentUser?.levelProgress ?? 0.0;
  bool get canLevelUp => _currentUser?.canLevelUp ?? false;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> loadUserData(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data()!, userId);
      } else {
        _setError('Usuario no encontrado');
      }
    } catch (e) {
      _setError('Error al cargar datos del usuario: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile({
    String? name,
    int? age,
    String? grade,
    String? avatar,
  }) async {
    if (_currentUser == null) return;

    try {
      _setLoading(true);
      _clearError();

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (age != null) updates['age'] = age;
      if (grade != null) updates['grade'] = grade;
      if (avatar != null) updates['avatar'] = avatar;

      await _firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update(updates);

      // Actualizar modelo local
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        age: age ?? _currentUser!.age,
        grade: grade ?? _currentUser!.grade,
        avatar: avatar ?? _currentUser!.avatar,
      );

      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar perfil: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addExperience(int points, {String? subject}) async {
    if (_currentUser == null) return;

    try {
      _setLoading(true);
      _clearError();

      // Calcular nuevo estado del usuario
      final updatedUser = _currentUser!.addExperience(points);
      
      // Actualizar en Firestore
      final updates = <String, dynamic>{
        'totalPoints': updatedUser.totalPoints,
        'currentLevel': updatedUser.currentLevel,
        'experiencePoints': updatedUser.experiencePoints,
      };

      // Si se especifica una materia, actualizar su nivel
      if (subject != null) {
        final currentSubjectLevel = updatedUser.getSubjectLevel(subject);
        updates['subjectLevels.$subject'] = currentSubjectLevel;
      }

      await _firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update(updates);

      // Actualizar modelo local
      _currentUser = updatedUser;
      notifyListeners();

      // Verificar si subió de nivel
      if (updatedUser.currentLevel > currentLevel) {
        _showLevelUpNotification(updatedUser.currentLevel);
      }
    } catch (e) {
      _setError('Error al agregar experiencia: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> unlockAchievement(String achievementId) async {
    if (_currentUser == null) return;

    try {
      if (!_currentUser!.achievements.contains(achievementId)) {
        final updatedAchievements = List<String>.from(_currentUser!.achievements)
          ..add(achievementId);

        await _firestore
            .collection('users')
            .doc(_currentUser!.id)
            .update({
          'achievements': updatedAchievements,
        });

        _currentUser = _currentUser!.copyWith(
          achievements: updatedAchievements,
        );

        notifyListeners();
        _showAchievementNotification(achievementId);
      }
    } catch (e) {
      _setError('Error al desbloquear logro: $e');
    }
  }

  Future<void> unlockAvatar(String avatarId) async {
    if (_currentUser == null) return;

    try {
      if (!_currentUser!.unlockedAvatars.contains(avatarId)) {
        final updatedAvatars = List<String>.from(_currentUser!.unlockedAvatars)
          ..add(avatarId);

        await _firestore
            .collection('users')
            .doc(_currentUser!.id)
            .update({
          'unlockedAvatars': updatedAvatars,
        });

        _currentUser = _currentUser!.copyWith(
          unlockedAvatars: updatedAvatars,
        );

        notifyListeners();
      }
    } catch (e) {
      _setError('Error al desbloquear avatar: $e');
    }
  }

  Future<void> updateSubjectLevel(String subject, int newLevel) async {
    if (_currentUser == null) return;

    try {
      final updatedSubjectLevels = Map<String, int>.from(_currentUser!.subjectLevels);
      updatedSubjectLevels[subject] = newLevel;

      await _firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update({
        'subjectLevels.$subject': newLevel,
      });

      _currentUser = _currentUser!.copyWith(
        subjectLevels: updatedSubjectLevels,
      );

      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar nivel de materia: $e');
    }
  }

  Future<void> updateProgress(String subject, Map<String, dynamic> progress) async {
    if (_currentUser == null) return;

    try {
      final updatedProgress = Map<String, dynamic>.from(_currentUser!.progress);
      updatedProgress[subject] = progress;

      await _firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update({
        'progress.$subject': progress,
      });

      _currentUser = _currentUser!.copyWith(
        progress: updatedProgress,
      );

      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar progreso: $e');
    }
  }

  void _showLevelUpNotification(int newLevel) {
    // Aquí se puede implementar una notificación visual
    // Por ahora solo imprimimos en consola
    print('¡Felicitaciones! Has subido al nivel $newLevel');
  }

  void _showAchievementNotification(String achievementId) {
    // Aquí se puede implementar una notificación visual
    print('¡Logro desbloqueado: $achievementId');
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

  // Métodos para obtener estadísticas
  Map<String, int> getSubjectLevels() {
    return _currentUser?.subjectLevels ?? {};
  }

  List<String> getAchievements() {
    return _currentUser?.achievements ?? [];
  }

  List<String> getUnlockedAvatars() {
    return _currentUser?.unlockedAvatars ?? [];
  }

  Map<String, dynamic> getProgress(String subject) {
    return _currentUser?.progress[subject] ?? {};
  }

  // Método para calcular el progreso general
  double getOverallProgress() {
    if (_currentUser == null) return 0.0;
    
    final subjectLevels = _currentUser!.subjectLevels.values;
    if (subjectLevels.isEmpty) return 0.0;
    
    final averageLevel = subjectLevels.reduce((a, b) => a + b) / subjectLevels.length;
    // Asumimos que el nivel máximo es 10
    return (averageLevel / 10.0).clamp(0.0, 1.0);
  }
}
