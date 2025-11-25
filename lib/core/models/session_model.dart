import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo para una sesión de aprendizaje
class SessionModel {
  final String id;
  final String category; // 'communication' o 'mathematics'
  final String title;
  final int order; // 1-4
  final int totalStories;
  final int completedStories;
  final bool unlocked;
  final bool completed;
  final DateTime? lastAccessedAt;

  SessionModel({
    required this.id,
    required this.category,
    required this.title,
    required this.order,
    this.totalStories = 7,
    this.completedStories = 0,
    this.unlocked = false,
    this.completed = false,
    this.lastAccessedAt,
  });

  double get progress => totalStories > 0 ? (completedStories / totalStories) * 100 : 0;

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'title': title,
      'order': order,
      'totalStories': totalStories,
      'completedStories': completedStories,
      'unlocked': unlocked,
      'completed': completed,
      'lastAccessedAt': lastAccessedAt != null ? Timestamp.fromDate(lastAccessedAt!) : null,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map, String id) {
    return SessionModel(
      id: id,
      category: map['category'] ?? '',
      title: map['title'] ?? '',
      order: map['order'] ?? 0,
      totalStories: map['totalStories'] ?? 7,
      completedStories: map['completedStories'] ?? 0,
      unlocked: map['unlocked'] ?? false,
      completed: map['completed'] ?? false,
      lastAccessedAt: map['lastAccessedAt'] != null
          ? (map['lastAccessedAt'] as Timestamp).toDate()
          : null,
    );
  }

  SessionModel copyWith({
    String? id,
    String? category,
    String? title,
    int? order,
    int? totalStories,
    int? completedStories,
    bool? unlocked,
    bool? completed,
    DateTime? lastAccessedAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      order: order ?? this.order,
      totalStories: totalStories ?? this.totalStories,
      completedStories: completedStories ?? this.completedStories,
      unlocked: unlocked ?? this.unlocked,
      completed: completed ?? this.completed,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }
}
