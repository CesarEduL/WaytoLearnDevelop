import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SessionProgressScreen extends StatefulWidget {
  final int sessionNumber;
  
  const SessionProgressScreen({
    super.key, 
    required this.sessionNumber,
  });

  @override
  State<SessionProgressScreen> createState() => _SessionProgressScreenState();
}

class _SessionProgressScreenState extends State<SessionProgressScreen> {
  String? _bearImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      // Cargar imagen del oso desde Firebase Storage
      final bearRef = FirebaseStorage.instance.ref().child('images/bear_character.png');
      final bearUrl = await bearRef.getDownloadURL();
      
      setState(() {
        _bearImageUrl = bearUrl;
        _isLoading = false;
      });
    } catch (e) {
      print('Error cargando imágenes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.purple,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Contenido principal con scroll
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 60), // Espacio para el oso
                
                // Banner principal púrpura
                _buildMainBanner(),
                
                const SizedBox(height: 20),
                
                // Grid de sesiones
                _buildSessionGrid(),
                
                const SizedBox(height: 100), // Espacio para el botón flotante
              ],
            ),
          ),

          // Oso en la parte superior
          _buildBearCharacter(),

          // Botón Home (arriba izquierda)
          _buildHomeButton(),

          // Botón Configuración (arriba derecha)
          _buildSettingsButton(),

          // Botón Libro (abajo derecha)
          _buildBookButton(),
        ],
      ),
    );
  }

  Widget _buildMainBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade600,
            Colors.purple.shade800,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Aprendizaje en curso"
          Text(
            "Aprendizaje en curso",
            style: TextStyle(
              color: Colors.cyan.shade300,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          
          // "Sesión X" y título
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sesión ${widget.sessionNumber}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getSessionTitle(widget.sessionNumber),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Progreso y porcentaje
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Comunicación",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "45%",
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
                      color: Colors.brown.shade600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Barra de progreso
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.45,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.cyan.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionGrid() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _SessionCard(
          title: "Sesión 1",
          subtitle: "Las Vocales Aventureras",
          progress: 1.0,
          color: Colors.purple,
          isCompleted: true,
        ),
        _SessionCard(
          title: "Sesión 2",
          subtitle: "Palabras con Magia",
          progress: 0.45,
          color: Colors.green,
          isCompleted: false,
        ),
        _SessionCard(
          title: "Sesión 3",
          subtitle: "Cuentos con Emociones",
          progress: 0.0,
          color: Colors.cyan,
          isCompleted: false,
        ),
        _SessionCard(
          title: "Sesión 4",
          subtitle: "Cuentacuentos Comunicador",
          progress: 0.0,
          color: Colors.lightBlueAccent,
          isCompleted: false,
        ),
        _SessionCard(
          title: "Sesión 5",
          subtitle: "Lectura Fluida",
          progress: 0.0,
          color: Colors.orange,
          isCompleted: false,
        ),
        _SessionCard(
          title: "Sesión 6",
          subtitle: "Comprensión Lectora",
          progress: 0.0,
          color: Colors.teal,
          isCompleted: false,
        ),
      ],
    );
  }

  Widget _buildBearCharacter() {
    return Positioned(
      top: 10,
      right: 20,
      child: GestureDetector(
        onTap: () => _onBearTap(),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _bearImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    _bearImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildBearPlaceholder();
                    },
                  ),
                )
              : _buildBearPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildBearPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown.shade300,
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(
        Icons.pets,
        size: 40,
        color: Colors.brown,
      ),
    );
  }

  Widget _buildHomeButton() {
    return Positioned(
      top: 30,
      left: 20,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.home,
            color: Colors.blue.shade800,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return Positioned(
      top: 30,
      right: 120,
      child: GestureDetector(
        onTap: () => _onSettingsTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade400, Colors.purple.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.gps_fixed,
                  color: Colors.purple,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookButton() {
    return Positioned(
      bottom: 30,
      right: 20,
      child: GestureDetector(
        onTap: () => _onBookMenuTap(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.green.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.menu_book,
            color: Colors.purple.shade700,
            size: 30,
          ),
        ),
      ),
    );
  }

  String _getSessionTitle(int sessionNumber) {
    switch (sessionNumber) {
      case 1:
        return "Las Vocales Aventureras";
      case 2:
        return "Palabras con Magia";
      case 3:
        return "Cuentos con Emociones";
      case 4:
        return "Cuentacuentos Comunicador";
      default:
        return "Sesión de Comunicación";
    }
  }

  void _onBearTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Hola! Soy tu compañero de aprendizaje'),
        backgroundColor: Colors.brown,
      ),
    );
  }

  void _onSettingsTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuración'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _onBookMenuTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Menú de libros'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final Color color;
  final bool isCompleted;

  const _SessionCard({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onCardTap(),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sesión
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtítulo
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            
            const Spacer(),
            
            // Barra de progreso
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Porcentaje e ícono
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompleted ? Icons.star : Icons.menu_book,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onCardTap() {
    // TODO: Navegar a la sesión específica
    print('Tapped on $title');
  }
}
