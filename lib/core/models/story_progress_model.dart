import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo para el progreso de un cuento individual
class StoryProgressModel {
  final String id;
  final String sessionId;
  final String title;
  final int order; // 1-7
  final int stepsCompleted;
  final int totalSteps;
  final bool completed;
  final DateTime? lastAttemptAt;
  final List<Map<String, dynamic>> responses; // Respuestas del niño

  StoryProgressModel({
    required this.id,
    required this.sessionId,
    required this.title,
    required this.order,
    this.stepsCompleted = 0,
    this.totalSteps = 5,
    this.completed = false,
    this.lastAttemptAt,
    this.responses = const [],
  });

  double get progress => totalSteps > 0 ? (stepsCompleted / totalSteps) * 100 : 0;

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'title': title,
      'order': order,
      'stepsCompleted': stepsCompleted,
      'totalSteps': totalSteps,
      'completed': completed,
      'lastAttemptAt': lastAttemptAt != null ? Timestamp.fromDate(lastAttemptAt!) : null,
      'responses': responses,
    };
  }

  factory StoryProgressModel.fromMap(Map<String, dynamic> map, String id) {
    return StoryProgressModel(
      id: id,
      sessionId: map['sessionId'] ?? '',
      title: map['title'] ?? '',
      order: map['order'] ?? 0,
      stepsCompleted: map['stepsCompleted'] ?? 0,
      totalSteps: map['totalSteps'] ?? 5,
      completed: map['completed'] ?? false,
      lastAttemptAt: map['lastAttemptAt'] != null
          ? (map['lastAttemptAt'] as Timestamp).toDate()
          : null,
      responses: List<Map<String, dynamic>>.from(map['responses'] ?? []),
    );
  }

  StoryProgressModel copyWith({
    String? id,
    String? sessionId,
    String? title,
    int? order,
    int? stepsCompleted,
    int? totalSteps,
    bool? completed,
    DateTime? lastAttemptAt,
    List<Map<String, dynamic>>? responses,
  }) {
    return StoryProgressModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      order: order ?? this.order,
      stepsCompleted: stepsCompleted ?? this.stepsCompleted,
      totalSteps: totalSteps ?? this.totalSteps,
      completed: completed ?? this.completed,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      responses: responses ?? this.responses,
    );
  }

  /// Agregar una respuesta del niño
  StoryProgressModel addResponse(Map<String, dynamic> response) {
    final updatedResponses = List<Map<String, dynamic>>.from(responses)..add(response);
    return copyWith(responses: updatedResponses);
  }
}
