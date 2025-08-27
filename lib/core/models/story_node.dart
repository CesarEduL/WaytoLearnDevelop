
class StoryOption {
  final String subStoryId;
  final String text;

  const StoryOption({required this.subStoryId, required this.text});

  factory StoryOption.fromMap(Map<String, dynamic> map) {
    return StoryOption(
      subStoryId: map['subcuento_id']?.toString() ?? '',
      text: map['texto']?.toString() ?? '',
    );
  }
}

class StoryNode {
  final String id;
  final String title;
  final String storyTitle;
  final String content;
  final String? imageUrl;
  final bool isFinal;
  final int? score;
  final List<StoryOption> options;

  const StoryNode({
    required this.id,
    required this.title,
    required this.storyTitle,
    required this.content,
    required this.imageUrl,
    required this.isFinal,
    required this.score,
    required this.options,
  });

  factory StoryNode.fromMap(String id, Map<String, dynamic> map) {
    final optionsMap = (map['opciones'] as Map<String, dynamic>?) ?? {};
    final parsedOptions = optionsMap.values
        .map((value) => StoryOption.fromMap(Map<String, dynamic>.from(value)))
        .toList(growable: false);

    return StoryNode(
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
}


