import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int age;
  final String grade;
  final String avatar;
  final int totalPoints;
  final int currentLevel;
  final int experiencePoints;
  final Map<String, int> subjectLevels;
  final List<String> achievements;
  final List<String> unlockedAvatars;
  final Map<String, dynamic> progress;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool isGuest;
  final int streak; // <-- Días consecutivos
  final DateTime? lastLearningDate; // <-- Última vez que completó una actividad

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.age,
    required this.grade,
    required this.avatar,
    this.totalPoints = 0,
    this.currentLevel = 1,
    this.experiencePoints = 0,
    this.subjectLevels = const {'mathematics': 1, 'communication': 1},
    this.achievements = const [],
    this.unlockedAvatars = const [],
    this.progress = const {},
    required this.createdAt,
    required this.lastLoginAt,
    this.isGuest = false,
    this.streak = 0,
    this.lastLearningDate,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      age: map['age'] ?? 0,
      grade: map['grade'] ?? '',
      avatar: map['avatar'] ?? 'default_avatar',
      totalPoints: map['totalPoints'] ?? 0,
      currentLevel: map['currentLevel'] ?? 1,
      experiencePoints: map['experiencePoints'] ?? 0,
      subjectLevels: Map<String, int>.from(
          map['subjectLevels'] ?? {'mathematics': 1, 'communication': 1}),
      achievements: List<String>.from(map['achievements'] ?? []),
      unlockedAvatars: List<String>.from(map['unlockedAvatars'] ?? []),
      progress: Map<String, dynamic>.from(map['progress'] ?? {}),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
      isGuest: map['isGuest'] ?? false,
      streak: map['streak'] ?? 0,
      lastLearningDate: map['lastLearningDate'] != null 
          ? (map['lastLearningDate'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'age': age,
      'grade': grade,
      'avatar': avatar,
      'totalPoints': totalPoints,
      'currentLevel': currentLevel,
      'experiencePoints': experiencePoints,
      'subjectLevels': subjectLevels,
      'achievements': achievements,
      'unlockedAvatars': unlockedAvatars,
      'progress': progress,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'isGuest': isGuest,
      'streak': streak,
      'lastLearningDate': lastLearningDate != null ? Timestamp.fromDate(lastLearningDate!) : null,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    int? age,
    String? grade,
    String? avatar,
    int? totalPoints,
    int? currentLevel,
    int? experiencePoints,
    Map<String, int>? subjectLevels,
    List<String>? achievements,
    List<String>? unlockedAvatars,
    Map<String, dynamic>? progress,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isGuest,
    int? streak,
    DateTime? lastLearningDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      grade: grade ?? this.grade,
      avatar: avatar ?? this.avatar,
      totalPoints: totalPoints ?? this.totalPoints,
      currentLevel: currentLevel ?? this.currentLevel,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      subjectLevels: subjectLevels ?? this.subjectLevels,
      achievements: achievements ?? this.achievements,
      unlockedAvatars: unlockedAvatars ?? this.unlockedAvatars,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isGuest: isGuest ?? this.isGuest,
      streak: streak ?? this.streak,
      lastLearningDate: lastLearningDate ?? this.lastLearningDate,
    );
  }

  // --- Métodos de utilidad ---
  int get experienceToNextLevel => currentLevel * 100;

  double get levelProgress => experiencePoints / experienceToNextLevel;

  bool get canLevelUp => experiencePoints >= experienceToNextLevel;

  int getSubjectLevel(String subject) => subjectLevels[subject] ?? 1;

  UserModel addExperience(int points) {
    int newExperiencePoints = experiencePoints + points;
    int newTotalPoints = totalPoints + points;
    int newCurrentLevel = currentLevel;

    while (newExperiencePoints >= (newCurrentLevel * 100)) {
      newCurrentLevel++;
      newExperiencePoints -= (newCurrentLevel * 100);
    }

    return copyWith(
      totalPoints: newTotalPoints,
      currentLevel: newCurrentLevel,
      experiencePoints: newExperiencePoints,
    );
  }

  // --- Nuevos métodos para progreso (7 Cuentos) ---
  static const int maxStoriesPerModule = 7;

  int getHighestUnlockedIndex(String subject) {
    if (progress.containsKey(subject)) {
      final subjectProgress = progress[subject] as Map<String, dynamic>;
      return subjectProgress['highestUnlockedIndex'] ?? 0;
    }
    return 0;
  }

  bool isStoryUnlocked(String subject, int storyIndex) {
    // El índice 0 siempre está desbloqueado
    if (storyIndex == 0) return true;
    return storyIndex <= getHighestUnlockedIndex(subject);
  }

  bool isStoryCompleted(String subject, int storyIndex) {
    if (progress.containsKey(subject)) {
      final subjectProgress = progress[subject] as Map<String, dynamic>;
      final completedStories = List<String>.from(subjectProgress['completedStories'] ?? []);
      // Asumimos que los IDs de los cuentos son "C01", "C02", etc. o simplemente índices
      // Para simplificar, usaremos el formato "STORY_{index}" internamente o verificaremos el índice
      // Si usamos IDs generados, deberíamos buscar ese ID.
      // Por ahora, basémonos en el índice almacenado en completedStories si son strings, 
      // o simplemente verifiquemos si el highestUnlockedIndex es mayor.
      
      // Estrategia más robusta: Verificar si el índice está en la lista de completados
      // Asumiremos que guardamos "STORY_0", "STORY_1", etc.
      return completedStories.contains('STORY_$storyIndex');
    }
    return false;
  }
}
