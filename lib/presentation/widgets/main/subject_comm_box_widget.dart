import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
  

class SubjectCommBoxWidget extends StatefulWidget {
  final double scale;
  final VoidCallback? onTap;
  final bool isHovered;
  final String currentSession;

  const SubjectCommBoxWidget({
    required this.currentSession,
    super.key,
    this.scale = 1.0,
    this.onTap,
    this.isHovered = false,
  });

  @override
  State<SubjectCommBoxWidget> createState() => _SubjectCommBoxWidgetState();
}

class _SubjectCommBoxWidgetState extends State<SubjectCommBoxWidget> {
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
              color: Color(0xFFF65CC8),
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
                      'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Fbosque_comm.png?alt=media&token=0a39e5d2-ffe2-4e47-a88e-3acb85fe52a0',
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
                          left: 0,
                          top:0,
                          child: SizedBox(
                            width: 50.09,
                            height: 54.63,
                            child: SvgPicture.network(
                              'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/dashBoard_resources%2Fcomm-icon.svg?alt=media&token=57131f04-16b6-4d2c-b85b-fce5ca567b90',
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
                  left: 10,
                  top: 98,
                  child: Text(
                    'Comunicación',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Color(0xFF5CF68A),
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