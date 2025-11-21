import 'package:flutter/material.dart';
import 'package:waytolearn/presentation/screens/communication/story_detail_screen.dart';
import 'package:waytolearn/presentation/widgets/mathematics/story_path_widget.dart';

enum SubjectType { mathematics, communication }

class StoryMapWidget extends StatelessWidget {
  final SubjectType subject;
  final int completedStories;

  const StoryMapWidget({
    super.key,
    required this.subject,
    this.completedStories = -1,
  });

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const designWidth = 912.0;
    final scale = mediaSize.width / designWidth;

    // Define los colores basados en la materia
    final Color pathColor = (subject == SubjectType.mathematics)
        ? const Color(0xFF583C95)
        : Colors.purple.shade300;

    final Color bearColor = (subject == SubjectType.mathematics)
        ? const Color(0xFF583C95)
        : Colors.purple.shade400;

    return Stack(
      children: [
        Positioned(
          top: 10 * scale,
          left: -20 * scale,
          child: StoryPathWidget(
            completedStoryIndex: completedStories,
            scale: scale,
            pathColor: pathColor,
            bearColor: bearColor,
            onStoryTap: (index) {
              _navigateToStory(context, index);
            },
          ),
        ),
      ],
    );
  }

  void _navigateToStory(BuildContext context, int index) {
    String storyId = "";
    if (subject == SubjectType.communication) {
      // Asigna el ID del cuento basado en el índice.
      // Ejemplo: C01, C02, etc.
      storyId = "C${(index + 1).toString().padLeft(2, '0')}";
    } else {
      // Lógica para cuentos de matemáticas si es necesario
      // storyId = "M${(index + 1).toString().padLeft(2, '0')}";
    }

    if (storyId.isNotEmpty) {
      debugPrint('Navegando a la historia: $storyId');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryDetailScreen(storyId: storyId),
        ),
      );
    } else {
      debugPrint('No se ha definido una acción para esta historia.');
    }
  }
}
