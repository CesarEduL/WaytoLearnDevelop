import 'package:cloud_firestore/cloud_firestore.dart';

class StoryOption {
  final String? subStoryId;
  final String text;

  const StoryOption({
    this.subStoryId,
    required this.text,
  });

  factory StoryOption.fromMap(Map<String, dynamic> map) {
    return StoryOption(
      subStoryId: map['subcuento_id']?.toString(),
      text: map['texto']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (subStoryId != null) 'subcuento_id': subStoryId,
      'texto': text,
    };
  }
}

class StoryExercise {
  final String id;
  final String title;
  final String storyTitle;
  final String content;
  final String? imageUrl;
  final bool isFinal;
  final int? score;
  final Map<String, StoryOption> options;

  const StoryExercise({
    required this.id,
    required this.title,
    required this.storyTitle,
    required this.content,
    this.imageUrl,
    required this.isFinal,
    this.score,
    required this.options,
  });

  factory StoryExercise.fromMap(String id, Map<String, dynamic> map) {
    final optionsMap = (map['opciones'] as Map<String, dynamic>?) ?? {};
    final parsedOptions = <String, StoryOption>{};
    
    optionsMap.forEach((key, value) {
      parsedOptions[key] = StoryOption.fromMap(Map<String, dynamic>.from(value));
    });

    return StoryExercise(
      id: id,
      title: map['titulo']?.toString() ?? '',
      storyTitle: map['titulo_cuento']?.toString() ?? '',
      content: map['contenido']?.toString() ?? '',
      imageUrl: map['imagen']?.toString(),
      isFinal: (map['final'] as bool?) ?? false,
      score: (map['puntaje'] as num?)?.toInt(),
      options: parsedOptions,
    );
  }

  Map<String, dynamic> toMap() {
    final optionsMap = <String, dynamic>{};
    options.forEach((key, option) {
      optionsMap[key] = option.toMap();
    });

    return {
      'titulo': title,
      'titulo_cuento': storyTitle,
      'contenido': content,
      if (imageUrl != null) 'imagen': imageUrl,
      'final': isFinal,
      if (score != null) 'puntaje': score,
      'opciones': optionsMap,
    };
  }

  List<StoryOption> get optionsList => options.values.toList();

  bool get hasNextOptions => options.values.any((option) => option.subStoryId != null);
}
