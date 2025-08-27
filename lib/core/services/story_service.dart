import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_node.dart';

class StoryService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StoryNode?> fetchStoryNode(String nodeId) async {
    try {
      final doc = await _firestore.collection('cuentos').doc(nodeId).get();
      if (!doc.exists || doc.data() == null) return null;
      return StoryNode.fromMap(doc.id, doc.data()!);
    } catch (e) {
      debugPrint('Error fetching story node: $e');
      return null;
    }
  }
}


