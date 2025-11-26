import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class ProgressService extends ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  
  // Cache of completed stories for the current session/user
  Set<String> _completedStoryIds = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Load progress for a specific user and subject
  Future<void> loadProgress(String userId, String subjectId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Usamos la estructura definida en UserService: users/$userId/progress/$subjectId/completedStories
      final snapshot = await _dbRef.child('users/$userId/progress/$subjectId/completedStories').get();

      _completedStoryIds = {};
      
      if (snapshot.exists && snapshot.value != null) {
        final data = snapshot.value;
        if (data is List) {
          // Si es una lista de strings (como lo maneja UserService)
          for (var item in data) {
            _completedStoryIds.add(item.toString());
          }
        } else if (data is Map) {
          // Fallback por si acaso se guardó como mapa
          data.forEach((key, value) {
             _completedStoryIds.add(key.toString());
          });
        }
      }
      
      debugPrint('Loaded progress for user $userId, subject $subjectId: ${_completedStoryIds.length} stories');
    } catch (e) {
      debugPrint('Error loading progress: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isStoryCompleted(String storyId) {
    return _completedStoryIds.contains(storyId);
  }

  bool isStoryUnlocked(String storyId, String? previousStoryId) {
    if (previousStoryId == null) return true;
    return isStoryCompleted(previousStoryId);
  }

  Future<void> markStoryCompleted(String userId, String subjectId, String storyId) async {
    if (_completedStoryIds.contains(storyId)) return;

    try {
      // Actualizamos localmente primero
      _completedStoryIds.add(storyId);
      notifyListeners();

      // Obtenemos la lista actual para agregar el nuevo ID
      final snapshot = await _dbRef.child('users/$userId/progress/$subjectId/completedStories').get();
      List<String> currentList = [];
      if (snapshot.exists && snapshot.value is List) {
        currentList = List<String>.from(snapshot.value as List);
      }
      
      if (!currentList.contains(storyId)) {
        currentList.add(storyId);
        await _dbRef.child('users/$userId/progress/$subjectId/completedStories').set(currentList);
        
        // También actualizamos highestUnlockedIndex si es necesario (lógica simplificada aquí, 
        // UserService tiene una lógica más completa en unlockNextStory, idealmente deberíamos usar esa)
      }

    } catch (e) {
      debugPrint('Error marking story completed: $e');
      // Revertir localmente si falla?
      rethrow;
    }
  }
}
