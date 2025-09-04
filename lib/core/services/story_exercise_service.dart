import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_exercise_model.dart';

class StoryExerciseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'story_exercises';

  // Obtener todos los ejercicios de cuentos
  Future<List<StoryExercise>> getAllStoryExercises() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        return StoryExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios de cuentos: $e');
    }
  }

  // Obtener un ejercicio específico por ID
  Future<StoryExercise?> getStoryExerciseById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return StoryExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error al cargar ejercicio de cuento: $e');
    }
  }

  // Obtener ejercicios por nivel de dificultad
  Future<List<StoryExercise>> getStoryExercisesByLevel(int level) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('nivel', isEqualTo: level)
          .get();
      
      return snapshot.docs.map((doc) {
        return StoryExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios por nivel: $e');
    }
  }

  // Obtener ejercicios finales (con puntaje)
  Future<List<StoryExercise>> getFinalStoryExercises() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('final', isEqualTo: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return StoryExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios finales: $e');
    }
  }

  // Obtener ejercicios por título de cuento
  Future<List<StoryExercise>> getStoryExercisesByTitle(String storyTitle) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('titulo_cuento', isEqualTo: storyTitle)
          .get();
      
      return snapshot.docs.map((doc) {
        return StoryExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios por título: $e');
    }
  }

  // Crear un nuevo ejercicio de cuento
  Future<String> createStoryExercise(StoryExercise exercise) async {
    try {
      final DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(exercise.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear ejercicio de cuento: $e');
    }
  }

  // Actualizar un ejercicio existente
  Future<void> updateStoryExercise(String id, StoryExercise exercise) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update(exercise.toMap());
    } catch (e) {
      throw Exception('Error al actualizar ejercicio de cuento: $e');
    }
  }

  // Eliminar un ejercicio
  Future<void> deleteStoryExercise(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar ejercicio de cuento: $e');
    }
  }

  // Obtener la siguiente parte de la historia
  Future<StoryExercise?> getNextStoryPart(String subStoryId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(subStoryId)
          .get();
      
      if (doc.exists) {
        return StoryExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error al cargar siguiente parte de la historia: $e');
    }
  }

  // Obtener ejercicios aleatorios para práctica
  Future<List<StoryExercise>> getRandomStoryExercises({int limit = 5}) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .limit(limit)
          .get();
      
      final exercises = snapshot.docs.map((doc) {
        return StoryExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      
      exercises.shuffle();
      return exercises;
    } catch (e) {
      throw Exception('Error al cargar ejercicios aleatorios: $e');
    }
  }
}
