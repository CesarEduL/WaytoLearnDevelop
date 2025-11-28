import 'package:flutter/material.dart';

class AchievementsBox extends StatefulWidget {
  final double scale;
  final bool isHovered;
  final String achievementName;
  final String achievementDescription;
  final int achievementNumber;
  final String status; // 'active' or 'locked'

  const AchievementsBox({
    super.key,
    this.scale = 1.0,
    this.isHovered = false,
    required this.achievementName,
    required this.achievementDescription,
    required this.achievementNumber,
    required this.status,
  });

  @override
  State<AchievementsBox> createState() => _AchievementsBoxState();
}

class _AchievementsBoxState extends State<AchievementsBox> {
  bool _isPressed = false;

  String _getImageUrl() {
    switch (widget.achievementNumber) {
      case 1:
        return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2FExplorador-de-cuentos.png?alt=media&token=d01d054c-6d71-4332-b490-9ed1748b28ca';
      case 2:
        return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Ftoca-descubre-aprende.png?alt=media&token=ac54f505-bf33-4836-b7e9-a05be398abfb';
      case 3:
        return 'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Famante-de-los-cuentos.png?alt=media&token=9e343106-9770-4391-9ca5-79dd8e9c1b51';
      default:
        return '';
    }
  }

  Color _getBackgroundColor() {
    switch (widget.achievementNumber) {
      case 1:
        return const Color(0xFF5CF6D7);
      case 2:
      case 3:
        return const Color(0xFFC8F65C);
      default:
        return const Color(0xFF5CF6D7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: (_isPressed || widget.isHovered) ? 1.07 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 237 * widget.scale,
            height: 115 * widget.scale,
            color: _getBackgroundColor(),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 5,
                  child: Center(
                    child: Container(
                      width: 92,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 12,
                            child: Center(
                            child: ColorFiltered(
                              colorFilter: widget.status == 'locked'
                                  ? const ColorFilter.matrix([
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0.2126, 0.7152, 0.0722, 0, 0,
                                      0, 0, 0, 1, 0,
                                    ])
                                  : const ColorFilter.mode(
                                      Colors.transparent,
                                      BlendMode.multiply,
                                    ),
                              child: Image.network(
                                _getImageUrl(),
                                width: 61,
                                height: 51,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          ),
                          if (widget.status == 'locked')
                            Positioned.fill(
                              child: Center(
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.grey[700],
                                  size: 24,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 72,
                  right: 0,
                  child: Text(
                    widget.achievementName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF2A1E96),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 92,
                  right: 0,
                  child: Text(
                    widget.achievementDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF2A1E96),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
