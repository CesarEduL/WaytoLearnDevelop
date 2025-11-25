import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/widgets/buttons.dart';

/// Botones modernos para iniciar sesión con Google o como invitado.
class LoginButtons extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onGuestSignIn;

  const LoginButtons({
    super.key,
    required this.onGoogleSignIn,
    required this.onGuestSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, userService, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 64,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  Text(
                    'Iniciar Sesión',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                  ),
                  const SizedBox(height: 12),

                  // Subtítulo
                  Text(
                    'Elige cómo quieres continuar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Botón de Google
                  GoogleButton(
                    onPressed: userService.isLoading ? null : onGoogleSignIn,
                    isLoading: userService.isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Separador "o"
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'o',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Botón de Invitado
                  SecondaryButton(
                    text: 'Ingresar como Invitado',
                    icon: Icons.person_outline,
                    onPressed: userService.isLoading ? null : onGuestSignIn,
                  ),
                  const Spacer(),

                  // Texto informativo
                  Text(
                    'Al continuar, aceptas nuestros términos y condiciones',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
