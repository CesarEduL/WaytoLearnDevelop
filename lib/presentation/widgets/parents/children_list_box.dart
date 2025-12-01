import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Data model for a child
class Child {
  final String childrenId;
  final String childrenName;
  final String? childrenIcon;

  const Child({
    required this.childrenId,
    required this.childrenName,
    this.childrenIcon,
  });
}

/// Main widget for displaying children list
class ChildrenListBox extends StatefulWidget {
  final List<Child> children;
  final Function(Child)? onEditChild;
  final VoidCallback? onAddChild;

  const ChildrenListBox({
    super.key,
    required this.children,
    this.onEditChild,
    this.onAddChild,
  });

  @override
  State<ChildrenListBox> createState() => _ChildrenListBoxState();
}

class _ChildrenListBoxState extends State<ChildrenListBox> {
  final Map<int, GlobalKey> _nodeKeys = {};
  Offset? _currentPointerPosition;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      _nodeKeys[i] = GlobalKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure we have exactly 5 slots
    final slots = List<Child?>.generate(5, (index) {
      return index < widget.children.length ? widget.children[index] : null;
    });

    return Center(
      child: Semantics(
        label: 'Tus hijos',
        child: Listener(
          onPointerDown: (event) {
            setState(() => _currentPointerPosition = event.localPosition);
          },
          onPointerMove: (event) {
            setState(() => _currentPointerPosition = event.localPosition);
          },
          onPointerUp: (event) {
            setState(() => _currentPointerPosition = null);
          },
          onPointerCancel: (event) {
            setState(() => _currentPointerPosition = null);
          },
          child: SizedBox(
            width: 555.74,
            height: 89.74,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Title
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      'Tus hijos',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF170444),
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                // Node 1
                Positioned(
                  left: 0,
                  top: 29,
                  child: _ChildNode(
                    key: _nodeKeys[0],
                    child: slots[0],
                    onTap: () => _handleNodeTap(context, slots[0]),
                    pointerPosition: _currentPointerPosition,
                    nodePosition: const Offset(0, 29),
                  ),
                ),
                // Node 2
                Positioned(
                  left: 124,
                  top: 29,
                  child: _ChildNode(
                    key: _nodeKeys[1],
                    child: slots[1],
                    onTap: () => _handleNodeTap(context, slots[1]),
                    pointerPosition: _currentPointerPosition,
                    nodePosition: const Offset(124, 29),
                  ),
                ),
                // Node 3
                Positioned(
                  left: 248,
                  top: 29,
                  child: _ChildNode(
                    key: _nodeKeys[2],
                    child: slots[2],
                    onTap: () => _handleNodeTap(context, slots[2]),
                    pointerPosition: _currentPointerPosition,
                    nodePosition: const Offset(248, 29),
                  ),
                ),
                // Node 4
                Positioned(
                  left: 371,
                  top: 29,
                  child: _ChildNode(
                    key: _nodeKeys[3],
                    child: slots[3],
                    onTap: () => _handleNodeTap(context, slots[3]),
                    pointerPosition: _currentPointerPosition,
                    nodePosition: const Offset(371, 29),
                  ),
                ),
                // Node 5
                Positioned(
                  left: 495,
                  top: 29,
                  child: _ChildNode(
                    key: _nodeKeys[4],
                    child: slots[4],
                    onTap: () => _handleNodeTap(context, slots[4]),
                    pointerPosition: _currentPointerPosition,
                    nodePosition: const Offset(495, 29),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNodeTap(BuildContext context, Child? child) {
    if (child != null) {
      if (widget.onEditChild != null) {
        widget.onEditChild!(child);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Función en desarrollo: editar niño (id: ${child.childrenId}).'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (widget.onAddChild != null) {
        widget.onAddChild!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Función en desarrollo: agregar niño.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

/// Individual child node widget with animation
class _ChildNode extends StatefulWidget {
  final Child? child;
  final VoidCallback onTap;
  final Offset? pointerPosition;
  final Offset nodePosition;

  const _ChildNode({
    super.key,
    required this.child,
    required this.onTap,
    required this.pointerPosition,
    required this.nodePosition,
  });

  @override
  State<_ChildNode> createState() => _ChildNodeState();
}

class _ChildNodeState extends State<_ChildNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  static const double _nodeSize = 60.74;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void didUpdateWidget(_ChildNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pointerPosition != null) {
      final pointerPos = widget.pointerPosition!;
      final nodePos = widget.nodePosition;
      
      // Check if pointer is within node bounds
      if (pointerPos.dx >= nodePos.dx &&
          pointerPos.dx <= nodePos.dx + _nodeSize &&
          pointerPos.dy >= nodePos.dy &&
          pointerPos.dy <= nodePos.dy + _nodeSize) {
        if (_controller.status != AnimationStatus.forward &&
            _controller.status != AnimationStatus.completed) {
          _controller.forward();
        }
      } else {
        if (_controller.status != AnimationStatus.reverse &&
            _controller.status != AnimationStatus.dismissed) {
          _controller.reverse();
        }
      }
    } else {
      if (_controller.status != AnimationStatus.reverse &&
          _controller.status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
  }

  String _getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      return words[0].isNotEmpty ? words[0][0].toUpperCase() : '?';
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isEmptySlot = widget.child == null;
    final tooltipLabel = isEmptySlot
        ? 'Agregar niño'
        : 'Editar niño: ${widget.child!.childrenName}';

    return RepaintBoundary(
      child: Tooltip(
        message: tooltipLabel,
        child: GestureDetector(
          onTap: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: _nodeSize,
                  height: _nodeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: isEmptySlot
                          ? const Color(0xFFC9C9C9)
                          : const Color(0xFFE6E6E6),
                      width: isEmptySlot ? 1.2 : 1.0,
                    ),
                  ),
                  child: ClipOval(
                    child: isEmptySlot
                        ? _buildAddIcon()
                        : _buildChildContent(widget.child!),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddIcon() {
    return Center(
      child: CachedNetworkImage(
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/parents_resources%2Fcreate-children-icon.svg?alt=media&token=20a3d6c9-7913-4757-af2c-e65d1f760c92',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        placeholder: (context, url) => const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) => Icon(
          Icons.add,
          size: 24,
          color: Color(0xFFC9C9C9),
        ),
      ),
    );
  }

  Widget _buildChildContent(Child child) {
    if (child.childrenIcon != null && child.childrenIcon!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: child.childrenIcon!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Color(0xFFE6E6E6),
          child: Center(
            child: Text(
              _getInitials(child.childrenName),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF170444),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Color(0xFFE6E6E6),
          child: Center(
            child: Text(
              _getInitials(child.childrenName),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF170444),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Color(0xFFE6E6E6),
        child: Center(
          child: Text(
            _getInitials(child.childrenName),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF170444),
            ),
          ),
        ),
      );
    }
  }
}
