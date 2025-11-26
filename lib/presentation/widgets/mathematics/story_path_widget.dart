import 'package:flutter/material.dart';
import 'package:waytolearn/presentation/widgets/mathematics/story_path_painter.dart';
import 'package:waytolearn/presentation/widgets/mathematics/story_node_widget.dart';

class StoryPathWidget extends StatefulWidget {
  final int completedStoryIndex; // Índice del último cuento completado (0-6)
  final Function(int)? onStoryTap;
  final double scale;
  final Widget Function(int index, bool isCompleted, bool isLocked)? storyIconBuilder;

  const StoryPathWidget({
    super.key,
    this.completedStoryIndex = -1, // -1 = ninguno completado
    this.onStoryTap,
    this.scale = 1.0,
    this.storyIconBuilder,
  });

  @override
  State<StoryPathWidget> createState() => _StoryPathWidgetState();
}

class _StoryPathWidgetState extends State<StoryPathWidget> {
  final List<GlobalKey> _storyKeys = List.generate(7, (_) => GlobalKey());
  final List<bool> _hoveredStates = List.generate(7, (_) => false);

  // Coordenadas de los 7 cuentos desde pathPoints (actualizadas sin duplicados)
  static const List<Offset> storyPositions = [
    Offset(130.0, 224.51), // Cuento 1 - P0
    Offset(246.0, 71.0), // Cuento 2 - P3
    Offset(363.0, 224.51), // Cuento 3 - P5
    Offset(485.5, 375.0), // Cuento 4 - P7
    Offset(596.0, 224.51), // Cuento 5 - P9
    Offset(712.25, 71.0), // Cuento 6 - P11
    Offset(828.5, 222), // Cuento 7 - P13
  ];

  void _handlePointerMove(PointerEvent details) {
    for (int i = 0; i < _storyKeys.length; i++) {
      final RenderBox? box =
          _storyKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        final bounds = Rect.fromLTWH(
            position.dx, position.dy, 70 * widget.scale, 60 * widget.scale);

        if (bounds.contains(details.position)) {
          if (!_hoveredStates[i]) {
            setState(() => _hoveredStates[i] = true);
          }
        } else {
          if (_hoveredStates[i]) {
            setState(() => _hoveredStates[i] = false);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dimensiones optimizadas para pantalla 912px
    const double baseWidth = 912.0; // Coincide con designWidth
    const double baseHeight = 450.0;

    final scaledWidth = baseWidth * widget.scale;
    final scaledHeight = baseHeight * widget.scale;

    return Listener(
      onPointerMove: _handlePointerMove,
      behavior: HitTestBehavior.deferToChild,
      child: SizedBox(
        width: scaledWidth,
        height: scaledHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Camino dibujado con CustomPainter
            Positioned.fill(
              child: CustomPaint(
                painter: StoryPathPainter(
                  completedStoryIndex: widget.completedStoryIndex,
                  scale: widget.scale,
                ),
              ),
            ),

            // Nodos de cuentos posicionados
            ...List.generate(7, (index) {
              final position = storyPositions[index];
              // Centrar el widget de 70x60 sobre la coordenada (con escala)
              final adjustedLeft =
                  (position.dx * widget.scale) - (35 * widget.scale);
              final adjustedTop =
                  (position.dy * widget.scale) - (30 * widget.scale);

              // Determinar si el cuento está bloqueado
              // El primer cuento (0) siempre está desbloqueado.
              // Los siguientes están desbloqueados si el anterior se completó.
              // completedStoryIndex es el índice del último completado.
              // Ejemplo: completed = 0 (cuento 1 completado).
              // index 0: desbloqueado (siempre)
              // index 1: desbloqueado (0 + 1 >= 1) -> TRUE
              // index 2: bloqueado (0 + 1 < 2) -> TRUE (bloqueado)
              final bool isLocked = index > widget.completedStoryIndex + 1;

              return Positioned(
                key: _storyKeys[index],
                left: adjustedLeft,
                top: adjustedTop,
                child: StoryNodeWidget(
                  storyIndex: index,
                  isCompleted: index <= widget.completedStoryIndex,
                  isLocked: isLocked,
                  isHovered: _hoveredStates[index],
                  onTap: () {
                    if (!isLocked) {
                      widget.onStoryTap?.call(index);
                    }
                  },
                  scale: widget.scale,
                  customIcon: widget.storyIconBuilder?.call(index, index <= widget.completedStoryIndex, isLocked),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
