import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/orientation_service.dart';
import '../../../core/widgets/orientation_aware_widget.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../auth/login_screen.dart';
import '../main/dashboard_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/progress_reports_screen.dart';

class ParentsAreaScreen extends StatefulWidget {
  const ParentsAreaScreen({super.key});

  @override
  State<ParentsAreaScreen> createState() => _ParentsAreaScreenState();
}

class _ParentsAreaScreenState extends State<ParentsAreaScreen> {
  // URL del oso desde Firebase Storage
  static const String _bearImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FOSO%20CON%20UN%20LIBRO_%202.png?alt=media&token=ef9324fd-da34-49f3-a52b-7faf3121dc25';

  @override
  void initState() {
    super.initState();
    // Permitir rotación automática
    OrientationService().enableAutoOrientation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<UserService>(
          builder: (context, userService, child) {
            final isAuthenticated = userService.isAuthenticated;
            
            return ResponsiveLayout(
              mobileBody: Padding(
                padding: const EdgeInsets.all(16),
                child: !isAuthenticated
                    ? _buildNotConnectedView(context)
                    : _buildConnectedView(context, isMobile: true),
              ),
              desktopBody: Padding(
                padding: const EdgeInsets.all(20),
                child: !isAuthenticated
                    ? _buildNotConnectedView(context)
                    : _buildConnectedView(context, isMobile: false),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildNotConnectedView(BuildContext context) {
    return Column(
        children: [
          // Alerta naranja/roja
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2), // Naranja claro
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.red.shade400,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Icono de advertencia
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Textos de alerta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cuenta no conectada',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Conecta tu cuenta para acceder a funciones avanzadas',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Link para vincular
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: Text(
              'Presiona aquí para vincular',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Oso con burbuja de diálogo
          _buildBearWithSpeechBubble(
            'Ups, parece que debemos iniciar sesión con nuestra cuenta.',
          ),
        ],
    );
  }

  Widget _buildConnectedView(BuildContext context, {required bool isMobile}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección "Tus hijos"
          _buildChildrenSection(),
          
          const SizedBox(height: 24),

          // Tarjetas de acción (Movidar arriba según feedback)
          _buildActionCards(context, isMobile: isMobile),
          
          const SizedBox(height: 24),

          // Consejos Pedagógicos
          _buildPedagogicalTips(),

          const SizedBox(height: 24),

          // Gráfico de Actividad (Mejorado)
          _buildActivityChart(),
          
          const SizedBox(height: 24),
          
          // Sección de progreso detallado
          _buildDetailedProgressSection(),
        ],
      ),
    );
  }

  Widget _buildChildrenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Botón home circular azul
            GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
              ),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF64B5F6), // Azul claro
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Avatar del niño (placeholder)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.amber.shade200,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  'PLACEHOLDER_AVATAR_URL', // Placeholder para avatar del niño
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.amber,
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Título "Tus hijos"
            const Text(
              'Tus hijos',
              style: TextStyle(
                color: Color(0xFF7B2CBF), // Púrpura oscuro
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const Spacer(),
            
            // Botones para agregar hijos (4 círculos con +)
            Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedProgressSection() {
    return Consumer<UserService>(
      builder: (context, userService, _) {
        final user = userService.currentUser;
        
        // --- Datos de Comunicación ---
        int commUnlocked = 0;
        double commProgress = 0.0;
        
        // --- Datos de Matemáticas ---
        int mathUnlocked = 0;
        double mathProgress = 0.0;
        
        if (user != null) {
          // Comunicación
          commUnlocked = user.getHighestUnlockedIndex('communication');
          commProgress = (commUnlocked / 28.0).clamp(0.0, 1.0);

          // Matemáticas
          mathUnlocked = user.getHighestUnlockedIndex('mathematics');
          mathProgress = (mathUnlocked / 28.0).clamp(0.0, 1.0);
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: const Color(0xFF7B2CBF),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Progreso Detallado',
                  style: TextStyle(
                    color: Color(0xFF7B2CBF),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // --- Tarjetas de Resumen (Sesión Actual, Cuentos, etc.) ---
            // Nota: Por simplicidad visual, mantenemos las tarjetas superiores enfocadas en el 
            // progreso general o podríamos alternarlas. Para este diseño, mostraremos 
            // el desglose por materia abajo y dejaremos las tarjetas superiores como "Resumen Global"
            // o las ocultaremos si se prefiere un diseño más limpio por materia.
            // Dado el requerimiento, vamos a enfocar en las barras de progreso por materia.

            // Barra de progreso Comunicación
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.menu_book,
                              color: Color(0xFF8B5CF6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Comunicación',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7B2CBF),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$commUnlocked/28 cuentos',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: commProgress,
                      minHeight: 16,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // Barra de progreso Matemáticas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF14B8A6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.calculate,
                              color: Color(0xFF14B8A6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Matemáticas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D9488), // Teal oscuro
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$mathUnlocked/28 ejercicios',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: mathProgress,
                      minHeight: 16,
                      backgroundColor: const Color(0xFFE5E7EB),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF14B8A6), // Teal
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Sección de Observaciones del Aprendizaje
            _buildPerformanceObservations(),

            const SizedBox(height: 16),
            
            // Asistencia de IA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFBBF24).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Asistencia de IA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user != null 
                            ? 'Analizando patrones de aprendizaje para personalizar ejercicios'
                            : 'No disponible sin cuenta',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPerformanceObservations() {
    return Consumer<UserService>(
      builder: (context, userService, _) {
        final user = userService.currentUser;
        double commProgress = 0.0;
        double mathProgress = 0.0;

        if (user != null) {
          final commUnlocked = user.getHighestUnlockedIndex('communication');
          commProgress = (commUnlocked / 28.0).clamp(0.0, 1.0);
          final mathUnlocked = user.getHighestUnlockedIndex('mathematics');
          mathProgress = (mathUnlocked / 28.0).clamp(0.0, 1.0);
        }

        String strengths = 'Muestra interés inicial en las actividades.';
        String improvements = 'Continuar explorando los diferentes módulos.';
        String recommendations = 'Dedicar unos minutos al día para crear hábito.';

        if (commProgress > 0.3) {
          strengths = 'Ha avanzado notablemente en comprensión lectora y vocabulario.';
        }
        if (mathProgress > 0.3) {
          strengths += ' Muestra agilidad en ejercicios numéricos básicos.';
        }

        if (commProgress < 0.1 && mathProgress < 0.1) {
          improvements = 'Se recomienda iniciar con los cuentos interactivos para captar su atención.';
        } else if (commProgress > mathProgress) {
          improvements = 'Podría equilibrar su aprendizaje explorando más el área de matemáticas.';
        } else {
          improvements = 'Podría reforzar la lectura para complementar sus habilidades lógicas.';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: const Color(0xFFEC4899),
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Observaciones del Aprendizaje',
                  style: TextStyle(
                    color: Color(0xFFBE185D), // Pink oscuro
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFCE7F3), // Pink muy claro
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEC4899).withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildObservationItem(
                    'Fortalezas',
                    strengths,
                    Icons.star,
                    const Color(0xFFF59E0B), // Amber
                  ),
                  const Divider(height: 24),
                  _buildObservationItem(
                    'Áreas de Mejora',
                    improvements,
                    Icons.trending_up,
                    const Color(0xFF3B82F6), // Blue
                  ),
                  const Divider(height: 24),
                  _buildObservationItem(
                    'Recomendaciones',
                    recommendations,
                    Icons.lightbulb,
                    const Color(0xFF10B981), // Emerald
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildObservationItem(String title, String content, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards(BuildContext context, {required bool isMobile}) {
    final actions = [
      _buildInfoCard(
        context,
        title: 'Perfil',
        subtitle: 'Editar datos',
        icon: Icons.person,
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        ),
      ),
      Consumer<UserService>(
        builder: (context, userService, _) {
          final user = userService.currentUser;
          String progressLabel = '0/7';
          if (user != null) {
            final unlocked = user.getHighestUnlockedIndex('communication');
            progressLabel = '$unlocked/7';
          }
          
          return _buildInfoCard(
            context,
            title: 'Progreso',
            subtitle: 'Nivel $progressLabel',
            icon: Icons.bar_chart,
            gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProgressReportsScreen()),
            ),
          );
        }
      ),
      _buildInfoCard(
        context,
        title: 'Tiempo de uso',
        subtitle: '45 min hoy', // Dato simulado/real
        icon: Icons.hourglass_bottom,
        gradient: const LinearGradient(
          colors: [Color(0xFF84CC16), Color(0xFF65A30D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Detalle de tiempo próximamente')),
          );
        },
      ),
      _buildInfoCard(
        context,
        title: 'Descargas',
        subtitle: '3 cuentos', // Dato simulado
        icon: Icons.download_done_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gestor de descargas próximamente')),
          );
        },
      ),
    ];

    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1, // Más anchas para que quepa el texto
        children: actions,
      );
    }

    return Row(
      children: actions.map((widget) => Expanded(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: widget,
      ))).toList(),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140, // Fixed height to prevent layout errors with Spacer/Expanded
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (gradient as LinearGradient).colors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Icono de fondo (marca de agua)
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                icon,
                size: 80,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use spaceBetween instead of Spacer
                children: [
                  Icon(icon, color: Colors.white, size: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    Color color,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icono en contenedor blanco
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
            
            // Texto
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChart() {
    // Datos simulados de actividad semanal (en minutos)
    final activityData = [15, 45, 30, 60, 20, 90, 45];
    final days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    final maxTime = 90.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time_filled,
              color: Colors.blue.shade700,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Tiempo de Aprendizaje (minutos)',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final height = (activityData[index] / maxTime) * 100;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${activityData[index]}m',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 20,
                        height: height,
                        decoration: BoxDecoration(
                          color: activityData[index] > 40 
                              ? Colors.blue.shade600 
                              : Colors.blue.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        days[index],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 12),
              Text(
                'Esta semana has aprendido 305 minutos. ¡Excelente!',
                style: TextStyle(
                  color: Colors.blue.shade800,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPedagogicalTips() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consejo del Día',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Fomenta la curiosidad haciendo preguntas abiertas sobre los cuentos leídos.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBearWithSpeechBubble(String message) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Burbuja de diálogo
        Positioned(
          bottom: 120,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        
        // Oso
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.network(
              _bearImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.brown.shade300,
                  child: const Icon(
                    Icons.pets,
                    size: 60,
                    color: Colors.brown,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
