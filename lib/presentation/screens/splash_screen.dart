import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/user_service.dart';
import '../../core/services/orientation_service.dart';
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
    // Configurar orientación vertical para el splash screen
    OrientationService().setPortraitOnly();
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
      begin: AppTheme.primaryColor,
      end: const Color(0xFF5B8CFF),
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

  void _navigateToNextScreen() async {
    // Cambiar a orientación horizontal antes de navegar
    await OrientationService().setLandscapeOnly();
    
    // Navegar directamente al dashboard sin verificar autenticación
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
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
                  _colorAnimation.value ?? AppTheme.primaryColor,
                  AppTheme.primaryColor,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Partículas de fondo animadas
                _buildBackgroundParticles(),
                
                // Contenido principal con SafeArea y padding
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo animado (placeholder Panda)
                            _buildAnimatedPanda(),
                            
                            const SizedBox(height: 30),
                            
                            // Título de la aplicación
                            _buildAnimatedTitle(),
                            
                            const SizedBox(height: 40),
                            
                            // Indicador de carga personalizado
                            _buildCustomLoadingIndicator(),
                          ],
                        ),
                      ),
                    ),
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

  Widget _buildAnimatedPanda() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        // Calcular tamaño responsive basado en el ancho de la pantalla
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final pandaSize = (screenWidth * 0.4).clamp(120.0, 200.0);
        
        return Transform.scale(
          scale: _logoAnimation.value,
          child: Transform.rotate(
            angle: _logoAnimation.value * 0.03,
            child: _PandaPlaceholder(size: pandaSize),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitle() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        // Calcular tamaños responsive
        final screenWidth = MediaQuery.of(context).size.width;
        final titleFontSize = (screenWidth * 0.08).clamp(28.0, 44.0);
        final subtitleFontSize = (screenWidth * 0.04).clamp(14.0, 20.0);
        
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
                    fontWeight: FontWeight.w800,
                    fontSize: titleFontSize,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 12),
                
                // Subtítulo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.28),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'La aplicación interactiva n.º 1 para niños',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: subtitleFontSize,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(0, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
                    Colors.white.withOpacity(0.95),
                  ),
                  backgroundColor: Colors.white.withOpacity(0.24),
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

// Placeholder de Panda (vector simple con shapes)
class _PandaPlaceholder extends StatelessWidget {
  final double size;
  const _PandaPlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    final double head = size * 0.58;
    final double ear = head * 0.28;
    final double eye = head * 0.22;
    final double pupil = eye * 0.45;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sombra
          Positioned(
            bottom: size * 0.05,
            child: Container(
              width: head * 0.9,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Cuerpo
          Positioned(
            bottom: size * 0.18,
            child: Container(
              width: head * 0.95,
              height: head * 0.58,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B6B),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          // Cabeza
          Container(
            width: head,
            height: head,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
          ),
          // Orejas
          Positioned(
            top: size * 0.16,
            left: size * 0.28,
            child: _circle(ear, Colors.black),
          ),
          Positioned(
            top: size * 0.16,
            right: size * 0.28,
            child: _circle(ear, Colors.black),
          ),
          // Ojos
          Positioned(
            top: size * 0.28,
            left: size * 0.34,
            child: _circle(eye, Colors.black),
          ),
          Positioned(
            top: size * 0.28,
            right: size * 0.34,
            child: _circle(eye, Colors.black),
          ),
          // Pupilas
          Positioned(
            top: size * 0.34,
            left: size * 0.38,
            child: _circle(pupil, Colors.white),
          ),
          Positioned(
            top: size * 0.34,
            right: size * 0.38,
            child: _circle(pupil, Colors.white),
          ),
          // Boca
          Positioned(
            top: size * 0.46,
            child: Container(
              width: head * 0.24,
              height: head * 0.12,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5A76),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}
