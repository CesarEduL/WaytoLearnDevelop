import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/orientation_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/orientation_aware_widget.dart';
import '../main/dashboard_screen.dart';
import 'login_buttons.dart';
import 'welcome_section.dart';

/// Pantalla de inicio de sesión que gestiona animaciones y lógica.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _bearController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bearAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    // Forzar orientación vertical para login
    OrientationService().setPortraitOnly();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _bearController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _slideController, curve: Curves.easeOutBack));
    _bearAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _bearController, curve: Curves.elasticOut));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _bearController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _bearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppTheme.primaryColor,
        AppTheme.backgroundColor,
      ],
    );

    return OrientationAwareWidget(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: backgroundGradient),
          child: SafeArea(
            child: Stack(
              children: [
                _buildBackgroundParticles(),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;

                    if (screenWidth < 600) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child:
                                  WelcomeSection(bearAnimation: _bearAnimation),
                            ),
                            const SizedBox(height: 40),
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: LoginButtons(
                                  onGoogleSignIn: () =>
                                      _handleGoogleSignIn(context),
                                  onGuestSignIn: () =>
                                      _handleGuestSignIn(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child:
                                  WelcomeSection(bearAnimation: _bearAnimation),
                            ),
                          ),
                          Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: LoginButtons(
                                  onGoogleSignIn: () =>
                                      _handleGoogleSignIn(context),
                                  onGuestSignIn: () =>
                                      _handleGuestSignIn(context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundParticles() => const SizedBox.shrink();

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final success = await userService.signInWithGoogle();

      if (success && mounted) {
        await OrientationService().setLandscapeOnly();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else if (mounted) {
        final error = userService.errorMessage ?? 'Error al iniciar sesión con Google';
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ));
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text('Ocurrió un error inesperado: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _handleGuestSignIn(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final success = await userService.signInAsGuest();

      if (success && mounted) {
        await OrientationService().setLandscapeOnly();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else if (mounted) {
        final error = userService.errorMessage ?? 'Error al ingresar como invitado';
        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ));
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text('Ocurrió un error inesperado: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
