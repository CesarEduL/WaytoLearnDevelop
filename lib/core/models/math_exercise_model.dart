import 'package:cloud_firestore/cloud_firestore.dart';

enum MathExerciseType {
  addition,
  subtraction,
  multiplication,
  division,
  counting,
  shapes,
  patterns,
  wordProblems,
}

class MathOption {
  final String text;
  final bool isCorrect;
  final String? explanation;

  const MathOption({
    required this.text,
    required this.isCorrect,
    this.explanation,
  });

  factory MathOption.fromMap(Map<String, dynamic> map) {
    return MathOption(
      text: map['texto']?.toString() ?? '',
      isCorrect: (map['correcta'] as bool?) ?? false,
      explanation: map['explicacion']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'texto': text,
      'correcta': isCorrect,
      if (explanation != null) 'explicacion': explanation,
    };
  }
}

class MathExercise {
  final String id;
  final String title;
  final String question;
  final String? imageUrl;
  final MathExerciseType type;
  final int level;
  final int score;
  final List<MathOption> options;
  final String? hint;
  final String? solution;
  final Map<String, dynamic>? metadata;

  const MathExercise({
    required this.id,
    required this.title,
    required this.question,
    this.imageUrl,
    required this.type,
    required this.level,
    required this.score,
    required this.options,
    this.hint,
    this.solution,
    this.metadata,
  });

  factory MathExercise.fromMap(String id, Map<String, dynamic> map) {
    final optionsList = (map['opciones'] as List<dynamic>?) ?? [];
    final parsedOptions = optionsList
        .map((option) => MathOption.fromMap(Map<String, dynamic>.from(option)))
        .toList();

    return MathExercise(
      id: id,
      title: map['titulo']?.toString() ?? '',
      question: map['pregunta']?.toString() ?? '',
      imageUrl: map['imagen']?.toString(),
      type: MathExerciseType.values.firstWhere(
        (e) => e.toString().split('.').last == map['tipo'],
        orElse: () => MathExerciseType.addition,
      ),
      level: (map['nivel'] as num?)?.toInt() ?? 1,
      score: (map['puntaje'] as num?)?.toInt() ?? 10,
      options: parsedOptions,
      hint: map['pista']?.toString(),
      solution: map['solucion']?.toString(),
      metadata: map['metadata'] != null 
          ? Map<String, dynamic>.from(map['metadata']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': title,
      'pregunta': question,
      if (imageUrl != null) 'imagen': imageUrl,
      'tipo': type.toString().split('.').last,
      'nivel': level,
      'puntaje': score,
      'opciones': options.map((option) => option.toMap()).toList(),
      if (hint != null) 'pista': hint,
      if (solution != null) 'solucion': solution,
      if (metadata != null) 'metadata': metadata,
    };
  }

  MathOption? get correctOption => 
      options.firstWhere((option) => option.isCorrect, orElse: () => options.first);

  String get typeText {
    switch (type) {
      case MathExerciseType.addition:
        return 'Suma';
      case MathExerciseType.subtraction:
        return 'Resta';
      case MathExerciseType.multiplication:
        return 'Multiplicación';
      case MathExerciseType.division:
        return 'División';
      case MathExerciseType.counting:
        return 'Conteo';
      case MathExerciseType.shapes:
        return 'Formas';
      case MathExerciseType.patterns:
        return 'Patrones';
      case MathExerciseType.wordProblems:
        return 'Problemas';
    }
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasHint => hint != null && hint!.isNotEmpty;
  bool get hasSolution => solution != null && solution!.isNotEmpty;
}
