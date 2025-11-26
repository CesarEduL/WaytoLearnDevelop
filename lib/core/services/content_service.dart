import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../models/interactive_story_model.dart';

class ContentService extends ChangeNotifier {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Fetch all subjects (and their nested content)
  Stream<List<SubjectModel>> getSubjects() {
    return _dbRef.child('content/subjects').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];
      
      try {
        if (data is List) {
          return data.map((e) {
            if (e is Map) return SubjectModel.fromMap(e as Map<dynamic, dynamic>);
            return null;
          }).whereType<SubjectModel>().toList();
        } else if (data is Map) {
          return data.values.map((e) {
            if (e is Map) return SubjectModel.fromMap(e as Map<dynamic, dynamic>);
            return null;
          }).whereType<SubjectModel>().toList();
        }
        return [];
      } catch (e) {
        debugPrint('Error parsing subjects: $e');
        return [];
      }
    });
  }

  // Helper to get a specific session's stories from the full tree
  Stream<List<StoryModel>> getStories(String subjectId, String sessionId) {
    return _dbRef.child('content/subjects').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return [];

      try {
        List<SubjectModel> subjects = [];
        if (data is List) {
          subjects = data.map((e) {
            if (e is Map) return SubjectModel.fromMap(e as Map<dynamic, dynamic>);
            return null;
          }).whereType<SubjectModel>().toList();
        } else if (data is Map) {
          subjects = data.values.map((e) {
            if (e is Map) return SubjectModel.fromMap(e as Map<dynamic, dynamic>);
            return null;
          }).whereType<SubjectModel>().toList();
        }
        
        final subject = subjects.firstWhere((s) => s.id == subjectId, orElse: () => throw 'Subject not found');
        final session = subject.sessions.firstWhere((s) => s.id == sessionId, orElse: () => throw 'Session not found');
        
        return session.stories;
      } catch (e) {
        debugPrint('Error getting stories: $e');
        return [];
      }
    });
  }

  // Get a specific node from a story
  Future<StoryNode?> getStoryNode(String subjectId, String sessionId, String storyId, String nodeId) async {
    try {
      // Fetch the whole subjects list to find the node. 
      // Not efficient but works with the current list-based structure without known indices.
      final snapshot = await _dbRef.child('content/subjects').get();
      if (!snapshot.exists) return null;

      final data = snapshot.value;
      List<SubjectModel> subjects = [];
      if (data is List) {
        subjects = data.map((e) {
          if (e is Map) return SubjectModel.fromMap(e as Map<dynamic, dynamic>);
          return null;
        }).whereType<SubjectModel>().toList();
      } else if (data is Map) {
        subjects = data.values.map((e) {
          if (e is Map) return SubjectModel.fromMap(e as Map<dynamic, dynamic>);
          return null;
        }).whereType<SubjectModel>().toList();
      }
      
      final subject = subjects.firstWhere((s) => s.id == subjectId);
      final session = subject.sessions.firstWhere((s) => s.id == sessionId);
      final story = session.stories.firstWhere((s) => s.id == storyId);
      
      return story.nodes.firstWhere((n) => n.id == nodeId);
    } catch (e) {
      debugPrint('Error fetching node: $e');
      return null;
    }
  }
}
