import 'package:flutter/material.dart';

class MathIndexScreenSessions extends StatelessWidget {
  const MathIndexScreenSessions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [

            const Center(
              child: Text(
                '¡Hola, mundo!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEC4899),
                ),
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFFEC4899),
                  size: 28,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
