import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/orientation_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/orientation_aware_widget.dart';

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
    // Asegurar que la orientación horizontal esté configurada
    OrientationService().setLandscapeOnly();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bearController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _bearAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bearController,
      curve: Curves.elasticOut,
    ));
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
    return OrientationAwareWidget(
      forceLandscape: true,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor,
                AppTheme.backgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Partículas de fondo
                _buildBackgroundParticles(),
                
                // Contenido principal responsive
                LayoutBuilder(
                  builder: (context, constraints) {
                    final screenWidth = constraints.maxWidth;
                    final screenHeight = constraints.maxHeight;
                    
                    // Si la pantalla es muy pequeña, usar layout vertical
                    if (screenWidth < 600) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            // Logo y título
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedBearLogo(),
                                  const SizedBox(height: 20),
                                  _buildWelcomeTitle(),
                                  const SizedBox(height: 10),
                                  _buildWelcomeSubtitle(),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Botones de login
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildLoginSection(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    // Layout horizontal para pantallas más grandes
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          // Lado izquierdo - Logo y título
                          Expanded(
                            flex: 1,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnimatedBearLogo(),
                                  const SizedBox(height: 24),
                                  _buildWelcomeTitle(),
                                  const SizedBox(height: 12),
                                  _buildWelcomeSubtitle(),
                                ],
                              ),
                            ),
                          ),

                          // Separador vertical
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

                          // Lado derecho - Botones de login
                          Expanded(
                            flex: 1,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: _buildLoginSection(),
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

  Widget _buildBackgroundParticles() {
    return const SizedBox.shrink();
  }

  Widget _buildAnimatedBearLogo() {
    return AnimatedBuilder(
      animation: _bearController,
      builder: (context, child) {
        // Calcular tamaño responsive
        final screenWidth = MediaQuery.of(context).size.width;
        final logoSize = (screenWidth * 0.15).clamp(100.0, 140.0);
        final innerSize = (logoSize * 0.5).clamp(50.0, 72.0);
        
        return Transform.scale(
          scale: _bearAnimation.value,
          child: Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: innerSize,
                height: innerSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.75),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'W',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: innerSize * 0.4,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeTitle() {
    // Calcular tamaño responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = (screenWidth * 0.04).clamp(20.0, 28.0);
    
    return Text(
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
    );
  }

  Widget _buildWelcomeSubtitle() {
    // Calcular tamaño responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final subtitleFontSize = (screenWidth * 0.025).clamp(14.0, 18.0);
    
    return Container(
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
    );
  }

  Widget _buildLoginSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Título de la sección de login
        Text(
          'Iniciar Sesión',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: const [
              Shadow(
                color: Colors.black54,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),

        // Botón de Google Sign In
        Consumer<UserService>(
          builder: (context, userService, child) {
            // Calcular tamaño responsive
            final screenWidth = MediaQuery.of(context).size.width;
            final buttonWidth = (screenWidth * 0.3).clamp(250.0, 350.0);
            
            return Container(
              width: buttonWidth,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: userService.isLoading
                    ? null
                    : () => _handleGoogleSignIn(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (userService.isLoading) ...[
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Iniciando sesión...'
                      ),
                    ] else ...[
                      // Círculo con la letra "G" (sin imágenes)
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black87, width: 1),
                        ),
                        child: const Center(
                          child: Text(
                            'G',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Continuar con Google',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 20),

        // Texto informativo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Text(
            'Al continuar, aceptas nuestros términos y condiciones',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.8),
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

        const SizedBox(height: 24),

        // Información adicional con icono de seguridad
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.security,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Tu información está segura y solo se usa para personalizar tu experiencia de aprendizaje',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    final userService = Provider.of<UserService>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    try {
      final success = await userService.signInWithGoogle();
      
      if (success && mounted) {
        // Asegurar orientación horizontal antes de ir al dashboard
        await OrientationService().setLandscapeOnly();
        // Ir al dashboard tras iniciar sesión correctamente
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (mounted) {
        // Mostrar error si no fue exitoso
        _showErrorSnackBar(scaffoldMessenger, userService.errorMessage ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(scaffoldMessenger, 'Error inesperado: $e');
      }
    }
  }

  void _showErrorSnackBar(ScaffoldMessengerState scaffoldMessenger, String message) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Pintor personalizado para las partículas de fondo del login
class LoginParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Dibujar partículas flotantes más sutiles
    for (int i = 0; i < 20; i++) {
      final x = (i * 37.0) % size.width;
      final y = (i * 61.0) % size.height;
      final radius = 1.0 + (i % 2) * 0.5;
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
