import 'package:flutter/material.dart';
import 'story_screen.dart';

class StoriesLauncher extends StatelessWidget {
  const StoriesLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return const StoryScreen(startNodeId: 'C01');
  }
}


