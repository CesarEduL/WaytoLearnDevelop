import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/services/orientation_service.dart';
import '../../../core/widgets/orientation_aware_widget.dart';
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
    OrientationService().setLandscapeOnly();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationAwareWidget(
      forceLandscape: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Consumer<UserService>(
            builder: (context, userService, child) {
              final isAuthenticated = userService.isAuthenticated;
              
              return Padding(
                padding: const EdgeInsets.all(20),
                child: !isAuthenticated
                    ? _buildNotConnectedView(context)
                    : _buildConnectedView(context),
              );
            },
          ),
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

  Widget _buildConnectedView(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección "Tus hijos"
          _buildChildrenSection(),
          
          const SizedBox(height: 40),
          
          // Tarjetas de acción
          _buildActionCards(context),
        ],
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

  Widget _buildActionCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            const Color(0xFF8B5CF6), // Púrpura
            Icons.person,
            'Perfil',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            const Color(0xFFEC4899), // Rosa
            Icons.bar_chart,
            'Progreso',
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProgressReportsScreen()),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            const Color(0xFF84CC16), // Verde lima
            Icons.hourglass_empty,
            'Tiempo de uso',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función en desarrollo'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            const Color(0xFF14B8A6), // Teal
            Icons.download,
            'Descargas',
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función en desarrollo'),
                  backgroundColor: Colors.teal,
                ),
              );
            },
          ),
        ),
      ],
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
            
            // Label en botón blanco
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
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
