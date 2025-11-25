import 'package:flutter/material.dart';
import 'bear_logo.dart';
import 'welcome_text.dart';

/// Combina el logo animado y los textos de bienvenida en una sección.
class WelcomeSection extends StatelessWidget {
  final Animation<double> bearAnimation;

  const WelcomeSection({
    super.key,
    required this.bearAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBearLogo(animation: bearAnimation),
        const SizedBox(height: 20),
        const WelcomeMessages(),
      ],
    );
  }
}
