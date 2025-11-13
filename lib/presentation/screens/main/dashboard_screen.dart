import 'package:flutter/material.dart';
import '../../../core/services/orientation_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/orientation_aware_widget.dart';
import '../profile/profile_screen.dart';
import '../profile/progress_reports_screen.dart';
import '../parents/parents_area_screen.dart';
import '../communication/session_progress_screen.dart';
import '../mathematics/math_index_screen_sessions.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // URL del oso desde Firebase Storage (usada en comunicación)
  static const String _bearImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/waytolearn-3ebca.appspot.com/o/images%2FOSO%20CON%20UN%20LIBRO_%202.png?alt=media&token=ef9324fd-da34-49f3-a52b-7faf3121dc25';

  @override
  void initState() {
    super.initState();
    // Asegurar que la orientación horizontal esté configurada
    OrientationService().setLandscapeOnly();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationAwareWidget(
      forceLandscape: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: _buildDrawer(context),
        body: SafeArea(
          child: Stack(
            children: [
              // Contenido con scroll
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    // Banner púrpura de progreso
                    _buildProgressBanner(),
                    
                    const SizedBox(height: 24),
                    
                    // Grid de bloques de contenido
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildContentGrid(context),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              
              // Top bar con hamburger, oso y usuario
              _buildTopBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        color: Colors.transparent,
        child: Row(
          children: [
            // Hamburger menu (izquierda)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Builder(
                builder: (ctx) => Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB0BEC5), // Azul-gris claro
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
              ),
            ),
            
            // Oso centrado
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Hola! Soy tu compañero de aprendizaje'),
                        backgroundColor: Colors.brown,
                        duration: Duration(milliseconds: 800),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        _bearImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.brown.shade300,
                            child: const Icon(
                              Icons.pets,
                              size: 50,
                              color: Colors.brown,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Ícono de usuario (derecha)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF7B2CBF), // Púrpura oscuro
              const Color(0xFF9D4EDD), // Púrpura medio
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lado izquierdo: textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aprendizaje en curso',
                        style: TextStyle(
                          color: Colors.cyan.shade300,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Sesión 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Palabras con Magia',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Lado derecho: Comunicación 45% y cofre
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Comunicación',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '45%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513), // Marrón del cofre
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.inventory_2,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Barra de progreso
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white.withOpacity(0.3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.45,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan.shade300,
                        Colors.cyan.shade400,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentGrid(BuildContext context) {
    return Column(
      children: [
        // Primera fila: 3 bloques pequeños
        Row(
          children: [
            Expanded(
              child: _buildSmallBlock(
                const Color(0xFF8B5CF6), // Púrpura
                null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSmallBlock(
                const Color(0xFF84CC16), // Verde lima
                null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSmallBlock(
                const Color(0xFF14B8A6), // Teal
                null,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Segunda fila: 2 bloques grandes
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildLargeBlock(
                const Color(0xFFEC4899), // Rosa
                Icons.calculate,
                'Matemáticas',
                () => _navigateToSubject(context, 'mathematics'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildLargeBlock(
                const Color(0xFF14B8A6), // Teal
                Icons.menu_book,
                'Comunicación',
                () => _navigateToSubject(context, 'communication'),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Tercera fila: 2 bloques largos
        Row(
          children: [
            Expanded(
              child: _buildLongBlock(
                const Color(0xFFFCD34D), // Amarillo
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLongBlock(
                const Color(0xFFFB923C), // Naranja
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSmallBlock(Color color, IconData? icon) {
    return Container(
      height: 120,
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
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
  
  Widget _buildLargeBlock(Color color, IconData icon, String title, VoidCallback onTap) {
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
        child: Stack(
          children: [
            // Icono en la esquina superior izquierda
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLongBlock(Color color) {
    return Container(
      height: 100,
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
    );
  }

  void _navigateToSubject(BuildContext context, String subject) async {
    print('🔍 _navigateToSubject llamado con: $subject');
    
    if (subject == 'communication') {
      print('✅ Entrando a Comunicación');
      await OrientationService().setLandscapeOnly();
      
      if (!context.mounted) return;
      
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const SessionProgressScreen(),
        ),
      );
      
      
      
    } else {
      // Matemáticas
      print('✅ Entrando a Matemáticas');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MathIndexScreenSessions(),
        ),
      );
    }
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
