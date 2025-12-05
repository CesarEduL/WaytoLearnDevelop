import 'package:flutter/material.dart';
import 'dart:ui';

class LoginFormBox extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;

  const LoginFormBox({super.key, this.child, this.onTap});
  @override
  State<LoginFormBox> createState() => _LoginFormBoxState();
}

class _LoginFormBoxState extends State<LoginFormBox> {
  bool _showBubble = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
              child: GestureDetector(
                onTap: () => setState(() => _showBubble = !_showBubble),
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/auth_resources%2Foso-icon-3d-polygon.png?alt=media&token=04a27892-c1a3-49e1-893b-284aa48c9b17',
                  width: 209,
                  height: 141,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 135,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 489,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF5C7BF6),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 205,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 489,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF5C7BF6),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 265,
              left: 20,
              child: Text("Crear Cuenta"),
            ),
            Positioned(
              top: 265,
              left: 350,
              child: Text("Olvide mi contraseña"),
            ),
            Positioned(
              left: 0,
              top: 285,
              right: 0,
              child: Center(
                child: Text(
                  "O",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 315,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "google",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            if (_showBubble)
              Positioned(
                left: -50,
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
                    'Es hora de Iniciar Sesión y continuar aprendiendo!',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF2A1E96)),
                    textAlign: TextAlign.center,
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
