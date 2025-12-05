import 'package:flutter/material.dart';
import 'dart:ui';

class OptionsBox extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onHaveAccountTap;
  final VoidCallback? onNoAccountTap;

  const OptionsBox({
    super.key,
    this.child,
    this.onTap,
    this.onHaveAccountTap,
    this.onNoAccountTap,
  });

  @override
  State<OptionsBox> createState() => _OptionsBoxState();
}

class _OptionsBoxState extends State<OptionsBox> {
  bool _isBox1Pressed = false;
  bool _isBox2Pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: widget.onTap,
      child: SizedBox(
        width: 273,
        height: 382,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Fondo con blur
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
            // Contenido sin blur
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: _BearWidget(),
            ),
            // Caja 1 (superior) - "ya tengo una cuenta"
            Positioned(
              top: 160,
              left: 0,
              right: 0, // Centrado horizontalmente
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => setState(() => _isBox1Pressed = true),
                onTapUp: (_) {
                  setState(() => _isBox1Pressed = false);
                  if (widget.onHaveAccountTap != null) {
                    widget.onHaveAccountTap!();
                  }
                },
                onTapCancel: () => setState(() => _isBox1Pressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: _isBox1Pressed ? 285 : 275,
                  height: _isBox1Pressed ? 88 :  83,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(39),
                    border: Border.all(
                      color: const Color(0xFFC8F65C),
                      width: 2,
                    ),
                  ),
                  child: Center(
                      child: Text(
                        'ya tengo una cuenta',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: const Color(0xFF5C7BF6),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ),
                ),
              ),
            ),
            // Caja 2 (inferior) - "no tengo una cuenta"
            Positioned(
              top: 260,
              left: 0,
              right: 0, // Centrado horizontalmente
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (_) => setState(() => _isBox2Pressed = true),
                onTapUp: (_) {
                  setState(() => _isBox2Pressed = false);
                  if (widget.onNoAccountTap != null) {
                    widget.onNoAccountTap!();
                  }
                },
                onTapCancel: () => setState(() => _isBox2Pressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  width: _isBox2Pressed ? 285 : 275,
                  height: _isBox2Pressed ? 88 :  83,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8A5CF6),
                    borderRadius: BorderRadius.circular(39),
                  ),
                  child: Center(
                      child: Text(
                        'no tengo una cuenta',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ),
                ),
              ),
            ),
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }
}

// Widget separado para el oso con su propio estado
class _BearWidget extends StatefulWidget {
  const _BearWidget();

  @override
  State<_BearWidget> createState() => _BearWidgetState();
}

class _BearWidgetState extends State<_BearWidget> {
  bool _showBubble = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => _showBubble = !_showBubble),
          child: SizedBox(
            width: 259,
            height: 191,
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/auth_resources%2Foso-icon-3d-polygon.png?alt=media&token=04a27892-c1a3-49e1-893b-284aa48c9b17',
              width: 259,
              height: 191,
              fit: BoxFit.contain,
            ),
          ),
        ),
        if (_showBubble)
          Positioned(
            left: -170,
            top: 60,
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              child: const Text(
                'Bienvenido a la mejor app educativa',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A1E96),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
