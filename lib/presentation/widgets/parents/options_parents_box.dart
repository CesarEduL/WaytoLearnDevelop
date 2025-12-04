import 'package:flutter/material.dart';

class OptionsParentsBox extends StatefulWidget {
  final int optionId;
  final VoidCallback? onTap;

  const OptionsParentsBox({
    super.key,
    required this.optionId,
    this.onTap,
  });

  @override
  State<OptionsParentsBox> createState() => _OptionsParentsBoxState();
}

class _OptionsParentsBoxState extends State<OptionsParentsBox> {
  Offset? _currentPointerPosition;

  // Configuration map for each option
  static const Map<int, Map<String, dynamic>> _optionsConfig = {
    1: {
      'icon': Icons.account_circle_rounded,
      'name': 'Perfil',
      'color': 0xFF8A5CF6,
    },
    2: {
      'icon': Icons.bar_chart_rounded,
      'name': 'Progreso',
      'color': 0xFFF65C7B,
    },
    3: {
      'icon': Icons.timer_rounded,
      'name': 'Tiempo de uso',
      'color': 0xFFC8F65C,
    },
    4: {
      'icon': Icons.cloud_download_rounded,
      'name': 'Descargas',
      'color': 0xFF5CF6D7,
    },
  };

  Map<String, dynamic> get _config => _optionsConfig[widget.optionId] ?? _optionsConfig[1]!;

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opción en desarrollo: ${_config['name']}'),
          duration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
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
      child: _OptionsBox(
        pointerPosition: _currentPointerPosition,
        icon: _config['icon'] as IconData,
        name: _config['name'] as String,
        backgroundColor: Color(_config['color'] as int),
        onTap: _handleTap,
      ),
    );
  }
}

class _OptionsBox extends StatefulWidget {
  final Offset? pointerPosition;
  final IconData icon;
  final String name;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _OptionsBox({
    required this.pointerPosition,
    required this.icon,
    required this.name,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  State<_OptionsBox> createState() => _OptionsBoxState();
}

class _OptionsBoxState extends State<_OptionsBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  static const double _widgetWidth = 170;
  static const double _widgetHeight = 170;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_OptionsBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pointerPosition != null) {
      final pointerPos = widget.pointerPosition!;
      
      // Check if pointer is within widget bounds
      if (pointerPos.dx >= 0 &&
          pointerPos.dx <= _widgetWidth &&
          pointerPos.dy >= 0 &&
          pointerPos.dy <= _widgetHeight) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: _widgetWidth,
            height: _widgetHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Container principal
                Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                // Icon Container
                Positioned(
                  left: 39,
                  top: 10,
                  child: Container(
                    width: 92,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Icon(
                        widget.icon,
                        size: 40,
                        color: widget.backgroundColor,
                      ),
                    ),
                  ),
                ),
                // Name Option Container
                Positioned(
                  left: 12,
                  top: 90,
                  child: Container(
                    width: 146,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF170444),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
    );
  }
}
