import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/orientation_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/orientation_aware_widget.dart';
import '../auth/login_screen.dart';
import '../main/dashboard_screen.dart';

class ParentsAreaScreen extends StatefulWidget {
  const ParentsAreaScreen({super.key});

  @override
  State<ParentsAreaScreen> createState() => _ParentsAreaScreenState();
}

class _ParentsAreaScreenState extends State<ParentsAreaScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    // Configurar orientación horizontal para el área de padres
    OrientationService().setLandscapeOnly();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationAwareWidget(
      forceLandscape: true,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text(
            'Área de Padres',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Consumer<UserService>(
            builder: (context, userService, child) {
              final isAuthenticated = userService.isAuthenticated;
              
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título de la sección
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Gestión de la Cuenta',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Administra la cuenta de tu hijo/a y accede a funciones avanzadas',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Estado de autenticación
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildAuthenticationStatus(isAuthenticated),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Opciones principales
                    Expanded(
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildMainOptions(context, isAuthenticated),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAuthenticationStatus(bool isAuthenticated) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAuthenticated ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAuthenticated ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isAuthenticated ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isAuthenticated ? Icons.check_circle : Icons.warning,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAuthenticated ? 'Cuenta Conectada' : 'Cuenta No Conectada',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isAuthenticated ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAuthenticated 
                    ? 'Tienes acceso completo a todas las funciones'
                    : 'Conecta tu cuenta para acceder a funciones avanzadas',
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

  Widget _buildMainOptions(BuildContext context, bool isAuthenticated) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        _buildOptionCard(
          context,
          'Perfil del Estudiante',
          Icons.person,
          AppTheme.primaryColor,
          'Ver y editar información del estudiante',
          () => _navigateToProfile(context),
        ),
        _buildOptionCard(
          context,
          'Informes de Progreso',
          Icons.analytics,
          AppTheme.secondaryColor,
          'Revisar el progreso académico',
          () => _navigateToProgressReports(context),
        ),
        _buildOptionCard(
          context,
          isAuthenticated ? 'Configuración de Cuenta' : 'Conectar Cuenta',
          isAuthenticated ? Icons.settings : Icons.login,
          isAuthenticated ? AppTheme.accentColor : Colors.green,
          isAuthenticated 
            ? 'Gestionar configuración de la cuenta'
            : 'Iniciar sesión para funciones avanzadas',
          () => _handleAccountAction(context, isAuthenticated),
        ),
        _buildOptionCard(
          context,
          'Volver al Dashboard',
          Icons.home,
          AppTheme.goldColor,
          'Regresar a la pantalla principal',
          () => _navigateToDashboard(context),
        ),
      ],
    );
  }

  Widget _buildOptionCard(
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProfile(BuildContext context) {
    // TODO: Implementar navegación al perfil del estudiante
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función en desarrollo'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  void _navigateToProgressReports(BuildContext context) {
    // TODO: Implementar navegación a informes de progreso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función en desarrollo'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }

  void _handleAccountAction(BuildContext context, bool isAuthenticated) {
    if (isAuthenticated) {
      // Mostrar opciones de configuración de cuenta
      _showAccountSettings(context);
    } else {
      // Navegar al login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _showAccountSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.settings, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Configuración de Cuenta'),
          ],
        ),
        content: const Text('¿Qué te gustaría hacer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<UserService>(context, listen: false).signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }
}
