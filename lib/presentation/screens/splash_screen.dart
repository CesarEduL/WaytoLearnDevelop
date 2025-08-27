import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/user_service.dart';
import '../../core/theme/app_theme.dart';
import 'auth/login_screen.dart';
import 'main/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Controlador para la animación del logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Controlador para la animación del texto
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Controlador para la animación del fondo
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Animación del logo (escala, rotación y rebote)
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Animación del texto (fade in con slide)
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    ));

    // Animación de color del fondo
    _colorAnimation = ColorTween(
      begin: AppTheme.backgroundColor,
      end: AppTheme.primaryColor,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // Animación del fondo con partículas
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() async {
    // Iniciar animación del fondo
    _backgroundController.forward();
    
    // Iniciar animación del logo
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoController.forward();
    
    // Iniciar animación del texto
    await Future.delayed(const Duration(milliseconds: 200));
    await _textController.forward();
    
    // Esperar un poco más para que se vea la animación completa
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Navegar a la siguiente pantalla
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    final userService = Provider.of<UserService>(context, listen: false);
    
    if (userService.isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _colorAnimation.value ?? AppTheme.backgroundColor,
                  AppTheme.backgroundColor,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Partículas de fondo animadas
                _buildBackgroundParticles(),
                
                // Contenido principal
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo animado del osito
                      _buildAnimatedLogo(),
                      
                      const SizedBox(height: 50),
                      
                      // Título de la aplicación
                      _buildAnimatedTitle(),
                      
                      const SizedBox(height: 60),
                      
                      // Indicador de carga personalizado
                      _buildCustomLoadingIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundParticles() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            animation: _backgroundAnimation.value,
            color: AppTheme.secondaryColor.withOpacity(0.3),
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value,
          child: Transform.rotate(
            angle: _logoAnimation.value * 0.05,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 15),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Fondo del logo con patrón sutil
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.grey.shade50,
                        ],
                      ),
                    ),
                  ),
                  
                  // Contenido del logo
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Osito de peluche (representado con iconos)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.brown.shade300,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.brown.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.face,
                            size: 50,
                            color: Colors.brown,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Libro
                        Container(
                          width: 60,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.book,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
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

  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _textAnimation.value)),
            child: Column(
              children: [
                // Título principal
                Text(
                  'WaytoLearn',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Subtítulo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Aprende jugando con tu amigo oso',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomLoadingIndicator() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Opacity(
          opacity: _textAnimation.value,
          child: Column(
            children: [
              // Indicador de carga personalizado
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.9),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.2),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Texto de carga
              Text(
                'Preparando tu aventura de aprendizaje...',
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
              ),
            ],
          ),
        );
      },
    );
  }
}

// Pintor personalizado para las partículas de fondo
class ParticlePainter extends CustomPainter {
  final double animation;
  final Color color;

  ParticlePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Dibujar partículas flotantes
    for (int i = 0; i < 15; i++) {
      final x = (i * 47.0) % size.width;
      final y = (i * 73.0 + animation * 100) % size.height;
      final radius = 2.0 + (i % 3) * 1.0;
      
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
