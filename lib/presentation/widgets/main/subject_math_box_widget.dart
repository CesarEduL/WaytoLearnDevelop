import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
  

class SubjectMathBoxWidget extends StatefulWidget {
  final double scale;
  final VoidCallback? onTap;
  final bool isHovered;
  final String currentSession;

  const SubjectMathBoxWidget({
    super.key,
    this.scale = 1.0,
    this.onTap,
    this.isHovered = false,
    required this.currentSession,
  });

  @override
  State<SubjectMathBoxWidget> createState() => _SubjectMathBoxWidgetState();
}

class _SubjectMathBoxWidgetState extends State<SubjectMathBoxWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: (_isPressed || widget.isHovered) ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 381 * widget.scale,
            height: 131 * widget.scale,
            decoration: const BoxDecoration(
              color: Color(0xFF8A5CF6),
            ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  left: 102,
                  top: 0,
                  child: SizedBox(
                    width: 369,
                    height: 131,
                    child: Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Fbosque_math.png?alt=media&token=2baf727d-0955-4ab8-897b-c9afdc0f2ea1',
                      fit: BoxFit.cover,
                      
                    ),
                  ),
                ),
                Positioned(
                  left: 34,
                  top: 21,
                  child: Container(
                    width: 59,
                    height: 54.63,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFFFFF),
                        width: 5,
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          left: 1,
                          top: 2,
                          child: SizedBox(
                            width: 48.09,
                            height: 47.63,
                            child: SvgPicture.network(
                              'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Fmath-icon.svg?alt=media&token=5aa52f6a-e92e-4fb7-a3db-b64ce32c1c72',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
                Positioned(
                  left: 25,
                  top: 78,
                  child: Text(
                    widget.currentSession,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  top: 98,
                  child: Text(
                    'Matemática',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF5CF68A)
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