import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/orientation_service.dart';
import '../../../core/models/user_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/orientation_aware_widget.dart';
import '../profile/profile_screen.dart';
import '../profile/progress_reports_screen.dart';
import '../parents/parents_area_screen.dart';
import '../splash_screen.dart';
import '../exercises/exercise_selection_screen.dart';
import '../communication/session_progress_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bearController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      begin: const Offset(0, 0.2),
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
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
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
        backgroundColor: const Color(0xFFF8FAFC), // Fondo más suave
        drawer: _buildDrawer(context),
        body: SafeArea(
          child: Consumer<UserService>(
            builder: (context, userService, child) {
              // Usar usuario por defecto si no hay autenticación
              final user = userService.currentUser ?? UserModel(
                id: 'default',
                name: 'Estudiante',
                email: 'estudiante@waytolearn.com',
                age: 8,
                grade: '3er Grado',
                avatar: 'default_avatar',
                currentLevel: 1,
                experiencePoints: 150,
                totalPoints: 150,
                achievements: ['Primer logro', 'Explorador'],
                createdAt: DateTime.now(),
                lastLoginAt: DateTime.now(),
              );

              return CustomScrollView(
                slivers: [
                  // AppBar modernizado con glassmorphism
                  _buildModernAppBar(user),
                  
                  // Contenido principal con mejor espaciado
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 20.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Tarjeta de progreso mejorada
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildModernProgressCard(user, userService),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Sección de nivel y estadísticas rápidas
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildQuickStatsSection(user),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Temas con diseño mejorado
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildModernSubjectsSection(context),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Recomendaciones diarias modernizadas
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildModernDailyRecommendations(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Mundos para explorar con mejor diseño
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildModernWorldsSection(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Logros recientes mejorados
                        if (user.achievements.isNotEmpty)
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: _buildModernAchievementsSection(user),
                            ),
                          ),

                        const SizedBox(height: 24),

                        // Estadísticas detalladas
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: _buildModernStatsSection(user),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildModernAppBar(UserModel user) {
    return SliverAppBar(
      expandedHeight: 80, // Reducido de 160 a 80
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    leading: Builder(
      builder: (ctx) => Container(
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, 2))],
        ),
        child: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
    ),

      flexibleSpace: FlexibleSpaceBar(
                 background: Container(
           decoration: BoxDecoration(
             color: Colors.transparent,
           ),
          child: Stack(
            children: [
              // Patrón de fondo moderno
              Positioned.fill(
                child: CustomPaint(
                  painter: ModernPatternPainter(),
                ),
              ),
                             // Elementos decorativos
              // Círculos decorativos
              Positioned(
                top: 40,
                left: 40,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 80,
                right: 80,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.person, color: AppTheme.primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.primaryColor),
            onPressed: () => _showLogoutDialog(context),
          ),
        ),
      ],
    );
  }

  Widget _buildModernProgressCard(UserModel user, UserService userService) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.9),
            AppTheme.secondaryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tu Progreso',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Nivel ${user.currentLevel} • ${user.totalPoints} puntos',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${(user.levelProgress * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Barra de progreso mejorada
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white.withOpacity(0.2),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: user.levelProgress,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.9),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Indicador de progreso con brillo
                  if (user.levelProgress > 0)
                    Positioned(
                      left: (user.levelProgress * 100) - 2,
                      top: 0,
                      child: Container(
                        width: 4,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${user.experiencePoints} / ${user.experienceToNextLevel} XP para el siguiente nivel',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection(UserModel user) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStatCard(
            'Nivel Actual',
            '${user.currentLevel}',
            Icons.star,
            AppTheme.primaryColor,
            '¡Excelente trabajo!',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildQuickStatCard(
            'Total Puntos',
            '${user.totalPoints}',
            Icons.emoji_events,
            AppTheme.accentColor,
            'Puntos acumulados',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildQuickStatCard(
            'Experiencia',
            '${user.experiencePoints}',
            Icons.flash_on,
            AppTheme.secondaryColor,
            'XP ganados',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModernSubjectsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernSectionHeader(
          icon: Icons.school,
          color: AppTheme.primaryColor,
          title: 'Temas de Aprendizaje',
          subtitle: 'Explora diferentes materias',
        ),
        const SizedBox(height: 20),
        
        Row(
          children: [
            Expanded(
              child: _buildModernSubjectCard(
                context,
                'Matemáticas',
                Icons.calculate,
                AppTheme.primaryColor,
                'Números y operaciones',
                () => _navigateToSubject(context, 'mathematics'),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildModernSubjectCard(
                context,
                'Comunicación',
                Icons.chat_bubble,
                AppTheme.secondaryColor,
                'Lenguaje y expresión',
                () => _navigateToSubject(context, 'communication'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernSectionHeader({required IconData icon, required Color color, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
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
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernSubjectCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Patrón de fondo
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Indicador de acción
            Positioned(
              bottom: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDailyRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernSectionHeader(
          icon: Icons.recommend,
          color: AppTheme.secondaryColor,
          title: 'Recomendaciones Diarias',
          subtitle: 'Actividades personalizadas para ti',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final locked = index != 0;
              return _ModernRecommendationTile(
                locked: locked,
                label: locked ? 'Bloqueado' : 'División',
                color: AppTheme.secondaryColor,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernWorldsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernSectionHeader(
          icon: Icons.public,
          color: AppTheme.accentColor,
          title: 'Mundos para Explorar',
          subtitle: 'Descubre nuevos temas',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) {
              final colors = [
                const Color(0xFF60A5FA),
                const Color(0xFFF59E0B),
                const Color(0xFF34D399),
                const Color(0xFFF472B6),
                const Color(0xFFA78BFA),
                const Color(0xFF22D3EE),
              ];
              final c = colors[i % colors.length];
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: c.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.tag_faces,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernAchievementsSection(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModernSectionHeader(
          icon: Icons.emoji_events,
          color: AppTheme.goldColor,
          title: 'Logros Desbloqueados',
          subtitle: 'Tus conquistas',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: user.achievements.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.goldColor,
                      AppTheme.goldColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.goldColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Logro ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildModernStatsSection(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estadísticas Detalladas',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Resumen de tu progreso',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildModernStatItem(
                  'Total Puntos',
                  '${user.totalPoints}',
                  Icons.stars,
                  AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: _buildModernStatItem(
                  'Nivel',
                  '${user.currentLevel}',
                  Icons.trending_up,
                  AppTheme.accentColor,
                ),
              ),
              Expanded(
                child: _buildModernStatItem(
                  'Experiencia',
                  '${user.experiencePoints}',
                  Icons.flash_on,
                  AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 35,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.goldColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.emoji_events,
                color: AppTheme.goldColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Logros Desbloqueados',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: user.achievements.length,
            itemBuilder: (context, index) {
              return Container(
                width: 85,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.goldColor,
                      AppTheme.goldColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.goldColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                                         const Icon(
                       Icons.emoji_events,
                       color: Colors.white,
                       size: 24,
                     ),
                    const SizedBox(height: 4),
                    Text(
                      'Logro ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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

    Widget _buildStatsSection(UserModel user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Estadísticas',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Layout mejorado para orientación horizontal
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Puntos',
                    '${user.totalPoints}',
                    Icons.stars,
                    AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Nivel',
                    '${user.currentLevel}',
                    Icons.trending_up,
                    AppTheme.accentColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Experiencia',
                    '${user.experiencePoints}',
                    Icons.flash_on,
                    AppTheme.secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _navigateToSubject(BuildContext context, String subject) async {
    if (subject == 'communication') {
      await OrientationService().setLandscapeOnly();
      
      if (!context.mounted) return;
      
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SessionProgressScreen(),
        ),
      );
      
      
      
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExerciseSelectionScreen(subject: subject),
        ),
      );
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
                         const Icon(
               Icons.logout,
               color: AppTheme.primaryColor,
               size: 24,
             ),
            const SizedBox(width: 8),
            const Text('Cerrar Sesión'),
          ],
        ),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Cambiar a orientación vertical antes de ir al splash screen
              await OrientationService().setPortraitOnly();
              await Provider.of<UserService>(context, listen: false).signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Tu hijo/a'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.insert_chart_outlined),
              title: const Text('Informes de progreso'),
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
              leading: const Icon(Icons.settings),
              title: const Text('Área de padres'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ParentsAreaScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernRecommendationTile extends StatelessWidget {
  final bool locked;
  final String label;
  final Color color;
  const _ModernRecommendationTile({
    required this.locked,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color,
                      color.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (locked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pintor personalizado para el patrón moderno del AppBar
class ModernPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Dibujar patrones geométricos modernos
    for (int i = 0; i < 8; i++) {
      final x = (i * 80.0) % size.width;
      final y = (i * 60.0) % size.height;
      final radius = 3.0 + (i % 3) * 2.0;
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }

    // Líneas decorativas
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final startX = (i * 100.0) % size.width;
      final endX = startX + 50;
      final y = (i * 40.0) % size.height;
      
      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
