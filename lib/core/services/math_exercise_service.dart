import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/math_exercise_model.dart';

class MathExerciseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'math_exercises';

  // Obtener todos los ejercicios de matemáticas
  Future<List<MathExercise>> getAllMathExercises() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios de matemáticas: $e');
    }
  }

  // Obtener un ejercicio específico por ID
  Future<MathExercise?> getMathExerciseById(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error al cargar ejercicio de matemáticas: $e');
    }
  }

  // Obtener ejercicios por tipo
  Future<List<MathExercise>> getMathExercisesByType(MathExerciseType type) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('tipo', isEqualTo: type.toString().split('.').last)
          .get();
      
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios por tipo: $e');
    }
  }

  // Obtener ejercicios por nivel
  Future<List<MathExercise>> getMathExercisesByLevel(int level) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('nivel', isEqualTo: level)
          .get();
      
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios por nivel: $e');
    }
  }

  // Obtener ejercicios por tipo y nivel
  Future<List<MathExercise>> getMathExercisesByTypeAndLevel(
    MathExerciseType type, 
    int level
  ) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('tipo', isEqualTo: type.toString().split('.').last)
          .where('nivel', isEqualTo: level)
          .get();
      
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios por tipo y nivel: $e');
    }
  }

  // Obtener ejercicios de suma
  Future<List<MathExercise>> getAdditionExercises({int? level}) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('tipo', isEqualTo: 'addition');
      
      if (level != null) {
        query = query.where('nivel', isEqualTo: level);
      }
      
      final QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios de suma: $e');
    }
  }

  // Obtener ejercicios de resta
  Future<List<MathExercise>> getSubtractionExercises({int? level}) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('tipo', isEqualTo: 'subtraction');
      
      if (level != null) {
        query = query.where('nivel', isEqualTo: level);
      }
      
      final QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios de resta: $e');
    }
  }

  // Obtener ejercicios de multiplicación
  Future<List<MathExercise>> getMultiplicationExercises({int? level}) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('tipo', isEqualTo: 'multiplication');
      
      if (level != null) {
        query = query.where('nivel', isEqualTo: level);
      }
      
      final QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios de multiplicación: $e');
    }
  }

  // Obtener ejercicios de conteo
  Future<List<MathExercise>> getCountingExercises({int? level}) async {
    try {
      Query query = _firestore
          .collection(_collection)
          .where('tipo', isEqualTo: 'counting');
      
      if (level != null) {
        query = query.where('nivel', isEqualTo: level);
      }
      
      final QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios de conteo: $e');
    }
  }

  // Crear un nuevo ejercicio de matemáticas
  Future<String> createMathExercise(MathExercise exercise) async {
    try {
      final DocumentReference docRef = await _firestore
          .collection(_collection)
          .add(exercise.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Error al crear ejercicio de matemáticas: $e');
    }
  }

  // Actualizar un ejercicio existente
  Future<void> updateMathExercise(String id, MathExercise exercise) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(id)
          .update(exercise.toMap());
    } catch (e) {
      throw Exception('Error al actualizar ejercicio de matemáticas: $e');
    }
  }

  // Eliminar un ejercicio
  Future<void> deleteMathExercise(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Error al eliminar ejercicio de matemáticas: $e');
    }
  }

  // Obtener ejercicios aleatorios para práctica
  Future<List<MathExercise>> getRandomMathExercises({
    int limit = 5,
    MathExerciseType? type,
    int? level,
  }) async {
    try {
      Query query = _firestore.collection(_collection);
      
      if (type != null) {
        query = query.where('tipo', isEqualTo: type.toString().split('.').last);
      }
      
      if (level != null) {
        query = query.where('nivel', isEqualTo: level);
      }
      
      final QuerySnapshot snapshot = await query.limit(limit).get();
      final exercises = snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      
      exercises.shuffle();
      return exercises;
    } catch (e) {
      throw Exception('Error al cargar ejercicios aleatorios: $e');
    }
  }

  // Verificar respuesta correcta
  bool checkAnswer(MathExercise exercise, String selectedAnswer) {
    final correctOption = exercise.correctOption;
    return correctOption?.text == selectedAnswer;
  }

  // Obtener ejercicios por rango de puntaje
  Future<List<MathExercise>> getMathExercisesByScoreRange(int minScore, int maxScore) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('puntaje', isGreaterThanOrEqualTo: minScore)
          .where('puntaje', isLessThanOrEqualTo: maxScore)
          .get();
      
      return snapshot.docs.map((doc) {
        return MathExercise.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error al cargar ejercicios por rango de puntaje: $e');
    }
  }
}
