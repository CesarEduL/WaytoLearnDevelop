// Helper to parse List or Map<String, dynamic> into List<T>
List<T> _parseList<T>(dynamic data, T Function(Map<dynamic, dynamic>) fromMap) {
  if (data == null) return [];
  if (data is List) {
    return data.map((e) {
      if (e is Map) return fromMap(e);
      return fromMap({}); // Handle unexpected types gracefully or ignore
    }).toList();
  }
  if (data is Map) {
    return data.values.map((e) {
      if (e is Map) return fromMap(e);
      return fromMap({});
    }).toList();
  }
  return [];
}

class StoryOption {
  final String text; // "label" in JSON
  final String nextNodeId; // "next" in JSON

  const StoryOption({
    required this.text,
    required this.nextNodeId,
  });

  factory StoryOption.fromMap(Map<dynamic, dynamic> map) {
    return StoryOption(
      text: map['label']?.toString() ?? '',
      nextNodeId: map['next']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': text,
      'next': nextNodeId,
    };
  }
}

class StoryNode {
  final String id;
  final String text;
  final String? image;
  final List<StoryOption> options;

  const StoryNode({
    required this.id,
    required this.text,
    this.image,
    required this.options,
  });

  factory StoryNode.fromMap(Map<dynamic, dynamic> map) {
    return StoryNode(
      id: map['id']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      image: map['image']?.toString(),
      options: _parseList(map['options'], (m) => StoryOption.fromMap(m)),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'image': image,
      'options': options.map((e) => e.toMap()).toList(),
    };
  }
}

class StoryModel {
  final String id;
  final String title;
  final String? image;
  final bool interactive;
  final List<StoryNode> nodes;

  const StoryModel({
    required this.id,
    required this.title,
    this.image,
    this.interactive = false,
    required this.nodes,
  });

  factory StoryModel.fromMap(Map<dynamic, dynamic> map) {
    return StoryModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      image: map['image']?.toString(),
      interactive: map['interactive'] as bool? ?? false,
      nodes: _parseList(map['nodes'], (m) => StoryNode.fromMap(m)),
    );
  }
}

class SessionModel {
  final String id;
  final String name;
  final List<StoryModel> stories;

  const SessionModel({
    required this.id,
    required this.name,
    required this.stories,
  });

  factory SessionModel.fromMap(Map<dynamic, dynamic> map) {
    return SessionModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      stories: _parseList(map['stories'], (m) => StoryModel.fromMap(m)),
    );
  }
}

class SubjectModel {
  final String id;
  final String name;
  final List<SessionModel> sessions;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.sessions,
  });

  factory SubjectModel.fromMap(Map<dynamic, dynamic> map) {
    return SubjectModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      sessions: _parseList(map['sessions'], (m) => SessionModel.fromMap(m)),
    );
  }
}
