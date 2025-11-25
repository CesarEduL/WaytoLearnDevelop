import 'package:flutter/material.dart';

/// Textos de bienvenida con estilo adaptable.
class WelcomeMessages extends StatelessWidget {
  const WelcomeMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = (screenWidth * 0.04).clamp(20.0, 28.0);
    final subtitleFontSize = (screenWidth * 0.025).clamp(14.0, 18.0);

    return Column(
      children: [
        Text(
          '¡Bienvenido a WaytoLearn!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
            shadows: const [
              Shadow(
                color: Colors.black54,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            'Aprende matemáticas y comunicación de forma divertida',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: subtitleFontSize,
              shadows: const [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
