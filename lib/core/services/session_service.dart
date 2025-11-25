import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';
import '../models/story_progress_model.dart';

/// Servicio para gestionar sesiones de aprendizaje
class SessionService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Inicializar sesiones para un usuario nuevo
  Future<void> initializeUserSessions(String userId) async {
    try {
      final sessionsRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions');

      // Verificar si ya existen sesiones
      final existing = await sessionsRef.limit(1).get();
      if (existing.docs.isNotEmpty) return;

      // Crear sesiones de Comunicación
      final commSessions = [
        SessionModel(
          id: 'comm_session_01',
          category: 'communication',
          title: 'Palabras con Magia',
          order: 1,
          unlocked: true, // Primera sesión desbloqueada
        ),
        SessionModel(
          id: 'comm_session_02',
          category: 'communication',
          title: 'Cuentos Encantados',
          order: 2,
        ),
        SessionModel(
          id: 'comm_session_03',
          category: 'communication',
          title: 'Aventuras de Lectura',
          order: 3,
        ),
        SessionModel(
          id: 'comm_session_04',
          category: 'communication',
          title: 'Maestro de Palabras',
          order: 4,
        ),
      ];

      // Crear sesiones de Matemáticas
      final mathSessions = [
        SessionModel(
          id: 'math_session_01',
          category: 'mathematics',
          title: 'Números Divertidos',
          order: 1,
          unlocked: true, // Primera sesión desbloqueada
        ),
        SessionModel(
          id: 'math_session_02',
          category: 'mathematics',
          title: 'Sumas Mágicas',
          order: 2,
        ),
        SessionModel(
          id: 'math_session_03',
          category: 'mathematics',
          title: 'Restas Aventureras',
          order: 3,
        ),
        SessionModel(
          id: 'math_session_04',
          category: 'mathematics',
          title: 'Genio Matemático',
          order: 4,
        ),
      ];

      // Guardar todas las sesiones
      final batch = _firestore.batch();
      for (var session in [...commSessions, ...mathSessions]) {
        batch.set(sessionsRef.doc(session.id), session.toMap());
      }
      await batch.commit();

      // Inicializar cuentos para la primera sesión de cada categoría
      await _initializeSessionStories(userId, 'comm_session_01');
      await _initializeSessionStories(userId, 'math_session_01');
    } catch (e) {
      debugPrint('Error initializing sessions: $e');
    }
  }

  /// Inicializar cuentos para una sesión
  Future<void> _initializeSessionStories(String userId, String sessionId) async {
    try {
      final storiesRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .collection('stories');

      final category = sessionId.startsWith('comm') ? 'C' : 'M';
      final stories = List.generate(7, (index) {
        return StoryProgressModel(
          id: '$category${(index + 1).toString().padLeft(2, '0')}',
          sessionId: sessionId,
          title: 'Cuento ${index + 1}',
          order: index + 1,
        );
      });

      final batch = _firestore.batch();
      for (var story in stories) {
        batch.set(storiesRef.doc(story.id), story.toMap());
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Error initializing stories: $e');
    }
  }

  /// Obtener sesiones de una categoría
  Future<List<SessionModel>> getSessions(String userId, String category) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .where('category', isEqualTo: category)
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => SessionModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error getting sessions: $e');
      return [];
    }
  }

  /// Obtener cuentos de una sesión
  Future<List<StoryProgressModel>> getSessionStories(
    String userId,
    String sessionId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .collection('stories')
          .orderBy('order')
          .get();

      return snapshot.docs
          .map((doc) => StoryProgressModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('Error getting stories: $e');
      return [];
    }
  }

  /// Marcar cuento como completado
  Future<void> markStoryCompleted(
    String userId,
    String sessionId,
    String storyId,
  ) async {
    try {
      final storyRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .collection('stories')
          .doc(storyId);

      await storyRef.update({
        'completed': true,
        'stepsCompleted': FieldValue.increment(0),
        'lastAttemptAt': FieldValue.serverTimestamp(),
      });

      // Actualizar progreso de la sesión
      await _updateSessionProgress(userId, sessionId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking story completed: $e');
    }
  }

  /// Actualizar progreso de sesión
  Future<void> _updateSessionProgress(String userId, String sessionId) async {
    try {
      final stories = await getSessionStories(userId, sessionId);
      final completedCount = stories.where((s) => s.completed).length;
      final allCompleted = completedCount == stories.length;

      final sessionRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId);

      await sessionRef.update({
        'completedStories': completedCount,
        'completed': allCompleted,
        'lastAccessedAt': FieldValue.serverTimestamp(),
      });

      // Si completó la sesión, desbloquear la siguiente
      if (allCompleted) {
        await _unlockNextSession(userId, sessionId);
      }
    } catch (e) {
      debugPrint('Error updating session progress: $e');
    }
  }

  /// Desbloquear siguiente sesión
  Future<void> _unlockNextSession(String userId, String sessionId) async {
    try {
      final currentSession = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionId)
          .get();

      if (!currentSession.exists) return;

      final data = currentSession.data()!;
      final category = data['category'];
      final currentOrder = data['order'];
      final nextOrder = currentOrder + 1;

      // Buscar la siguiente sesión
      final nextSessions = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .where('category', isEqualTo: category)
          .where('order', isEqualTo: nextOrder)
          .limit(1)
          .get();

      if (nextSessions.docs.isNotEmpty) {
        final nextSessionId = nextSessions.docs.first.id;
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('sessions')
            .doc(nextSessionId)
            .update({'unlocked': true});

        // Inicializar cuentos de la siguiente sesión
        await _initializeSessionStories(userId, nextSessionId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error unlocking next session: $e');
    }
  }
}
