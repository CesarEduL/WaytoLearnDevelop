import 'package:cloud_firestore/cloud_firestore.dart';

enum ExerciseType {
  multipleChoice,
  dragAndDrop,
  fillInTheBlank,
  trueFalse,
  matching,
  ordering,
}

enum Subject {
  mathematics,
  communication,
}

enum Difficulty {
  beginner,
  intermediate,
  advanced,
}

class ExerciseModel {
  final String id;
  final String title;
  final String description;
  final Subject subject;
  final Difficulty difficulty;
  final ExerciseType type;
  final int level;
  final int points;
  final Map<String, dynamic> content;
  final List<String> tags;
  final String? imageUrl;
  final String? audioUrl;
  final Map<String, dynamic>? hints;
  final bool isActive;
  final DateTime createdAt;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.difficulty,
    required this.type,
    required this.level,
    required this.points,
    required this.content,
    required this.tags,
    this.imageUrl,
    this.audioUrl,
    this.hints,
    this.isActive = true,
    required this.createdAt,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map, String id) {
    return ExerciseModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      subject: Subject.values.firstWhere(
        (e) => e.toString().split('.').last == map['subject'],
        orElse: () => Subject.mathematics,
      ),
      difficulty: Difficulty.values.firstWhere(
        (e) => e.toString().split('.').last == map['difficulty'],
        orElse: () => Difficulty.beginner,
      ),
      type: ExerciseType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => ExerciseType.multipleChoice,
      ),
      level: map['level'] ?? 1,
      points: map['points'] ?? 10,
      content: Map<String, dynamic>.from(map['content'] ?? {}),
      tags: List<String>.from(map['tags'] ?? []),
      imageUrl: map['imageUrl'],
      audioUrl: map['audioUrl'],
      hints: map['hints'] != null ? Map<String, dynamic>.from(map['hints']) : null,
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'subject': subject.toString().split('.').last,
      'difficulty': difficulty.toString().split('.').last,
      'type': type.toString().split('.').last,
      'level': level,
      'points': points,
      'content': content,
      'tags': tags,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'hints': hints,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ExerciseModel copyWith({
    String? id,
    String? title,
    String? description,
    Subject? subject,
    Difficulty? difficulty,
    ExerciseType? type,
    int? level,
    int? points,
    Map<String, dynamic>? content,
    List<String>? tags,
    String? imageUrl,
    String? audioUrl,
    Map<String, dynamic>? hints,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
      type: type ?? this.type,
      level: level ?? this.level,
      points: points ?? this.points,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      hints: hints ?? this.hints,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Métodos de utilidad
  bool get isMathematics => subject == Subject.mathematics;
  bool get isCommunication => subject == Subject.communication;
  
  String get difficultyText {
    switch (difficulty) {
      case Difficulty.beginner:
        return 'Principiante';
      case Difficulty.intermediate:
        return 'Intermedio';
      case Difficulty.advanced:
        return 'Avanzado';
    }
  }

  String get subjectText {
    switch (subject) {
      case Subject.mathematics:
        return 'Matemáticas';
      case Subject.communication:
        return 'Comunicación';
    }
  }

  String get typeText {
    switch (type) {
      case ExerciseType.multipleChoice:
        return 'Opción Múltiple';
      case ExerciseType.dragAndDrop:
        return 'Arrastrar y Soltar';
      case ExerciseType.fillInTheBlank:
        return 'Completar Espacios';
      case ExerciseType.trueFalse:
        return 'Verdadero o Falso';
      case ExerciseType.matching:
        return 'Emparejar';
      case ExerciseType.ordering:
        return 'Ordenar';
    }
  }

  // Método para obtener la dificultad ajustada según el nivel del usuario
  Difficulty getAdjustedDifficulty(int userLevel) {
    if (userLevel >= level + 2) {
      return Difficulty.beginner;
    } else if (userLevel >= level - 1) {
      return Difficulty.intermediate;
    } else {
      return Difficulty.advanced;
    }
  }

  // Método para calcular puntos ajustados según la dificultad del usuario
  int getAdjustedPoints(int userLevel) {
    Difficulty adjustedDifficulty = getAdjustedDifficulty(userLevel);
    switch (adjustedDifficulty) {
      case Difficulty.beginner:
        return (points * 0.7).round();
      case Difficulty.intermediate:
        return points;
      case Difficulty.advanced:
        return (points * 1.3).round();
    }
  }
}


