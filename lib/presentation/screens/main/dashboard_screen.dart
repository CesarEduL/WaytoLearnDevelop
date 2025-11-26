import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/orientation_service.dart';
import '../../../core/services/user_service.dart';
import '../../../core/theme/child_colors.dart';
import '../../../core/theme/child_text_styles.dart';
import '../../../core/widgets/child_header.dart';
import '../../../core/widgets/modern_child_card.dart';
import '../../../core/widgets/orientation_aware_widget.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../auth/login_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/progress_reports_screen.dart';
import '../parents/parents_area_screen.dart';
import '../communication/comm_index_screen_sessions.dart';
import '../mathematics/math_index_screen_sessions.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Permitir rotación automática
    OrientationService().enableAutoOrientation();
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Estás seguro que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ChildColors.pinkSweet,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      final userService = Provider.of<UserService>(context, listen: false);
      await userService.signOut();
      
      if (context.mounted) {
        await OrientationService().setPortraitOnly();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final childName = userService.currentUser?.name ?? 'Amiguito';

    return Scaffold(
      backgroundColor: ChildColors.background,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header con nombre del niño y logout
            ChildHeader(
              childName: childName,
              onLogout: () => _handleLogout(context),
            ),
            
            // Contenido principal responsivo
            Expanded(
              child: ResponsiveLayout(
                mobileBody: _buildVerticalLayout(context, userService),
                desktopBody: _buildHorizontalLayout(context, userService),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalLayout(BuildContext context, UserService userService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de bienvenida
          Text(
            '¿Qué quieres aprender hoy?',
            style: ChildTextStyles.title.copyWith(
              color: ChildColors.purpleMagic,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),

          // Racha y Nivel
          _buildStreakSection(userService),
          const SizedBox(height: 16),
          _buildLevelSection(userService),
          const SizedBox(height: 24),
          
          // Categorías en lista vertical
          _buildCategoryCard(
            context: context,
            title: 'Comunicación',
            icon: Icons.menu_book,
            gradient: ChildColors.blueGradient,
            onTap: () => _navigateToSubject(context, 'communication'),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            context: context,
            title: 'Matemáticas',
            icon: Icons.calculate,
            gradient: ChildColors.greenGradient,
            onTap: () => _navigateToSubject(context, 'math'),
          ),
          
          const SizedBox(height: 24),
          
          // Tarjeta de Área de Padres
          _buildParentsAreaCard(context, userService),
          
          const SizedBox(height: 24),
          
          // Sección de progreso
          _buildProgressSection(userService),

          const SizedBox(height: 24),

          // Logros
          _buildAchievementsSection(userService),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout(BuildContext context, UserService userService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de bienvenida
          Text(
            '¿Qué quieres aprender hoy?',
            style: ChildTextStyles.title.copyWith(
              color: ChildColors.purpleMagic,
            ),
          ),
          const SizedBox(height: 24),

          // Racha y Nivel en fila
          Row(
            children: [
              Expanded(child: _buildStreakSection(userService)),
              const SizedBox(width: 20),
              Expanded(child: _buildLevelSection(userService)),
            ],
          ),
          const SizedBox(height: 24),
          
          // Grid de categorías
          Row(
            children: [
              // Comunicación
              Expanded(
                child: _buildCategoryCard(
                  context: context,
                  title: 'Comunicación',
                  icon: Icons.menu_book,
                  gradient: ChildColors.blueGradient,
                  onTap: () => _navigateToSubject(context, 'communication'),
                ),
              ),
              const SizedBox(width: 20),
              // Matemáticas
              Expanded(
                child: _buildCategoryCard(
                  context: context,
                  title: 'Matemáticas',
                  icon: Icons.calculate,
                  gradient: ChildColors.greenGradient,
                  onTap: () => _navigateToSubject(context, 'math'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Tarjeta de Área de Padres
          _buildParentsAreaCard(context, userService),
          
          const SizedBox(height: 24),
          
          // Sección de progreso y logros
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildProgressSection(userService)),
              const SizedBox(width: 20),
              Expanded(child: _buildAchievementsSection(userService)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return ModernChildCard(
      onTap: onTap,
      gradient: gradient,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono grande
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Título
          Text(
            title,
            style: ChildTextStyles.subtitle.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Botón de acción
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '¡Vamos!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(UserService userService) {
    final user = userService.currentUser;
    double commProgress = 0.0;
    double mathProgress = 0.0;

    if (user != null) {
      final commUnlocked = user.getHighestUnlockedIndex('communication');
      commProgress = (commUnlocked / 28.0).clamp(0.0, 1.0);

      final mathUnlocked = user.getHighestUnlockedIndex('mathematics');
      mathProgress = (mathUnlocked / 28.0).clamp(0.0, 1.0);
    }

    return ModernChildCard(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: ChildColors.yellowSun,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Tu Progreso',
                style: ChildTextStyles.subtitle.copyWith(
                  color: ChildColors.purpleMagic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildProgressItem('Comunicación', commProgress, ChildColors.blueSky),
          const SizedBox(height: 12),
          _buildProgressItem('Matemáticas', mathProgress, ChildColors.greenHappy),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: ChildTextStyles.body,
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: ChildTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildParentsAreaCard(BuildContext context, UserService userService) {
    final user = userService.currentUser;
    
    // Datos de Comunicación
    int commCurrentSession = 1;
    int commStoriesCompleted = 0;
    double commOverallProgress = 0.0;
    
    // Datos de Matemáticas
    int mathCurrentSession = 1;
    int mathStoriesCompleted = 0;
    double mathOverallProgress = 0.0;
    
    if (user != null) {
      // Cálculo Comunicación
      final commUnlocked = user.getHighestUnlockedIndex('communication');
      commCurrentSession = (commUnlocked ~/ 7) + 1;
      if (commCurrentSession > 4) commCurrentSession = 4;
      
      int commStoriesInSession = commUnlocked % 7;
      if (commStoriesInSession == 0 && commUnlocked > 0) {
        commStoriesInSession = 7;
      }
      commOverallProgress = (commUnlocked / 28.0).clamp(0.0, 1.0);
      commStoriesCompleted = commStoriesInSession;

      // Cálculo Matemáticas
      final mathUnlocked = user.getHighestUnlockedIndex('mathematics');
      mathCurrentSession = (mathUnlocked ~/ 7) + 1;
      if (mathCurrentSession > 4) mathCurrentSession = 4;
      
      int mathStoriesInSession = mathUnlocked % 7;
      if (mathStoriesInSession == 0 && mathUnlocked > 0) {
        mathStoriesInSession = 7;
      }
      mathOverallProgress = (mathUnlocked / 28.0).clamp(0.0, 1.0);
      mathStoriesCompleted = mathStoriesInSession;
    }

    return ModernChildCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ParentsAreaScreen()),
        );
      },
      gradient: const LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF4FC3F7)], // Azul/Violeta para englobar ambos
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título con icono
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.family_restroom,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Área de Padres',
                      style: ChildTextStyles.subtitle.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ver progreso detallado',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.8),
                size: 24,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Información de progreso dividida
          Row(
            children: [
              // Columna Comunicación
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Comunicación',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(commOverallProgress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sesión $commCurrentSession',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Columna Matemáticas
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Matemáticas',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(mathOverallProgress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Sesión $mathCurrentSession',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToSubject(BuildContext context, String subject) async {
    if (subject == 'communication') {
      await OrientationService().setLandscapeOnly();
      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const CommIndexScreenSessions(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MathIndexScreenSessions(),
        ),
      );
    }
  }

  Widget _buildStreakSection(UserService userService) {
    final streak = userService.currentUser?.streak ?? 0;
    
    return ModernChildCard(
      gradient: const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
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
              Icons.local_fire_department,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$streak Días',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '¡Racha de aprendizaje!',
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

  Widget _buildLevelSection(UserService userService) {
    final user = userService.currentUser;
    final level = user?.currentLevel ?? 1;
    final xp = user?.experiencePoints ?? 0;
    final nextLevelXp = user?.experienceToNextLevel ?? 100;
    final progress = (xp / nextLevelXp).clamp(0.0, 1.0);

    return ModernChildCard(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: ChildColors.yellowSun,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Nivel $level',
                    style: ChildTextStyles.subtitle.copyWith(
                      color: ChildColors.purpleMagic,
                    ),
                  ),
                ],
              ),
              Text(
                '$xp / $nextLevelXp XP',
                style: ChildTextStyles.body.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 16,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(ChildColors.yellowSun),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '¡Sigue así para llegar al nivel ${level + 1}!',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(UserService userService) {
    // Simulación de logros por ahora
    final achievements = [
      {'icon': Icons.emoji_events, 'color': Colors.amber, 'name': 'Primeros Pasos'},
      {'icon': Icons.menu_book, 'color': Colors.blue, 'name': 'Lector'},
      {'icon': Icons.calculate, 'color': Colors.green, 'name': 'Matemático'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tus Logros',
          style: ChildTextStyles.subtitle.copyWith(
            color: ChildColors.purpleMagic,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      achievement['icon'] as IconData,
                      color: achievement['color'] as Color,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      achievement['name'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del drawer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: ChildColors.purpleGradient,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 36,
                      color: ChildColors.purpleMagic,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Menú',
                      style: ChildTextStyles.subtitle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            // Opciones del menú
            ListTile(
              leading: const Icon(Icons.insert_chart_outlined, size: 28),
              title: const Text('Informes de progreso', style: ChildTextStyles.body),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProgressReportsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.family_restroom, size: 28),
              title: const Text('Área de padres', style: ChildTextStyles.body),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentsAreaScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, size: 28),
              title: const Text('Mi perfil', style: ChildTextStyles.body),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, size: 28, color: ChildColors.pinkSweet),
              title: Text(
                'Cerrar sesión',
                style: ChildTextStyles.body.copyWith(color: ChildColors.pinkSweet),
              ),
              onTap: () {
                Navigator.pop(context); // Cerrar drawer
                _handleLogout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
